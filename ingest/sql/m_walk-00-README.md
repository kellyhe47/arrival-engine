# Hunter Walk parallel ingest

This shard is isolated from `db/arena.db`. Rebuild it from the canonical seed, then apply the two
ordered overlay files:

```sh
rm -f db/arena.m_walk.db
sqlite3 -bail db/arena.m_walk.db < db/schema.sql
sqlite3 -bail db/arena.m_walk.db < db/vocabulary.sql
sqlite3 -bail db/arena.m_walk.db < db/roster.sql
sqlite3 -bail db/arena.m_walk.db < ingest/sql/m_walk-01-facts.sql
sqlite3 -bail db/arena.m_walk.db < ingest/sql/m_walk-02-edges-contexts-status.sql
```

The overlay owns `run_ingest_walk_20260903`, `f_walk_001` through `f_walk_042`, Hunter Walk's
`person`/`person_topic` backfills, his identity and source-attempt rows, his contexts and outgoing
edges, and namespaced non-member people introduced by those edges. One-hop people and edges use
`INSERT OR IGNORE` so the operator can merge this shard with the other nine parallel ingests.
The first SQL transaction leaves the run unfinished; the second transaction is the sole place that
sets final counts, notes, and `finished_at`, so an interruption between files cannot look complete.
If a merge store already contains the unfinished run after `m_walk-01-facts.sql`, resume by applying
`m_walk-02-edges-contexts-status.sql`; do not replay the immutable fact layer into that same store.

No schema or vocabulary changes are included. The seeded prominence tier and 246,611 basis are
left untouched; the overlay records the slightly lower current X measurement and the higher
LinkedIn follower count as dated facts instead of re-baselining a shared roster field.
