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

Run in any order, in parallel if you like — each writes only its own member's rows, plus
`is_member=0` nodes, edges, and any new deny-list rows it discovers. Serially, start with Feld
(everything open, so failures are yours, not the web's).

Every URL, count and quote traces to `docs/audit/01–07`, `db/roster.sql` or `db/vocabulary.sql`.
If a prompt and an audit disagree, the audit wins — say so rather than working around it.
