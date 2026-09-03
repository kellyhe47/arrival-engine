# 06 — Edges: what actually connects the ten

**Audit date:** 2026-09-03. **Scope:** all 45 unordered pairs among Fred Wilson, Brad Feld,
Josh Kopelman, Sarah Tavel, Hunter Walk, Steve Huffman, Emmett Shear, Eric Ries, Nabeel Qureshi,
Melanie Perkins.

**Rule applied throughout:** a search-result snippet is not a source. Every edge below carries a URL
that was actually fetched and a verbatim quote from the body of that page. Anything I could not open
and quote is marked **UNVERIFIED** and is not asserted as an edge.

---

## Headline: the shape of the graph

**16 of the 45 pairs have a verifiable edge. 29 have none.**

The graph is not a network. It is **one dense clique, one dyad, and three near-isolates.**

| Cluster | Members | Pairs with an edge |
|---|---|---|
| **The 2005–2016 VC blogosphere clique** | Fred Wilson, Brad Feld, Josh Kopelman, Hunter Walk, Eric Ries | **10 of 10** — every pair inside this group is documented, and one artifact (*Uncensored*, 2012) contains all five at once |
| **Attached to the clique, one-way and thin** | Sarah Tavel → Wilson, ↔ Walk, → Feld | 3 of her 9 |
| **The YC-S05 dyad** | Emmett Shear ↔ Steve Huffman | 1 |
| **A single citation** | Nabeel Qureshi → Emmett Shear | 1 |
| **A book recommendation** | Melanie Perkins → Eric Ries (names his book, not him) | 1, WEAK |
| **Zero-edge people** | — | Huffman has **1** edge in 9; Qureshi **1** in 9; Perkins **1 weak** in 9 |

Three structural facts a scoring engine has to respect:

1. **Edge density is a function of blogging, not of importance.** The five people in the clique are
   the five who ran long-running personal blogs in the 2005–2015 window and linked to each other in
   public. Huffman, Shear, Qureshi and Perkins are not less connected in life; they are less
   connected **in retrievable text**. Do not let the engine narrate absence as social distance.
2. **Almost every edge is asymmetric, and the direction is the interesting part.** Wilson names
   Kopelman in 17 posts; Kopelman names Wilson in 13 — roughly balanced. But Walk names Feld in 16
   posts and Feld names Walk in 5; Tavel names Wilson four times and Wilson has **never** named her.
   A digest that says "you two are connected" without saying *who has been paying attention to whom*
   is throwing away the useful half of the signal.
3. **Almost nothing is recent.** Of the 16 edged pairs, only **four** have any evidence after 2020:
   Wilson↔Feld, Feld↔Ries, Tavel↔Walk, and Walk→Feld. The 2012 *Uncensored* anthology, the 2016 open
   letter and the 2009 Techstars/Startup-Visa material are all a decade or more old. **A 2011 edge and
   a 2026 edge are different products** — the engine must decay them.

---

## 0. Method and corpora actually searched

| Corpus | How it was searched | Volume actually retrieved |
|---|---|---|
| **feld.com** | No usable site search (`/index.json` → **404**, so the Hugo search box is broken). Pulled `https://feld.com/posts-sitemap.xml` → **5,551 post URLs**, then fetched **every one** and grepped. Candidate hits re-fetched and re-tested against the JSON-LD `articleBody` only, to strip sidebar/"recent posts" contamination. | 5,551 posts crawled; 908 candidates re-fetched for body text |
| **avc.com** | WordPress REST is **wide open**: `https://avc.com/wp-json/wp/v2/posts?search=…` returns full `content.rendered`. Result counts read from the `x-wp-total` header. | full-text search over the whole archive |
| **hunterwalk.com** | Same — `https://hunterwalk.com/wp-json/wp/v2/posts?search=…` | full-text search over ~1,761 posts |
| **nabeelqu.substack.com** | `/feed` → 410 KB, **14 items** = his entire Substack, full bodies | 14 posts |
| **sarahtavel.com** | `/feed` → 215 KB, 20 items = her entire Substack, full bodies | 20 posts |
| **Hacker News** | Algolia `search_by_date?tags=author_<u>`, paginated to exhaustion, for the six of the ten who have HN accounts: `spez` (83), `emmett` (927), `hunterwalk` (87), `fredwilson` (251), `bfeld` (14), `jkopelman` (276). | **1,638 items**, full comment text |
| **SEC EDGAR** | Full-text search with a declarative UA. Per-name entity sets, plus an explicit **two-phrase query for all 45 pairs** (`q="A" "B"`). | 2,589 hits scanned across 9 names |
| **Nabeel Qureshi interview corpus** | Fetched and grepped the Lenny's, Common Reader, Ian Leslie and *Minutes* transcripts | 4 long transcripts |

**Operational finding worth recording: feld.com rate-limits after a full crawl.** The 5,551-post
sweep plus an 908-URL re-fetch (≈6,500 requests over ~12 minutes at concurrency 12) completed with
**zero** errors, but roughly 20 minutes later `https://feld.com/tags/running/` — which had returned
**200** earlier in the same session — began returning **403** with a 32 KB body. Nothing else on the
site was re-tested. **Budget a crawl of feld.com as a one-shot with a low concurrency and a cache**,
and do not design a live-query dependency on it. avc.com, hunterwalk.com, the Substack feeds, HN
Algolia and EDGAR showed no such behaviour under comparable load.

**Who has no HN account** (checked against the Firebase user API): Eric Ries, Sarah Tavel,
Nabeel Qureshi, Melanie Perkins. (`nabeel` on HN is **Nabeel Hyatt of Spark Capital** — see the
false-positive note in §3.)

---

## 1. EDGE TABLE

Strength key — **STRONG**: documented repeatedly, or a formal/financial tie in a filing.
**MEDIUM**: documented at least once in a primary source. **WEAK**: real but thin, one-directional,
or inferable rather than stated.

| # | Pair | Type | Date / range | Direction | Strength | Evidence (verbatim + URL fetched) |
|---|---|---|---|---|---|---|
| E1 | **Wilson ↔ Feld** | board-together | 2013-10-07 Form D (relationship runs 2001–2019) | symmetric | **STRONG** | Return Path Inc. Form D, Related Persons list, both filed as **Director**: `Fred Wilson … 915 Broadway Suite 1900 New York NY … Director` and `Brad Feld … 304 Park Avenue 7th Floor New York NY … Director`. `https://www.sec.gov/Archives/edgar/data/1108129/000140508613000347/primary_doc.xml` |
| E2 | **Wilson ↔ Feld** | co-investment | 2007-11 → 2012 (Zynga) | symmetric; Feld took the seat for both firms | **STRONG** | Fred Wilson, in his own words on HN, 2011-11-13: *"i am not on the Zynga board and never have been. when we made our Series A investment in Zynga, my good friend Brad Feld took the Series A board seat representing both our firms on the board."* `https://news.ycombinator.com/item?id=3230594` (retrieved via `hn.algolia.com/api/v1/search_by_date?tags=author_fredwilson`). Corroborated by the Zynga S-1: *"The holders of our Series A preferred stock and Series A-1 preferred stock, voting together as a single class, have designated Brad Feld for election to our board of directors."* and *"Brad Burnham, Fred Wilson, Albert Wenger and John Buttrick are Partners at Union Square Ventures and share voting and dispositive power over the shares held by Union Square Ventures 2004, LP"* — `https://www.sec.gov/Archives/edgar/data/1439404/000119312511180285/ds1.htm` |
| E3 | **Wilson ↔ Feld** | personal | first met **1997**; ran to **2026** | symmetric | **STRONG** | Feld, 2005-02-10, on how they met: *"I've known Fred since the first day I started working with Mobius (called Softbank at the time). My very first Softbank-related meeting was to do due diligence at a company outside Boston called Yoyodyne and I met Fred, Charley Lax, and Seth Godin … Neither Fred nor I knew each other (nor did we know the other was going to be there), but I remember an immediate first impression about five minutes into the meeting of 'smart dude.'"* — and, later in the same post, *"I worked closely with Fred and Jerry on a handful of companies (eShare – big success, abuzz – solid success, Mainspring – got our money back, Appgenesys – big failure, Return Path – success in progress) and adore both of them."* `https://feld.com/archives/2005/02/fred-wilson-announces-the-launch-of-union-square-ventures/`. Feld, 2012-09-18: *"At our board meeting last week, Matt gave me and Fred Wilson our 12 year anniversary gift – a pair of red Return Path-branded Adidas sneakers. I still vividly remember the phone call Fred and I had where we cut a deal to merge two nascent companies – Veripost and Return Path … I offered up a 50/50 merger and Fred suggested he wanted a little more since Return Path had raised 3x the money Veripost had. I responded with 'how about 55/45' and Fred said 'it's a deal.'"* `https://feld.com/archives/2012/09/return-path-launches-email-intelligence/`. Wilson, 2019-05-02: *"Brad Feld and Greg Sands joined the board a year or two after I did and they are among my closest friends in the venture bu[siness]"* `https://avc.com/2019/05/the-long-game/`. Feld's post the same week is literally titled **"The Long Arc of a CEO-Investor Friendship"** and opens *"My fellow board member Fred Wilson wrote a great history titled The Long Game"* `https://feld.com/archives/2019/05/the-long-arc-of-a-ceo-investor-friendship/`. **Volume:** Feld names Wilson in the body of **296 of his 5,551 posts (2004-05-04 → 2026-06-15)**; Wilson names Feld in **148** avc.com posts (2004-05-10 → 2021-01-12). This is the densest edge in the set by an order of magnitude. |
| E3b | **Wilson ↔ Feld** | shared-org (policy campaign) | 2006-07 → 2010-02 | symmetric | **MEDIUM** | Feld, 2010-02-19: *"I'm good friends with Brad and his partner Fred Wilson and we've had a number of conversations about this over the past six months, including the creation of an ad-hoc group we are calling 'Abolish Software Patents' (which is similar in structure to the group behind the Startup Visa Movement."* `https://feld.com/archives/2010/02/phenomenal-essay-on-why-software-patents-are-the-problem/`. Earlier, 2006-07-11: *"Fred referenced my post 'Abolish Software Patents' and his subsequent post 'Patently Absurd' as starting points for the discussion."* `https://feld.com/archives/2006/07/more-on-abolishing-software-patents/` |
| E3c | **Wilson ↔ Feld** | shared-org (Techstars) | 2009-08 | Feld's org; Wilson showed up for it | **MEDIUM** | Feld, 2009-08-19, listing who wrote about the Techstars Boulder 2009 class: *"Mentors / Investors: Fred Wilson, Todd Vernon, Matt Blumberg, Jeffrey Kalmikoff, Don Dodge, Chris DeVore, Mark Solon, Andrew Hyde, Brad Feld"* `https://feld.com/archives/2009/08/techstars-episode-12-the-beginning/`. Two weeks earlier, on Demo Day: *"I've gotten to spent the past 36 hours with a couple of good friends, including Dick Costolo, Fred Wilson, Stewart Alsop, and Mike Marquez who have come to town for the event."* `https://feld.com/archives/2009/08/techstars-investor-demo-day-boulder-2009/`. Wilson from his own side, HN 2009-09-15, ranking accelerators: *"brad, david, shawn at techstars are also quite good"* `https://news.ycombinator.com/item?id=824939` — "brad" is Feld, "david" is David Cohen. Also relevant to the *"one thing a host could say out loud"* brief: Feld, 2013-08-16, *"I give a talk for many of the Techstars CEOs called 'How to be a Great CEO' and I focus the conversation around Fred's points."* `https://feld.com/archives/2013/08/being-a-great-ceo/` |
| E4 | **Wilson → Kopelman** | public-praise-or-citation | 2006-02-07 → 2016-05-16 (**17** posts; nothing since) | **asymmetric** — Wilson names Kopelman constantly; no reciprocal blog corpus found (see §4) | **STRONG** | 17 avc.com posts. 2016-05-16: *"a video from Disrupt featuring my partner Andy, Josh Kopelman (one of my favorite VCs), and one of Josh's limited partners Chris Douvos."* `https://avc.com/2016/05/from-the-investors-perspective/`. 2006-11-01: *"Josh Kopelman, a well known early stage investor who we have co-invested with successfully, has a good post up on CRV Quickstart."* `https://avc.com/2006/11/more_on_crv_qui/` — note this asserts co-investment but **names no company**; the company-level co-investment is **UNVERIFIED**. 2006-12-28: *"My partner Brad and I were at lunch with Josh Kopelman a month or so ago and we got to talking … Josh blurted out 'web 2.0 is the explicit web and web 3.0 is the implicit web'."* `https://avc.com/2006/12/2007_the_implic/` |
| E5 | **Feld → Kopelman** | public-praise-or-citation | 2006-04-09 → 2018-07-02 | asymmetric (Feld names Kopelman) | **MEDIUM** | 18 feld.com posts. 2006-04-09: *"Josh Kopelman has a thoughtful post on why he prefers preferred equity instead of convertible debt in seed-stage investments. I agree with everything he says."* `https://feld.com/archives/2006/04/kopelman-prefers-preferred-equity/`. 2006-08-31: *"my post 'The First 25,000 Users Are Irrelevant' that built off of Josh Kopelman's superb post titled '53,651'"* `https://feld.com/archives/2006/08/the-80-19-1-rule/` |
| E5b | **Feld ↔ Kopelman** | co-appearance (panel) | 2009-05 (announced 2009-03-31) | symmetric | **MEDIUM** | Feld: *"This year Scott Kirsner invited me to be on a panel and I happily accepted … I'm on a panel on Friday afternoon titled 'How is the Venture World Changing' with Josh Kopelman (First Round Capital), Jo Tango (Kepha), and Paul Ciriello (Fairhaven). Dan Primack, the creator of peHUB Wire will be moderating."* — the Nantucket Conference. `https://feld.com/archives/2009/03/nantucket-conference-10/` |
| E6 | **Kopelman → Wilson** | public-praise-or-citation | 2006-05-11 → 2012-08-15 | reciprocal — this closes the loop on E4 | **STRONG** | **Correction to an earlier assumption in this audit: Kopelman's blog *Redeye VC* is live.** `https://redeye.firstround.com` returns 200; 72 monthly index pages and **all 212 posts** were fetched and searched. **13 of the 212 name Fred Wilson in the post body.** 2007-03-25: *"It was nice to wake up to today to Fred Wilson's blog post - he articulately summarized several of the benefits of investing at the Seed Stage."* `https://redeye.firstround.com/2007/03/thoughts_on_see.html`. 2009-10-15: *"I couldn't agree with Fred more."* `https://redeye.firstround.com/2009/10/company-math-vs-vc-math.html` |
| E6b | **Kopelman → Feld** | public-praise-or-citation + co-appearance | 2006-04-09 → 2009-03-29 | reciprocal to E5 / E5b | **STRONG** | 5 Redeye posts name Feld in the body. 2006-04-09: *"Brad Feld recently posted a great overview highlighting the two leading structures for a pre-VC investment."* `https://redeye.firstround.com/2006/04/bridge_loans_vs_1.html`. And Kopelman's own confirmation of the Nantucket panel that Feld announced from his side (E5b), 2009-03-29: *"I will be on a panel discussing the 'Changing VC industry' with **Brad Feld**, Jo Tango, Paul Ciriello that is moderated by Dan Primack."* `https://redeye.firstround.com/2009/03/nantucket-conference.html` — **both men wrote about the same panel independently, two days apart.** |
| E6c | **Kopelman → Wilson / Feld / Walk** | HN submissions | 2011-05-18, 2013-09-01, 2013-06-29 | asymmetric | **WEAK** (superseded by E6/E6b for Wilson and Feld) | Kopelman's HN account `jkopelman` **submitted** each of their posts without commentary: `http://www.avc.com/a_vc/2011/05/sizing-option-pools-in-connection-with-financings.html` (id 2560048); `http://www.feld.com/wp/archives/2013/09/the-toxicity-of-arrogance.html` (id 6311501); `http://hunterwalk.com/2013/06/28/waving-goodbuy-facebooks-big-whiff-on-traffic-of-commercial-intent/` (id 5961563). **Note the asymmetry that survives: Kopelman never names Hunter Walk in any of the 212 Redeye posts** (Redeye stops in 2014), so E10b remains one-way.
| E7 | **Walk → Wilson** | public-praise-or-citation | 2007-04-22 → 2019-02-05 | asymmetric (Walk cites Wilson far more than the reverse) | **STRONG** | **20 posts** on hunterwalk.com contain the exact string "Fred Wilson" (2007-04-22 → 2019-02-05). 2018-04-20: *"Like many in the venture community, especially us newer investors, I enjoy Fred Wilson's 'process' posts, where he shares a POV on the practice of our profession."* `https://hunterwalk.com/2018/04/20/and-when-my-time-is-up-have-i-done-enough-fred-wilsons-post-on-time-money/`. 2010-09-26, in a post title: *"Parallel Entrepreneurism: I'm as smart as Fred Wilson was in 2006"*. 2013-12-24: *"I believe that was my introduction to people like Fred Wilso[n]"* `https://hunterwalk.com/2013/12/24/why-nyc-tech-scene-excites-me-deep-roots/` |
| E8 | **Wilson → Walk** | public-praise-or-citation | 2012-06-06 → 2013-09-29 (**3** posts) | asymmetric, and **stale** (nothing after 2013) | **MEDIUM** | 3 avc.com posts. 2012-06-06: *"Hunter Walk has a post up suggesting that 'social proof' is not as helpful of an indicator of startup quality as it once was."* `https://avc.com/2012/06/social-proof-is-dangerous/`. 2013-09-29: *"USV is a lead investor. Benchmark is a lead investor. Gotham Gal is a lead investor. I suspect Hunter's Homebrew is a lead investor."* `https://avc.com/2013/09/leading-vs-following/` |
| E9 | **Feld ↔ Walk** | co-investment (LP) | 2014-05-27, states a relationship in place since ~2013 | Feld's firm is money **into** Walk's firm | **STRONG** | Feld, in his own words: *"A few weeks ago Hunter Walk and Satya Patel of Homebrew, a one year old seed-stage VC firm that my partners and I are investors in, came and spent the day in Boulder."* `https://feld.com/archives/2014/05/spending-day-another-vc-firm/` |
| E10 | **Walk → Feld** | public-praise-or-citation | 2012-03-04 → 2024-08-17 | asymmetric (Walk is the admirer) | **STRONG** | **16 posts** on hunterwalk.com contain the exact string "Brad Feld" (2012-03-04 → 2024-08-17). 2017-06-16: *"Brad Feld, one of my VC 'true norths,' posted about VC Fund Differentiation the other day."* `https://hunterwalk.com/2017/06/16/vc-fund-differentiation-should-matter/`. 2013-10-26: *"Brad Feld of Foundry Group, a firm and team who have been especially helpful"* `https://hunterwalk.com/2013/10/26/vcs-be-a-partnership-not-a-collection-of-partners/`. 2015-04-06: *"my desire to not be Fred Wilson 2.0, Brad Feld 2.0 or Marc Andreessen 2.0"* `https://hunterwalk.com/2015/04/06/five-questions-charlie-odonnell-asked-me-to-answer/` |
| E10b | **Walk → Kopelman** | public-praise-or-citation | 2014-04-10 → 2023-06-26; the substantive one is **2019-12-16** | asymmetric (Walk names Kopelman) | **MEDIUM** | 3 posts on hunterwalk.com contain "Josh Kopelman". The load-bearing one is Walk's post *"The Five Most Influential VCs of the 2010s"*, where Kopelman is one of the five: *"Josh Kopelman — Over the course of the 2010s, seed investing went from a clubby handful of individuals and 'micro VCs' to an outpouring of capital and multi GP firms. The institutionalizing of seed financing was driven by the aptly-named First Round Capital which Josh co-founded and for a long while, was clearly the visible frontman of the group."* `https://hunterwalk.com/2019/12/16/the-five-most-influential-vcs-of-the-2010s/`. **Notable:** Fred Wilson and Brad Feld are **not** on that list of five — checked by string search of the fetched body. Walk cites them far more often but ranked Kopelman, not them, as decade-defining. |
| E11 | **Feld ↔ Ries** | personal + public-praise + shared-org | 2007 → **2026-04-29** | close to symmetric; Feld does the naming, Ries reciprocated with a book foreword | **STRONG** | **28 feld.com posts, 2009-07-24 → 2026-04-20.** Feld, 2020-07-28: *"Some of the inspiration for The Startup Community Way came from Eric Ries. I met Eric in 2007 or so and he's another example, like Tim Ferriss, of a 'good friend and colleague' from a distance. We've only physically been in the same space a few times, but I've learned an enormous amount from Eric, feel emotionally close to him, and have a deep respect for the work he doe[s]."* `https://feld.com/archives/2020/07/eric-ries-foreword-to-the-startup-community-way/`. Feld, 2018-10-31: *"I'm a big fan and long-time friend of Eric's."* `https://feld.com/archives/2018/10/innovation-and-venture-capital-in-new-jersey/`. **Live in 2026:** *"On April 29 at 10am PT, Eric Ries and I are doing a free fireside chat for startup communities. We're going to talk about the lessons we've learned as founders, investors, and advisors - and the books we've each just put into the world."* `https://feld.com/archives/2026/04/give-first-build-right-with-eric-ries/` |
| E12 | **Feld ↔ Ries** | shared-org (Startup Visa Movement) | 2009-09 → 2016-08 | symmetric — they campaigned together | **STRONG** | Feld, 2009-09-29: *"Thanks to the efforts of Dave McClure and Eric Ries, we shifted the name to the StartupVisa, figured out that the EB-5 visa was the most logical one to try to 'modify', and got a web site up about it."* `https://feld.com/archives/2009/09/startupvisa-momentum/`. Feld, 2010-04-30: *"In March, I went to DC with Dave McClure, Eric Ries, Shervin Pishevar, and a bunch of Geeks on a Plane to discuss, advocate, and support the Startup Visa initiative."* `https://feld.com/archives/2010/04/startup-visa-videos-from-our-dc-trip/` |
| E12b | **Feld ↔ Ries** | shared-org (Techstars) | 2009-07-24 → 2015-03-16 | Feld pulled Ries into his org's orbit | **MEDIUM** | Feld, on how it started: *"I gave a talk at the fbFund Rev program about a month ago on the same day that Eric gave a talk. Since I was hanging around for the day, I listened to Eric's talk, which was great. I mentioned it to David Cohen at TechStars who told me that he had been emailing with Eric about having Eric come to Boulder to do his thing. Eric has decided to come to Boulder on 8/19 and 8/20."* `https://feld.com/archives/2009/07/eric-ries-is-coming-to-boulder/`. Six years later, Feld personally backed a Ries Kickstarter reward tier: *"One of the award levels is a day in Boulder with me, time with Techstars, several of my portfolio companies, a night at the St. Julien Hotel, and dinner with me at Kasa Sushi."* `https://feld.com/archives/2015/03/three-startup-books-buy-today/` |
| E13 | **Walk ↔ Ries** | shared-org (co-edited a book) | 2012-01 (announced 2012-03-04) | symmetric — they co-curated it | **MEDIUM** | Hunter Walk, in his own words: *"In January Eric Ries and I curated an ebook called Uncensored to benefit the Electronic Frontier Foundation, a nonprofit organization which defends digital rights. The book features blog posts from notable technologists such as Fred Wilson, Brad Feld, danah boyd, Marc Andreessen and dozens of other big thinking folks."* `https://hunterwalk.com/2012/03/04/uncensoredbook-now-free-to-all-eff-supporters/` — **note this single sentence also establishes Walk→Wilson and Walk→Feld as contributors to the same volume.** |
| **E13b** | **Walk ↔ Ries ↔ Wilson ↔ Feld ↔ Kopelman** | shared-org (**one book, five of the ten**) | Jan–Feb 2012 | Walk and Ries are the editors; the other three are contributors | **STRONG** | *Uncensored* (Leanpub), byline **“Hunter Walk and Eric Ries”**, `https://leanpub.com/uncensored` (also confirmed against the Wayback capture of 2012-02-01, identical). The table of contents names, verbatim: **“Josh Kopelman — Founders and Heat Seeking Missiles”**, **“Fred Wilson — Investing In The Cultural Revolution”**, **“Brad Feld — This Is The Smell Of Inevitability”**, **“Eric Ries — The Visionary’s Lament”**, **“Hunter Walk — Sorry Mike, Facebook could reboot and we’d mess it up again”**. Kopelman’s contributor bio reads *“Josh Kopelman @joshk / VC. Father. Geek”*. **Absent from the TOC: Tavel, Huffman, Shear, Perkins, Qureshi.** This single artifact is the densest multi-way tie in the set — it puts five of the ten inside one 2012 charity anthology for the EFF. ⚠️ Two caveats: **Ries’s own 392 blog posts never mention this book**, so it is documented from Walk’s side plus the Leanpub page only; and the EFF-membership-perk claim is **UNVERIFIED** (eff.org search returns 410, Wayback CDX timed out). |
| **E13c** | **Ries ↔ Feld** | shared-org (book chapter) | 2010 (*Do More Faster*), stated 2011-07-26 | reciprocal to E11 — Ries naming Feld in **Ries’s** own words | **STRONG** | Eric Ries on his own blog: *“Brad Feld and I have a bit of a mutual admiration society going. He and I have worked together on the Startup Visa initiative. He’s said nice things about me and my book. I think he’s a great guy. I even contributed a chapter to his previous book, Do More Faster.”* `https://www.startuplessonslearned.com/2011/07/venture-deals.html`. Corroborated inside the book via Open Library search-inside (IA identifier `domorefastertech0000cohe`): *“Progress Equals Validated Learning / Eric Ries / Eric is the co-founder and CTO of IMVU”*. **The same volume also carries a Fred Wilson chapter and a Josh Kopelman jacket blurb.** 11 of Ries’s 392 posts name Feld (2009-07-30 → 2015-03-13). |
| **E15b** | **Ries → Wilson** | public-praise-or-citation | 2011-05-15 | reciprocal to E15, two days apart | **MEDIUM** | Wilson posts *“One that I have my eye on is Startup Lessons Learned from Eric Ries and his Lean Startup gang”* on 2011-05-13 (`https://avc.com/2011/05/startup-lessons-learned/`); Ries answers on 2011-05-15: *“Thanks to Fred Wilson’s endorsement, it looks like we’ll now have well north of one hundred cities participating.”* `https://www.startuplessonslearned.com/2011/05/new-speakers-ignite-streaming-locations.html`. **Caveat: that is the only Fred Wilson mention in all 392 Ries posts** — the relationship is real, but Wilson does nearly all of the naming. |
| **E15c** | **Ries ↔ Kopelman** | co-appearance + public-praise | 2010-01-28 and 2010-05-02 | genuinely bidirectional, but **time-boxed to 2010–2012** | **MEDIUM** | Kopelman→Ries: *“I really want to thank the entire First Round Capital team along with our outside speakers and resources for putting on a great CEO Summit: Dick Costolo, Eric Ries, Jeff Jordan…”* `https://redeye.firstround.com/2010/01/sharing-and-exchanging.html` — **Ries’s only appearance across all 212 Redeye posts.** Ries→Kopelman: *“Panel: Investing in the era of the lean startup … Panelists: Ann Miura-Ko, Josh Kopelman, Jeff Clavier”* `https://www.startuplessonslearned.com/2010/05/lean-startup-intensive-is-tomorrow-at.html` — **Kopelman’s only appearance across all 392 Ries posts.** Plus both in *Uncensored* (E13b). Nothing after 2012 in either direction. |
| E14 | **Walk ↔ Feld ↔ Ries** | co-appearance (co-signatories) | 2016-07-14 | symmetric, three-way | **MEDIUM** | All three appear on the same open letter against a Trump presidency, which Walk posted in full: *"Brad Feld, Managing Director, Foundry Group; Co-Founder, Techstars"*, *"Eric Ries, Entrepreneur & Author, The Lean Startup"*, *"Hunter Walk, Partner, Homebrew VC; Former Director of Product Management, Google"*. `https://hunterwalk.com/2016/07/14/trump-would-hurt-innovation-im-with-her/` — Fred Wilson, Kopelman, Tavel, Huffman, Shear and Perkins are **not** on this list (checked by string search of the fetched body). |
| E15 | **Wilson → Ries** | public-praise-or-citation | 2011-02-12 → 2015-03-16 (**4** posts) | asymmetric, and **stale** (nothing after 2015) | **MEDIUM** | 4 avc.com posts. 2015-03-16: *"My friend Eric Ries, author of The Lean Startup, is writing a new book called The Leader's Guide. He's crowdfunding the research, writing, and production of this new book on Kickstarter and the campaign was launched today. I've already backed this project and you can too."* `https://avc.com/2015/03/the-leaders-guide/`. 2011-05-13: *"One that I have my eye on is Startup Lessons Learned from Eric Ries and his Lean Startup gang."* `https://avc.com/2011/05/startup-lessons-learned/` |
| E16 | **Wilson ↔ Feld ↔ Walk** | shared-org (joint philanthropy) | 2017-06-09 | Walk is the connector; Wilson and Feld put up the money | **MEDIUM** | Feld: *"Our month match for June is The Human Utility. Fred Wilson, Joanne Wilson, Amy Batchelor, and I are matching up to $20,000 of contributions via our #GiveWater campaign. Hunter Walk introduced us to The Human Utility at the beginning of the year."* `https://feld.com/archives/2017/06/monthly-match-human-utility-givewater/` — this is the only artifact in the whole audit where three of the ten act together on a non-commercial project. |
| E17 | **Qureshi → Shear** | public-praise-or-citation | 2024-01-20 | **strongly asymmetric** — Qureshi links Shear; nothing found in the reverse direction | **MEDIUM** | Qureshi, in "The Serendipity Machine": *"Bookmark tweets that are especially wise, so you can find them again later. I love Karpathy's best tweets, for example. Michael Nielsen on spaced repetition. Emmett Shear on burnout."* — the link target is `https://twitter.com/eshear/status/1561120325584109574`. `https://nabeelqu.substack.com/p/the-serendipity-machine` (retrieved via the full-text Substack feed). **This is the only edge Nabeel Qureshi has to anyone in the set.** |
| E17b | **Shear ↔ Huffman** | shared-org (**Y Combinator, Summer 2005 — the first batch ever**) | 2005; recalled 2010, restated by Huffman 2021 | symmetric, and **self-declared from both sides** | **STRONG** | Emmett Shear, HN 2010-10-22, on a thread titled *"Y Combinator's Original Home For Sale"*: *"This is where we wrote a good deal of the code for Kiko, and where Steve wrote a lot of Reddit. It makes me nostalgic for our 2005 YC batch, and sad to see it go on the market. I hope whoever buys it puts it to good use."* `https://news.ycombinator.com/item?id=1821879`. Four days earlier: *"Justin and I applied for Kiko Calendar (YC S05) just before the deadline. We only found out about 2 days before that it even existed."* `https://news.ycombinator.com/item?id=1804706`. And from Huffman's own side, his HN submission of 2021-07-21 is titled *"Reddit (YC S05) Is Hiring a Head of Developer Platform"* `https://news.ycombinator.com/item?id=27908879` — he stamps Reddit as **YC S05** himself. Shear still labels himself *"the founder of Twitch (YC S05)"* in his 2026-03-02 hiring post. **Both men, in their own words, place themselves in the same YC batch, in the same house.** This is the single best under-the-radar edge in the set: 21 years old, never mentioned in either man's press coverage, and the "same room" detail is exactly the sort of thing a host could say out loud. |
| E18 | **Shear → Huffman** | public-praise-or-citation (factual, not warm) | 2011-06-17 | asymmetric — Shear names Huffman; `spez`'s 83 HN items name no one in the set | **MEDIUM** | Shear on HN: *"Jedberg was not on the founding team of Reddit. The founding team of reddit was Steve Huffman (spez) and Alexis Ohanian (kn0thing). Jedberg was their first hire after acquisition, though they'd acquired two other team members via merger (Chris Slowe and Aaron Swartz) prior to that."* `https://news.ycombinator.com/item?id=2666830` (retrieved via `hn.algolia.com/api/v1/search_by_date?tags=author_emmett`). He corrects the record about Huffman's company from memory — that is familiarity, but it is not warmth and it is not a relationship claim. |
| **E22** | **Tavel → Wilson** | public-praise-or-citation | 2009-09-09 → 2010-07-20; blogroll 2006–2008 | **strongly asymmetric** — she engages with him constantly, he has never named her | **STRONG** | Four in-body references on *Adventurista*, each linking avc.com, plus a permanent blogroll slot. The best is a whole post written in reply to him, 2010-07-20: *“Fred Wilson has a post on his blog about not doing a full pitch on the phone. I agree with Fred and the many commenters that in person meetings trump phone call pitches, but lest Fred’s advice be taken to the extreme, please don’t avoid them all together.”* `https://web.archive.org/web/20100723024639/http://www.adventurista.com/2010/07/in-defense-of-phone-call-pitches.html` (verified independently). Also 2009-11-23: *“Fred Wilson is our Marc Benioff (disrupter of software…)”*; 2010-06-29: *“I often find that picking a topic to write about is the hardest thing about blogging consistently (I don’t know how Fred Wilson does it).”* Her sidebar blogroll, headed **“How I Procrastinate:”**, lists **“A VC” → `http://avc.blogs.com/a_vc/`** on **53 of 113** archived posts. **Reciprocal: none.** avc.com WP REST returns 0 for both `Tavel` and `Adventurista`. |
| **E23** | **Tavel ↔ Walk** | public-praise-or-citation, both ways; implies acquaintance | 2015-10-06 → 2025-03-18 | **bidirectional**, and still live in 2025 — the only Tavel edge that is | **STRONG** | Tavel → Walk, citing a conversation rather than a post, 2015-10-06: *“Hunter Walk reminded me that in a zero-sum world of only so many minutes in a day, blank spaces to absorb those minutes must come from cannibalizing other minutes, either from online or offline.”* `https://web.archive.org/web/20151012010918/http://www.adventurista.com/2015/10/times-have-changedgoing-after-dollars.html`. Walk → Tavel, in his own words and a warm register, 2023-09-03: *“AI startups: Sell work, not software [Sarah Tavel/Benchmark] – **Like many of us Sarah writes in spurts, so I’m always excited when there’s a burst of stuff from her.**”* `https://hunterwalk.com/2023/09/03/a-technical-cofounder-tells-you-how-to-find-your-technical-cofounder-where-the-stuff-we-return-to-amazon-goes-a-benchmark-vc-on-rethinking-your-ai-startup-and-more/` (verified independently). Again 2025-03-18: *“Sarah basically assumes the LLM platforms are going to evolve into competition for most of the B2B businesses built on top of them, so she gives her best guess as to how to manage this as a challenger.”* |
| **E24** | **Tavel → Feld** | shared-declared-interest (blogroll subscription only) | 2006–2008 | one-way, and it is a link, not prose | **WEAK** | Her *Adventurista* sidebar blogroll listed **“Feld Thoughts” → `http://www.feld.com/blog/index.php`** on **53 of 113** archived posts, dropped in her 2009 redesign — e.g. `https://web.archive.org/web/20071217162549/http://www.adventurista.com/2006/12/contempt-eh.html`. **Zero body mentions of “Brad Feld” or “Feld” in any of the 113 posts**, and zero “Tavel” in Feld's 5,551. A reading habit, not a relationship. Score it only as evidence she was in his audience in 2006. |
| **E16b** | **Walk ↔ Wilson ↔ Feld** | co-appearance (one post, original contributions from all three) | 2014-09-30 | Walk is the convener | **MEDIUM** | Hunter Walk solicited and published original, previously-unpublished rules from both men side by side: *“Brad Feld – Foundry Group 1. I try not to schedule any meetings until 11am … Fred Wilson – Union Square Ventures 1. I spend 5am to 7am every weekday by myself reading and writing and thinking”* `https://hunterwalk.com/2014/09/30/makers-schedule-managers-schedule-investors-schedule/`. Distinct from E16 (#GiveWater) and E13b (*Uncensored*): here Walk got both of them to write something for him. |
| **E4b** | **Wilson ↔ Feld** | co-appearance (podcast) | recorded mid-2016, published 2016-08-01, re-run 2017-10-19 | symmetric | **MEDIUM** | Reboot Podcast #45, *“What's Love Got to Do with It?”*, show notes verbatim: *“We are so fortunate to welcome Brad Feld and Fred Wilson back to the Reboot Podcast. Jerry, Brad, and Fred have a friendship and history that goes back 20 years…”* (feed `https://rss.libsyn.com/shows/119983/destinations/697611.xml`). Wilson's own announcement: `https://avc.com/2016/08/reboot-podcast-with-jerry-and-brad/` — *“Jerry Colonna, Brad Feld, and I go way back in the venture capital business. We met in the mid 90s and worked very closely together during the late 90s.”* Republished as Reboot #70, *“The Inner-Workings of a Good Board”*, 2017-10-19 (*“In this episode that we originally ran last summer…”*) — **one recording, two publications; do not double-count.** |
| E19 | **Shear → Wilson** | co-presence only | 2008-10-28, 2011-09-25 | one-way, and it is not really about Wilson | **WEAK — do not score this as an edge** | Two of Shear's HN comments sit on threads whose *story titles* are "Fred Wilson's Survival Matrix" and "Moneyball for startups? PG, Fred Wilson, Chris Dixon discuss". Shear comments on the substance and **never names Wilson**. Recorded here only so a future crawler does not mistake the story title for a mention. |
| E20 | **Perkins → Ries** | public-praise-or-citation (impersonal) | 2025-11-02 | one-way; she names his book, not him | **WEAK** | Melanie Perkins' *Lenny's Podcast* episode page lists, under the show's standard guest-recommendation segment: *"Recommended books: • Creativity, Inc. … • **The Lean Startup: How Today's Entrepreneurs Use Continuous Innovation to Create Radically Successful Businesses** … • The Power of Moments … • Designing the Obvious…"* `https://www.lennysnewsletter.com/p/the-making-of-canva`. **Caveat:** the page does not explicitly attribute the list to her. It is corroborated as hers because *Designing the Obvious* also appears in her 2016 20VC show notes as *"Melanie's Fave Book: Designing The Obvious"*. This is a book citation, not contact — do not upgrade it. |
| E21 | **Kopelman ~ Perkins** | institutional co-presence, **not** a person edge | 2021-11-18, 2025-08-20, 2026-01-13 | Kopelman's firm's publication covers Perkins' company; Kopelman himself never appears | **WEAK — flag, do not score as a relationship** | First Round Review (First Round Capital's own publication) has three posts naming her, e.g. *"Cameron Adams barely knew Melanie Perkins and Cliff Obrecht before the three decided to build Canva together."* `https://review.firstround.com/canvas-path-to-product-market-fit/`. All **982** First Round Review posts were paginated via its Ghost content API: exactly 3 contain "Melanie Perkins", **Kopelman's name appears in 0 of them**, and Perkins is never a guest or author. |

---

## 2. NO DISCOVERABLE EDGE

These are **confirmed absences**, not gaps I skipped. For each I name the corpus I searched and what
came back. A confirmed absence should make the scoring engine fall back to topical affinity (§5) and
must never be dressed up as a connection.

**Master negative results that kill many pairs at once:**
- **Sarah Tavel's 2006–2015 blog *Adventurista* — 113 archived posts — DOES name Fred Wilson and
  Hunter Walk, and names nobody else.** ⚠️ **Method warning, recorded because it nearly produced a false
  negative in this very document:** a first pass over the Wayback CDX list (806 capture rows → 152 distinct
  archived pages, fetched through `web.archive.org/web/<ts>id_/…` at concurrency 8) returned **almost zero
  hits** — because `web.archive.org` started refusing connections partway through and the errors were being
  discarded. A second, slower pass over the same corpus found four in-body Fred Wilson references and a
  Hunter Walk reference. **Never trust a Wayback bulk crawl that does not count its own failures.** The
  corrected result is in E22–E24 below. What *is* a clean zero across all 113 posts: **Josh Kopelman, Steve
  Huffman, Emmett Shear, Eric Ries, Nabeel Qureshi and Melanie Perkins** — plus the strings "Twitch" and
  "Lean Startup", which never appear at all.
- **Pinterest's S-1 is a dead end for all nine.** `https://www.sec.gov/Archives/edgar/data/1506293/000119312519083544/d674330ds1.htm`
  (2019-03-22, 2.0 MB) was fetched and searched: **Tavel herself: 0 hits.** Feld, Kopelman, Walk, Huffman,
  Shear, Ries, Qureshi: 0. The 14 "Wilson" hits are all director **Michelle** Wilson; the single "Perkins"
  is the law firm **Perkins Coie**. Bessemer appears 11× — Jeremy Levine held the Series A board seat, and
  he is not one of the ten. Tavel's own EDGAR CIK is **0001774645**, 14 filings, all Benchmark Form 4s
  (Confluent, Amplitude) and Form Ds (Agentio, Hipcamp, Chainalysis, Supergreat) — **no overlap with any of
  the other nine.**
- **LTSE's complete related-persons universe is four people, and none of them is one of the ten (bar Ries).**
  All **8** LTSE Form D filings were pulled directly (CIK 0001680712 for Long-Term Stock Exchange, Inc. /
  LTSE Services / LTSE Holdings, and CIK 0001786417 for LTSE Group), spanning 2016-07-27 → 2022-08-08.
  The related persons across every filing are only: **Eric Ries** (Executive Officer, Director, Promoter),
  **John V. Bautista** (Director), **Brian Singerman** (Director) and **Maliz Beams** (from 2022). LTSE's
  own board page corroborates. **No USV, Foundry, First Round, Benchmark or Homebrew person appears.**
- **First Round Capital's own fund filings name nobody else from the set.** Form D related persons pulled
  directly for First Round Capital VI Partners (2016), VII (2018), IX (2022) and X Partners (2025):
  Kopelman plus Hayes, Trenchard, Barnes, Berson, Fralic, Barna, Jackson, Asonye, Cordova and Wessel.
  **None of the other eight.** firstround.com's companies page contains **no Canva, no Reddit, no Twitch
  and no LTSE.**
- **Podcast sweep, second pass:** a further **19 feeds / 6,915 episodes** were resolved and grepped for
  Ries and Kopelman against the other eight — including Ries's own two shows (*The Eric Ries Show*, 44
  episodes; *Out of the Crisis*, 29) and First Round's *In Depth* (185). **Zero co-appearances.**
  Combined with the 89-feed Perkins sweep, **the only verified two-of-the-ten-on-one-recording events in
  this entire audit are the Reboot/"What's Love Got To Do With It" episodes (Colonna + Wilson + Feld) and
  the 2026 Feld–Ries fireside chat.** Caveat: this is RSS titles and descriptions only; a guest named
  nowhere in the show notes would be missed.

- **Canva's investor list contains none of the ten's firms.** Assembled from pages actually fetched:
  seed (TechCrunch 2013-08-26) — *"Matrix Partners, InterWest Partners, 500 Startups, and various
  angels"*; 2019 (TechCrunch 2019-10-16) — *"Investors in the company include Bond, General Catalyst,
  Bessemer Venture Partners, Blackbird and Sequoia China"*; Perkins herself on 20VC 2016-06-10 —
  *"have funding from our friends at Shasta, Felicis and upcoming guests Blackbird Ventures and
  Airtree in Australia."* **USV, Foundry Group, First Round Capital, Benchmark and Homebrew appear in
  zero Canva investor list.** Canva is also **absent from Y Combinator's full company directory**
  (6,200 companies via `https://yc-oss.github.io/api/companies/all.json`; the only match is a
  different company called "Canvas") and absent from the Techstars portfolio search. So there is no
  co-investment edge and no shared-accelerator edge to Perkins, at all.
- **Podcast co-appearance sweep, Perkins vs. the nine: zero.** 89 podcast feeds were resolved via the
  iTunes Search API and each RSS grepped in full — 20VC (1,504 items), This Week in Startups (1,470),
  How I Built This (865), Masters of Scale (734), Invest Like the Best (595), Lenny's (359), Guy
  Kawasaki (367), Acquired (216), First Round's *In Depth* (185). **No episode anywhere co-features
  Perkins with any of the nine.** She shares *shows* with Wilson, Feld, Kopelman, Tavel, Walk,
  Huffman, Shear, Ries and Qureshi — never an *episode*. Same-show-different-episode is not an edge.
- **Open Library `search/inside`, "Melanie Perkins" + each of the nine names: 0 hits for all nine.**
- **Wikipedia's Melanie Perkins article names none of the nine.** The only investors/collaborators it
  names are Blackbird Ventures, Lars Rasmussen, Cliff Obrecht and Cameron Adams.

- **feld.com, all 5,551 posts, body text only:** **zero** occurrences of "Tavel", "Huffman",
  "Emmett", "Shear", "Nabeel", "Qureshi", "Melanie Perkins". Brad Feld — the single most
  name-dropping writer in this set — has never once written any of those five names.
- **avc.com, WordPress REST full-text search** (`x-wp-total` header): `Tavel` → **0**,
  `Huffman` → **0**, `Qureshi` → **0**, `Melanie Perkins` → **0**. `Emmett` → 1 (unrelated).
  `Twitch` → 3, all about the company or the word "twitch", none naming Shear.
- **sarahtavel.com, all 20 Substack posts:** **zero** occurrences of any of the other nine names.
- **SEC EDGAR pairwise full-text search, all 45 pairs** (`q="Name A" "Name B"`): only
  **Wilson+Feld** returned real hits (Return Path Form Ds, Zynga S-1/424B4). Wilson+Huffman returned
  316 hits, **all of which are N-PX proxy-voting tables** from unrelated mutual funds where the two
  names appear in different rows — noise, not an edge. Every other pair: **0**.

| Pair | What was searched | Result |
|---|---|---|
| Wilson ~ Tavel | — | **EDGE FOUND on the second pass — see E22.** One-way: she names him four times plus a blogroll slot; avc.com returns **0** for `Tavel` and `Adventurista`. |
| Wilson ~ Huffman | avc.com (`Huffman`→0, `Reddit`→49 posts none naming him); `spez` HN corpus; EDGAR pair query (N-PX noise only) | **NO EDGE** |
| Wilson ~ Shear | avc.com; `emmett` HN corpus (co-presence only, E19) | **NO EDGE** |
| Wilson ~ Qureshi | avc.com (`Nabeel`→6 hits, **all Nabeel Hyatt of Spark Capital**); Qureshi's 14 Substack posts | **NO EDGE** |
| Wilson ~ Perkins | avc.com (`Melanie Perkins`→0; `Canva`→25 hits, all "canvas"/"CanvasPop"/Chris Poole's *Canvas*); Canva investor lists; Open Library; 89 podcast feeds | **NO EDGE** |
| Feld ~ Tavel | — | **WEAK EDGE — see E24.** Blogroll link only, 2006–2008; zero prose in either direction. |
| Feld ~ Huffman | 5,551-post crawl; `bfeld` HN corpus | **NO EDGE** |
| Feld ~ Shear | 5,551-post crawl | **NO EDGE** |
| Feld ~ Qureshi | 5,551-post crawl; Qureshi Substack | **NO EDGE** |
| Feld ~ Perkins | 5,551-post crawl; EDGAR; Canva investor lists; Techstars portfolio (Canva absent); Open Library; 89 podcast feeds | **NO EDGE** |
| Kopelman ~ Tavel | **all 212 Redeye VC posts**; `jkopelman` HN corpus (276 items); her Substack; her Adventurista archive; EDGAR `"Kopelman" "Sarah Tavel"` = **0**; no First Round Review article contains both | **NO EDGE** |
| Kopelman ~ Huffman | all 212 Redeye posts; `jkopelman` + `spez` HN corpora; Open Library pair = 0. EDGAR pair shows 385 hits — **all N-PX proxy ballots**, noise. First Round Review's single Huffman mention sits in an Alexis Ohanian profile with no Kopelman. | **NO EDGE** |
| Kopelman ~ Shear | all 212 Redeye posts; `jkopelman` + `emmett` HN corpora; EDGAR pair = 0; Open Library pair = 0; **"Emmett Shear" appears in 0 of all 979 First Round Review articles** | **NO EDGE** |
| Kopelman ~ Ries | — | **EDGE FOUND on the second pass — see E15c.** The first pass called this NO EDGE because Redeye VC had not been located. |
| Kopelman ~ Qureshi | all 212 Redeye posts; `jkopelman` HN corpus; **"Nabeel Qureshi" appears in 0 of all 979 First Round Review articles**; Qureshi's Substack; EDGAR; Open Library | **NO EDGE** |
| Kopelman ~ Perkins | `jkopelman` HN corpus; EDGAR; all 982 First Round Review posts via its Ghost API; Canva investor lists | **NO EDGE** as a person edge — see E21 for the institutional near-miss |
| Tavel ~ Huffman | her Substack; her Adventurista archive; `spez` HN corpus; EDGAR | **NO EDGE** |
| Tavel ~ Shear | her Substack; her Adventurista archive; `emmett` HN corpus (927 items) | **NO EDGE** |
| Tavel ~ Ries | **all 392 startuplessonslearned.com posts** (0 hits); her Substack; her Adventurista archive; EDGAR; podcast sweep. The only Benchmark mention anywhere on Ries's blog is co-founder Andy Rachleff. | **NO EDGE** |
| Tavel ~ Qureshi | her Substack; her Adventurista archive; Qureshi's Substack and interview transcripts | **NO EDGE** |
| Tavel ~ Perkins | Tavel Substack; EDGAR; Canva investor lists; 89 podcast feeds (both 20VC and Lenny's guests, never same episode) | **NO EDGE** |
| Walk ~ Huffman | hunterwalk.com WP search (`Reddit`→7 posts, none naming Huffman); `spez` HN corpus | **NO EDGE** |
| Walk ~ Shear | hunterwalk.com (`Twitch`→7 posts, none naming Shear — most are the word "twitchy"); `emmett` HN corpus | **NO EDGE** |
| Walk ~ Qureshi | hunterwalk.com WP search; Qureshi Substack | **NO EDGE** |
| Walk ~ Perkins | hunterwalk.com (`Perkins`→5 hits, **all a different Perkins**; `Canva`→3 hits: two are "canvass"/"canvas", the third is a 2025-04-17 Q&A in which the *interviewee* Joe Hyrkin — not Walk — says *"For Issuu, Canva was a natural potential acquirer."* The post names no Canva executive and never mentions Perkins.) | **NO EDGE** |
| Huffman ~ Ries | `spez` HN corpus; **all 392 startuplessonslearned.com posts** (Reddit mentions there are unrelated); EDGAR; podcast sweep | **NO EDGE** |
| Huffman ~ Qureshi | `spez` HN corpus; Qureshi Substack | **NO EDGE** |
| Huffman ~ Perkins | `spez` HN corpus; EDGAR; 89 podcast feeds (both on How I Built This and Masters of Scale, never the same episode) | **NO EDGE** |
| Shear ~ Ries | `emmett` HN corpus (927 items; `lean startup` → 0 in his own text); all 392 Ries posts. **One indirect hit, deliberately not scored:** on Ries's podcast 2020-07-22 (`https://www.startuplessonslearned.com/2020/07/out-of-crisis-15-lenore-estrada-on-her.html`) guest Lenore Estrada discusses Shear as a third-party donor and Ries says *"And, kudos to him for just stepping up and writing the check at a time when others were not."* Ries praises Shear's action while talking to someone else; there is no evidence the two ever interacted. | **NO EDGE** (one WEAK indirect mention) |
| Shear ~ Perkins | `emmett` HN corpus; EDGAR; 89 podcast feeds | **NO EDGE** |
| Ries ~ Qureshi | All 392 Ries posts (0); Qureshi's Substack, where `lean startup` appears **once**, 2024-10-15, as a *contrast* — *"doing the opposite of the 'lean startup' thing"* about Palantir (`https://nabeelqu.substack.com/p/reflections-on-palantir`) — critiquing the doctrine without naming Ries | **NO EDGE** (see §3, near-miss) |
| Ries ~ Perkins | All **392** startuplessonslearned.com posts pulled via its JSON feed: the 3 `Canva` hits are all **"Lean Canvas" / "Business Model Canvas"** false positives, and `Perkins` hits are the 1933 radio serial *Ma Perkins*. EDGAR 0; Open Library 0; podcast sweep 0. | **WEAK one-way only — see E20** |
| Qureshi ~ Perkins | Qureshi Substack archive (neither "Canva" nor "Perkins" appears); Qureshi interview transcripts; 89 podcast feeds | **NO EDGE** |

---

## 3. False positives and near-misses a naive crawler will get wrong

These are the traps. Each one looks like an edge in a search-result snippet and is not one.

1. **"Nabeel" on avc.com is Nabeel *Hyatt*, not Nabeel Qureshi.** Six avc.com posts (2008–2016) name a
   "Nabeel" — he is the Spark Capital venture partner and co-host of the *Hallway Chat* podcast.
   Verbatim, 2016-03-04: *"Yesterday I hung out (virtually) with Bijan and Nabeel at Spark Capital and
   joined them in their podcast they call Hallway Chat."* `https://avc.com/2016/03/hallway-chat/`.
   The HN account `nabeel` is the same person — its bio reads *"entrepreneur. spark capital."*
   **Any name-matching on the first token produces a phantom Wilson↔Qureshi edge.**
2. **"Canva" on avc.com is not Canva.** 25 avc.com posts match `Canva`; the actual strings are
   *canvas*, *CanvasPop*, and Chris Poole's startup *Canvas* — e.g. 2011-06-13, HN, Wilson commenting
   on a story titled "Union Square Ventures Leads $3 Million Round in Moot's Startup, Canvas".
   Substring matching on company names manufactures a Wilson↔Perkins edge that does not exist.
3. **"Twitch" is usually the verb.** On hunterwalk.com, 5 of the 7 `Twitch` hits are *"twitchy"*,
   *"my lizard brain still twi[tches]"*, *"an anxious twitch in the cheek"* (that last one is
   avc.com, 2005). None name Emmett Shear.
4. **"Homebrew" is usually the 1970s computer club.** 3 of the 5 avc.com `Homebrew` hits are the
   Homebrew Computer Club and one is a Kickstarter project called "homebrew Tesla Powerwall clone".
   Only one — 2013-09-29 — is Hunter Walk's firm.
5. **EDGAR N-PX filings are a co-occurrence factory.** `"Fred Wilson" "Steven Huffman"` returns
   **316** EDGAR hits. Every one is a mutual-fund proxy-voting record where a "Fred Wilson" appears
   as a director nominee at one company and Reddit's "Steven Huffman" at another, hundreds of rows
   apart in the same table. **Filter `N-PX` and `N-PORT` out of any EDGAR co-occurrence signal.**
6. **Near-miss, worth knowing but not an edge: Qureshi versus the Lean Startup.** He argues against
   the doctrine Ries is famous for, without naming him: *"Palantir floundered for years, barely
   getting any real traction in the gov space, and doing the opposite of the 'lean startup' thing"*
   (`https://nabeelqu.substack.com/p/reflections-on-palantir`, 2024-10-15). If you wanted a
   conversational hook between two people with no relationship, this is it — but it is a
   `shared-declared-interest` collision, not a `public-disagreement` between them.
7. **A quoted list is not the blogger's opinion.** `https://hunterwalk.com/2016/02/24/if-you-stop-learning-you-stop-living-why-alexia-tsotsis-left-techcrunch-for-stanford-bschool/`
   contains the string *“Fred Wilson, Sarah Tavel”* on a page authored by Hunter Walk — which looks like
   Walk endorsing both. It is not. The list is **Alexia Tsotsis's answer**, printed under the speaker label
   `AT:`: *“As for non-reporters, I enjoy reading Chris Dixon, Paul Graham, Fred Wilson, Sarah Tavel, Ben
   Horowitz, MG Siegler, Sam Altman, Joelle Emerson, Hunter Walk [hw note: aww thanks!], Tracy Chou and
   Mark Suster”*. Walk's only words in that passage are the bracketed aside **about himself**. Roughly a
   third of hunterwalk.com is Q&A with other people, so **any name-extraction over his archive must respect
   speaker labels** or it will attribute his interviewees' opinions to him. (The real Walk↔Tavel evidence is
   E23, and it is elsewhere.)
8. **`eshear` vs `emmett` on Hacker News.** Emmett Shear's real HN account is **`emmett`** (927
   items, karma 4,858, bio names Softmax and Twitch). `eshear` also exists but has **1 item and
   karma 14**. Crawl the wrong one and you get nothing.
9. **A podcast episode *title* naming two people does not mean both were on it.** The 20VC episode of
   2016-10-17 is titled *“Investing Lessons From Fred Wilson & Brad Feld… with Howard Lindzon.”* **Neither
   Wilson nor Feld is on it** — Lindzon is the sole guest, talking about them. This was the single most
   seductive false positive in a sweep of 108 feeds. Likewise 20VC 2018-01-29, *“Investing Lessons From
   Fred Wilson and Brad Burnham @ USV.”* **Match on the guest field, never on the title.** A related trap:
   20VC 2016-03-23 show notes read *“Rebecca's Fave Blog or Newsletter: Sarah Tavel, Brad Feld, Wait But
   Why”* — a third party's reading list, not a Tavel–Feld edge.
10. **Open Library `search/inside` co-occurrence is far too noisy to use as an edge signal.** Querying
   `"A" "B"` returns books containing both names *anywhere*, which for this crowd means every VC
   directory and every startup-history book. Measured, keyless, today:
   `"Fred Wilson" "Brad Feld"` → **52** books; `"Fred Wilson" "Steve Huffman"` → **18**;
   `"Fred Wilson" "Emmett Shear"` → **7**; `"Brad Feld" "Sarah Tavel"` → **2** (*Startup Mixology*,
   *The Business of Venture Capital*). Those last three pairs have **no edge whatsoever** in any
   first-person corpus. The hits are directory entries and third-party narration, e.g.
   *"Two University of Virginia graduates, {{Steve Huffman}} and Alexis Ohanian, created Reddit"*
   next to *"{{Emmett [Shear}}, chief technology officer]"* — two unrelated sentences in
   *The Social Media Bible*. **Use `search/inside` only for acknowledgement-section hits you open
   and read; never as a co-occurrence score.** (Genuine negatives it does give cleanly:
   `"Nabeel Qureshi"` co-occurs with **zero** of the other nine in any scanned book, and
   `"Hunter Walk"` co-occurs with none of Huffman, Shear, Qureshi or Tavel.)
11. **No `public-disagreement` edge was found anywhere in the 45 pairs.** Nobody in this set has
   publicly argued with anybody else in this set, in any corpus searched. That edge type is empty.

---

## 4. Known gaps — where an edge could exist and I could not test for it

Be honest with the scoring engine about these; they are the places where "no edge" means
"not measurable", not "not there".

| Gap | Why it matters | Status |
|---|---|---|
| ~~**Josh Kopelman has no retrievable first-person archive.**~~ **RESOLVED during this audit.** *Redeye VC* is live at `https://redeye.firstround.com` (200) — 72 monthly index pages, **212 posts**, all fetched and body-searched. `kopelman.com` 301s to firstround.com and `joshkopelman.com` **fails DNS**, which is why it looks dead from the obvious URLs. | This was the single largest gap in the first pass and it changed three verdicts: Kopelman→Wilson and Kopelman→Feld went from WEAK to **STRONG**, and Ries↔Kopelman appeared where there had been nothing. **The residual gap is that Redeye stops in 2014** — so Kopelman's outbound naming after 2014 is still unmeasured, and Hunter Walk (Homebrew founded 2013) barely overlaps its lifespan. | **Resolved / partially remaining** |
| ~~**Sarah Tavel's 2006–2015 blog *Adventurista*.**~~ **RESOLVED.** 113 archived posts crawled from the Wayback Machine. | It produced two of her three edges (E22 Wilson, E23 Walk) and one weak one (E24 Feld) — none of which existed in the first pass. It also nearly produced a **false negative**: see the method warning in §2. | **Resolved** |
| **X/Twitter is unreadable.** Half the citations in this set are Twitter links — including the *only* artifact of the Qureshi→Shear edge (a tweet). | Several documented edges are Twitter-shaped (Wilson↔Walk's 2012 #Discover exchange; Feld quoting Walk's tweets). Those are permanently unverifiable at the source. | **Blocked** (see 04-source-retrievability §B1) |
| **Firm-level co-investment is still only partly enumerated.** usv.com/companies, foundry.vc/portfolio, firstround.com/companies and homebrew.co are all JS-rendered and name extraction from the HTML was unreliable. Form D does **not** list co-investors, so a Form-D firm-pair query returning 0 is a **null method, not evidence of absence**. | Mitigated but not closed: Form D **related-persons** lists were pulled directly for **all 8 LTSE filings** and for **First Round Capital VI/VII/IX/X**, and neither contains anyone else from the ten (see §2). firstround.com's companies page contains **no Canva, no Reddit, no Twitch and no LTSE**. | **Partially closed** |
| **Open Library `search/inside`** was run for every pair, but it is a low-precision instrument. | It produced exactly **one** finding worth keeping — the *Do More Faster* chapter list, which independently corroborates Ries↔Feld (E13c) and puts Wilson and Kopelman in the same volume. Everything else it returned was directory noise; see the warning in §3. | **Closed, low yield** |
| **Podcast sweeps are RSS-metadata only, and three important feeds are truncated.** ~108 distinct feeds and well over 10,000 episodes were resolved via the iTunes Search API and grepped — but only titles and descriptions. | A guest who is not named in the show notes is invisible to this method. Specific known holes: **Hard Fork's public feed serves only 3 of ~212 episodes** (NYT gates the back catalogue), so Shear's Nov-2023 OpenAI-era appearances there are **unchecked**; the **a16z feed caps at 1,000 items** (nothing before 2016); **This Week in Startups' feed starts in 2019**, so a pre-2019 Melanie Perkins TWiST episode referenced elsewhere could not be pulled; Equity starts 2021. Every "zero co-appearances" result below should be read as "zero in the retrievable metadata". | **Partially closed, bounded** |
| Tag | Corpus evidence | Representative URL + verbatim |
|---|---|---|
| `venture-capital-craft` | category **"VC & Technology" = 3,859 posts**; series "MBA Mondays" = 196 | `https://avc.com/2019/08/employee-equity-how-much-2/` — *"I wrote a blog post about this topic in November 2010 that has become one of the most searched on and referenced AVC posts of all time."* |
| `crypto-web3` | categories **crypto = 254, blockchain = 254** | `https://avc.com/2024/05/ive-moved-onchain/` — *"Over the last few years, I've moved my internet life from web2 to web3 and rarely use any web2 services anymore."* |
| `music` | category **"My Music" = 898 posts** | `https://avc.com/2023/12/my-year-end-playlist-2/` — *"Every year I put together a playlist at the end of the year with some of the new music I found and got into. Most of these songs are under the radar which is my favorite kind of music."* |
| `education-access` | category **"hacking education" = 205 posts** | `https://avc.com/2023/04/the-annual-computer-science-fair-2/` — *"Ten years ago, a small group of folks in the K12 Computer Science Education community in NYC decided to put on a 'mock job fair' for high school students."* |
| `crowdfunding` | category **crowdfunding = 212 posts** | `https://avc.com/2023/05/funding-friday-crowdfunding-restaurants-via-blackbird/` — *"We have funded a lot of bars, restaurants, coffee shops, and bakeries here over the years."* |
| `climate` | category **"climate crisis" = 59 posts** | `https://avc.com/2023/07/flooding/` — *"I got an email yesterday with photos of the flooding at West Point."* |

### Brad Feld
Tag evidence from `https://feld.com/tags/` (2,978 tags), corroborated by the 5,551-post body crawl.

| Tag | Corpus evidence | Representative URL + verbatim |
|---|---|---|
| `startup-communities` | tags `startup-communities`, `startup-community-way`, `boulder-startup-community`; two books on the subject | `https://feld.com/archives/2020/07/eric-ries-foreword-to-the-startup-community-way/` — *"Some of the inspiration for The Startup Community Way came from Eric Ries."* |
| `venture-capital-craft` | tags `venture-capital`, `venture-deals`, `entrepreneurial-finance`, `startup-boards`, `board-of-directors` | `https://feld.com/archives/2013/01/the-best-approach-to-a-board-package/` — *"I've been describing this as a part of a 'continuous board engagement'."* |
| `mental-health` | tags `mental-health`, `depression`, `#depressionhero`, `mental-fitness`, `brain` | `https://feld.com/tags/depression/` (tag index, 200) |
| `endurance-running` | tags `running`, `marathon`, `marathons`, `ultramarathon`, `ultrarunning`, `trail-running`, `barkley-marathons`, `western-states-endurance-run`, `double-long-run` | `https://feld.com/tags/running/` (tag index, 200) |
| `tech-policy-immigration` | tags `startup-visa`, `international-entrepreneur-rule`, `visa` | `https://feld.com/archives/2016/08/startup-visa-international-entrepreneurs-rule-form-941/` — *"This journey started for me about seven years ago on 9/10/2009 when I wrote the blog post The Founders Visa Movement."* |
| `software-patents` | tags `software-patents`, `patent-trolls`, `abolish-software-patents`, `innovators-patent-agreement`, `functional-claiming` | Feld: *"I'm good friends with Brad and his partner Fred Wilson and we've had a number of conversations about this over the past six months, including the creation of an ad-hoc group we are calling 'Abolish Software Patents'."* (feld.com body crawl) |
| `reading-and-books` | tags `books`, `book`, `book-club`, `book-tour`, `audiobook`; `https://feld.com/books/` | `https://feld.com/archives/2011/11/books-on-entrepreneurship/` — *"I gobbled down some entrepreneurship books in the last week."* |

### Josh Kopelman
Sourced from **his own blog**, *Redeye VC* (`https://redeye.firstround.com`, 200) — 212 posts,
2005–2014. It is dormant but fully readable, and it is the only first-person Kopelman corpus that exists.

| Tag | Representative URL + verbatim |
|---|---|
| `seed-stage-financing` | `https://redeye.firstround.com/2006/04/bridge_loans_vs_1.html` (2006-04-09) — *“Brad Feld recently posted a great overview highlighting the two leading structures for a pre-VC investment.”* |
| `venture-capital-craft` | `https://redeye.firstround.com/2009/10/company-math-vs-vc-math.html` (2009-10-15) — *“I couldn’t agree with Fred more.”* |
| `freemium-and-pricing` | Wilson quoting him, 2007-03-12: *“Josh Kopelman explains the reasons for this in his post, The Penny Gap. The biggest gap in any venture is that between a service that is free and one that costs a penny.”* `https://avc.com/2007/03/in_defense_of_f/` |
| `startup-metrics` | His own HN submission, 2008-01-24: *“I just changed the link -- you can now download the spreadsheet at http://www.kopelman.com/Cohort.xls”* (cohort analysis), `https://news.ycombinator.com/item?id=103771` |
| `founder-support-platform` | `https://redeye.firstround.com/2010/01/sharing-and-exchanging.html` (2010-01-28) — *“I really want to thank the entire First Round Capital team along with our outside speakers and resources for putting on a great CEO Summit.”* First Round's “platform” model is the thing Hunter Walk singles out about him in E10b. |
| ⚠️ | **Recency caveat that matters more than the topics:** Redeye stops in **2014**. Kopelman has no live owned channel in this corpus, so his topic vector is a decade old. Anything current about him comes from other people writing about him. |

### Sarah Tavel

| Tag | Representative URL + verbatim |
|---|---|
| `ai-and-work` | `https://www.sarahtavel.com/p/ai-startups-sell-work-not-software` — *"any work for which a human is a critical input into the work product is vulnerable to substitution with a software product built leveraging large language models (LLMs)"* |
| `ai-coding-agents` | `https://www.sarahtavel.com/p/the-benefits-of-writing-code-two` — *"You want to conserve complexity, not let accidental complexity bubble up. But it's going to be really hard to distinguish accidental complexity from actual complexity when you are 100k lines of alien code deep."* |
| `consumer-network-effects` | `https://www.sarahtavel.com/p/will-ai-be-as-big-of-a-catalyst-for` — *"One of the questions I hear a lot is 'will AI be as big of a catalyst for a consumer AI wave as mobile?'"* |
| `escaping-competition` | `https://www.sarahtavel.com/p/how-to-escape-competition-building` — *"so you don't fall into the trap of providing a service that gets all the margin squeezed away"* |
| `startup-org-design` | `https://www.sarahtavel.com/p/the-mitochondria-in-startups` — *"they start from the perspective of their own optimization, are rational actors, and the value they add to the company, while valuable, scales linearly"* |
| `venture-capital-craft` | Two eras. Recent: `https://www.sarahtavel.com/p/theyre-the-ones-who-reached-out-to` — *"You've got to take control of your process and figure out who you want to partner with. Right now, by relying on inbound…"* Early: *Adventurista*, 2010-07-20 — *"I agree with Fred and the many commenters that in person meetings trump phone call pitches, but lest Fred's advice be taken to the extreme, please don't avoid them all together."* `https://web.archive.org/web/20100723024639/http://www.adventurista.com/2010/07/in-defense-of-phone-call-pitches.html` |
| `blogging-practice` | *Adventurista*, 2010-06-29 — *"I often find that picking a topic to write about is the hardest thing about blogging consistently (I don't know how Fred Wilson does it)."* She has written about the difficulty of writing consistently since 2010 and still opens posts apologising for gaps (2025-08-20: *"I'm embarrassed how long this post took me to sit down to write"*). |

### Hunter Walk

| Tag | Representative URL + verbatim |
|---|---|
| `seed-stage-financing` | `https://hunterwalk.com/2023/09/15/venture-capitalists-will-overpay-for-seed-rounds-but-for-reasons-you-likely-havent-considered/` — *"So when I tell you what I'm seeing in venture financing these [days]…"* |
| `venture-capital-craft` | `https://hunterwalk.com/2018/02/25/venture-funds-as-products-what-we-changed-for-homebrews-third-fund/` — *"Larger, longer fund gives us a better shot to hit our recycling goals"* |
| `startup-boards` | `https://hunterwalk.com/2022/05/11/most-startups-add-independent-board-members-too-late-to-make-a-real-difference-heres-why/` — *"Think Of Your First Non-Investor Board Member As a Senior Hire, And Not Your IPO Board"* |
| `employee-equity` | `https://hunterwalk.com/2024/05/11/are-startup-stock-options-like-lottery-tickets-a-ceo-and-former-employee-discuss-and-my-pov/` — *"I shared a post by Ben Werdmuller where he details that a company he used to work for had a recent repricing/restructuring of their stock"* |
| `product-management` | `https://hunterwalk.com/2013/02/11/what-is-product-management/` — *"What is Product Management? General Assembly asked me to answer that question, so i took my best stab on their blog."* |
| `tech-philanthropy` | `https://hunterwalk.com/2021/11/07/a-tech-millionaires-guide-to-philanthropy/` — *"I still insist that we don't talk enough about money in our community. I mean really talk — publicly, openly, emotionally."* |

### Steve Huffman

| Tag | Representative URL + verbatim |
|---|---|
| `online-community-and-moderation` | Q1-2026 earnings release, SEC-filed: *"Reddit is a one-of-one business powered by deeply engaged communities and authentic human conversation."* `https://www.sec.gov/Archives/edgar/data/1713445/000171344526000067/earningspressreleaseq126.htm` |
| `human-authenticity-vs-ai` | Q2-2026 earnings release, SEC-filed: *"In an increasingly automated web, the value of real human perspective has never been higher."* `https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm` |
| `infrastructure-and-rewrites` | u/spez, 2026-08-05, "Modernizing Reddit's infrastructure with you": *"I love Old Reddit. It's the platform I largely built—as a kid, 21 years ago… If we replace every line of code but the output is the same, is it still old Reddit?"* |
| `bots-and-identity` | u/spez post title, 2026-03-25: *"Humans welcome, bots must wear name tags"* |
| `teaching-programming` | In his own words on HN, 2014-03-31: *"Steve, the Udacity instructor, here. I actually deliberately didn't use Django specifically because it's so complicated for beginners (and for pros, IMHO). I was trying to avoid magic."* `https://news.ycombinator.com/item?id=7502623` (retrieved via `hn.algolia.com/api/v1/search_by_date?tags=author_spez`); course announcement at `https://www.udacity.com/blog/2012/05/steve-huffman-has-something-to-teach.html` (200) |
| `ranking-and-feed-design` | HN, 2013-10-05: *"At reddit we had two tactics for the frontpage problem. The first thing we added was the 'rising' page, which used to be reddit's default 'new' page. The rising page was a weighted new page."* `https://news.ycombinator.com/item?id=6499144` |
| `travel-search` | 5 years of his HN corpus (2010–2014) is **Hipmunk**, not Reddit — e.g. 2010-08-19: *"I think the most important feature we have is that we remove about 80% of results from listings because they're totally redundant."* `https://news.ycombinator.com/item?id=1618999` This is the largest single topic in his own public prose and it is invisible in his press coverage. |

### Emmett Shear

| Tag | Representative URL + verbatim |
|---|---|
| `ai-alignment` | His own HN "Who is hiring" post, 2026-03-02: *"THE MOST IMPORTANT UNSOLVED PROBLEM IN AI IS THE MOST POWERFUL OF ALL CAPABILITIES: ALIGNMENT… I believe the question of how AI systems learn to understand themselves and others is one of the most consequential technical problem[s]"* `https://news.ycombinator.com/item?id=47219766` |
| `burnout-and-founder-psychology` | Independently corroborated from outside: Nabeel Qureshi links *"Emmett Shear on burnout"* as one of three tweets worth bookmarking (`https://nabeelqu.substack.com/p/the-serendipity-machine`) |
| `livestreaming-and-creator-economy` | HN bio: *"founder and CEO of Twitch"*; 2011-03-20, recruiting: *"I'm going to be shamlessly self-promotional and suggest http://www.justin.tv/jobs/apply … we are a startup-y startup."* |
| `economic-history` | HN submissions: *"Global GDP since 1820: a small china is an aberration"* (2009-10-06), *"Why did the Industrial Revolution begin in northwestern Europe?"* (2008-07-02) |
| `programming-languages` | HN submissions: *"MISC: A homoiconic language based on maps"*, *"Don't use Pound for load balancing"* (2008-03-03) |
| `science-fiction` | HN, 2009-12-22: *"Greg Egan is my favorite sci-fi writer. Read [Axiomatic] and have your mind blown."* |

### Eric Ries

| Tag | Representative URL + verbatim |
|---|---|
| `lean-startup-methodology` | His own blog, `https://www.startuplessonslearned.com` — **392 posts, 2008-08-02 → 2026-05-17**, all pulled via its JSON feed. E.g. `https://www.startuplessonslearned.com/2010/05/lean-startup-intensive-is-tomorrow-at.html` — *"Panel: Investing in the era of the lean startup"* |
| `continuous-deployment` | Wilson, 2011-02-12: *"Here's an Eric Ries post on continuous deployment if you want to get a longer description of what it is and how it works."* `https://avc.com/2011/02/continuous-deployment/` |
| `startup-communities` | Feld, 2020-07-28: he wrote the foreword to *The Startup Community Way*. `https://feld.com/archives/2020/07/eric-ries-foreword-to-the-startup-community-way/` |
| `tech-policy-immigration` | Feld, 2010-03-22: *"Eric Ries, who is part of the Startup Visa Initiative core team (and the creator of the Lean Startup Methodology), has a great essay up on The Huffington Post."* `https://feld.com/archives/2010/03/monday-morning-startup-visa-articles/` |
| `long-term-capitalism` | LTSE — his own SEC-registered exchange. EDGAR full-text search for `"Eric Ries"` returns 64 hits, top entities **Long-Term Stock Exchange, Inc. (CIK 0001680712)**, LTSE Services, LTSE Group, LTSE Holdings. Across all **8** LTSE Form D filings (2016-07-27 → 2022-08-08) he is listed as **Executive Officer, Director and Promoter** — the only one of the ten with a registered national securities exchange to his name. |
| `tech-policy-elections` | Co-signatory, 2016-07-14: *"Eric Ries, Entrepreneur & Author, The Lean Startup"* on the anti-Trump innovation letter. `https://hunterwalk.com/2016/07/14/trump-would-hurt-innovation-im-with-her/` |

### Nabeel Qureshi

| Tag | Representative URL + verbatim |
|---|---|
| `attention-and-serendipity` | `https://nabeelqu.substack.com/p/the-serendipity-machine` (2024-01-20) — *"Twitter is of great (and underrated) societal importance."* |
| `enterprise-software-and-palantir` | `https://nabeelqu.substack.com/p/reflections-on-palantir` (2024-10-15) — *"Palantir floundered for years, barely getting any real traction in the gov space, and doing the opposite of the 'lean startup' thing"* |
| `taste-and-aesthetics` | `https://nabeelqu.substack.com/p/what-makes-art-great` (2026-05-03) — *"Shakespeare is excellent, whereas AI writing…"* |
| `learning-and-practice` | `https://nabeelqu.substack.com/p/notes-on-puzzles` (2023-07-11) — *"I mostly don't play chess anymore — it's too addicti[ve]"* |
| `advice-and-principles` | `https://nabeelqu.substack.com/p/advice` (2022-07-04) — *"The most valuable feedback usually hurts a lot. If you want to think originally and differently, seek uncorrelated inputs. Read minor works, older things, obscure journals."* |
| `reading-and-books` | Same post, plus his book notes: *"A fun but light read, ending felt forced… Very 'young adult', will appeal to people who like that kind of thing."* |

### Melanie Perkins
Her corpus is the hardest to reach: `canva.com` **403s every automated client**, so the primary source
is the Wayback capture of her own 21-Questions memoir.

| Tag | Representative URL + verbatim |
|---|---|
| `design-democratization` | `http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/` — *"I found that the design tools I was teaching were really clunky and difficult to use."* |
| `fundraising-and-rejection` | Same source — the Fusion Books / Cameron Adams rejection-email material |
| `investor-access-and-networking` | Same source: *"I was also learning to kitesurf, as I knew Bill ran a conference called MaiTai which was a gathering of entrepreneurs and kitesurfers. Kitesurfing scares the hell out of me… But I wanted to get Canva off the ground, so it was just a small inconvenience."* |
| `founder-origin-story` | SmartCompany, 2013-03-19: *"I met Bill Tai at a conference in Perth a few years back. We kept in contact and kept him informed about what we were doing."* `https://www.smartcompany.com.au/startupsmart/design-start-up-canva-raises-3-million-after-kitesurfing-in-hawaii/` |
| `community-and-comfort-zones` | Same SmartCompany piece: *"Everyone is learning to kitesurf, so it's about getting people out of their comfort zone. It helps people to bond in a way you can't do in a boardroom."* |

### Computable topic overlaps

Only tags shared by two or more people, using the vocabulary above:

| Tag | Held by | Note |
|---|---|---|
| `venture-capital-craft` | Wilson, Feld, Kopelman, Tavel, Walk | 5 of 10 — the least discriminating tag in the set |
| `seed-stage-financing` | Kopelman, Walk | Walk names Kopelman as the person who institutionalised it (E10b) |
| `startup-communities` | Feld, Ries | backed by a real edge (E11) |
| `tech-policy-immigration` | Feld, Ries | backed by a real edge (E12) |
| `tech-policy-elections` | Feld, Ries, Walk | backed by a real edge (E14) |
| `startup-boards` | Walk, Feld | |
| `reading-and-books` | Feld, Qureshi | **no edge between them** — this is the best pure-topic pairing in the set |
| `blogging-practice` | Tavel, Wilson | Tavel's is *about* Wilson (E22) |
| `ai-and-work` · `ai-alignment` · `human-authenticity-vs-ai` | Tavel · Shear · Huffman | **three people, three different tags, no shared tag.** All writing about AI; none writing about the same thing. Do **not** collapse these into one `AI` bucket — that is the fastest way to manufacture a fake affinity between Huffman and Tavel. |

Two things this table is for:

**(a) Spotting where topical affinity is all you have.** `reading-and-books` (Feld ↔ Qureshi) is the
clearest case in the whole audit: two people with a genuine, deep, repeatedly-documented shared
interest and **zero** documented contact. That is exactly the pair the arrival digest should
introduce — and it should say so honestly ("you have both written a lot about what you read; as far
as I can tell you have never met") rather than implying a connection.

**(b) Guarding against the opposite failure.** `venture-capital-craft` is held by five of the ten,
so topic similarity alone will happily rank Kopelman↔Tavel — a pair with **no edge in any corpus
searched, including all 212 of his posts and all 133 of hers** — as highly as Wilson↔Feld, the
densest edge in the set. **Topic overlap and relationship evidence must be scored on separate axes,
and the engine must be able to say out loud: "you have never mentioned each other."**

---

## E-NEW — Huffman <-> Shear: same YC batch, Summer 2005. STRONG. (measured 2026-09-03)

The strongest edge found outside the Wilson/Feld cluster, and the cleanest asymmetry in the set.

**Evidence**
- YC's own live company directory (Algolia index `YCCompany_production`, public key from
  `https://www.ycombinator.com/companies`), `facetFilters=[["batch:Summer 2005"]]` -> exactly 9 hits:
  `Clickfacts, Infogami, Kiko, Loopt, Memamp, Parakey, Reddit, Simmery, TextPayMe`.
  Both **Kiko** (Shear) and **Reddit** (Huffman) are in it.
- `ycombinator.com/companies/reddit` — "Batch: Summer 2005 … Founded by Steve Huffman and Alexis Ohanian"
- `ycombinator.com/companies/kiko` — "Summer 2005 … Former Founders Justin Kan … Emmett Shear"
- Shear in his own words, HN item 1821879, 2010-10-22:
  *"This is where we wrote a good deal of the code for Kiko, and where Steve wrote a lot of Reddit.
  It makes me nostalgic for our 2005 YC batch, and sad to see it go on the market."*
- Shear, HN 47219766, 2026-03-02: *"You may know me as the founder of Twitch (YC S05)"*

**Direction is ONE-WAY, and this is the demo-grade finding.**
Shear names Huffman (HN 2666830, 2011-06-17: *"The founding team of reddit was Steve Huffman (spez)
and Alexis Ohanian (kn0thing)."*). Huffman has **never** named Shear: all 67 `spez` HN comments
contain zero occurrences of emmett / shear / kiko. They co-occur in exactly **one** HN thread ever
(item 1481914, 2010), with no reply relationship.
=> `shared_org` symmetric (S2/S3), plus `cited_in_own_writing` Shear->Huffman only (S5 one-way).
This is exactly the shape R-021 asserts and G-001 fixtures.

**Two institutional bridges, both verified in filings**
- **Michael Seibel** — Shear's Justin.tv/Twitch co-founder — sits on **Reddit's board**.
  Reddit 424B4: *"Michael Seibel has served on our board of directors since July 2020 … from June
  2007 to October 2011, he served as Chief Executive Officer of Justin.tv (now known as Twitch.tv)"*
- **Adam Goldstein** — Huffman's Hipmunk co-founder — is on **Softmax's board**.
  softmax.com/about: *"Adam Goldstein Board Member and Founder Emeritus / Cofounded Hipmunk"*

**Caveat:** Twitch's YC page says Winter 2007 — that is Justin.tv's batch. The S2005 tie is
Kiko<->Reddit, not Twitch<->Reddit. An implementation keying on "Twitch" will miss this edge.

**Negative results worth keeping** (searched, not skipped): Huffman has NO edge to Wilson, Feld,
Kopelman, Tavel, Walk, Ries, Qureshi or Perkins in any first-person corpus. Reddit's 424B4 contains
zero occurrences of any of the other nine names. Justin.tv's Form D related persons are Shear, Kan,
Alsop, Kurzweil, Paik, Sutton — no USV, Foundry, First Round, Benchmark or Homebrew.
One residual gap: feld.com now serves a Pagefind WASM index that could not be queried headlessly;
in-body mentions there cannot be fully excluded.
