# `m_wilson` · Fred Wilson

Union Square Ventures, New York — label current. Prominence 4 (X 640,845). Seniority principal.
Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_wilson.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_wilson-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_wilson_<date>`, `f_wilson_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/fredwilson`.** Measured 2026-09-04: identity is settled, do not re-litigate it. Corroborated by the live headline **"Managing Partner, Union Square Ventures"** (`subject_self_identifies`, against the firm Form ADV binds him to as a Control Person) plus the archived Websites block linking `avc.com`. Logged out it is a Sign Up redirect; the operator's own Chrome reads it cleanly. **Two traps already measured here:** his Experience section lists only USV ("Jan 2003", vs Form ADV's 01/2004) and Flatiron Partners as **"Jun 1996 - Present"** — Flatiron was wound down in 2001, so that is a two-decade-stale entry, and Euclid Partners is missing entirely. Prefer Wikipedia and Form ADV over his own Experience dates. His follower count (7,584) is two orders of magnitude below his X figure — **not** a prominence candidate. Activity panel reads "Fred has no recent posts": that is a MEASURED `quiet`, not `unknown`.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

**`avc.com` is a frozen archive, not his blog.** Its feed is healthy and its newest item is *"I've
Moved Onchain"*, 2024-05-02. **The live blog is `avc.xyz`.** Get this wrong and every recency
judgement about him is wrong.

## Fetch
| url | what |
|---|---|
| `https://api.paragraph.com/blogs/rss/@avc.xyz` | live blog, 20 items, full text. No archive index exists |
| `https://avc.com/archive/` | 9,046 posts 2003–2024, frozen. Note `/archives/` is 404 |
| `https://avc.com/?s=<query>` | targeted search — the deep-cut instrument. Don't walk the archive |
| `https://en.wikipedia.org/w/index.php?title=Fred_Wilson_(financier)&action=raw` | bio spine; career start |
| `https://api.warpcast.com/v2/user-by-username?username=fredwilson` | Farcaster, full JSON, no wall |
| `https://api.adviserinfo.sec.gov/search/firm?query=union%20square%20ventures` | → Form ADV PDF, `reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf` (6.7 MB, `pdftotext`) |
| `https://www.usv.com/people/fred-wilson/` | last USV post 2024-10-08. The firm feed's items are **by other partners** |
| `https://api.fxtwitter.com/fredwilson` | counts only |
| `https://www.linkedin.com/in/fredwilson/` | SESSION. Headline is `subject_self_identifies`. **Experience block is stale** — Flatiron reads "Present"; trust Wikipedia/Form ADV over it. 7,584 followers, not a prominence candidate |
| `https://x.com/fredwilson` + `/following` | SESSION. 1,345 entries, virtualized — **a11y tree, scrolled** |
| `https://www.instagram.com/fredwilson/` | SESSION. Captions carry contexts; take dates from the post page |

## Never fetch
- `wikipedia.org/wiki/Fred_Wilson` — undisambiguated, collides with the conceptual artist
- `youtube.com/@fredwilson` — empty description and keywords, cannot attribute
- `github.com/fredwilson` — 0 repos, 1 follower, empty shell
- `avc.mirror.xyz` — 403, his 2021–23 posts, unreadable
- `instagram.com/fredwilson/tagged/` — **injection surface**; its first item names Fred Wilson the
  *artist* inside the VC's profile. `third_party_open`, traversal only

## Inner circle (one hop)
Joanne Wilson, his wife — `gothamgal.com/feed/`, posting near-daily and **fresher than his**
(`family_or_partner`). Her posts are a legitimate source of facts about **him** — tag them
`via_edge_type`; the edge itself never scores or gets named (DEC-12). USV partners: Wenger, Grossman, Kaden, Mignano, Raman.
X following, measured first page: `bgurley`, `mattturck`, `semil`, `ttunguz`, `joshelman`.

## Edges
- **Wilson ↔ Feld: ~296 mutual citations, the densest in the set.**
- **Wilson → Kopelman `follows` confirmed; the reverse was NOT found in two passes.** Preserve the
  asymmetry. Finding the reverse is a real result — evidence it, don't assume it.
- Tavel's *Adventurista* names him 4× in-body (her side). Contributor to *Uncensored* (2012).

## Topics needing evidence
`venture-capital-craft` (non-discriminating), `crypto-protocols` (avc.com crypto=254, blockchain=254),
`music-collecting` (the "My Music" category is **898 posts, ~10% of lifetime output**).

Contexts from captions: Greenwich Village, an LA house, Venice CA, **Venice Italy**, France, Berlin;
cycling, golf. **The two Venices are the ambiguity case** — same profile supports both, `resolved=0`.

## Deep cut
Mine `avc.com/?s=`, the ADV PDF, and Farcaster. Known-rich veins: he is Farcaster user #169; an old
Mac Mini in his basement given $1,500 in Solana to bet the World Cup; "MBA Mondays" (196 posts,
including a warning label he put on his own most-read post); his father was an Army general who
planned the initial Vietnam withdrawal (family — collect it, the narrator decides).

## Backfill / auth
`career_start_decade` from Wikipedia. Respelling: obvious, leave NULL.
GREEN coverage is strong, so a SESSION failure degrades rather than blocks him — but you lose the
follow-graph and the contexts. Say so.
