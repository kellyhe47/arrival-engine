# Melanie Perkins parallel ingest

Shard: **`db/arena.m_perkins.db`**. Isolated from `db/arena.db`, which this run never touched.

```sh
rm -f db/arena.m_perkins.db
sqlite3 -bail db/arena.m_perkins.db < db/schema.sql
sqlite3 -bail db/arena.m_perkins.db < db/vocabulary.sql
sqlite3 -bail db/arena.m_perkins.db < db/roster.sql
sqlite3 -bail db/arena.m_perkins.db < ingest/sql/m_perkins-01-facts.sql
sqlite3 -bail db/arena.m_perkins.db < ingest/sql/m_perkins-02-edges-contexts-status.sql
```

Verified to replay clean from the canonical seed on 2026-09-03; the shipped `.db` was rebuilt
by exactly the commands above. The FTS rebuild is the last statement of file 2.

## What this overlay owns

- `run` — `run_ingest_perkins_20260903`. File 1 opens it with `finished_at` NULL; **file 2 is the
  only place that sets `finished_at` and the final notes**, so an interruption between the two
  files cannot look like a completed run.
- `fact` — `f_perkins_001` … `f_perkins_050`. Append-only; nothing was UPDATEd.
- `person` — `m_perkins.career_start_decade = '2000s'` only. `name_respelling` stays NULL (no
  recording of her saying her own name was fetched). **`prominence_tier` and `prominence_basis`
  are untouched** even though both figures drifted (LinkedIn 370,639 → 370,636; X 56,591 →
  56,593); the drift is recorded as `f_perkins_032` rather than re-baselined into a shared field.
- `person_topic` — `('m_perkins','product-led-growth')` evidence backfilled to `f_perkins_026`.
- `person_identity` — 7 new rows for her, all `INSERT OR IGNORE`.
- `context` — 14 rows, all hers.
- `edge` — 24 rows out of `m_perkins`: 15 real, 9 `no_edge_confirmed`.

## Shared-table rows this overlay touches

One-hop non-members, written `INSERT OR IGNORE` with stable `p_<first>_<last>` ids so a second
agent reaching the same person merges instead of colliding:

`p_cliff_obrecht`, `p_cameron_adams`, `p_lars_rasmussen`, `p_bill_tai`, `p_niki_scevak`,
`p_lenny_rachitsky`, `p_jonathan_shriftman`, `p_greg_mitchell`, `p_antony_sguazzin`,
`p_mike_cannon_brookes`, `p_alex_konrad` — all `is_member = 0`.

No `person_identity_negative` rows were added: no new collision was measured. No schema or
vocabulary change is included.

## Two things a merger should not undo

1. **`f_perkins_050` is the only evidence under the nine `no_edge_confirmed` edges**, and it names
   its corpus exactly: the full Wikipedia wikitext, both memoir parts, the archived newsroom index,
   and the 20 LinkedIn posts. **Her X following list is deliberately excluded** — it was read 56 of
   246 and a partial walk cannot carry an absence (R-011).
2. **`openlibrary.org` was unreachable** (connection refused, twice). The in-book co-mention search
   of Perkins against each of the nine did not run this time, so nothing here re-confirms an
   earlier "0 hits for all nine" from that source.
