# m_huffman ingest — replay and merge notes

This is the isolated Steve Huffman store. The shared `db/arena.db` is never written.

```bash
scratch_dir="$(mktemp -d)"
scratch_db="$scratch_dir/arena.m_huffman.db"
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_huffman-01-schema-overlay.sql \
         ingest/sql/m_huffman-02-ingest.sql \
         ingest/sql/m_huffman-03-fts.sql; do
  sqlite3 "$scratch_db" < "$f"
done
mv "$scratch_db" db/arena.m_huffman.db
```

`m_huffman-01-schema-overlay.sql` applies the pending `fact.suppression_class` schema request to
this scratch database and extends `v_renderable_fact` with the corresponding exclusion. Apply that
file only while the shared schema still lacks the column; once the request is merged upstream, its
DDL is redundant and should be skipped. The ingest and FTS files remain replayable unchanged.

Shared-table effects are scoped and replayable:

- Inserts `run_ingest_huffman_20260903` and 31 `f_huffman_*` facts. Exactly one fact has
  `suppression_class='finance'`; it is countable but structurally absent from
  `v_renderable_fact`.
- `INSERT OR IGNORE`s Alexis Ohanian, Michael Seibel, and Adam Goldstein as one-hop non-members.
- Adds eight `person_identity` rows for newly corroborated SEC, YC, HN, archive, and LinkedIn
  sources. It does not rewrite the five Huffman allow-list rows seeded by `db/roster.sql`.
- Adds the measured `/in/shuffman/` collision to `person_identity_negative`; the accepted
  LinkedIn profile is `/in/shuffman56/`, corroborated by YC's official Reddit founder record.
- Updates only `m_huffman.career_start_decade`, `m_huffman.prominence_tier`,
  `m_huffman.prominence_basis`, and the evidence id for Huffman's seeded
  `content-moderation` topic. `name_respelling` remains NULL.
- Adds 12 directed edges: three one-hop relationships, the Huffman-to-Shear Summer 2005
  `shared_org`, and eight corpus-bounded `no_edge_confirmed` rows. No reverse edge is written.
- Adds seven contexts and 20 source-attempt rows. Reddit live access remains unavailable, so the
  profile coverage is `unknown`, not `quiet`.
