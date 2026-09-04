# Brad Feld ingest sidecar

Build `db/arena.m_feld.db` from the shared seed SQL, then apply the namespaced Feld overlay:

```bash
rm -f db/arena.m_feld.db
for file in db/schema.sql db/vocabulary.sql db/roster.sql; do
  sqlite3 db/arena.m_feld.db < "$file"
done
for file in ingest/sql/m_feld-[0-9][0-9]-*.sql; do
  sqlite3 -bail db/arena.m_feld.db < "$file"
done
```

Shared-table rows touched by the overlay:

- `run`: inserts `run_ingest_feld_20260903` and the follow-up `run_ingest_feld_instagram_20260903`.
- `person`: updates only `m_feld`; inserts-or-ignores `p_amy_batchelor`, `p_jason_mendelson`, and `p_david_cohen`.
- `person_identity`: inserts Feld source identities, refreshes Feld's existing X measurement, and records two non-collectable Instagram candidates as `negative_probe` rows.
- `fact`: inserts only `f_feld_*` rows, including `f_feld_cites_wilson`.
- `person_topic`: updates evidence only for `m_feld`'s five seeded topics.
- `context`: inserts only `m_feld` contexts.
- `edge`: inserts only Feld's outgoing directed relationships and qualified absence edges; reverse Ries observations belong to the Ries sidecar.
- `source_status`: inserts only Feld rows for the two namespaced runs, including the unresolved authenticated Instagram attempt.
- `fact_fts`: rebuilds the content index after the fact inserts.
- `v_assertable_absence`: creates the checked-in schema view only when an older seed snapshot lacks it.

The overlay does not touch another member's profile, topic assignments, prominence, source status, or outgoing edge namespace.
