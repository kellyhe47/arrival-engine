# m_wilson ingest — how `db/arena.m_wilson.db` was built

Per-person store, so concurrent ingest agents don't collide on `db/arena.db`.
`db/arena.db` is left as the untouched roster seed.

```bash
rm -f db/arena.m_wilson.db
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_wilson-0[123]-*.sql; do
  sqlite3 db/arena.m_wilson.db < "$f"
done
sqlite3 db/arena.m_wilson.db "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
```

To merge into a shared store that already has schema + vocabulary + roster loaded, apply only
the three `m_wilson-0[123]-*.sql` files, then rebuild `fact_fts`. They touch nothing outside
`m_wilson`, its one-hop non-members (`p_*`), and three `UPDATE`s:

- `person.career_start_decade` for `m_wilson` only
- `person_topic.evidence_fact_id` for `m_wilson`'s three topics only
- `run.notes`/`finished_at` for `run_ingest_wilson_20260903` only

New rows in shared tables, safe to co-apply: 10 `person` rows with `is_member=0`
(`p_joanne_wilson`, seven USV members off Form ADV Schedule A, `p_jerry_colonna`,
`p_michael_mignano`) and 6 `person_identity` rows scoped to `m_wilson`
(`usv_bio`, `sec_adv_pdf`, `partner_blog`, `x_public`, `instagram_public`, `threads`).

No `person_identity_negative` rows added — no new collision was measured.
