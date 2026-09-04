# Eric Ries parallel ingest

Shard file: **`db/arena.m_ries.db`**. Nothing here writes to `db/arena.db`.

```sh
rm -f db/arena.m_ries.db
sqlite3 -bail db/arena.m_ries.db < db/schema.sql
sqlite3 -bail db/arena.m_ries.db < db/vocabulary.sql
sqlite3 -bail db/arena.m_ries.db < db/roster.sql
sqlite3 -bail db/arena.m_ries.db < ingest/sql/m_ries-01-facts.sql
sqlite3 -bail db/arena.m_ries.db < ingest/sql/m_ries-02-edges-contexts-status.sql
sqlite3 db/arena.m_ries.db "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
```

The first file opens `run_ingest_ries_20260903` and leaves `finished_at` NULL; the second is the
only place that sets counts, notes and `finished_at`, so an interruption between the two cannot
look complete. If a merge store already holds the unfinished run, resume by applying file 02 only —
do not replay the immutable fact layer into that store.

## Shared-table rows this shard touches

| table | what |
|---|---|
| `run` | 1 insert + 1 update, `run_ingest_ries_20260903` only |
| `person` | 1 **UPDATE** of `m_ries` (`career_start_decade='1990s'`) + 6 `INSERT OR IGNORE` one-hop non-members |
| `fact` | 58 inserts, `f_ries_001` … `f_ries_058` |
| `person_identity` | 16 `INSERT OR IGNORE`, all `m_ries` |
| `person_identity_negative` | 1 `INSERT OR IGNORE`: `outofthecrisis.com` |
| `edge` | 15 `INSERT OR IGNORE`, all `from_id='m_ries'` |
| `context` | 18 `INSERT OR IGNORE`, all `m_ries` |
| `person_topic` | 3 **UPDATE**s of `m_ries` rows only (`evidence_fact_id` backfill) |
| `source_status` | 33 inserts, all `m_ries` + this run |

One-hop people minted: `p_john_bautista`, `p_brian_singerman`, `p_maliz_beams`,
`p_michelle_greene`, `p_annette_nazareth`, `p_will_harvey`.

## What is deliberately NOT changed

- **`prominence_tier` stays 4** and `prominence_basis` is untouched. LinkedIn shows 582,687
  followers against X's 301,420; that is recorded as the dated fact `f_ries_046`, not as a
  re-baseline of a shared roster field. Fixtures G-006/G-017 carrying 3 re-baseline against the
  table, never the reverse.
- **`name_respelling` stays NULL.** No recording was sourced this run.
- No `vocabulary.sql` count is recomputed; no other member's row is touched.

## Two things the merge should carry upward

1. **`db/roster.sql` records `m_ries/github_api` corroboration as `api_name_field_matches`. The
   GitHub API `name` field is null** — along with `bio`, `blog`, `company` and `twitter_username`.
   The identity is still sound, on `linked_from_own_canonical`: his newsletter links
   howisincorruptiblegoing.com, that domain is the GitHub Pages deployment of
   `github.com/ericries/howisincorruptiblegoing`, and `ericries.github.io/howisincorruptiblegoing/`
   redirects to it. See `f_ries_041` / `f_ries_042`. Fix the corroboration string, not the row.
2. **His LinkedIn newsletter "Trust is Everything" (72,340 subscribers) is in no allow-list.**
   It is a first-person long-form channel and the single largest coverage gap found for him.
