"""Three surfaces: Card (primary), Why-this-score (one tap from Room), Room (presence + webhook).

Mobile-first, server-rendered, no build step, no login. Discovery mitigations only — an unguessable
path, `X-Robots-Tag: noindex`, a `robots.txt` disallow, and no member name in any URL or page title
(R-059). That is not access control, and the README says so in plain words.

The serving path makes no source-adapter calls. Its one permitted external dependency is the
narrator that writes the Say line; adapters remain recorded and the store is a local SQLite file.
`deployed_registry()` cannot hold a SESSION adapter.
"""
from __future__ import annotations

import datetime as dt
import json
import uuid
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Form, Header, HTTPException, Request
from fastapi.responses import HTMLResponse, JSONResponse, PlainTextResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from .adapters import deployed_registry
from .adapters.registry import registry_from_sources
from .card import generate_digest
from .config import Settings, card_path_secret, public_root, store_path
from .ingest import run_ingestion
from .narrator import close_live_narrator, live_narrator
from .ranking import brokering_mode
from .scoring import score_pair
from .store import Store, StoreUnavailable
from .view import (STATE_COPY, affiliation_line, block_title, card_banner, card_state,
                   mark_borrowed, resolve_token, token_for, why_view)
from .webhook import ReplayGuard, WebhookRejected, resolve_arrival_name, secret, verify

HERE = Path(__file__).resolve().parent
SECRET = card_path_secret()
PUBLIC_ROOT = public_root()

#: Every surface answers under `/<SECRET>/`. When PUBLIC_ROOT is on it ALSO answers under `/`, and
#: the two are the same handlers registered twice rather than a redirect, so a bookmark of either
#: keeps working. `_base` tells a template which mount it was reached through, so every link it
#: writes stays on that mount.
ROUTES = (
    ("GET", "", "room"), ("GET", "/", "room"),
    ("POST", "/arrive", "arrive"), ("POST", "/depart", "depart"),
    ("GET", "/card/{token}", "card"), ("GET", "/why/{token}/{other}", "why"),
    ("POST", "/reingest", "reingest"), ("GET", "/resolve", "resolve"),
    ("POST", "/webhook/arrival", "webhook_arrival"),
)


def _base(request: Request) -> str:
    """The mount this request came in on: `/<SECRET>` or `` (root)."""
    path = request.url.path
    return f"/{SECRET}" if path == f"/{SECRET}" or path.startswith(f"/{SECRET}/") else ""

@asynccontextmanager
async def _lifespan(_app: FastAPI):
    yield
    close_live_narrator()


app = FastAPI(title="Arrival", docs_url=None, redoc_url=None, openapi_url=None,
              lifespan=_lifespan)
REPLAY_GUARD = ReplayGuard()
app.mount("/static", StaticFiles(directory=HERE / "static"), name="static")
templates = Jinja2Templates(directory=str(HERE / "templates"))
templates.env.filters["mark_borrowed"] = mark_borrowed


@app.middleware("http")
async def _noindex(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Robots-Tag"] = "noindex, nofollow, noarchive"
    response.headers["Referrer-Policy"] = "no-referrer"
    return response


@app.get("/robots.txt", response_class=PlainTextResponse)
def robots() -> str:
    return "User-agent: *\nDisallow: /\n"


def _store(writable: bool = False) -> Store:
    try:
        return Store(store_path(), writable=writable)
    except StoreUnavailable as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc


def _now() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _ctx(store: Store, request: Request | None = None, **extra) -> dict:
    """Everything every page needs, including the honesty banner about synthetic rows."""
    synthetic = store.conn.execute(
        "SELECT COUNT(*) FROM fact WHERE run_id = 'run_synthetic_demo'").fetchone()[0]
    measured = store.conn.execute(
        "SELECT COUNT(*) FROM fact WHERE run_id <> 'run_synthetic_demo'").fetchone()[0]
    base = {"secret": SECRET, "base": _base(request) if request is not None else f"/{SECRET}",
            "synthetic_facts": synthetic, "measured_facts": measured,
            "css_version": int((HERE / "static" / "arena.css").stat().st_mtime),
            "token_for": lambda mid: token_for(mid, SECRET),
            # Render-time only. The block IDS stay `Who`/`Now`/`Room`/`Notice`/`Say` everywhere
            # else in the system; this is the heading the host reads. See view.BLOCK_TITLES.
            "block_title": block_title,
            "affiliation": affiliation_line}
    base.update(extra)
    return base


# ── Room ──────────────────────────────────────────────────────────────────────
@app.get("/" + SECRET, response_class=HTMLResponse)
@app.get("/" + SECRET + "/", response_class=HTMLResponse)
def room(request: Request):
    """R-044. Current presence, ordered by arrival, plus simulate-arrival and mark-departed.

    This stands in for the webhook, which the brief says is solved. Physical position is not
    tracked in this deliverable.
    """
    store = _store()
    present = store.roster_rows()
    present_ids = {r["person_id"] for r in present}
    absent = [
        {"id": mid, "display_name": (store.member(mid) or {}).get("display_name", mid)}
        for mid in store.member_ids() if mid not in present_ids
    ]
    return templates.TemplateResponse(request, "room.html", _ctx(
        store, request, present=present, absent=absent, registry=sorted(deployed_registry())))


@app.post("/" + SECRET + "/arrive")
def arrive(request: Request, person_id: str = Form(...)):
    """Fires the webhook path for that member against the current roster."""
    store = _store(writable=True)
    store.arrive(person_id, _now())
    return RedirectResponse(f"{_base(request)}/card/{token_for(person_id, SECRET)}",
                            status_code=303)


@app.post("/" + SECRET + "/depart")
def depart(request: Request, person_id: str = Form(...)):
    """Removes from roster. Already-rendered cards are not retro-edited."""
    store = _store(writable=True)
    store.depart(person_id, _now())
    return RedirectResponse(f"{_base(request)}/" if _base(request) else "/", status_code=303)


# ── Card ──────────────────────────────────────────────────────────────────────
@app.get("/" + SECRET + "/card/{token}", response_class=HTMLResponse)
def card(request: Request, token: str, retry: int = 0):
    """The primary surface. Retry re-runs render only: it does not re-ingest and it does not
    relax a gate (R-047)."""
    store = _store()
    member_id = resolve_token(token, store.member_ids(), SECRET)
    if member_id is None:
        # R-013 / ui-states: no corroborated profile. Greet and log; the Say block still renders.
        return templates.TemplateResponse(request, "card.html", _ctx(
            store, request, state="not_found",
            copy=card_banner(None, None, "not_found", industry_labels={}, vocabulary={}),
            digest=None, member=None, chips=[], token=token), status_code=404)

    settings = Settings()
    present_ids = [p for p in store.present_ids() if p != member_id]

    digest = generate_digest(
        {"arrival": {"member_id": member_id}, "present_members": present_ids},
        settings=settings, clock=_now(), store=store, narrator=live_narrator())

    renderable = set(digest.get("renderable_fact_ids") or [])
    state = card_state(digest, present_count=len(present_ids),
                       renderable_count=len(renderable))

    member = store.member(member_id)
    label = store.label(member_id) or {}
    chips = {c["fact_id"]: c for c in digest.get("provenance_chips") or []}
    synthetic_ids = {r["id"] for r in store.conn.execute(
        "SELECT id FROM fact WHERE run_id = 'run_synthetic_demo'")}
    for c in chips.values():
        c["synthetic"] = c["fact_id"] in synthetic_ids

    names = {mid: (store.member(mid) or {}).get("display_name", mid) for mid in present_ids}

    # A-4. `unknown` is the one state that earns a gutter rule, and the line beside it is a COUNT:
    # "reached 2 of 3". A bare list of unreachable source ids does not tell a host how much of the
    # profile it is looking at. The denominator is every source attempted on the last run.
    attempted = store.source_status(member_id)
    out = sorted(set((digest.get("recency") or {}).get("unavailable_source_ids") or []))
    total = len({s["source_id"] for s in attempted})
    coverage = {"total": total, "out": out, "reached": total - len(out)}

    copy = card_banner(member, label, state, industry_labels=store.industry_labels(),
                       vocabulary=store.vocabulary())

    # R-051 / schema `card`: if a member ever asks what was said about them, this is the answer.
    if digest.get("card"):
        writable = _store(writable=True)
        writable.record_card(
            card_id=str(uuid.uuid4()), subject_id=member_id, rendered_at=_now(),
            word_count=digest["card"]["word_count"], gates_passed=digest["gates_passed"],
            gate_failures=digest["gate_failures"],
            body=json.dumps(digest["card"]["blocks"]),
            fact_ids=sorted(renderable), run_id="run_serving")
        writable.close()

    return templates.TemplateResponse(request, "card.html", _ctx(
        store, request, state=state, copy=copy, digest=digest, member=member,
        label=label, chips=chips, names=names, token=token, retry=retry,
        coverage=coverage, floor=settings.surface_min_score))


# ── Why this score ────────────────────────────────────────────────────────────
@app.get("/" + SECRET + "/why/{token}/{other}", response_class=HTMLResponse)
def why(request: Request, token: str, other: str):
    store = _store()
    ids = store.member_ids()
    a_id = resolve_token(token, ids, SECRET)
    b_id = resolve_token(other, ids, SECRET)
    if a_id is None or b_id is None:
        raise HTTPException(status_code=404)
    a, b = store.member(a_id), store.member(b_id)
    vocabulary = store.vocabulary()
    aliases = store.aliases()
    from .scoring import excluded_topic_records, excluded_topic_slugs
    excluded = excluded_topic_slugs(vocabulary)
    forward = score_pair(a, b, excluded_topics=excluded, aliases=aliases)
    reverse = score_pair(b, a, excluded_topics=excluded, aliases=aliases)
    names = {a_id: a["display_name"], b_id: b["display_name"]}
    view = why_view(a, b, forward=forward, reverse=reverse,
                    excluded_topics=excluded_topic_records(vocabulary), names=names)
    view["brokering"] = brokering_mode(forward, reverse)
    return templates.TemplateResponse(request, "why.html", _ctx(
        store, request, why=view, token=token, other=other, floor=6))


# ── Ingesting (DEC-3: one live re-run, GREEN adapters only) ───────────────────
@app.post("/" + SECRET + "/reingest", response_class=HTMLResponse)
def reingest(request: Request, person_id: str = Form(...)):
    """The on-stage live re-run. GREEN adapters only, so it cannot fail on a dead session.

    SESSION adapters are not disabled here — they are absent from `deployed_registry()`, so there
    is nothing to disable.
    """
    store = _store()
    rows = store.collectable_sources(person_id)
    # Derived from the store's own allow-list. SESSION rows produce no adapter at all, and are
    # still PLANNED, so the ingesting screen shows them reporting `absent_from_registry` rather
    # than quietly disappearing — the structural absence is the thing worth seeing.
    registry = registry_from_sources(rows) or deployed_registry()
    seen, plan, configuration_adapters = set(), [], {}
    for row in rows:
        sid = row["source_id"]
        if sid in seen:
            continue
        seen.add(sid)
        plan.append({"source_id": sid, "member_id": person_id})
        configuration_adapters[sid] = {"tier": row["tier"], "enabled": True}
    configuration = {"execution_context": "deployed_runtime", "adapters": configuration_adapters}
    result = run_ingestion({"fetch_plan": plan}, configuration=configuration, registry=registry)
    return templates.TemplateResponse(request, "ingesting.html", _ctx(
        store, request, state="ingesting", copy=STATE_COPY["ingesting"], result=result,
        member=store.member(person_id), token=token_for(person_id, SECRET)))


# ── The arrival webhook (R-001) ───────────────────────────────────────────────
@app.post("/" + SECRET + "/webhook/arrival")
async def webhook_arrival(
    request: Request,
    x_arena_signature: str | None = Header(default=None),
    x_arena_timestamp: str | None = Header(default=None),
):
    """Accept an arrival event from the configured arrival system, and only from it.

    Authenticated, integrity-checked and replay-protected; a malformed or unknown identity is
    rejected before any profile or Room data is read. Room's simulate-arrival control exercises the
    same path with the signature step already satisfied.
    """
    body = await request.body()
    try:
        verify(body, signature=x_arena_signature, timestamp=x_arena_timestamp,
               key=secret(), guard=REPLAY_GUARD)
    except WebhookRejected as exc:
        # Identifiers and statuses only — never fact text, never the secret.
        return JSONResponse({"accepted": False, "reason": exc.reason}, status_code=exc.status)

    try:
        payload = json.loads(body or b"{}")
    except json.JSONDecodeError:
        return JSONResponse({"accepted": False, "reason": "malformed_body"}, status_code=400)
    name = payload.get("name")
    if not isinstance(name, str) or not name.strip():
        return JSONResponse({"accepted": False, "reason": "malformed_identity"}, status_code=400)

    store = _store()
    members = [store.member(mid) for mid in store.member_ids()]
    outcome = resolve_arrival_name(name, [m for m in members if m])
    if outcome["resolution"] != "resolved":
        # The engine never guesses. Ambiguous shows the chooser and emits no brief.
        return JSONResponse(
            {"accepted": False, "reason": outcome["resolution"],
             "candidates": [token_for(c["id"], SECRET) for c in outcome["candidates"]]},
            status_code=409 if outcome["resolution"] == "ambiguous" else 404)

    member_id = outcome["candidates"][0]["id"]
    writable = _store(writable=True)
    writable.arrive(member_id, _now())
    writable.close()
    return JSONResponse({"accepted": True,
                         "card": f"{_base(request)}/card/{token_for(member_id, SECRET)}"})


@app.get("/" + SECRET + "/resolve", response_class=HTMLResponse)
def resolve(request: Request, name: str = ""):
    """The chooser. Reached when a supplied name resolves to more than one member (R-013).

    Picking a candidate binds identity for this arrival only; it does not write to the profile
    store.
    """
    store = _store()
    members = [m for m in (store.member(mid) for mid in store.member_ids()) if m]
    outcome = resolve_arrival_name(name, members)
    state = outcome["resolution"]
    return templates.TemplateResponse(request, "resolve.html", _ctx(
        store, request, state=state, copy=STATE_COPY[state], supplied=name,
        candidates=outcome["candidates"]))


# ── the root mount ────────────────────────────────────────────────────────────
# Registered LAST, so `/static` and `/robots.txt` keep their own handlers, and only when the
# operator has asked for it. See `arena.config.public_root` for what turning this on gives up.
if PUBLIC_ROOT:
    for _method, _path, _name in ROUTES:
        if _path == "":
            continue                     # `/` already covers the bare mount at the root
        app.add_api_route(_path, globals()[_name], methods=[_method],
                          response_class=HTMLResponse if _method == "GET" else JSONResponse)
    app.add_api_route("/", room, methods=["GET"], response_class=HTMLResponse)
