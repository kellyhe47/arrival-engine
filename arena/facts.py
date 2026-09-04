"""The render gate — enforced by the STORE's own view, not re-implemented in Python.

`db/schema.sql` defines `v_renderable_fact`, and that view already carries three rules:
  * no source          -> cannot render (B-007 / R-025)
  * inferred with no `composed_from` -> cannot render (B-008 / R-025)
  * `third_party_open` -> never renders (P-5 / R-026)

Re-writing those predicates in Python is how the store stops being the contract. So this module
loads the view definition FROM `db/schema.sql` (read-only) into a scratch in-memory database and
asks it. The per-fact rejection REASONS are diagnostic labels for Why-this-score; a startup
self-check asserts that the diagnostics and the view always agree, so a divergence raises instead
of silently changing what renders.
"""
from __future__ import annotations

import json
import sqlite3
import threading
from urllib.parse import urlparse

from .config import SCHEMA_SQL

#: Each clause mirrors one line of `v_renderable_fact`, so a fact can be told WHY it was refused.
#: `_assert_agrees_with_view` proves the conjunction equals the view on every input.
_CLAUSES = (
    ("missing_provenance", "source_url IS NOT NULL"),
    ("inferred_without_named_inputs",
     "NOT (provenance_class = 'inferred' "
     "AND (composed_from IS NULL OR json_array_length(composed_from) = 0))"),
    ("__trust__", "trust_class <> 'third_party_open'"),
)

#: One scratch database PER THREAD. A `sqlite3.Connection` may only be used on the thread that
#: created it, and the web layer runs sync handlers on a threadpool — so a single cached connection
#: works until the pool hands the next request to a different worker, and then raises
#: `SQLite objects created in a thread can only be used in that same thread` from inside the render
#: gate. Thread-local keeps the schema load to once per worker and removes the failure entirely.
_local = threading.local()


def _scratch() -> sqlite3.Connection:
    """One in-memory database carrying the real schema. Never touches db/ except to READ the DDL."""
    conn = getattr(_local, "conn", None)
    if conn is None:
        conn = sqlite3.connect(":memory:")
        conn.row_factory = sqlite3.Row
        conn.executescript(SCHEMA_SQL.read_text())
        # Throwaway classifier: candidate facts have no person or run rows to point at.
        conn.execute("PRAGMA foreign_keys = OFF")
        _local.conn = conn
    return conn


def _load(conn: sqlite3.Connection, facts: list[dict]) -> None:
    conn.execute("DELETE FROM fact")
    for f in facts:
        composed = f.get("composed_from")
        if composed is not None and not isinstance(composed, str):
            composed = json.dumps(composed)
        conn.execute(
            "INSERT INTO fact (id, subject_id, text, provenance_class, trust_class, source_url,"
            " source_host, source_date, observed_at, composed_from, search_first_page,"
            " via_edge_type, via_person_id, run_id)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            (
                f.get("fact_id") or f.get("id"),
                f.get("subject_id") or "_",
                f.get("text") or "",
                f.get("provenance_class") or "self_published",
                f.get("trust_class") or "subject_authored",
                f.get("source_url"),
                f.get("source_host"),
                f.get("source_date"),
                f.get("observed_at") or f.get("source_date") or "1970-01-01",
                composed,
                1 if f.get("search_first_page") else 0,
                f.get("via_edge_type"),
                f.get("via_person_id"),
                f.get("run_id") or "_",
            ),
        )


def _assert_agrees_with_view(conn: sqlite3.Connection) -> set[str]:
    view_ids = {r["id"] for r in conn.execute("SELECT id FROM v_renderable_fact")}
    where = " AND ".join(sql for _, sql in _CLAUSES)
    clause_ids = {
        r["id"] for r in conn.execute(
            f"SELECT id FROM fact WHERE superseded_by IS NULL AND {where}")
    }
    if view_ids != clause_ids:
        raise AssertionError(
            "the render-gate diagnostics have drifted from db/schema.sql's v_renderable_fact: "
            f"view={sorted(view_ids)} clauses={sorted(clause_ids)}. Fix the clauses, never the view."
        )
    return view_ids


def chip_host(url: str | None) -> str | None:
    """Provenance chip host: the URL's hostname with a leading `www.` removed, and nothing else.

    A real subdomain is part of the identity of the source: `blog.emmettshear.com` is not
    `emmettshear.com`, which is a GoDaddy parking page and a different site entirely.
    """
    if not url:
        return None
    host = urlparse(url).hostname
    if not host:
        return None
    return host[4:] if host.startswith("www.") else host


def select_renderable_facts(candidate_facts: list[dict], *, settings) -> dict:
    """Split candidates into what may render and what may not, with a reason for each refusal."""
    conn = _scratch()
    facts = list(candidate_facts or [])
    _load(conn, facts)
    view_ids = _assert_agrees_with_view(conn)

    allowed_trust = settings.render_trust_classes
    ok, rejected = [], []
    for f in facts:
        fid = f.get("fact_id") or f.get("id")
        if fid in view_ids:
            if allowed_trust is not None and f.get("trust_class") not in allowed_trust:
                # Configuration may be stricter than the view; it may never be looser.
                rejected.append({"fact_id": fid, "reason": f.get("trust_class")})
            else:
                ok.append(fid)
            continue
        for reason, sql in _CLAUSES:
            fails = not conn.execute(
                f"SELECT 1 FROM fact WHERE id = ? AND {sql}", (fid,)).fetchone()
            if fails:
                rejected.append({
                    "fact_id": fid,
                    "reason": f.get("trust_class") if reason == "__trust__" else reason,
                })
                break

    by_id = {(f.get("fact_id") or f.get("id")): f for f in facts}
    chips = [
        {
            "fact_id": fid,
            "source_host": chip_host(by_id[fid].get("source_url")),
            "source_date": by_id[fid].get("source_date"),
            "provenance_class": by_id[fid].get("provenance_class"),
            # DEC-12: labelled, not hidden. The edge never scores and is never named on a card,
            # but the class stays countable and visible in Why-this-score.
            "via_edge_type": by_id[fid].get("via_edge_type"),
        }
        for fid in sorted(ok)
    ]

    return {
        "renderable_fact_ids": sorted(ok),
        "rejected": sorted(rejected, key=lambda r: r["fact_id"]),
        "provenance_chips": chips,
        # Nothing untrusted reaches the narrator, even as context. Retrieved text is data, never
        # instructions, and a tagged post is an injection surface (AUD-07-7).
        "narrator_context_fact_ids": sorted(ok),
        "third_party_open_in_narrator_context": 0,
    }


def suppression_notice(suppressed: list[dict]) -> dict:
    """R-028. Class and count only — never content.

    It proves restraint without leaking, and it is the visible answer to "what did you leave out".
    Huffman's SEC Form 4 share sales are public, filed, verified, and suppressed.
    """
    classes = sorted({f["class"] for f in suppressed or []})
    short = sorted({c.split("_")[0] for c in classes})
    return {
        "withheld_count": len(suppressed or []),
        "withheld_classes": classes,
        "suppression_notice": (
            f"{len(suppressed)} withheld: {', '.join(short)}" if suppressed else None
        ),
        "withheld_text_exposed": 0,
    }
