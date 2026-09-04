#!/usr/bin/env python3
"""Build the serving store — OUTSIDE db/, always.

`db/` is frozen: live ingest agents are writing there while this runs. This script reads it and
never writes it. The DDL and seeds are read as text; live `.db` files are opened `mode=ro`.

    python scripts/build_store.py --out var/arena.serve.db --merge --seed

  --merge  copy measured rows out of every db/arena*.db that exists, read-only
  --seed   overlay seed/synthetic.sql — MY synthetic demo material, tagged run_synthetic_demo,
           so it is separable from measured material by a single predicate

Load order is schema.sql -> vocabulary.sql -> roster.sql, with PRAGMA foreign_keys = ON.
"""
from __future__ import annotations

import argparse
import sqlite3
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from arena.config import DB_DIR, LOAD_ORDER, SEED_SQL  # noqa: E402
from arena.store import read_only  # noqa: E402

#: Proposed in docs/schema-requests.md; applied HERE, to the scratch store only, never to db/.
#:
#: R-032 requires deletion to be a REAL purge, and db/schema.sql's own closing comment says
#: `DELETE FROM person WHERE id=?` already is one. It is not: `fact.subject_id` — the largest table
#: and the one that matters — references `person(id)` with no ON DELETE action at all, so the
#: delete raises FOREIGN KEY constraint failed and nothing is purged. Same for `roster.person_id`
#: and `card.subject_id`. SQLite cannot ALTER a foreign-key action, so the fix is a DDL text patch
#: applied while the tables are still empty. Each replacement is asserted, so an upstream schema
#: change surfaces loudly instead of silently skipping the fix.
FK_ACTION_PATCHES = (
    ("fact.subject_id",
     "  subject_id       TEXT NOT NULL REFERENCES person(id),",
     "  subject_id       TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,"),
    ("fact.via_person_id",
     "  via_person_id    TEXT REFERENCES person(id),",
     "  via_person_id    TEXT REFERENCES person(id) ON DELETE SET NULL,"),
    ("fact.superseded_by",
     "  superseded_by    TEXT REFERENCES fact(id),",
     "  superseded_by    TEXT REFERENCES fact(id) ON DELETE SET NULL,"),
    ("*.evidence_fact_id",
     "  evidence_fact_id TEXT REFERENCES fact(id),",
     "  evidence_fact_id TEXT REFERENCES fact(id) ON DELETE SET NULL,"),
    ("roster.person_id",
     "  person_id   TEXT NOT NULL REFERENCES person(id),",
     "  person_id   TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,"),
    ("card.subject_id",
     "  subject_id     TEXT NOT NULL REFERENCES person(id),",
     "  subject_id     TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,"),
)


def patched_schema(text: str) -> tuple[str, list[str]]:
    """Return db/schema.sql's DDL with the proposed ON DELETE actions, and what was patched."""
    applied = []
    for name, old, new in FK_ACTION_PATCHES:
        if old not in text:
            raise AssertionError(
                f"db/schema.sql no longer contains the line the {name} cascade request patches. "
                f"Re-derive docs/schema-requests.md against the current schema before building.")
        text = text.replace(old, new)
        applied.append(name)
    return text, applied


SCHEMA_REQUESTS = (
    ("fact", "recorded_at", "ALTER TABLE fact ADD COLUMN recorded_at TEXT"),
    ("fact", "is_rerun",
     "ALTER TABLE fact ADD COLUMN is_rerun INTEGER NOT NULL DEFAULT 0 CHECK (is_rerun IN (0,1))"),
    ("fact", "suppression_class", "ALTER TABLE fact ADD COLUMN suppression_class TEXT"),
    ("fact", "quote", "ALTER TABLE fact ADD COLUMN quote TEXT"),
)

#: FK-safe order. `fact.superseded_by` is self-referential, so FKs are off during the copy and
#: `PRAGMA foreign_key_check` runs afterwards — a violation is reported, never swallowed.
MERGE_ORDER = (
    "run", "person", "member_flags", "member_label", "corroboration_kind",
    "person_identity", "person_identity_negative",
    "fact", "person_topic", "person_industry", "context", "edge", "source_status", "roster",
)

#: Which column says whose row this is. Ten collectors run independently, so the same non-member,
#: the same shared edge and the same seed row arrive from several files. Two collectors recording
#: `m_wilson -> m_kopelman follows` is corroboration, not a conflict — but only one row can survive
#: a primary key, and which one survives decides whose evidence fact the edge names.
#:
#: R-010 settles it: the member's own words outrank the follow graph outrank press. So the file
#: that OWNS the row wins — `arena.m_wilson.db` is authoritative for edges leaving Wilson and for
#: facts about Wilson — and every other file's copy is kept only where the owner wrote nothing.
#: Deterministic either way, and the losing collector's evidence fact is still in the store; it is
#: simply not the one the edge points at.
#: Deliberately narrow: only the tables a COLLECTOR produces. `person`, `member_label`,
#: `person_identity`, `person_identity_negative`, `person_topic` and `person_industry` are seeded
#: by db/roster.sql and db/vocabulary.sql, which are the canonical cast and the measured deny-list.
#: A collection run does not get to overwrite those.
OWNED_BY = {
    "fact": "subject_id",
    "edge": "from_id",
    "context": "person_id",
    "source_status": "person_id",
}


def _owner(path: Path) -> str | None:
    """`db/arena.m_wilson.db` -> `m_wilson`. `db/arena.db` owns nothing in particular."""
    stem = path.stem
    return stem.split("arena.", 1)[1] if stem.startswith("arena.") and stem != "arena" else None


def _columns(conn: sqlite3.Connection, table: str) -> list[str]:
    return [r["name"] for r in conn.execute(f"PRAGMA table_info({table})")]


def _apply_schema_requests(conn: sqlite3.Connection) -> list[str]:
    applied = []
    for table, column, ddl in SCHEMA_REQUESTS:
        if column not in _columns(conn, table):
            conn.execute(ddl)
            applied.append(f"{table}.{column}")
    conn.commit()
    return applied


def build(out: Path, *, merge: bool, seed: bool, quiet: bool = False) -> dict:
    def say(msg: str) -> None:
        if not quiet:
            print(msg)

    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists():
        out.unlink()

    conn = sqlite3.connect(out)
    conn.row_factory = sqlite3.Row
    cascade_applied: list[str] = []
    for path in LOAD_ORDER:
        text = path.read_text()                       # READ from db/, never write
        if path.name == "schema.sql":
            text, cascade_applied = patched_schema(text)
        conn.executescript(text)
        say(f"  loaded {path.relative_to(DB_DIR.parent)}")
    if cascade_applied:
        say(f"  applied the ON DELETE request to the scratch store only: "
            f"{', '.join(cascade_applied)}")
    conn.execute("PRAGMA foreign_keys = ON")
    conn.commit()

    # The serving run. Cards emitted at runtime name it, so "what did the card say on Friday, and
    # why" stays answerable and every row in the store still names the run that produced it (R-051).
    conn.execute(
        "INSERT OR IGNORE INTO run (id, started_at, execution_ctx, notes)"
        " VALUES ('run_serving', ?, 'deployed_runtime',"
        " 'Cards emitted by the serving path. No fact is ever written under this run.')",
        (datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),))
    conn.commit()

    applied = _apply_schema_requests(conn)
    if applied:
        say(f"  applied pending schema requests to the scratch store only: {', '.join(applied)}")

    report = {"merged": {}, "seeded": False,
              "schema_requests_applied": applied + cascade_applied}

    if merge:
        conn.execute("PRAGMA foreign_keys = OFF")
        for src_path in sorted(DB_DIR.glob("arena*.db")):
            try:
                src = read_only(src_path)             # mode=ro. Ingest is writing these RIGHT NOW.
            except sqlite3.Error as exc:
                say(f"  ! {src_path.name}: {exc} — skipped")
                continue
            copied, dropped, overridden = 0, {}, {}
            owner = _owner(src_path)
            try:
                for table in MERGE_ORDER:
                    try:
                        src_cols = _columns(src, table)
                    except sqlite3.Error:
                        continue
                    if not src_cols:
                        continue
                    cols = [c for c in src_cols if c in _columns(conn, table)]
                    if not cols:
                        continue
                    collist = ", ".join(cols)
                    rows = list(src.execute(f"SELECT {collist} FROM {table}"))
                    if not rows:
                        continue
                    own_col = OWNED_BY.get(table)
                    owned, borrowed = [], []
                    for r in rows:
                        values = tuple(r[c] for c in cols)
                        is_owned = (owner is not None and own_col in cols
                                    and r[own_col] == owner)
                        (owned if is_owned else borrowed).append(values)

                    placeholders = ", ".join("?" * len(cols))

                    def count() -> int:
                        return conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]

                    # INSERT OR IGNORE is how the same non-member, the same run row and the same
                    # roster seed arrive from ten files without colliding. It is ALSO how a genuine
                    # id collision between two collectors would disappear in silence, so the drop
                    # is counted per table and reported rather than assumed benign.
                    before = count()
                    if borrowed:
                        conn.executemany(
                            f"INSERT OR IGNORE INTO {table} ({collist})"
                            f" VALUES ({placeholders})", borrowed)
                    kept = count() - before
                    if kept != len(borrowed):
                        dropped[table] = dropped.get(table, 0) + (len(borrowed) - kept)

                    if owned:
                        # The owner is authoritative for its own rows (R-010), so it replaces
                        # rather than yields. Counted separately so the override is visible.
                        mid = count()
                        conn.executemany(
                            f"INSERT OR REPLACE INTO {table} ({collist})"
                            f" VALUES ({placeholders})", owned)
                        added = count() - mid
                        if added != len(owned):
                            overridden[table] = overridden.get(table, 0) + (len(owned) - added)
                    copied += count() - before
            except sqlite3.Error as exc:
                say(f"  ! {src_path.name}: {exc} — partial merge kept")
            finally:
                src.close()
            conn.commit()
            report["merged"][src_path.name] = {"inserted": copied, "already_present": dropped,
                                               "owner_overrode": overridden}
            note = ""
            if dropped:
                note += ("  [already present: "
                         + ", ".join(f"{t} {n}" for t, n in sorted(dropped.items())) + "]")
            if overridden:
                note += ("  [owner overrode: "
                         + ", ".join(f"{t} {n}" for t, n in sorted(overridden.items())) + "]")
            say(f"  merged {copied} rows from {src_path.name} (read-only){note}")
        conn.execute("PRAGMA foreign_keys = ON")

    if seed and SEED_SQL.exists():
        conn.executescript(SEED_SQL.read_text())
        conn.commit()
        report["seeded"] = True
        say(f"  seeded {SEED_SQL.name} (synthetic, tagged run_synthetic_demo)")

    violations = list(conn.execute("PRAGMA foreign_key_check"))
    if violations:
        say(f"  ! {len(violations)} foreign-key violation(s) after build; first: {tuple(violations[0])}")
    report["fk_violations"] = len(violations)

    counts = {}
    for table in ("person", "fact", "edge", "context", "source_status", "roster", "topic"):
        counts[table] = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    report["counts"] = counts
    say("  " + "  ".join(f"{k}={v}" for k, v in counts.items()))

    conn.close()
    return report


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", default="var/arena.serve.db")
    ap.add_argument("--merge", action="store_true", help="copy measured rows from db/arena*.db")
    ap.add_argument("--seed", action="store_true", help="overlay seed/synthetic.sql")
    ap.add_argument("--quiet", action="store_true")
    args = ap.parse_args()
    out = Path(args.out)
    if DB_DIR in out.resolve().parents:
        print("refusing to build inside db/ — it is frozen", file=sys.stderr)
        return 2
    if not args.quiet:
        print(f"building {out}")
    build(out, merge=args.merge, seed=args.seed, quiet=args.quiet)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
