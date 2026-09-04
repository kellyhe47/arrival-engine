#!/usr/bin/env python3
"""Red-first evidence — proof that every fixture is load-bearing.

"Observe each fixture failing for its intended reason before you make it pass. A fixture that was
never seen red proves nothing." Watching a test go red once, by hand, leaves no artifact and cannot
be re-run. This does the same job as a MECHANISM: for each fixture, break exactly the rule that
fixture defends, then assert that (a) the fixture fails, and (b) it fails for the intended reason.

A mutation that leaves its fixture green is reported as a failure of THIS harness — it means the
fixture is not actually pinning the behaviour it claims to pin.

    python eval/red_first.py            # every mutation
    python eval/red_first.py --only G-017
"""
from __future__ import annotations

import argparse
import contextlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from arena import card, facts, identity, ingest, labels, ranking, recency, reason, scoring  # noqa: E402
from arena.adapters import session as session_adapter  # noqa: E402
from golden_runner import GOLDEN, MANIFEST, ensure_store, run_fixture  # noqa: E402


@contextlib.contextmanager
def patched(*targets):
    """Swap attributes for the duration of one case, then put them back."""
    saved = [(obj, name, getattr(obj, name)) for obj, name, _ in targets]
    for obj, name, value in targets:
        setattr(obj, name, value)
    try:
        yield
    finally:
        for obj, name, value in saved:
            setattr(obj, name, value)


# ── the mutations ─────────────────────────────────────────────────────────────
def _symmetric_score(a, b, **kw):
    """B-001: compute one symmetric affinity number and report it for both directions."""
    return scoring.score_pair(dict(a, declared_links=[]), dict(b, declared_links=[]), **kw)


def _s8_without_substrate(a, b, **kw):
    """B-003: let prominence contribute with no substrate behind it."""
    kw["s8_requires_substrate"] = False
    return scoring.score_pair(a, b, **kw)


def _strict_floor(pair, *, minimum=6, requires_any_of=("S3", "S5", "S6", "S7")):
    """B-004: a strict greater-than, so a score of exactly 6 never surfaces."""
    return pair.score_excluding_s8() > minimum and bool(pair.signal_ids & set(requires_any_of))


def _advisory_band(narration, *, settings, facts=None, scored_pair=None, degraded=False):
    """B-005: treat the word budget as advisory."""
    wide = settings.__class__(**{**settings.__dict__, "word_band": (0, 10_000)})
    return card.render_card(narration, settings=wide, facts=facts, scored_pair=scored_pair,
                            degraded=degraded)


def _floor_reads_s9(pair, *, minimum=6, requires_any_of=("S3", "S5", "S6", "S7")):
    """B-025: let the display-only intent signal S9 leak into the surfacing floor."""
    s9 = pair.s9.weight if pair.s9 else 0
    return (pair.score_excluding_s8() + s9 >= minimum
            and bool(pair.signal_ids & set(requires_any_of)))


def _publication_date(item):
    """B-009: rank recency on publication date alone, so a rerun reads as this month's news."""
    return item.get("published_at")


def _handle_equality(candidate_accounts, **kw):
    """B-010: resolve identity by handle equality, with no corroborating signal required."""
    return identity.resolve_identity(candidate_accounts, **{**kw, "require_corroboration": False})


def _recency_inverted(x, y):
    """B-011 tier 2: order equal-score ties by OLDEST evidence."""
    if x["score"] != y["score"]:
        return -1 if x["score"] > y["score"] else 1
    if x["_large"] != y["_large"]:
        return -1 if x["_large"] > y["_large"] else 1
    rx, ry = x["_recency"], y["_recency"]
    if rx is not None and ry is not None and rx != ry:
        return -1 if rx < ry else 1
    return -1 if x["member_id"] < y["member_id"] else 1


def _large_count_inverted(x, y):
    """B-011 tier 1: order equal-score ties by FEWEST large signals."""
    if x["score"] != y["score"]:
        return -1 if x["score"] > y["score"] else 1
    if x["_large"] != y["_large"]:
        return -1 if x["_large"] < y["_large"] else 1
    return -1 if x["member_id"] < y["member_id"] else 1


def _room_never_empty(arriving, present, **kw):
    """B-013: an empty room is treated as a match state rather than an honest absence."""
    out = ranking.rank_room(arriving, present, **kw)
    out["room_block_kind"] = "match"
    return out


def _permissive_reason(scored_pair, narration):
    """B-012: render a reason template that names signal categories without checking them."""
    return {"valid": True, "gate_failures": []}


def _leaky_suppression(suppressed):
    """B-024: report withheld facts by content instead of class and count."""
    out = facts.suppression_notice(suppressed)
    if suppressed:
        out["suppression_notice"] = "; ".join(f["text"] for f in suppressed)
    return out


def _room_genericity(vocabulary):
    """B-016: recompute genericity from the current room, so nothing is excluded up front."""
    return frozenset()


_REAL_INGEST = ingest.run_ingestion


def _drop_run_on_session_failure(inputs, *, configuration, registry=None):
    """B-017: discard the whole run when a session dies, instead of keeping what was collected."""
    out = _REAL_INGEST(inputs, configuration=configuration, registry=registry)
    if not out["profile_complete"]:
        out["facts_ingested"] = 0
        out["profile_marked_partial"] = False
        for row in out["source_status"]:
            row["facts"] = 0
    return out


def _blacklist_extraction(raw, *, whitelist=()):
    """B-019: blacklist instead of whitelist, so anything nobody thought of is stored."""
    fields = (raw or {}).get("fields") or {}
    banned = {"degree_of_connection", "viewer_handle"}
    stored = sorted(k for k in fields if k not in banned)
    return {"stored_fields": stored,
            "dropped_fields": sorted(k for k in fields if k in banned),
            "stored_values": {k: fields[k] for k in stored},
            "operator_data_stored": 0}


def _echo_supplied_label(arrival, profile):
    """B-020: trust the webhook's identifying detail and print it."""
    supplied = arrival.get("supplied_label") or ""
    return {"label_correction": {"supplied": supplied, "current": supplied, "stale": False},
            "show_correction_to_host": False, "echo_supplied_label": True}


def _recency_from_what_was_fetched(inputs, *, settings, as_of):
    """B-021: compute recency from whatever was reached, ignoring the sources that were not."""
    stripped = {k: v for k, v in inputs.items() if k != "source_status"}
    return recency.build_now_block(stripped, settings=settings, as_of=as_of)


def _trust_everything(candidate_facts, *, settings):
    """B-022: hand-roll the render gate instead of asking the store's view.

    Loosening `render_trust_classes` alone is NOT enough to make this fixture fail, and that is
    worth knowing: `v_renderable_fact` in db/schema.sql excludes `third_party_open` structurally,
    so configuration cannot open the door. The realistic defect is the one modelled here — an
    implementation that re-implements the predicate in Python and checks only for a source URL.
    """
    ok, rejected = [], []
    for f in candidate_facts:
        fid = f.get("fact_id") or f.get("id")
        (ok if f.get("source_url") else rejected).append(fid)
    return {
        "renderable_fact_ids": sorted(ok),
        "rejected": sorted(({"fact_id": r, "reason": "missing_provenance"} for r in rejected),
                           key=lambda r: r["fact_id"]),
        "provenance_chips": [{"fact_id": fid,
                              "source_host": facts.chip_host(
                                  next(c for c in candidate_facts
                                       if (c.get("fact_id") or c.get("id")) == fid)["source_url"]),
                              "provenance_class": next(
                                  c for c in candidate_facts
                                  if (c.get("fact_id") or c.get("id")) == fid)["provenance_class"]}
                             for fid in sorted(ok)],
        "narrator_context_fact_ids": sorted(ok),
        "third_party_open_in_narrator_context": 0,
    }


MUTATIONS = {
    "G-001": ("score_pair_both_directions computes one symmetric number",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_score",
                               _symmetric_score))),
    "G-005": ("S8 fires with no substrate behind it",
              lambda: patched((ranking, "score_pair", _s8_without_substrate))),
    "G-006": ("the introduction floor uses a strict greater-than",
              lambda: patched((ranking, "surfaces", _strict_floor))),
    "G-010": ("the word budget is treated as advisory",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_render",
                               _advisory_band))),
    "G-014": ("recency ranks on publication date alone",
              lambda: patched((recency, "effective_date", _publication_date))),
    "G-016": ("identity resolves on handle equality",
              lambda: patched((__import__("arena.operations", fromlist=["x"]),
                               "_resolve_identity", _handle_equality))),
    "G-017": ("tie-break tier 2 prefers the OLDEST evidence",
              lambda: patched((ranking, "_compare", _recency_inverted))),
    "G-019": ("an empty room is reported as a match state",
              lambda: patched((card, "rank_room", _room_never_empty))),
    "G-020": ("the reason gate accepts any cited signal",
              lambda: patched((__import__("arena.operations", fromlist=["x"]),
                               "_validate_reason", _permissive_reason))),
    "G-022": ("the suppression counter reports content instead of class and count",
              lambda: patched((card, "suppression_notice", _leaky_suppression))),
    "G-025": ("genericity is recomputed from the room, excluding nothing",
              lambda: patched((ranking, "excluded_topic_slugs", _room_genericity))),
    "G-027": ("a dead session discards the whole run",
              lambda: patched((ingest, "run_ingestion", _drop_run_on_session_failure),
                              (__import__("arena.operations", fromlist=["x"]), "_ingest",
                               _drop_run_on_session_failure))),
    "G-029": ("session extraction blacklists instead of whitelisting",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_extract",
                               _blacklist_extraction))),
    "G-031": ("the supplied label is echoed as fact",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_resolve_label",
                               _echo_supplied_label))),
    "G-033": ("recency is computed from whatever was fetched",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_now",
                               _recency_from_what_was_fetched))),
    "G-034": ("third_party_open content is allowed to render",
              lambda: patched((__import__("arena.operations", fromlist=["x"]), "_select",
                               _trust_everything))),
    "G-038": ("the surfacing floor reads the display-only intent signal S9",
              lambda: patched((ranking, "surfaces", _floor_reads_s9))),
    "G-037": ("tie-break tier 1 prefers the FEWEST large signals",
              lambda: patched((ranking, "_compare", _large_count_inverted))),
}


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--only")
    args = ap.parse_args()

    manifest = json.loads(MANIFEST.read_text())
    store = ensure_store()
    fixtures = {json.loads(p.read_text())["id"]: json.loads(p.read_text())
                for p in sorted(GOLDEN.glob("*.json"))}

    missing = sorted(set(fixtures) - set(MUTATIONS))
    if missing:
        print(f"no mutation defined for: {missing}")

    survived, killed = [], []
    for fid in sorted(fixtures):
        if args.only and fid != args.only:
            continue
        if fid not in MUTATIONS:
            continue
        label, make_patch = MUTATIONS[fid]
        ok_before, _ = run_fixture(fixtures[fid], manifest, store)
        with make_patch():
            ok_after, problems = run_fixture(fixtures[fid], manifest, store)
        if ok_before and not ok_after:
            killed.append(fid)
            print(f"  RED->GREEN  {fid}  when {label}:")
            print(f"              {problems[0]}")
        elif not ok_before:
            survived.append(fid)
            print(f"  BROKEN      {fid} does not pass unmutated — fix the implementation first")
        else:
            survived.append(fid)
            print(f"  SURVIVED    {fid} still passes when {label} — the fixture is not "
                  f"pinning what it claims to")

    print(f"\nred-first: {len(killed)} fixture(s) proven load-bearing, {len(survived)} not")
    return 1 if survived else 0


if __name__ == "__main__":
    raise SystemExit(main())
