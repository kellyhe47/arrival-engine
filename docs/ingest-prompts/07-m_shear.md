# `m_shear` · Emmett Shear

**Door says "Twitch". He runs Softmax — the label is STALE.** Prominence 3 (X 123,007).
Seniority chief-executive. Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_shear.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_shear-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_shear_<date>`, `f_shear_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/emmettshear`.** A slug IS attested: **`softmax.com/about` links it under `aria-label="Emmett Shear … LinkedIn"`** — his own company's team page, `linked_from_own_canonical` (STRONG). The "999 on both slugs" note below is obsolete: logged out it is 999, but the Wayback capture of **2026-05-21** is readable (the only 200 in a CDX list otherwise full of 999s) and the operator's Chrome reads it live. ⚠️ **A THIRD label lives here.** His LinkedIn headline is **"Researching organic alignment"** — not "CEO of Softmax" (X) and not "Twitch" (the door). Three surfaces, three answers; carry the disagreement rather than picking one silently. The archived profile also holds exactly one recommendation, **written by Justin Kan** — the strongest attestation of that edge anywhere.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

`x.com/eshear` `og:description`, current and readable logged out: **"CEO of Softmax: Massively
Multiplayer Learning Environments"**. Write `member_label` with `stale = 1` and carry the correction —
a host who opens with *"so, Twitch…"* has already damaged the relationship.

**Keying on "Twitch" also loses his strongest edge:** the YC Summer 2005 tie is **Kiko ↔ Reddit**.
Twitch's YC page says Winter 2007, which is Justin.tv's batch.

## Fetch
| url | what |
|---|---|
| `https://hacker-news.firebaseio.com/v0/user/emmett.json` + Algolia `search_by_date?tags=author_emmett` | **his richest archive: 927 items, 2007→2026-03-02, karma 4,858.** ⚠️ handle is **`emmett`**, not `eshear` (that one has 1 submission) |
| `https://softmax.com/blog` | 6 posts. **Only two carry his byline**, both co-credited to **Claude Sonnet 3.7** |
| `https://softmax.com/sitemap.xml` | **no RSS exists** — all feed paths 404. This is the only index |
| `https://softmax.com/robots.txt` | allows all but `/api/observatory/v2/coworlds/replays/`. **Honour it** |
| `http://blog.emmettshear.com/` via Wayback | **"Optimize Prime", 25 posts, 2006–2010.** Note: the **subdomain** |
| `https://api.github.com/users/eshear` | 9 repos, joined 2009 |
| `https://en.wikipedia.org/w/index.php?title=Emmett_Shear&action=raw` | career start |
| `https://threadreaderapp.com/user/eshear` | **18 unrolled threads to 2025-11-24** — a real workaround for the JS-walled timeline |
| `https://www.linkedin.com/in/emmettshear/` | SESSION; Wayback `20260521164402` is the GREEN fallback. Headline is a **THIRD label**: "Researching organic alignment". Carries Justin Kan's recommendation |
| `https://api.fxtwitter.com/eshear` · `https://x.com/eshear` | counts; the og:description above |

## Never fetch — he has the worst trap in the set
- **`eshear.com` — a GoDaddy parking page**, and **parking wildcards every path**: `/feed`,
  `/rss.xml`, `/atom.xml`, `/blog`, `/posts`, even `/robots.txt` all return 200 with the same
  114-byte stub. **This is why "a 200 is not identity confirmation" is a rule.**
- **`emmettshear.com`** — NXDOMAIN now; was an Indonesian SEO spam blog ~2019–21. His blog was the
  *subdomain*.
- **`youtube.com/@eshear`** — "eshwar mr Kannada gamer", read from the page title
- **`github.com/emmettshear`** — 404. Real account is `eshear`
- **`humanx.co/speaker/emmett-shear`** — 404. A search result asserted it exists. **Search results
  are not sources.**
- `eshear.substack.com` — one item, "Coming soon", never used · TikTok `@eshear` "Couldn't find this
  account" · Instagram `/eshear/` and `/emmettshear/` are identical shells, **indeterminate — don't
  conclude either way** · **no authored book**

## Inner circle (one hop)
Justin Kan (Kiko, Justin.tv). **Michael Seibel** — Justin.tv co-founder, on **Reddit's board**.
**Adam Goldstein** — on **Softmax's board**, Huffman's Hipmunk co-founder. Two bridges to Huffman.
Yatharth Agarwal (Softmax). Claude Sonnet 3.7 is not a person.

## Edges
- **Shear ↔ Huffman, Summer 2005 — strongest edge outside the Wilson/Feld cluster, and the cleanest
  asymmetry in the set.** `shared_org` symmetric; `cited_in_own_writing` **Shear → Huffman only**.
  His words, HN 1821879 (2010-10-22): *"…where we wrote a good deal of the code for Kiko, and where
  Steve wrote a lot of Reddit. It makes me nostalgic for our 2005 YC batch…"*
- **Measured absences:** Tavel's 113 posts — zero, and **"Twitch" never appears at all**. Feld's
  5,551 — zero. Justin.tv's Form D related persons include no USV/Foundry/First Round/Benchmark/
  Homebrew person.
- Don't merge his `ai-alignment` with Huffman's moderation or Tavel's AI-and-work.

## Topics needing evidence
`ai-alignment` — 1 of 10, highly discriminating.

## Deep cut
Known veins: **"Optimize Prime", his 2006–2010 blog, Wayback-only — with Aaron Swartz in the
comments**; **amateur quantum gravity**, his words: *"crackpot physics from someone who isn't a
physicist"*; an abandoned blog-post-idea list dated 2025-06-20; 19 years of HN submissions.

## Recency — read carefully
Real activity March–April 2026, then nothing fetchable. His own bylined writing is **~16 months old**.
**But his X timeline is JS-walled**, so this is a gap in what is *retrievable*, not proof of silence.
That makes him **`unknown`, not `quiet`.** Do not write "dormant".

## Backfill / auth
`career_start_decade` from Wikipedia. Respelling NULL. **`seniority_tier` = `chief-executive`** in the
canonical cast — fixture G-017 still says `founder` and is logged as defect P0-9; don't fix the table
to match the fixture. HN, Softmax, GitHub, Wikipedia, Wayback and ThreadReader carry most of his
value and are all open.
