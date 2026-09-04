# m_ries · Eric Ries — `db/arena.m_ries.db`

```
Status:     complete (0 auth blockers; 6 sources unavailable for non-auth reasons, 3 skipped by rule)
Sources:    24 ok, 6 unavailable, 3 skipped  (33 attempts)
Written:    58 facts (58 renderable), 15 edges (3 measured absences), 18 contexts, 3 topic backfills
Recency:    active — GitHub Pages rebuild 2026-09-03T22:13:02Z, LinkedIn reposts 3h before the read,
            newsletter post 11 days old. The staleness signal is a retrieval artifact of reading only
            the blog (last post 2026-05-17) and the podcast feed (last episode 2026-01-08).
```

**Deep cuts**
- He is cc'd on his own exchange's SEC cover letter and did not write it — Davis Polk letterhead, signed by Annette L. Nazareth, "cc: Mr. Eric Ries" on the last line. He *did* personally sign and swear the execution page, before a notary stamped QUALIFIED IN KINGS COUNTY. `.../long-term-stock-exchange-form1-filing-letter.pdf`
- A 320-page Tom Lehrer songbook he stitched together himself with wget, Ghostscript, pandoc and MacTeX — "If He Could Only See Us" — with open TODOs about Amazon KDP page geometry. `github.com/ericries/tom-lehrer`
- The bio paragraph on his blog has misspelled his own university as "Yale Unviersity" since 2008, through a February 2011 edit. `startuplessonslearned.com/2008/10/about-author.html`
- Maliz Beams' address is typed "SAN FRANCSICO" on all four 2022 LTSE Form Ds while the other three officers' read "SAN FRANCISCO". Never amended.
- The long-term exchange's first Form D gave its address as a suite in Walnut, CA; the entity now files from Greenwich Street, New York. `.../000168071216000001/primary_doc.xml`
- He learned to program in MUDs: "you could literally conjure new objects that never existed before... to me it actually was magic."
- Two live side projects nobody attaches to his name: **SkinTiers**, an effect-size × evidence-quality skincare rubric, and **Seedlist** (`seedlist.com`) — both pushed the day of the audit.

**New denies**
- `outofthecrisis.com` — a vanity domain I guessed for his second podcast. Answers on 443 with a certificate issued for `*.outofthecrisis.org`, expired 2025-11-25. Ownership UNVERIFIED either way. The attested feed is `anchor.fm/s/477be9bc/podcast/rss`, reached from the Apple id he linked himself.

**Not established** *(the valuable part)*
- **The X follow graph.** Two independent reload-and-walk passes both halted on the identical 70th account (@mehdirhasan) — **70 of a claimed 1,835, 3.8%** — with no spinner, error or 429. A silent ceiling, not the end of the list. **No `no_edge_confirmed` row in this shard rests on it**, and none of the other nine appears in the 70.
- **No Huffman edge, in either direction.** LTSE's own Insights corpus carries "Inside Reddit, with Co-Founder and CEO Steve Huffman" *and* "Hunter Walk shares insights from the Homebrew Computer Club". That is the shape of a co-appearance and is not one: unbylined firm editorial, neither article naming Ries, neither in either of his podcast feeds. So Huffman gets no edge **and no measured absence** — the corpus is not clean. This is exactly the caveat the prompt's "19 feeds / 6,915 episodes, zero co-appearances" sweep carried: it read RSS only, and these pages are not in any feed.
- **The Walk edge is real but one-sided.** *Uncensored* (2012) carries the byline "Hunter Walk and Eric Ries" on Leanpub. A literal scan of the full text of **all 392** of his blog posts finds **zero** occurrences of Hunter Walk. Documented from the publisher's side; never renderable in his voice.
- **`The Leader's Guide` (2015)** stays unverifiable from a primary page — Kickstarter 403s and was not fetched. Wikipedia's **$588,903 is UNVERIFIED** and appears in no fact.
- **`The Black Art of Java Game Programming` co-authorship is self-reported**, from his own bio; OpenLibrary was unreachable this run so the Joel-Fan-only listing could not be re-confirmed.
- **The X syndication window** — the 121 recovered tweets, including 2020-09-09 *"I launched a stock exchange today. Ask me anything:"* — was **not** re-obtained (429 twice). Nothing was written from memory of it.
- **Facebook is UNKNOWN at every login state.** No Facebook URL is attested on any page confirmed as his; only `sharer.php` widgets. Guessing a vanity slug is what the LinkedIn protocol forbids, so nothing was fetched.
- **TikTok's video grid is UNKNOWN, not empty** — the header renders logged out, the grid does not, and there is no TikTok session on this machine.
- **His LinkedIn newsletter back catalogue was not enumerated.** The articles tab rendered empty in the accessibility tree; one article and the subscriber count is all that row supports.
- **Instagram contributed no S4 context.** The account is public and readable, but the grid is book-promotion clips and quote cards — no caption carries a place or a date.

**Corrections for the merge**
1. `db/roster.sql` records `m_ries/github_api` corroboration as `api_name_field_matches`. **The GitHub API `name` field is null** (so are `bio`, `blog`, `company`, `twitter_username`). The identity holds on `linked_from_own_canonical` instead — his newsletter links howisincorruptiblegoing.com, which is that account's GitHub Pages deployment. Fix the corroboration string.
2. **Coverage gap: his LinkedIn newsletter "Trust is Everything", 72,340 subscribers**, a first-person long-form channel in no allow-list. Its 2026-06-01 essay on Meta and Sarah Wynn-Williams is the strongest recent writing of his that the current allow-list cannot reach.
3. **Out of the Crisis** (29 episodes, 2020-03-30 → 2021-05-24) is his second show and is in no allow-list either. Added here as `podcast_rss_ooc`.
4. X followers read **301,420** against the roster's 301,423 the same day. Counts drift; the row was left alone.

**Blockers:** none. LinkedIn, X, Instagram and TikTok all read; no credential was entered and no write affordance — post, reply, like, follow, connect, message, subscribe or consent click — was touched on any platform. The six `unavailable` rows are infrastructure, not walls: openlibrary.org refuses TCP on 443, Google Books 429s, X syndication 429s twice, `youtube.com/feeds/videos.xml` 404s **for a control channel too**, archive.org CDX was 503, and `linkedin.com/in/eries` logged out is a Sign Up redirect. Because nine sources went unreached, `v_recency_state` coverage is correctly `unknown` — but "active" here is an affirmative finding from three independent same-day signals, not an inference from absence.
