# Ingest prompts

Hand an agent `00-COMMON.md` plus **one** person file.

| file | member | notable |
|---|---|---|
| `00-COMMON.md` | — | rules, auth protocol, what to write, output format |
| `01-m_wilson.md` | Fred Wilson | live blog is `avc.xyz`, not `avc.com` |
| `02-m_feld.md` | Brad Feld | everything open — good first run |
| `03-m_kopelman.md` | Josh Kopelman | thinnest footprint; dead feed that returns 200 |
| `04-m_tavel.md` | Sarah Tavel | Wayback-heavy; count your failures |
| `05-m_walk.md` | Hunter Walk | weakest accepted identity |
| `06-m_huffman.md` | Steve Huffman | three fake handles; prominence blocked on one read |
| `07-m_shear.md` | Emmett Shear | stale label; parking domain 200s on every path |
| `08-m_ries.md` | Eric Ries | looked dormant, had shipped a book |
| `09-m_qureshi.md` | Nabeel Qureshi | name collides with a deceased person — read §1 |
| `10-m_perkins.md` | Melanie Perkins | most exposed to auth failure |

## Expansion source plans

These six briefs use the same collection contract and provenance discipline, but the people are
**not yet members of the ten-person seed in `db/roster.sql`**. Before running one, add audited
member/label/identity rows, review any vocabulary additions, and recompute roster-wide topic and
prominence baselines. Until that is done, use these as source plans only; do not write them into a
database built from the current seed.

| file | candidate | notable |
|---|---|---|
| `11-m_su.md` | Lisa Su | AMD/SEC identity anchors; testimony and recorded interviews for her own words |
| `12-m_scott.md` | Kendra Scott | company-hosted first-person set; a plausible LinkedIn slug is a confirmed collision |
| `13-m_musk.md` | Elon Musk | SEC-filed interview/post exhibits provide unusually strong provenance |
| `14-m_dell.md` | Michael Dell | canonical spelling corrected; subject-controlled link hub binds exact social destinations |
| `15-m_liemandt.md` | Joe Liemandt | deliberately light footprint; prioritize complete, speaker-verifiable interviews |
| `16-m_dorsey.md` | Jack Dorsey | SEC-bound `@jack`; Nostr public key remains a candidate pending strong binding |

Run in any order, in parallel if you like — each writes only its own member's rows, plus
`is_member=0` nodes, edges, and any new deny-list rows it discovers. Serially, start with Feld
(everything open, so failures are yours, not the web's).

**Running them in parallel — the one thing that will bite you.** Each agent writes its own
`db/arena.<person_id>.db`, built from `db/schema.sql` + `db/vocabulary.sql` + `db/roster.sql`.
**Nobody writes `db/arena.db`**; it is the shared seed and a rebuild of it silently discards
whatever another agent just wrote. Each agent also leaves its writes as replayable SQL in
`ingest/sql/<person_id>-NN-*.sql` so the ten files can be merged into one store at the end by
re-applying them. `ingest/BLOCKERS.md` is shared: append, never overwrite. Full rules in the
"You are one of ten agents running in parallel" section of `00-COMMON.md`.

Every URL, count and quote traces to `docs/audit/01–07`, `db/roster.sql` or `db/vocabulary.sql`.
If a prompt and an audit disagree, the audit wins — say so rather than working around it.
