# m_kopelman ingest — how `db/arena.m_kopelman.db` was built

This is a per-person store so concurrent ingest agents do not collide on `db/arena.db`.
The shared roster database is never written.

```bash
work_db="$(mktemp -d)/arena.m_kopelman.db"
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_kopelman-0[123]-*.sql; do
  sqlite3 "$work_db" < "$f"
done
sqlite3 "$work_db" "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
mv "$work_db" db/arena.m_kopelman.db
```

To merge into a store that already has schema, vocabulary, and roster loaded, apply only the three
`m_kopelman-0[123]-*.sql` files and rebuild `fact_fts`.

Shared-table effects are scoped and replayable:

- Inserts `run_ingest_kopelman_20260903` and 35 namespaced `f_kopelman_*` facts.
- `INSERT OR IGNORE`s 12 one-hop non-members: Robert Hayes, William Trenchard, Phineas Barnes,
  Brett Berson, Christopher Fralic, Hayley Barna, Todd Jackson, Chukwuemeka Asonye, Cristina
  Cordova, Elizabeth Wessel, Meg Whitman, and Howard Morgan.
- Adds 11 `person_identity` rows scoped to `m_kopelman`; existing roster identity rows are not
  updated. The successful current LinkedIn measurement uses `linkedin_session_current` so the
  audit-time 999 row remains historical rather than being overwritten.
- Updates only `m_kopelman.career_start_decade`, the evidence ids on `m_kopelman`'s two seeded
  topics, and this ingest run's completion fields. `name_respelling` remains NULL.
- Adds 23 directed edges and 12 contexts. The one `no_edge_confirmed` edge is limited to the fully
  searched 212-post Redeye corpus. The measured absence in Tavel's 20 + 113 blog posts remains a
  fact but is not an edge because her separate X ingest found two replies to Kopelman.
- Adds deny-list rows for `instagram.com/jkopelman` (operator-confirmed wrong account) and
  `instagram.com/joshk` (a verified but different Josh K associated with Kelly Media Inc.). No
  Instagram profile, post, source-status, context, edge, or allow-list data is retained.
- `ingest/BLOCKERS.md` remains untouched: both retained SESSION sources succeeded, and the two
  unavailable sources were non-authenticated auxiliary retrieval failures.
