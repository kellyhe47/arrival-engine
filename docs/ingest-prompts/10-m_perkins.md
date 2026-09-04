# `m_perkins` · Melanie Perkins

Canva — Co-founder and CEO, Sydney. Prominence 4 (LinkedIn 370,639). Seniority chief-executive.
Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_perkins.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_perkins-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_perkins_<date>`, `f_perkins_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/melanieperkins`, and it remains her single best source.** `subject_self_identifies` on the live headline **"Co-founder & CEO at Canva"**. Measured 2026-09-03: **370,636 followers** — three below the 370,639 the roster baselined on, so state the `measured_at`, and remember she is the one member ranked on LinkedIn rather than X. Experience gives **"Founder and Director, Fusion Books, Jan 2007"** and **"CEO & Co-founder, Canva, May 2012"**, which settles `career_start_decade` = 2000s. Her newest post was **one day old** at read time — the retracted "no fetchable 2026 first-person publication" claim stays retracted.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

**Every `canva.com` path is 403 to every automated client** — plain curl, Chrome-UA curl, WebFetch.
Blanket bot denial at the edge. Consequence: guessed RSS paths also 403, which is
**indistinguishable from "absent"** — so you may neither confirm nor deny a feed exists.

**She has no personal site.** `melanieperkins.com` doesn't resolve; `melanieperkins.com.au` is a
GoDaddy parking page listed for sale. Her long-form first-person writing lives inside the walled
newsroom. That is the biggest structural fact about her footprint.

## Fetch
| url | what |
|---|---|
| `https://www.linkedin.com/in/melanieperkins/` | SESSION. **Her single best recency source anywhere** — headline, company, follower count 370,639, and **full post bodies ~1 year back**. Most recent at audit: **1d old** |
| `web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/` (+ part-2, `20251031134619`) | **her ~64,000-char first-person memoir.** Archive.org only |
| `web.archive.org/web/20260825193821/…/newsroom/news/` | the newsroom index; ~2–5 posts/week, **almost none bylined to her** |
| `https://api.fxtwitter.com/MelanieCanva` · `https://x.com/MelanieCanva` | ⚠️ handle is **capitalised**. The profile card is **server-rendered**: 1,314 posts, 56,591 followers, joined June 2011 |
| `https://www.npr.org/2019/01/24/688299882/canva-melanie-perkins` | *How I Built This*. ⚠️ status by curl only — the fetch timed out, so transcript presence is **UNVERIFIED** |
| `https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw` | names Blackbird, Lars Rasmussen, Cliff Obrecht, Cameron Adams — **and none of the other nine** |

**Wayback note:** WebFetch refuses `web.archive.org`; **curl retrieves it fine.** `canva.com/newsroom/`
bare has no snapshots, and `canva.com/foundation/` has none — likely a URL that never existed.

## Never fetch
- **`youtube.com/feeds/videos.xml?user=canva`** — **silently resolves to an unrelated Hong Kong
  channel.** No error, valid XML, wrong data. One of the nastiest traps in the set
- `melanieperkins.com.au` — parking page, for sale
- TikTok `@melaniecanva` — contradictory payload, 9 followers, effectively nothing
- `instagram.com/melanieperkins/` — at audit this was "Profile isn't available", **never
  disambiguated between logged-out artifact and wrong handle.** Confirm before attributing anything

## The date trap
A LinkedIn post's slug said `canva-create-2026` and the title said 2026, but **the body said 2025**.
**The slug is not a date signal.** Take dates from the body or the platform's own field. Her activity
feed is **not enumerable logged out** — only permalinks you already have. No RSS.

## Inner circle (one hop)
**Cliff Obrecht** — co-founder **and her partner**; her feed carries *"Melanie Perkins reposted this —
Cliff Obrecht"* (`family_or_partner` **and** `shared_org`; facts reached through him render,
tagged `via_edge_type` — DEC-12).
**Cameron Adams** (co-founder). **Lars Rasmussen**. From a measured tag line: *`cc: Melanie Perkins,
Lachlan Andrews, Kelly Steckelberg, Ian Lee`*. **Bill Tai** — see the deep cut.
Investors, from fetched pages: Matrix, InterWest, 500 Startups (2013); Bond, General Catalyst,
Bessemer, Blackbird, Sequoia China (2019); Shasta, Felicis, Airtree (her own words, 2016).

## Edges — she is the most isolated of the ten, and it is thoroughly measured
Every one is a **searched absence**, not a gap:
- **No Canva investor list contains USV, Foundry, First Round, Benchmark or Homebrew.**
- **Canva is absent from YC's full 6,200-company directory** (the only match is a different company
  called "Canvas") and from Techstars. No co-investment, no shared-accelerator edge.
- **89 podcast feeds resolved and grepped in full** — 20VC (1,504), TWiST (1,470), How I Built This
  (865), Masters of Scale, Invest Like the Best, Lenny's, Acquired, *In Depth*. **No episode anywhere
  co-features her with any of the nine.** She shares *shows*, never an *episode*. **Same-show is not
  an edge.**
- Open Library `search/inside`, her + each of the nine: **0 for all nine.** Wikipedia names none of
  them. Tavel's 113 posts: zero. Feld's 5,551: zero. Pinterest's S-1: the only "Perkins" is the law
  firm **Perkins Coie**. Absent from the *Uncensored* TOC.

Her honest card is a thin-room card. That is a correct result.

## Topics needing evidence
`product-led-growth`.

## Deep cut
The memoir is the mine — 64,000 characters that exist nowhere fetchable except archive.org. Known
vein: **she learned to kitesurf purely as an instrument to reach Bill Tai — and hated it**, in her
own words.

## Recency — a conclusion that was already retracted once
An earlier audit concluded no first-person 2026 publication was fetchable at all. **That was false** —
her LinkedIn had a post dated **1d**. The logged-out measurement simply couldn't see it.
**If LinkedIn is unavailable she is `unknown`, never `quiet`.** Don't repeat the retracted claim.

## Backfill / auth
`career_start_decade` from Wikipedia. Respelling NULL. Record the **platform** alongside her follower
figure — she is the only one ranked on LinkedIn rather than X.
**She is the member most exposed to auth failure**: no personal site, no confirmed feed, no
enumerable logged-out activity. If LinkedIn is down, fall back to the Wayback memoir and the X card,
mark her **partial** and **`unknown`**, and say plainly that her freshest material was unreachable.
