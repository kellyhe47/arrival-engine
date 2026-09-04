# `m_tavel` · Sarah Tavel

Benchmark, Partner. Prominence 3 (X 52,896). Seniority principal. Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_tavel.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_tavel-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_tavel_<date>`, `f_tavel_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/sarahtavel`, and it is the single richest source she has.** A slug IS attested: her own **Substack profile lists it in its `userLinks`** (`linked_from_own_canonical`, STRONG). It is the source that settles `career_start_decade` = **2000s** (Consultant, The Kerdan Group, **Jun 2005**) and it carries her full employment spine in her own words — Bessemer VP May 2006–Apr 2012, **first PM at Pinterest** Apr 2012–Jul 2015, Greylock GP 2015–2017, Benchmark Partner May 2017–present, with her own deal and board lists. It also independently corroborates two Adventurista deep cuts twenty years apart: **Harvard A.B. Philosophy cum laude, "Captain of Women's Rugby Team as a sophomore"**, and her entire high-school entry, verbatim: **"Stuyvesant High School — Nerd amongst nerds."** 38,047 followers — below her X figure, so not a prominence candidate.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

Her own bio: *"Blogging since 2006. Partner @benchmark. formerly: product @pinterest. vc @greylockvc,
@bessemervp."*

## Fetch
| url | what |
|---|---|
| `https://www.sarahtavel.com/feed` | 20 items, 2023-04-24 → 2025-09-03. `sarahtavel.substack.com` 301s here |
| `https://www.sarahtavel.com/api/v1/publication/users/ranked?public=true` | bio verbatim |
| `https://medium.com/feed/@sarahtavel` | **the feed works where the HTML 403s.** 10 items, dormant since 2024 |
| `https://web.archive.org/web/20140110041657/http://www.adventurista.com/` | **113 posts, 2006–2015.** The big one — see the warning below |
| `https://api.fxtwitter.com/sarahtavel` | 52,896 followers, joined 2008 |
| `https://every.to/podcast/what-s-missing-from-ai-tools-is-other-people` | **public transcript**, 2025-04-30 |
| EDGAR CIK **0001774645** | 14 filings, Benchmark Form 4s and Form Ds |
| `https://www.linkedin.com/in/sarahtavel` | SESSION |

Her firm is deliberately empty — `benchmark.com` is **2,297 bytes** (name, two addresses, a link),
no bios, no blog, no RSS; `/people` is 404. Stop probing it.

## Never fetch / can't conclude
- `medium.com/@sarahtavel` HTML — 403; use the feed
- `instagram.com/sarahtavel/` — login wall. Public vs private **cannot be determined.** Don't guess
- TikTok `@sarahtavel` exists with **1 video, ever**. Record it as the nothing it is
- **No Wikipedia article** (404) — so `career_start_decade` must come from LinkedIn or her own text

## The warning — read before touching Adventurista
A first pass over 152 archived pages at **concurrency 8** returned almost zero hits, because
`web.archive.org` started refusing connections partway through and **the errors were discarded**. A
slower second pass found four Fred Wilson references and a Hunter Walk reference.
**Never trust a Wayback crawl that doesn't count its own failures** — an uncounted failure becomes a
false `no_edge_confirmed`.

## Inner circle (one hop)
Benchmark partners; Pinterest, Greylock, Bessemer (`employer_history`). `@cklemke` resolves to
Christine Lemke — verify before creating an edge.

## Edges
- **Adventurista names Fred Wilson (4×) and Hunter Walk, and nobody else** (her side).
- **Clean zero across all 113 posts:** Kopelman, Huffman, Shear, Ries, Qureshi, Perkins — plus the
  strings **"Twitch"** and **"Lean Startup"**, which never appear.
- **Pinterest's S-1 is a dead end** — she gets 0 hits; the 14 "Wilson" hits are director *Michelle*
  Wilson. Don't build an edge from a surname.
- **Don't merge AI tags.** Hers is AI-and-work, Shear's is alignment, Huffman's is moderation.

## Topics needing evidence
`venture-capital-craft` (non-discriminating), `marketplace-dynamics`, `rugby` (Adventurista: *"I
can't believe I played for four years"*). Also measured: `blogging-practice`, shared with Wilson —
but hers is *about* him.

## Deep cut
Adventurista is the mine. Known veins: she ran it 2006–2015 and **the "-ista" was a deliberate
feminist joke**; she played rugby for four years; *"I regret to inform you that Bessemer does not
have a corporate jet."* Cadence: ~0.7 posts/month, bursty — 8 in Jan–Sep 2025, then nothing for 12
months. Lifetime corpus ≈ 113 + 10 + 20. She is low-volume and high-effort, and says so herself.

## Backfill / auth
`career_start_decade` — no Wikipedia; LinkedIn or "blogging since 2006". Respelling **needed** —
"Tavel" isn't obvious; source it from the Every podcast audio or leave NULL.
**Re-measure her recency before calling her stale** — the same logged-out assumption was overturned
for Perkins once LinkedIn was readable. Wayback is flaky, not walled: retry slowly, count failures.
