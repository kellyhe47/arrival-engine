# `m_ries` · Eric Ries

LTSE; author, *Incorruptible* (2026-05-26). Prominence 4 (X 301,423). Seniority founder.
Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_ries.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_ries-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_ries_<date>`, `f_ries_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/eries`, and it is his single biggest channel.** A slug IS attested: **`theleanstartup.com` and `news.theleanstartup.com` both link it** (`linked_from_own_canonical`, STRONG). ⚠️ **582,687 followers, measured 2026-09-03 — nearly double his 301,420 on X**, so his prominence basis is measured on the wrong platform. Do not re-baseline the row yourself; report it. He also runs a **LinkedIn newsletter, "Trust is Everything", 72,340 subscribers** — a first-person publication channel that appears in **no allow-list in `db/roster.sql`** and is a genuine gap in his source coverage. His activity feed's two newest items were **3 and 4 hours old** at read time: whatever his blog cadence suggests, this is where he actually posts.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

**He looked dormant the month he shipped a book.** The staleness was a retrieval artifact. He is the
most active of the ten — if your pipeline concludes otherwise, your pipeline is wrong.

## Fetch
| url | what |
|---|---|
| `https://news.theleanstartup.com/archive` | **the current primary channel.** 12 posts 2026-05-26 → 08-23. **No working RSS** — scrape the page |
| `https://www.startuplessonslearned.com/sitemap.xml` | **392 posts, 2008 → 2026-05-17** |
| `https://data.sec.gov/submissions/CIK0001757271.json` | **62 filings through 2026-08-17.** Form 1 order 34-85828 |
| CIK **0001680712** and **0001786417** | all 8 LTSE Form D filings, 2016–2022 |
| `https://anchor.fm/s/f51132a8/podcast/rss` | *The Eric Ries Show*, 44 episodes |
| `https://www.youtube.com/@TheEricRiesShow` | live to 2026-09-03 |
| `https://www.linkedin.com/in/eries/` | SESSION. **582,687 followers — nearly 2x his X count**; newest posts hours old |
| *Trust is Everything* — his LinkedIn newsletter, reached from his profile (**do not guess a URL for it**; one article measured at `linkedin.com/pulse/you-cant-inspect-ai-can-watch-how-its-makers-treat-people-eric-ries-aivlc`) | **72,340 subscribers.** A first-person channel in NO allow-list — the real gap in his source coverage |
| `https://api.github.com/users/ericries` | 11 repos, active same-day. Includes the Tom Lehrer songbook |
| `openlibrary.org/isbn/9780307887894.json`, `search.json` | ***Incorruptible*** — Authors Equity, 2026-05-26, ISBN 9798893311860, 432pp |
| `https://en.wikipedia.org/w/index.php?title=Eric_Ries&action=raw` | career start |
| `https://syndication.twitter.com/srv/timeline-profile/screen-name/ericries` | parse `__NEXT_DATA__` — yields 121 tweets where the HTML shell yields none |
| `https://ltse.com/insights` | `ltse.com/newsroom` is a guessed URL and a 404 |

## Never fetch / can't verify
- `ericries.com` — curl exit 000, DNS failure · `theleanstartup.com/feed` 404
- Kickstarter `/projects/ericries/the-leaders-guide` — **403.** *The Leader's Guide* (2015) is the one
  book unverifiable from a primary page; Wikipedia's $588,903 figure is **UNVERIFIED**
- *The Black Art of Java Game Programming* — OpenLibrary lists **Joel Fan only**. His co-authorship is
  **self-reported** from his own blog bio
- `penguinrandomhouse.com/books/210164/…` and `…/546855/…` — guessed URLs, both 404. Don't re-guess
- **The X syndication window is not silence** — its newest item was 2026-01-23. That's a window

## Inner circle (one hop)
**LTSE's entire related-persons universe is four people**, across all 8 Form Ds: Ries, **John V.
Bautista**, **Brian Singerman**, **Maliz Beams** (2022). **No USV, Foundry, First Round, Benchmark or
Homebrew person appears anywhere.** Also **Answer.AI** (founding director, rarely attached to his
name) and **Authors Equity**.

## Edges
- **Ries ↔ Feld:** startup-communities, immigration policy, elections, and a **2026 fireside chat** —
  one of only two verified co-recordings in the whole audit.
- **Ries ↔ Walk, STRONG but asymmetric:** they co-curated ***Uncensored*** (2012), byline *"Hunter
  Walk and Eric Ries"*. ⚠️ **His own 392 posts never mention it** — documented from Walk's side only.
  Don't attribute it to his voice.
- **Measured absences:** Tavel's 113 posts — zero, and **"Lean Startup" never appears at all**. A
  sweep of 19 feeds / 6,915 episodes including **his own two shows** and First Round's *In Depth*
  found **zero co-appearances**. Caveat for the evidence string: RSS titles and descriptions only.

## Topics needing evidence
`startup-communities`, `tech-policy-immigration`, `long-term-governance` (LTSE, Form 1 order
34-85828). Also measured: `tech-policy-elections`.

## Deep cut
Known veins: he is **cc'd on his own exchange's SEC cover letter and it isn't signed by him**; a
**320-page Tom Lehrer songbook he stitched together himself**; the 2008 "About the author" post
(Catalyst Recruiting, There.com, MUDs, a 1996 Java book); **Answer.AI**. Recovered tweets:
2020-09-09 *"I launched a stock exchange today. Ask me anything:"*

## Backfill / auth
`career_start_decade` from Wikipedia, cross-check the 2008 post. Respelling NULL.
**`prominence_tier` = 4**; fixture G-006 carries 3 and re-baselines against the table, not the reverse.
His GREEN coverage is excellent. **If you conclude he is quiet, re-check before writing it down.**
