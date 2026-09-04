# m_tavel ingest — how `db/arena.m_tavel.db` was built

Per-person store, so the ten concurrent ingest agents don't collide on `db/arena.db`.
`db/arena.db` is left as the untouched roster seed.

```bash
rm -f db/arena.m_tavel.db
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_tavel-0[12]-*.sql; do
  sqlite3 db/arena.m_tavel.db < "$f"
done
sqlite3 db/arena.m_tavel.db "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
```

To merge into a shared store that already has schema + vocabulary + roster loaded, apply the two
`m_tavel-0[12]-*.sql` files **in order**, then rebuild `fact_fts`. Order matters inside file 02 as
well: `f_tavel_051` (the absence-evidence fact) is inserted before the six `no_edge_confirmed`
edges that reference it, or the FK fails.

Everything written is scoped to `m_tavel`, its one-hop non-members (`p_*`), or its own run row.

## Shared-table rows this run touches

**New `person` rows, all `is_member=0`, all `INSERT OR IGNORE`** (17). Several are shared ground
with other agents — Benchmark's partner list overlaps nobody else's member, but
`p_ben_silbermann` / `p_evan_sharp` may be reached by a Perkins or Walk run, and the Bessemer and
Greylock names may be reached by Kopelman's:

`p_matt_cohler`, `p_peter_fenton`, `p_bill_gurley`, `p_anyen_hu`, `p_mitchell_lasky`,
`p_chetan_puttagunta`, `p_steven_spurlock`, `p_eric_vishria`, `p_victor_lazarte`,
`p_miles_grimshaw`, `p_christine_lemke`, `p_ben_silbermann`, `p_evan_sharp`, `p_john_lilly`,
`p_jeremy_levine`, `p_philippe_botteri`, `p_byron_deeter`.

**New `person_identity` rows** (8), all `person_id='m_tavel'`, all `INSERT OR IGNORE`:
`blog_archive_api`, `medium_rss`, `sec_person`, `linkedin_session`, `x_session`,
`instagram_session`, `firm_site`, and `tiktok_public` (written `role='negative_probe'` so
`v_collectable_source` excludes it — see below).

**No `person_identity_negative` row was added.** No *new* collision was measured. The TikTok
account is **unresolved**, not proven to be someone else, and the deny-list is for measured
wrong-person URLs. Putting an unresolved candidate on it would assert something not observed.

**Three `UPDATE`s, all scoped to my own rows:**

- `person.career_start_decade = '2000s'` for `m_tavel` only
- `person_topic.evidence_fact_id` for `m_tavel`'s three topics only
  (`venture-capital-craft`, `marketplace-dynamics`, `rugby`)
- `run.finished_at` / `run.notes` for `run_ingest_tavel_20260903` only

**Not touched:** `person.prominence_tier` and `prominence_basis` (fxtwitter now reads 52,899
against the roster's 52,896 — drift of three, not a new measurement); `member_label` (see the
report — her precise role changed in 2025 but her own bios still read "Partner"); every
`vocabulary.sql` count; every other member's row.
