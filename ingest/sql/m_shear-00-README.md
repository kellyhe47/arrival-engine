# m_shear ingest — how `db/arena.m_shear.db` was built

Per-person store. `db/arena.db` was **not opened for writing** at any point.

```bash
rm -f db/arena.m_shear.db
for f in db/schema.sql db/vocabulary.sql db/roster.sql \
         ingest/sql/m_shear-0[12]-*.sql; do
  sqlite3 db/arena.m_shear.db < "$f"
done
sqlite3 db/arena.m_shear.db "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
```

To merge into a shared store that already has schema + vocabulary + roster, apply the two
`m_shear-0[12]-*.sql` files **in order**. Order matters: every `edge` and `context` in file 02
references a fact id created in file 01, and the two absence-evidence facts (`f_shear_057`,
`f_shear_059`) must exist before the seven `no_edge_confirmed` edges and the two `shared_org`
edges that cite them.

Everything written is scoped to `m_shear`, its one-hop non-members (`p_*`), or its own run row.
Verified by diffing a clean schema+vocabulary+roster build against this one: the only shared rows
that differ are the three named below.

## Shared-table rows this run touches

**New `person` rows, all `is_member=0`, all `INSERT OR IGNORE`** (11). Three are shared ground with
other agents and are the reason the ids are `p_<first>_<last>` rather than namespaced:
`p_michael_seibel` (Justin.tv co-founder **and on Reddit's board** — a Huffman run will reach him),
`p_adam_goldstein` (**Hipmunk co-founder with Huffman**, and Softmax co-founder and board member —
the second, independent Shear→Huffman bridge), `p_alexis_ohanian`.

Full list: `p_justin_kan`, `p_michael_seibel`, `p_kyle_vogt`, `p_adam_goldstein`,
`p_david_bloomin`, `p_yatharth_agarwal`, `p_david_langer`, `p_alexis_ohanian`,
`p_leonore_estrada`, `p_dan_clancy`, `p_trevor_blackwell`.

**New `person_identity` rows** (11), all `person_id='m_shear'`, all `INSERT OR IGNORE`:
`hn_algolia`, `firm_team`, `personal_site` (**edbs.media — new, not previously catalogued**),
`linkedin_session`, `linkedin_archive`, `instagram_session`, `threadreader`, `yale_paper`,
`substack` (`role='dead'`), `facebook_session` and `tiktok_public` (both `role='negative_probe'`,
so `v_collectable_source` excludes them).

**One new `person_identity_negative` row:** `https://www.tiktok.com/@eshear` → "Ramdas Paladi".
A measured collision, not a guess. It is also a *correction*: that handle previously returned
"Couldn't find this account" and now resolves to somebody else, which is the worse failure mode.

**Three `UPDATE`s, all scoped to my own rows:**

- `person.career_start_decade = '2000s'` for `m_shear` only (Yale 2005 + YC's first batch, 2005)
- `member_label.basis` / `.measured_at` for `m_shear` only — the row was already correct
  (`stale=1`, current `Softmax — CEO`); only the evidence string was refreshed to cite four
  same-day surfaces
- `run.finished_at` / `run.notes` for `run_ingest_shear_20260903` only

**One new `person_topic` row:** `m_shear` / `reading-and-books`.

**Not touched:** `person.prominence_tier` and `prominence_basis` (fxtwitter now reads 123,009
against the roster's 123,007 — a drift of two, same band, not a new measurement);
`person.seniority_tier` (already `chief-executive`; fixture G-017 still says `founder` and that is
logged as defect P0-9 — the table is not bent to match the fixture); `name_respelling` (still NULL,
no recording fetched); **every `db/vocabulary.sql` count**, including `topic.holder_count` for
`reading-and-books`, which now under-counts by one — see the report; every other member's row.
