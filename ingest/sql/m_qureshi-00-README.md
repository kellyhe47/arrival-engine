# m_qureshi ingest — how `db/arena.m_qureshi.db` was built

This is a per-person store. The shared `db/arena.db` is read-only and was never changed.

```bash
work_dir="$(mktemp -d)"
work_db="$work_dir/arena.m_qureshi.db"
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_qureshi-0[123]-*.sql; do
  sqlite3 "$work_db" < "$f"
done
sqlite3 "$work_db" "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
mv "$work_db" db/arena.m_qureshi.db
```

To merge into a database that already contains schema, vocabulary, and roster rows, apply only the
three numbered SQL files and rebuild `fact_fts`.

Shared-table effects are deliberately narrow and replayable:

- Inserts `run_ingest_qureshi_20260903` and 32 namespaced `f_qureshi_*` facts.
- `INSERT OR IGNORE`s two one-hop non-members: Will Manidis and Tyler Cowen.
- Adds 10 `person_identity` rows scoped to `m_qureshi`; existing roster allow-list and deny-list rows
  are not updated. The wrong Wikipedia, Instagram, and GitHub identities were never fetched.
- Updates only `m_qureshi.career_start_decade` and the evidence ids on the member's two seeded topic
  rows. `name_respelling` remains NULL and the prominence row is unchanged despite follower drift.
- Adds 10 contexts, four positive directed edges, and one measured-absence edge. The Qureshi–Feld
  absence names both searched corpora; the X follow walk writes only the reached Tyler Cowen edge.
- Adds 16 `source_status` rows. Thirteen are `ok`, the inferior title-only RSS is `skipped`, and the
  New Statesman remainder plus the Open Library recheck are `unavailable`.
- `ingest/BLOCKERS.md` remains untouched: no surviving auth wall exists. The New Statesman paywall
  and Open Library connection failure are non-auth auxiliary limitations and are retained in
  `source_status` and the report.
