# `m_huffman` · Steve Huffman

Reddit, Inc. — CEO. **Prominence NULL (unmeasured).** Seniority chief-executive.
Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_huffman.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_huffman-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_huffman_<date>`, `f_huffman_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — the attested slug was WRONG. Use `linkedin.com/in/shuffman56`, never `/in/shuffman`.** `/in/shuffman` belongs to **Sarah Huffman** — the only readable capture (2008) is her profile, and the 2021 and 2024 captures are HTTP 999 walls, so nothing ever showed Steve there. It is now a deny-list row. The real profile, `/in/shuffman56`, is corroborated three ways in the archive: a **2010** capture names him co-founder of reddit.com, a **2016** capture lists **"Co-founder, Reddit, June 2005 – October 2009"** plus **Y Combinator 2005–2006** and Image Matters LLC **2001–2005**, and a **2024** capture links Reddit and Hipmunk. **This is the source that unblocked both of his NULL columns:** `career_start_decade` = **2000s** (Image Matters, 2001), and `prominence_tier` = **2** from **8,128 followers** measured 2026-09-03 — he is no longer unmeasured, and he is now the LOWEST of the ten, not the highest. The 2016 capture also independently corroborates the **YC Summer 2005** batch that his only strong edge depends on. Its "People Also Viewed" rail named Ohanian, Kan and Goldstein — **discarded, rails are not edge evidence.**

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

**The crown-jewel source is the hardest one.** Reddit is completely closed to logged-out reads. His
most open, quotable channel is **the SEC**.

## Fetch
Needs the contact UA — `data.sec.gov` 403s without it.

| url | what |
|---|---|
| `https://data.sec.gov/submissions/CIK0001827011.json` | **"Huffman Steve Ladd", 88 filings** from 2020-10-01. ⚠️ CIK 0001690226 is a **different** Steve Huffman |
| `https://data.sec.gov/submissions/CIK0001713445.json` | Reddit, Inc., 478 filings, NYSE:RDDT |
| Q2 2026 8-K + shareholder letter, `…/000171344526000098/` | **the letter is signed by him personally** — the quotable substitute for the un-fetchable earnings call |
| `https://efts.sec.gov/LATEST/search-index?q=…` | full-text search, **2001 onward only** |
| `http://web.archive.org/cdx/search/cdx?url=old.reddit.com/user/spez/comments/` | **the only path to u/spez.** Serial, count failures |
| `https://en.wikipedia.org/w/index.php?title=Steve_Huffman&action=raw` | 322 KB; career start |
| `https://mixergy.com/interviews/steve-huffman-reddit-interview/` | **full free transcript, ~60 KB** |
| `https://redditinc.com/news` | company voice, rarely his — attribute carefully |
| `https://www.linkedin.com/in/shuffman56/` | SESSION. ⚠️ **`56` is load-bearing.** This is the source that filled BOTH his NULL columns: 8,128 followers → tier 2, and Image Matters 2001 → `career_start_decade` 2000s |

## Never fetch — three handles look like him and none are
- **`x.com/spez` — NOT HIM.** 103 followers, no posts. `spez` on Reddit is Huffman; `@spez` on X is
  a stranger. The canonical identity-collision case in this project.
- **`api.fxtwitter.com/stevehuffman`** — 38 followers. **`api.fxtwitter.com/shuffman`** — 4
  followers. His LinkedIn slug is **`shuffman56`**; his X is neither.
- **`linkedin.com/in/shuffman` — NOT HIM.** Belongs to **Sarah Huffman**; the one readable capture
  (2008) is her profile and the 2021/2024 captures are 999 walls. It was the attested slug in an
  earlier version of this prompt and it was wrong. Use `shuffman56`.
- `investor.redditinc.com` 403 · Instagram `/spez/` login-gated · TikTok `@spez` not-found
- **Reddit keyless `.json`** — `old.reddit` 302s to `/login`, `www.reddit` 403s on every UA, `.rss`
  429s after one request. Use OAuth or drop it.

## Prominence — the one member with no measurable figure
Every GREEN path is exhausted, so his tier is **NULL** and **S8 cannot fire in either direction**.
That is correct output. Do not substitute a count from an account you haven't confirmed.
**RESOLVED 2026-09-03 by one SESSION read of `linkedin.com/in/shuffman56`:** 8,128 followers →
**`prominence_tier` = 2**. He is now the LOWEST of the ten, not the highest — and, like Perkins, he
is ranked on LinkedIn rather than X, so the K-9 cross-platform caveat applies to him too.

## Inner circle (one hop)
**Alexis Ohanian** (co-founder). **Michael Seibel** — on Reddit's board since 2020, formerly CEO of
Justin.tv/Twitch. **Adam Goldstein** — his Hipmunk co-founder, now on **Softmax's board**. The last
two are institutional bridges to Shear.

## Edges — one strong, eight measured absences
- **Huffman ↔ Shear: same YC batch, Summer 2005.** YC's own directory returns exactly 9 companies for
  that batch; both **Kiko** (Shear) and **Reddit** (Huffman) are in it. `shared_org`, symmetric.
  **But the citation is ONE-WAY:** Shear names Huffman; **Huffman has never named Shear** — zero
  occurrences of emmett/shear/kiko across all 67 `spez` HN comments.
  ⚠️ **Keying on "Twitch" misses this** — Twitch's YC page says Winter 2007 (Justin.tv's batch). The
  S2005 tie is **Kiko ↔ Reddit**.
- **Measured absences:** no edge to the other eight in any first-person corpus. Reddit's 424B4
  contains **zero** occurrences of any of the other nine names. Tavel's 113 posts: zero. Feld's
  5,551: zero. Record each with the corpus named.

## Topics needing evidence
`content-moderation`. Don't merge it with Shear's alignment or Tavel's AI-and-work.

## Deep cut
Archived Reddit comments are the mine, via Wayback. Known veins: **the SEC formally designates his
shitposting account as a Regulation FD disclosure channel**; a fully-worked **licorice doctrine** in
r/ModSupport; his first concert was **Weird Al Yankovic**; he has a Cavapoo and posts in r/CavaPoo.

## The suppression case
**His SEC Form 4 share sales are public, filed, verified — and suppressed.** Collect them; they are
real facts with impeccable provenance. They may reach a card only as class and count
(*"1 withheld: finance"*), never as content.

## Backfill / auth
`career_start_decade` from Wikipedia. Respelling NULL. **`prominence_tier` blocked on SESSION.**
Expect walls at Reddit (all methods), investor relations, LinkedIn. His SEC coverage is excellent, so
he won't be empty — but he **will be `unknown`, not `quiet`**, because Reddit couldn't be read.
