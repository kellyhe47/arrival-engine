"""Read access to the serving store, and the writes the surfaces are allowed to make.

Two rules this module exists to keep:

1. **`db/` is never opened for writing.** Not by this module, not by anything it calls. The DDL and
   the seeds under `db/` are read as TEXT; live `.db` files there are opened with
   `file:...?mode=ro`. The serving store is a separate file built outside `db/`.
2. **The gates in the store are queried, not re-implemented.** `v_present`, `v_recency_state`,
   `v_collectable_source`, `v_assertable_absence`, `v_traversable_person` and `v_renderable_fact`
   are the rules; this module reads through them.
"""
from __future__ import annotations

import json
import sqlite3
from pathlib import Path

from .config import store_path

#: Edge types that feed S5 (docs/knowledge-graph.md). `family_or_partner` is NOT among them: the
#: edge never scores and is never named on a card (DEC-12).
DIRECTED_LINK_TYPES = ("follows", "cited_in_own_writing", "co_mention", "repost")

#: The only tables the running application may write. The profile half of the store is a frozen
#: cache; the runtime adds presence, the cards it emitted, and the outcomes hosts log against
#: those cards (R-060) — and nothing else.
RUNTIME_WRITABLE = frozenset({"roster", "card", "outcome"})


class StoreUnavailable(RuntimeError):
    """The serving store has not been built. `make store` builds it; the app says so honestly."""


def read_only(path: Path | str) -> sqlite3.Connection:
    """Open any SQLite file read-only. This is the ONLY way this codebase opens a file in db/."""
    conn = sqlite3.connect(f"file:{Path(path)}?mode=ro", uri=True)
    conn.row_factory = sqlite3.Row
    return conn


class Store:
    def __init__(self, path: Path | None = None, *, writable: bool = False):
        self.path = Path(path or store_path())
        if not self.path.exists():
            raise StoreUnavailable(f"{self.path} does not exist — run `make store`")
        if writable:
            self.conn = sqlite3.connect(self.path)
            self.conn.row_factory = sqlite3.Row
            self.conn.execute("PRAGMA foreign_keys = ON")
        else:
            self.conn = read_only(self.path)
        self.writable = writable

    # ── writes, narrowly ──────────────────────────────────────────────────────
    def _guard(self, table: str) -> None:
        if not self.writable:
            raise PermissionError("this store was opened read-only")
        if table not in RUNTIME_WRITABLE:
            raise PermissionError(
                f"the runtime may not write `{table}`; only {sorted(RUNTIME_WRITABLE)}")

    def arrive(self, person_id: str, at: str) -> None:
        """Record an arrival. A member is in the room ONCE, however many times they arrive.

        The primary key is (person_id, arrived_at), so `INSERT OR REPLACE` only collapses two
        arrivals that land in the same second. A badge scanned twice, a webhook retried, or a host
        tapping back and re-firing left a SECOND live row: the member appeared twice in Room, the
        banner counted them twice, and — because presence is read as a join — they were scored
        FOUR times and named four times in Who's here. So any open row is closed first, and the
        newest arrival is the one that stands.
        """
        self._guard("roster")
        self.conn.execute(
            "UPDATE roster SET departed_at = ? WHERE person_id = ? AND departed_at IS NULL"
            " AND arrived_at <> ?", (at, person_id, at))
        self.conn.execute(
            "INSERT OR REPLACE INTO roster (person_id, arrived_at, departed_at) VALUES (?,?,NULL)",
            (person_id, at))
        self.conn.commit()

    def depart(self, person_id: str, at: str) -> None:
        self._guard("roster")
        self.conn.execute(
            "UPDATE roster SET departed_at = ? WHERE person_id = ? AND departed_at IS NULL",
            (at, person_id))
        self.conn.commit()

    def record_card(self, card_id: str, subject_id: str, rendered_at: str, word_count: int,
                    gates_passed: bool, gate_failures: list, body: str, fact_ids: list,
                    run_id: str) -> None:
        """R-051 / schema `card`. If a member ever asks what was said about them, this answers."""
        self._guard("card")
        self.conn.execute(
            "INSERT OR REPLACE INTO card (id, subject_id, rendered_at, word_count, gates_passed,"
            " gate_failures, body, fact_ids, run_id) VALUES (?,?,?,?,?,?,?,?,?)",
            (card_id, subject_id, rendered_at, word_count, 1 if gates_passed else 0,
             json.dumps(gate_failures), body, json.dumps(fact_ids), run_id))
        self.conn.commit()

    def record_outcome(self, outcome_id: str, subject_id: str, matched_id: str | None,
                       outcome: str | None, observation: str | None, logged_at: str,
                       run_id: str) -> None:
        """R-060. Append-only: an outcome is never updated, only added. The only proof an
        introduction worked is what happened next, and this is where it lands."""
        self._guard("outcome")
        self.conn.execute(
            "INSERT INTO outcome (id, subject_id, matched_id, outcome, observation, logged_at,"
            " run_id) VALUES (?,?,?,?,?,?,?)",
            (outcome_id, subject_id, matched_id, outcome, observation or None, logged_at, run_id))
        self.conn.commit()

    # ── reference data ────────────────────────────────────────────────────────
    def vocabulary(self) -> dict:
        return {
            r["slug"]: {
                "discriminating": bool(r["discriminating"]),
                "holder_count": r["holder_count"],
                "base_size": r["base_size"],
                "kind": r["kind"],
                "label": r["label"],
                "basis": r["basis"],
            }
            for r in self.conn.execute(
                "SELECT slug, kind, label, discriminating, holder_count, base_size, basis FROM topic")
        }

    def industry_labels(self) -> dict:
        """The controlled industry vocabulary, slug -> label. Read, never invented (P0-6)."""
        return {r["slug"]: r["label"] for r in
                self.conn.execute("SELECT slug, label FROM industry")}

    def aliases(self) -> dict:
        return {r["alias"]: r["canonical"] for r in
                self.conn.execute("SELECT alias, canonical FROM topic_alias")}

    def corroboration_strengths(self) -> dict:
        return {r["slug"]: r["strength"] for r in
                self.conn.execute("SELECT slug, strength FROM corroboration_kind")}

    def deny_list(self) -> set[str]:
        return {r["value"] for r in
                self.conn.execute("SELECT value FROM person_identity_negative")}

    def collectable_sources(self, person_id: str) -> list[dict]:
        """Allow-listed AND not deny-listed. Read through `v_collectable_source` (R-056)."""
        return [dict(r) for r in self.conn.execute(
            "SELECT * FROM v_collectable_source WHERE person_id = ? ORDER BY source_id",
            (person_id,))]

    def flags(self) -> dict:
        """Operator-set flags. `do_not_brief` is gone (DEC-15) — members are never told this
        service exists, so a column recording their preference about it recorded nothing.
        `do_not_traverse` remains: it restrains the INGEST walk over any person row, including
        the non-members who never opted in and have nobody to ask (K-11)."""
        return {
            r["person_id"]: {"do_not_traverse": bool(r["do_not_traverse"])}
            for r in self.conn.execute(
                "SELECT person_id, do_not_traverse FROM member_flags")
        }

    def traversable(self) -> set[str]:
        """K-11, honoured at ingest. Read through the view, never off the base table."""
        return {r["id"] for r in self.conn.execute("SELECT id FROM v_traversable_person")}

    def assertable_absences(self, person_id: str) -> list[dict]:
        """K-5: an absence with no named corpus is not readable by the engine."""
        return [dict(r) for r in self.conn.execute(
            "SELECT * FROM v_assertable_absence WHERE from_id = ?", (person_id,))]

    # ── people ────────────────────────────────────────────────────────────────
    def member_ids(self) -> list[str]:
        return [r["id"] for r in self.conn.execute(
            "SELECT id FROM person WHERE is_member = 1 ORDER BY id")]

    def person_row(self, person_id: str) -> sqlite3.Row | None:
        return self.conn.execute("SELECT * FROM person WHERE id = ?", (person_id,)).fetchone()

    def label(self, person_id: str) -> dict | None:
        r = self.conn.execute("SELECT * FROM member_label WHERE person_id = ?",
                              (person_id,)).fetchone()
        return dict(r) if r else None

    def member(self, person_id: str) -> dict | None:
        """The scoring record: exactly the attributes `score_pair` reads, and nothing else."""
        p = self.person_row(person_id)
        if p is None:
            return None
        topics = list(self.conn.execute(
            "SELECT pt.topic_slug, t.kind FROM person_topic pt JOIN topic t ON t.slug = pt.topic_slug"
            " WHERE pt.person_id = ? ORDER BY pt.topic_slug", (person_id,)))
        return {
            "id": p["id"],
            "is_member": p["is_member"],
            "display_name": p["display_name"],
            "name_respelling": p["name_respelling"],
            "seniority_tier": p["seniority_tier"],
            "career_start_decade": p["career_start_decade"],
            "prominence_tier": p["prominence_tier"],
            "prominence_basis": p["prominence_basis"],
            # R-022: NULL reads as I0 — unknown, never "being social". R-022b: at most two.
            "intent": p["intent"] if "intent" in p.keys() else None,
            "intent_secondary": (p["intent_secondary"]
                                 if "intent_secondary" in p.keys() else None),
            "intent_basis": p["intent_basis"] if "intent_basis" in p.keys() else None,
            "industries": [r["industry_slug"] for r in self.conn.execute(
                "SELECT industry_slug FROM person_industry WHERE person_id = ? ORDER BY 1",
                (person_id,))],
            "topics_professional": [t["topic_slug"] for t in topics if t["kind"] == "professional"],
            "topics_personal": [t["topic_slug"] for t in topics if t["kind"] == "personal"],
            "contexts": [
                {"type": r["type"], "value": r["value"], "resolved": r["resolved"]}
                for r in self.conn.execute(
                    "SELECT type, value, resolved FROM context WHERE person_id = ?"
                    " ORDER BY type, value", (person_id,))
            ],
            "declared_links": [
                {"to": r["to_id"], "kind": r["type"], "evidence_fact_id": r["evidence_fact_id"],
                 "evidence_date": r["observed_at"]}
                for r in self.conn.execute(
                    f"SELECT to_id, type, evidence_fact_id, observed_at FROM edge"
                    f" WHERE from_id = ? AND type IN ({','.join('?' * len(DIRECTED_LINK_TYPES))})"
                    f" ORDER BY to_id, type", (person_id, *DIRECTED_LINK_TYPES))
            ],
        }

    def signal_evidence(self, person_id: str, others: list[str]) -> dict:
        """Dates behind fired signals, for tie-break tier 2.

        A signal's date is the date of the FACT backing it. Only dated evidence is returned; an
        undated signal falls through to tier 3 rather than inventing an order.
        """
        out: dict[str, dict] = {}
        for other in others:
            dates = {}
            row = self.conn.execute(
                f"SELECT MAX(COALESCE(f.source_date, e.observed_at)) AS d FROM edge e"
                f" LEFT JOIN fact f ON f.id = e.evidence_fact_id"
                f" WHERE e.from_id = ? AND e.to_id = ?"
                f"   AND e.type IN ({','.join('?' * len(DIRECTED_LINK_TYPES))})",
                (person_id, other, *DIRECTED_LINK_TYPES)).fetchone()
            if row and row["d"]:
                dates["S7"] = row["d"][:10]        # declared link
            row = self.conn.execute(
                "SELECT MAX(f.source_date) AS d FROM context ca"
                " JOIN context cb ON cb.type = ca.type AND cb.value = ca.value"
                " LEFT JOIN fact f ON f.id = ca.evidence_fact_id"
                " WHERE ca.person_id = ? AND cb.person_id = ? AND ca.resolved = 1"
                "   AND cb.resolved = 1", (person_id, other)).fetchone()
            if row and row["d"]:
                dates["S3"] = row["d"][:10]        # shared context
            row = self.conn.execute(
                "SELECT MAX(f.source_date) AS d FROM person_topic pa"
                " JOIN person_topic pb ON pb.topic_slug = pa.topic_slug"
                " LEFT JOIN fact f ON f.id = pa.evidence_fact_id"
                " WHERE pa.person_id = ? AND pb.person_id = ?", (person_id, other)).fetchone()
            if row and row["d"]:
                dates["S5"] = row["d"][:10]        # shared topic
                dates["S6"] = row["d"][:10]
            if dates:
                out[other] = dates
        return out

    # ── presence ──────────────────────────────────────────────────────────────
    def present_ids(self) -> list[str]:
        """R-044. Ordered by arrival. Read through `v_present`.

        Grouped, not just joined. `v_present` yields one row per LIVE ROSTER ROW, so joining it
        back against `roster` squares any duplication — two live rows for one person came back as
        four, and every one of them was scored and surfaced separately. Presence is a set of
        people; this returns each person once, ordered by their earliest live arrival.
        """
        return [r["person_id"] for r in self.conn.execute(
            "SELECT v.person_id, MIN(r.arrived_at) AS arrived FROM v_present v"
            " JOIN roster r ON r.person_id = v.person_id AND r.departed_at IS NULL"
            " GROUP BY v.person_id ORDER BY arrived, v.person_id")]

    def roster_rows(self) -> list[dict]:
        """What Room lists. One row per PERSON, dated by their earliest live arrival."""
        return [dict(r) for r in self.conn.execute(
            "SELECT r.person_id, MIN(r.arrived_at) AS arrived_at, p.display_name"
            " FROM roster r JOIN person p ON p.id = r.person_id"
            " WHERE r.departed_at IS NULL GROUP BY r.person_id"
            " ORDER BY arrived_at, r.person_id")]

    # ── facts and coverage ────────────────────────────────────────────────────
    def _register_filter(self) -> str:
        """SQL guard excluding `operational` collection notes from anything card-bound.

        Those rows exist for the engine — measured absences, identity checks, follow-graph
        methodology — and a member must never read one over the host's shoulder. An older store
        without the column has no such rows to hide.
        """
        cols = {r["name"] for r in self.conn.execute("PRAGMA table_info(fact)")}
        return (" AND COALESCE(register, 'member') <> 'operational'"
                if "register" in cols else "")

    def candidate_facts(self, person_id: str) -> list[dict]:
        """Live MEMBER facts for a subject, pre-gate. `select_renderable_facts` applies the
        store's view; operational collection notes never enter the pool."""
        rows = self.conn.execute(
            "SELECT * FROM fact WHERE subject_id = ? AND superseded_by IS NULL"
            + self._register_filter()
            + " ORDER BY COALESCE(source_date, observed_at) DESC, id", (person_id,))
        out = []
        for r in rows:
            d = dict(r)
            d["fact_id"] = d.pop("id")
            out.append(d)
        return out

    def suppressed_facts(self, person_id: str) -> list[dict]:
        """Facts held back on purpose. Class and count reach the card; text never does (R-028)."""
        try:
            rows = self.conn.execute(
                "SELECT id, suppression_class FROM fact WHERE subject_id = ?"
                " AND suppression_class IS NOT NULL AND superseded_by IS NULL ORDER BY id",
                (person_id,))
        except sqlite3.OperationalError:
            return []                      # schema request not merged yet; see docs/schema-requests.md
        return [{"fact_id": r["id"], "class": r["suppression_class"]} for r in rows]

    def source_status(self, person_id: str) -> list[dict]:
        return [dict(r) for r in self.conn.execute(
            "SELECT source_id, tier, status, reason, http_code, fact_count, checked_at"
            " FROM source_status WHERE person_id = ? ORDER BY source_id", (person_id,))]

    def recency_state(self, person_id: str) -> dict | None:
        """R-058 / P-4. The view is the only thing that distinguishes `quiet` from `unknown`."""
        r = self.conn.execute(
            "SELECT coverage, unreached_sources FROM v_recency_state WHERE person_id = ?",
            (person_id,)).fetchone()
        return dict(r) if r else None

    def items(self, person_id: str) -> list[dict]:
        """Dated first-person items, for the Now block. A rerun is dated by its recording."""
        cols = {r["name"] for r in self.conn.execute("PRAGMA table_info(fact)")}
        rec = "recorded_at" if "recorded_at" in cols else "NULL AS recorded_at"
        rer = "is_rerun" if "is_rerun" in cols else "0 AS is_rerun"
        rows = self.conn.execute(
            f"SELECT id, text, source_date, source_url, {rec}, {rer} FROM fact"
            f" WHERE subject_id = ? AND superseded_by IS NULL AND source_date IS NOT NULL"
            f"{self._register_filter()}"
            f" ORDER BY source_date DESC, id", (person_id,))
        return [
            {"item_id": r["id"], "text": r["text"], "published_at": r["source_date"],
             "recorded_at": r["recorded_at"], "is_rerun": bool(r["is_rerun"]),
             "source_url": r["source_url"]}
            for r in rows
        ]

    def close(self) -> None:
        self.conn.close()
