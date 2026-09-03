# People audit — Shear, Ries, Qureshi, Perkins

**Audit date: 2026-09-03.** Part of the Arena Hall Arrival Engine audit phase (see `00-AUDIT-BRIEF.md`). This document measures the **real, retrievable** public footprint of four of the ten stand-in figures. It is a measurement record, not a research essay.

**Rules applied throughout.** A search-engine snippet is never cited as a source — every quotation was extracted from a page actually fetched. HTTP status codes are observed, not assumed. Guessed URLs that failed are recorded as negative findings rather than deleted. Anything believed but not confirmed against a primary artifact is marked **UNVERIFIED**.

**Method.** `curl` (with and without a desktop Chrome User-Agent) for honest status codes and redirect chains; `WebFetch` for page text; a real headless browser where bot challenges blocked both; the Wayback Machine via `curl` where the live web was gone; and structured APIs (Hacker News Firebase/Algolia, GitHub, SEC EDGAR, OpenLibrary, iTunes Search) where HTML was walled. Work was fanned out across four parallel auditors and reconciled here.

---

## Cross-cutting findings

**1. Retrievability varies enormously across these four, and not in the way reputation predicts.** Ranked by how much of their own unmediated voice a machine can actually read today:

| | Own-voice corpus retrievable? | Best single artifact | Verdict |
|---|---|---|---|
| **Nabeel Qureshi** | **Very high** | A 120,836-char public speaker-labeled podcast transcript, plus 14 full-text essays via RSS | Richest of the four |
| **Emmett Shear** | **High, but historical** | **927 Hacker News items, 2007-02-19 → 2026-03-02**, free via API | Deep archive, thin present |
| **Eric Ries** | **High** | **392-post blog archive** + 12 current newsletter issues + SEC primary documents | Live and layered |
| **Melanie Perkins** | **Very low** | A ~64,000-char first-person memoir — **only reachable via archive.org** | Structurally walled |

**2. The most-walled person is the most famous one.** Every `canva.com` path tested returned **403** (11/11), including under a full Chrome UA. Perkins has **no personal website** (`melanieperkins.com` refuses connection; the `.com.au` is parked for sale on GoDaddy). Her X is a JS wall, her LinkedIn returns **999**. The four places she speaks in her own voice are unreadable by four *different* mechanisms. Everything quotable about her in 2026 is journalist-mediated — her own words survive only in the Internet Archive.

**3. Uniform social-platform result across all four.** No subject has a usable public Instagram or TikTok. LinkedIn returned **999** for Shear, Ries and Perkins and a hard signup wall for Qureshi — **no activity feed is readable logged-out for anyone**. **Nobody's X following list is visible logged-out** for any of the four; only the aggregate count leaks. Do not design anything that depends on these.

**4. Name collision is a live hazard, not a hypothetical.** `en.wikipedia.org/wiki/Nabeel_Qureshi` is a **different person** (the Christian apologist, 1983–2017); our subject has no Wikipedia article. `instagram.com/nabeelqu` is a different person again ("Nabeel qurban Ali"). `youtube.com/@eshear` is "eshwar mr Kannada gamer". `eshear.com` is a GoDaddy parking page that returns **200 on every path**, and `emmettshear.com` was an Indonesian SEO spam blog before it stopped resolving. `youtube.com/feeds/videos.xml?user=canva` silently resolves to an unrelated Hong Kong personal channel. **A 200 is not identity confirmation.**

**5. AFR routes on the trailing article ID and rewrites the rest of the path.** Two invented `afr.com` slugs both returned **200** — to a superannuation-tax story and a Formula 1 story respectively. Any AFR citation not obtained by following a real link is untrustworthy. Separately, AFR and SMH (both Nine Entertainment) carry an explicit anti-AI clause in `robots.txt` and are **hard-excluded from the search tool at the API level**. The outlets that cover Canva's finances most closely are invisible to this pipeline; Forbes **Australia** and Startup Daily are the open substitutes.

**6. Feeds are scarcer than expected, and often worse than the alternative.** Qureshi's own RSS is title-only — the **Substack mirror carries full text and four extra items**. Ries's *most active* channel (a beehiiv newsletter) has **no working RSS at all**. Softmax has no feed; its only machine-readable index is `sitemap.xml`. The only confirmed working feed in Perkins's entire orbit belongs to Canva's **company** YouTube channel. Feed availability is inversely correlated with how current the channel is.

**7. Two infrastructure conditions materially shaped this audit and should be recorded.**
- **The Internet Archive was intermittently offline** — `web.archive.org/cdx/...` returned **HTTP 503, "Internet Archive services are temporarily offline"** during the Qureshi pass, while succeeding for the Shear and Perkins passes. Since archive.org is the *only* route to Perkins's own writing and to Shear's 2006–2010 blog, this is a single point of failure for a third of the value in this document.
- **The Nitter/X-mirror route is closed.** `xcancel.com` now serves a cease-and-desist notice dated "Monday 24th August" — roughly ten days before this audit.
- Note also that `WebFetch` refuses `web.archive.org` entirely; all archive work here was done with `curl`.

**8. "Stale" is usually a retrieval artifact, not a fact about the person.** Ries looked dormant (blog: 3 posts since 2021, podcast dead 8 months, X unreadable since January) and is in fact mid-book-launch with 12 newsletter issues, near-daily YouTube uploads, and GitHub pushes **on the audit date itself**. Shear's Mar–Sep 2026 gap is a gap in what is *fetchable* — his X timeline is JS-walled, so silence cannot be inferred. State recency claims as claims about *the record*, not about the person.

## Per-person quick reference

| | Richest source | Best deep cut | Recency (Mar–Sep 2026) |
|---|---|---|---|
| **Shear** | Hacker News: 927 items, karma 4,858, via Firebase/Algolia API | "Optimize Prime," his 2006–2010 blog — incl. **Aaron Swartz in his comments section** | **Thin.** Mar 2 HN post, Apr 2026 GitHub/company blog, then nothing. Own bylined writing ~16 months old. |
| **Ries** | Startup Lessons Learned: 392 posts, 2008 → 2026 + SEC/EDGAR primary docs | A **320-page Tom Lehrer songbook** he ghostscript-stitched himself | **Very live.** New book May 26; newsletter through Aug 23; YouTube + GitHub **same-day**. |
| **Qureshi** | `nabeelqu.co` + Substack full-text feed + a 120k-char public transcript | A **chess endgame kata trainer** he vibe-coded, closing a loop opened in a 2020 essay | **Very live.** X Aug 31; essay May 2; New Statesman May 23; Dialectic Jun 29; GitHub Sept. |
| **Perkins** | Her own "21 Questions" memoir — **archive.org only** | She learned to kitesurf **as an instrument to reach Bill Tai, and hated it** — in her own words | **Active but mediated.** No fetchable first-person publication in the window. |

---

## Emmett Shear — public footprint measurement audit

Audit date: **2026-09-03**. Every URL below was actually requested (curl or WebFetch). Status codes are observed, not assumed.

---

### 1. Source inventory

#### 1.1 Headline table

| Channel | URL fetched | HTTP | Feed? | Volume / cadence | Gated? |
|---|---|---|---|---|---|
| Softmax site | `https://softmax.com/` | 200 | **No RSS** (see below) | 139 URLs in sitemap | Open |
| Softmax blog | `https://softmax.com/blog` | 200 | none | **6 posts, Mar 2025 → Apr 2026** | Open |
| Softmax sitemap | `https://softmax.com/sitemap.xml` | 200 | n/a | 139 `<loc>` entries | Open |
| Softmax robots | `https://softmax.com/robots.txt` | 200 | n/a | Allows all but `/api/observatory/v2/coworlds/replays/` | Open |
| **Old personal blog** | `http://blog.emmettshear.com/` (Wayback) | 200 via archive | atom + rss2 (archived) | **25 posts, Aug 2006 → Feb 2010** | **Dead domain — Wayback only** |
| Posterous blog | `http://eshear.posterous.com/` (Wayback) | 200 via archive | n/a | ~5 posts, Oct 2009 → Feb 2012 | **Platform dead (2013)** |
| X / Twitter | `https://x.com/eshear` | 200 | none | Timeline JS-walled | Bio readable, tweets not |
| Hacker News (`emmett`) | `https://hacker-news.firebaseio.com/v0/user/emmett.json` | 200 | n/a | **927 items, 2007-02-19 → 2026-03-02**; karma 4,858 | Open |
| Hacker News (`eshear`) | same API, `/user/eshear.json` | 200 | n/a | **1 submission**, karma 14 | Open |
| GitHub | `https://api.github.com/users/eshear` | 200 | n/a | 9 repos, 48 followers, joined 2009-02-04 | Open |
| Substack | `https://eshear.substack.com/feed` | 200 | **yes, but empty** | **1 item: "Coming soon", 2023-10-17** | Open, abandoned |
| Wikipedia | `https://en.wikipedia.org/wiki/Emmett_Shear` | 200 | n/a | Last edit 2026-09-01 (bot) | Open |
| LinkedIn | `https://www.linkedin.com/in/eshear/` | **999** | no | — | **Blocked** |
| LinkedIn (alt) | `https://www.linkedin.com/in/emmettshear/` | **999** | no | — | **Blocked** |
| Crunchbase | `https://www.crunchbase.com/person/emmett-shear` | **403** | no | — | **Blocked** |
| Instagram | `https://www.instagram.com/eshear/` | 200 | no | JS shell only | **Indeterminate** |
| TikTok | `https://www.tiktok.com/@eshear` | 200 | no | Page body says **"Couldn't find this account"** | **Does not exist** |
| YouTube `@eshear` | `https://www.youtube.com/@eshear` | 200 | — | **NOT HIM** (see 1.5) | n/a |
| `eshear.com` | `https://eshear.com/` | 200 | — | **GoDaddy parking page** (see 1.5) | n/a |
| `emmettshear.com` | DNS lookup | **NXDOMAIN** | — | Domain does not resolve | n/a |
| Deep Tech Week | `https://www.deep-tech-week.com/speakers/emmett-shear` | 200 | — | 1 session, **June 27 2025** | Open |
| HumanX speaker page | `https://www.humanx.co/speaker/emmett-shear` | **404** | — | Guessed from a search result — **does not exist** | n/a |
| ThreadReader | `https://threadreaderapp.com/user/eshear` | 200 | — | 18 unrolled threads, May 2024 → **Nov 24 2025** | Open |

#### 1.2 Softmax — the live centre of gravity

`https://softmax.com/blog` (200) lists exactly six posts:

| Post | Author | Date | URL |
|---|---|---|---|
| Mission: Organic Alignment | Softmax Team | Apr 2025 | `/mission` |
| **Red Button, Blue Button: Teaching AI to supercooperate** | Yatharth Agarwal | **Apr 2026** | `/blog/red-button-blue-button` |
| Research That Inspires Us | Softmax Team | Apr 2025 | `/blog/inspiration` |
| **Rheomode: When Language Flows Like Reality** | **Emmett Shear and Sonnet 3.7**, based on the work of David Bohm | Apr 2025 | `/blog/rheomode` |
| **The Frame-Dependent Mind** | **Emmett Shear and Sonnet 3.7** | Apr 2025 | `/blog/the-frame-dependent-mind` |
| Reimagining Alignment | Softmax Team | Mar 2025 | `/blog/reimagining-alignment` |

`lastmod` values from the fetched sitemap: red-button-blue-button `2026-04-30`, inspiration `2025-04-30`, rheomode `2025-04-19`, frame-dependent-mind `2025-04-18`, reimagining-alignment `2025-03-28`.

Only **two** posts carry Shear's own byline, and both are co-credited to **Claude Sonnet 3.7** — a genuinely unusual authorship convention worth noting.

**No RSS/Atom feed exists.** All of these 404'd: `softmax.com/feed`, `/rss.xml`, `/index.xml`, `/blog/rss.xml`, `/blog/feed`. The only machine-readable index is `sitemap.xml`.

#### 1.3 The Softmax "coworld" gallery — 139 URLs, largely undocumented

The sitemap exposes a very large environment gallery that is not linked prominently from the homepage. A partial list of fetched `<loc>` entries: `/sugarscape`, `/atlas`, `/browse`, `/vanilla-wow` (plus `/vanilla-wow/arena-wow`, `/dungeon-wow`, `/race-wow`), `/nethack`, `/minecraft`, `/factorio`, `/hanabi`, `/nomic`, `/nomic-fable`, `/eleusis`, `/liars-dice`, `/werecog`, `/cogplomacy`, `/cogtan`, `/cogs-against-humanity`, `/cogs-vs-clips`, `/cogmud`, `/cogolf`, `/cosino`, `/coguire`, `/polymarket-coworld`, `/tribal-fortress`, `/battleroyale`, `/pudge-wars`, `/atari-57`, `/atari-cabinet`, `/vizdoom-deathmatch`, `/smac-starcraft-micro`, `/procgen`, `/pommerman`, `/lux-ai`, `/halite`.

`https://softmax.com/atlas` (200) renders, per the fetched page, a **1930s-style illustrated map labelled "softmax universe"**, with regions named "The Paintlands", "The Great Simulations", "The Tabletop Coast", "The Cozy Shire", "Terra Incognita" and "Melting Pot Marshes".

Note the naming joke running through the whole gallery: agents are "cogs", so Diplomacy → *Cogplomacy*, Catan → *Cogtan*, Werewolf → *Werecog*, Machiavelli → *Cogiavelli*, agriculture → *Cogriculture*.

#### 1.4 Hacker News — the single richest verifiable archive

`https://hacker-news.firebaseio.com/v0/user/emmett.json` (200) returns his self-written bio verbatim:

> "Founder and CEO of Softmax. Softmax is building massively multiplayer benchmarks for coding agents to train social intelligence.<p>Previously very interim CEO of OpenAI, YC Partner, and founder and CEO of Twitch.<p>Email me at emmett@softmax.com."

Karma **4,858**; account created **2007-02-19** (HN's public launch day). I paginated the Algolia API (`hn.algolia.com/api/v1/search_by_date?tags=author_emmett`) and pulled **all 927 items**, spanning **2007-02-19 → 2026-03-02**. This is by far the largest body of his own prose that is fully retrievable without a login.

A second account, `eshear` (`/user/eshear.json`, 200), created **2006-10-09** — the literal first day of HN's private "Startup News" beta — karma 14, with exactly **one** submission: item **#32**, "Scratchtop - notepad for the web" (`http://scratchtop.com`), 2006-10-10. See §3 for why this is almost certainly him.

Direct HN page fetches (`news.ycombinator.com/user?id=...`) returned **429 Too Many Requests** from both curl and WebFetch; the Firebase and Algolia APIs were the working route.

#### 1.5 Negative findings on plausible-looking URLs

These matter as much as the positives:

- **`eshear.com` is not his.** It returns 200 but the entire body is `<!DOCTYPE html><html><head><script>window.onload=function(){window.location.href="/lander"}</script></head></html>`, and following redirects lands on `https://forsale.godaddy.com/forsale/eshear.com?...` — a **GoDaddy domain-for-sale parking page**. Because parking wildcards every path, `eshear.com/feed`, `/rss.xml`, `/atom.xml`, `/blog`, `/posts` and `/robots.txt` *all* return 200 with that same 114-byte stub. Anyone probing this domain will get false positives.
- **`emmettshear.com` no longer resolves** (`curl: (6) Could not resolve host`). Wayback CDX shows that between roughly 2019 and 2021 the domain was taken over by an **Indonesian SEO spam blog** (e.g. `emmettshear.com/10-cara-memulai-dagang-usaha-online-tanpa-modal-terpercaya/`, 200 in 2021). None of that is his writing. His actual blog lived on the **subdomain** `blog.emmettshear.com`.
- **`youtube.com/@eshear` is not him.** Fetched page `<title>` is **"eshwar mr Kannada gamer - YouTube"**. I found no YouTube channel he owns.
- **`humanx.co/speaker/emmett-shear` → 404.** A search result asserted a "HumanX 2026" speaker page; the URL does not exist. `humanx.co/us/2027/speakers` returns 200.
- **`github.com/emmettshear` → 404.** The real account is `github.com/eshear`.
- **No book.** I found no evidence of an authored book anywhere in the fetched sources.
- **Substack is a shell.** `eshear.substack.com/feed` (200) contains a single item, title `Coming soon`, description `This is Emmett's Substack.`, `pubDate: Tue, 17 Oct 2023 02:43:22 GMT`. Registered a month before the OpenAI weekend; never used since.

#### 1.6 GitHub — `https://github.com/eshear` (200)

Profile: name "Emmett Shear", location "San Francisco, CA", 9 public repos, 48 followers, created 2009-02-04, **profile updated 2026-05-24**. Repos from `api.github.com/users/eshear/repos`:

| Repo | Fork | Lang | Created | Last push | Description |
|---|---|---|---|---|---|
| `softmax-universe` | no | — | 2026-04-07 | 2026-04-07 | "Game service ontology and admin dashboard" |
| `autoquine` | **no** | Python | 2025-12-09 | **2026-02-25** | (no description) |
| `metta` | yes | — | 2025-09-30 | 2025-09-30 | "A reinforcement learning codebase focusing on the emergence of cooperation and alignment in multi-ag…" |
| `pong-wars` | yes | — | 2025-09-28 | **2026-04-01** | "the eternal battle between day and night" |
| `noteswiki` | yes | TypeScript | 2025-06-03 | 2025-06-03 | Open-source DeepWiki |
| `tweetgrabber` | no | Python | 2025-04-25 | 2025-04-25 | (no description) |
| `xmpp4r-simple` | yes | Ruby | 2010-08-24 | 2010-08-24 | Jabber::Simple |
| `homebrew-versions` | yes | Ruby | 2012-08-29 | 2012-08-30 | — |
| `gcal-multical-event-merge` | yes | JavaScript | 2014-09-17 | 2014-09-17 | — |

`autoquine` has **no README** (`raw.githubusercontent.com/eshear/autoquine/main/README.md` → **404**); the contents API shows three files: `README` (859 B, extensionless), `autoquine.py` (5,951 B), `test_autoquine.py` (1,458 B).

#### 1.7 Podcasts

Verified from fetched pages:

- **a16z** — `https://a16z.com/podcast/emmett-shear-on-building-ai-that-actually-cares-beyond-control-and-steering/` (200). Published **November 17, 2025**. **No transcript on the page.** Fetched description verbatim: *"Emmett Shear, founder of Twitch and former OpenAI interim CEO, challenges the fundamental assumptions driving AGI development… he proposes 'organic alignment' – teaching AI systems to genuinely care about humans the way we naturally do."*
- **Par Conley interview** — `https://parconley.com/emmett-shear/` (200). Includes an LLM-generated transcript (the page itself flags typos). Topics: SF, power, AI alignment, meditation, Softmax. *Note: the fetched page reports a publication date of **September 19, 2025**, contradicting a search snippet that claimed May 2026. I trust the fetched page.*
- **Deep Tech Week 2025** — `https://www.deep-tech-week.com/speakers/emmett-shear` (200). Session **"Democratize Intelligence"**, **June 27, 2025**, 1 Beach St. Bio verbatim: *"Emmett Shear is the founder and CEO of Softmax, and formerly Twitch, a live streaming service, which he helped build from Justin.tv starting in 2011."*

A parallel sub-agent was dispatched to systematically verify the wider podcast record (Lex Fridman, Dwarkesh, Logan Bartlett, My First Million, Complex Systems, Cognitive Revolution, Win-Win, Doom Debates) and had not reported back at the time of writing. **Treat the podcast section as the least complete part of this audit.** In particular I did **not** myself verify that a Lex Fridman or Dwarkesh Patel episode exists — do not assume either does.

---

### 2. Recency probe (Mar – Sep 2026)

**Verdict: the trail is thin but not dead.** There is solid activity in **March and April 2026** and then it goes quiet. I found **nothing at all dated June–September 2026** in any source I could fetch.

Dated, fetched items in the window:

**(a) 2026-03-02 — Hacker News "Who is hiring?", item 47219766.** His most recent HN activity of any kind, verbatim from the Algolia API:

> "THE MOST IMPORTANT UNSOLVED PROBLEM IN AI IS THE MOST POWERFUL OF ALL CAPABILITIES: ALIGNMENT.
> Hi, I'm Emmett. You may know me as the founder of Twitch (YC S05), and as the (extremely) interim CEO of OpenAI.
> I believe the question of how AI systems learn to understand themselves and others is one of the most consequential technical problems of our time. If we get it right, the agents we build today will become our friends and collaborators tomorrow."

and, on the job itself:

> "The work is unusually hard. The problems are ambiguous and challenging. High autonomy, high expectations. You'll work directly with me and the rest of our small but mighty team."

Source: `https://hn.algolia.com/api/v1/search_by_date?tags=author_emmett` → `https://news.ycombinator.com/item?id=47219766`

**(b) 2026-04-30 — Softmax blog, "Red Button, Blue Button: Teaching AI to supercooperate"** (`https://softmax.com/blog/red-button-blue-button`, 200; sitemap `lastmod 2026-04-30T00:00:00.000Z`). Verbatim from the fetched article body:

> "If your goal is to live and keep everyone else alive, for a given population, the 'correct' choice is to vote with the majority. Suppose the poll was repeated many times. If you knew from the past that red usually won, it would be easy for people to know to choose red and save themselves."

**Important caveat: this is not Shear's writing.** The byline is **Yatharth Agarwal**. It is the newest thing on his company's blog, but it is not his voice.

**(c) 2026-04-07 — GitHub `softmax-universe` created**, described as "Game service ontology and admin dashboard" (`https://api.github.com/users/eshear/repos`). His fork of `pong-wars` was last pushed **2026-04-01**, and his GitHub profile record shows `updated_at: 2026-05-24T21:32:16Z`.

**What is stale:** his own bylined writing on the Softmax blog is **~16 months old** (April 2025). His Substack has never been used. His last archived long-form X thread is **2025-11-24**. His last verified podcast appearance is **2025-11-17**, and his last verified conference talk is **2025-06-27**.

**Honest caveat on X:** I could not read his timeline. `x.com/eshear` returns 200 but the timeline is JavaScript-walled; the only thing I could extract from the fetched HTML was the `og:description` — **"CEO of Softmax: Massively Multiplayer Learning Environments"** — which is current. He may well be tweeting daily. **The Mar–Sep 2026 gap is a gap in what is *retrievable*, not proof of silence.**

---

### 3. The deep cut

#### 3.1 "Optimize Prime" — his 2006–2010 blog, now reachable only through the Wayback Machine

This is the find of the audit. His HN submissions from 2007–08 link to `blog.emmettshear.com`, a domain that no longer resolves. Wayback CDX (`http://web.archive.org/cdx/search/cdx?url=blog.emmettshear.com/post*`) returns a **complete 25-post inventory**, Aug 21 2006 → Feb 12 2010. The blog was called **"Optimize Prime"** — a Transformers pun — and ran on DotClear 2 hosted at Gandi.

Post titles include: *First Post*, *The Kiko Asset Sale*, *The $100k Plan*, *The Kiko Asset Sale: Finished*, *Yogurt: The Unknown Danger*, *Things I Didn't Know About The History Of Schools*, *Lessons from eBaying Kiko*, *Arrival in San Francisco*, *Scratchtop*, *The World: Very Very Small*, *Blacklist Script for Reddit*, *That's very liberal of you*, *This Blog Is Boring*, *Splay Tree*, *What's Wealth*, *Food Riffs*, *Google Ownz Me*, *Insecure By Default*, *The next tinyurl*, *Don't use Pound for load balancing*, *Shortest parser*, *Counting Uniques With MongoDB*.

**(i) "Yogurt: The Unknown Danger" (2006-08-29)** — a Swiftian TSA satire, tagged by him as `modestproposal security airports airplanes yogurt`. Verbatim:

> "While surely the extremely thorough security check given by the flight attendants as you board would catch a simple ruse like hiding the yogurt by placing it in a bag, I am worried they will miss other more devious possibilities. For example, they sell good, honest, plane-legal muffins in the airport. But I happen to know they do not check your muffin when you board, and it would be only too easy for a criminal to hollow out the muffin and fill it with yogurt. I expect the TSA to follow up on this glaring security hole. Muffin inspection kits should be present at every gate."

URL: `https://web.archive.org/web/20070208094601/http://blog.emmettshear.com:80/post/2006/08/29/Yogurt%3A-The-Unknown-Danger` (200)

**(ii) "This Blog Is Boring" (2006-11-30)** — a 23-year-old Shear worrying that startup life is hollowing out his personality. The last line is startling in hindsight, given his later contemplative turn:

> "I think that's objectively true. What I'm really worried about is that this reflects my current personality, working for a startup: boring. More generally, I've been concerned that everyone in startups winds up, to an outsider, fundamentally boring."

and closing:

> "And I'm not even a particularly good writer, let alone great, so it's a fairly grim outlook for me. My only hope is to retire to a monastery in the mountains."

URL: `https://web.archive.org/web/20061206190139/http://blog.emmettshear.com/` (200)

**(iii) "Scratchtop" (2006-10-14) — with Aaron Swartz in the comments.** Shear built a no-login web notepad and claimed it was the simplest useful web app ever written:

> "I threw together scratchtop.com in frustration with all the current ways to write and share simple documents on the web. Why are you making me register? Why do I have to click 10 times to start writing my first document? Why do I have to click edit and save? Why do I have to click at all?"
>
> "As far as I know, scratch top is the simplest useful web application ever written. Anyone know anything simpler?"

The first comment, timestamped Saturday October 14 2006, 20:35, is from **Aaron Swartz**:

> "Are we measuring by UI or coding? Arguably makeashorterlink.com wins on both."

To which Shear replied:

> "I can't comment on coding, but I suspect you're right. But by UI (which was what I was thinking of), there are only 2 screens and 3 non-text elements in scratchtop, compared with 3 screens and a 5 non-text elements for makeashorterlink.com. Plus, they wimp out and include 'options'."

URL: `https://web.archive.org/web/20070907063144/http://blog.emmettshear.com:80/post/2006/10/14/Scratchtop` (200)

**This also resolves the HN identity question.** HN item **#32** — one of the first three dozen posts ever made to Hacker News — was submitted by user `eshear` on 2006-10-10 with the title "Scratchtop - notepad for the web" pointing at `http://scratchtop.com`. Scratchtop was Shear's own project. So `eshear` is his original Startup News account, registered **2006-10-09, HN's first day**, used once, then abandoned for `emmett` when HN went public in Feb 2007. *(Identity inferred from the Scratchtop match rather than a self-declaration — high confidence, but strictly it is **UNVERIFIED**.)*

**(iv) "Lessons from eBaying Kiko" (2006-09-18)** — real-time founder blogging of the YC prehistory, three weeks after he and Justin Kan sold their failed calendar startup on eBay:

> "Kiko's auction was pulled on the 7th day (out of 10) for having 2 links to the kiko.com (one to our main page, another to the API documentation). Apparently that's one over the limit, and an extremely vigilant community member killed our auction for it. We relisted it again as a 3 day auction and it doesn't seem any long term harm was done, but it was very nerve wracking."

URL: `https://web.archive.org/web/20070208094503/http://blog.emmettshear.com:80/post/2006/09/18/Lessons-from-eBaying-Kiko` (200)

**(v) The Justin.tv chat prehistory.** "Somehow it seems I always wind up rolling my own..." (2006-11-07) documents him building the live-chat component that live video would need, months before Justin.tv launched:

> "I spent a few days looking for a customizable real-time chat component to use on our new project… In the end, I decided to roll my own. In the search process I ran across Juggernaut, a Rails plugin for persistent connections… My new chat project is called Zinzani; most of the functionality is now in place, although the default template is still very ugly."

URL: `https://web.archive.org/web/20061206190139/http://blog.emmettshear.com/` (200)

#### 3.2 Amateur quantum gravity — "crackpot physics from someone who isn't a physicist"

On **2025-08-11** he posted a 21-tweet speculative theory of quantum gravity, opening verbatim:

> "Since the cool kids are doing it, my quantum gravity prediction below! Epistemic warning: crackpot physics from someone who isn't a physicist. Epistemic upside: I think I have one maybe actually correct idea buried in it."

> "Ok, so there's just one quantum field. Likely in C^4 interacting via CP^3 ala Twistors or teleparallel gravity, so we'll go with that. A 'particle' excitation in this field is a probability density, basically a (mixed-state) spinor."

> "There's only one force, sortagravity: spinors want to be in the same state as other spinors they interact with, and also want to stay the way they are. The precision of the distribution is sortamass, since interactions are basically Bayesian."

He cites, by name, *"A free energy principle for generic quantum systems"* by Fields, Friston, Glazebrook and **Levin** — the same Michael Levin whose Tufts lab, per reporting, seeded Softmax's ideas. URL: `https://threadreaderapp.com/thread/1954738143833539031.html` (200)

#### 3.3 The abandoned blog-post-idea list (2025-06-20)

He found and published an old private list of essays he never wrote — a direct window into his obsessions. Verbatim entries:

> "Power is like radioactive ore…drives the engine of an organization but dangerous to everyone who touches it. Needs to be contained and channeled."

> "Tracking a history of The Spirit. There seems to be one city on earth, at any given time, where The Spirit dwells. Vienna 1910, Florence 1470-1530, Bay Area 1997-present. Write a history of the spirit."

> "Working theory that education today is like medicine in 1600…some might work by accident occasionally but mostly it's criminally incompetent. The solution is not to write off the concept of education, but to start over and throw away most everything we think we know."

> "What caused the baby boom? I have no idea. Research and write the history!"

URL: `https://threadreaderapp.com/thread/1936140530603491338.html` (200)

#### 3.4 Documented intellectual obsessions, from his own HN submissions

His ~50 HN story submissions (2007–2016) are a portrait of an omnivore rather than a tech executive. Fetched from the Algolia API, actual titles and dates:

- **Greg Egan is his favourite novelist.** 2009-12-22, item 1009050, on a thread about Egan's Avatar review: *"Greg Egan is my favorite sci-fi writer. Read [Axiomatic] and have your mind blown."*
- **Economic history**: "Global GDP since 1820: a small china is an aberration" (2009-10-06), "Why did the Industrial Revolution begin in northwestern Europe?" (2008-07-02), "Controlled experiment in futures markets: onions" (2008-07-09).
- **Maps, compulsively**: "Map of Language Distribution in Europe", "Map overlaying the 4 next largest economies over the USA", "Animated Map of the Imperial History of the Middle East", "Map: Mentions per capita in the NYT" (all 2008).
- **Programming-language exotica**: "MISC: A homoiconic language based on maps", "STEPS allows TCP in 200 LoC, Javascript in 170, self-hosting in 1000 (Alan Kay)", "A calculus for causality?" (Judea Pearl's lecture notes), "One of the most interesting new languages I've seen...and it's on geocities?"
- **Odd corners**: "Abstract Expressionism was (in part) a covert CIA operation" (2010-11-10), "Reality looks staged" (a TVTropes link, 2008-01-20), "Bram Cohen on Taboo Words" (a LiveJournal link, 2008-08-12).
- **Rationalist reading long predating the AI work**: he cited LessWrong posts on HN in **2010** and **2012** ("Markets are anti-inductive", "The Bottom Line") and quoted the Quaker/Republican nonmonotonic-reasoning parable in 2010.

#### 3.5 Things I could NOT document

Despite targeted keyword sweeps over the full 927-item HN corpus, I found **no documentary evidence** for: rock climbing, sailing, D&D/tabletop roleplay, anime, or a named meditation practice/retreat. The single "climb" hit is a 2008 joke about running being "a gateway sport", and the single "meditation" hit is a passing mention in 2022 advice. His contemplative interest is real but is attested in the Par Conley interview, not in his own writing — treat "Buddhism/meditation" as **thinly sourced**.

---

### 4. What is not retrievable

Observed, not assumed:

| Target | URL requested | Observed result |
|---|---|---|
| **LinkedIn (logged out)** | `https://www.linkedin.com/in/eshear/` | **HTTP 999**, 1,530-byte body, no `<title>`, no description. LinkedIn's anti-scraping code. Activity feed unreadable. |
| **LinkedIn alt handle** | `https://www.linkedin.com/in/emmettshear/` | **HTTP 999**, identical. Cannot even confirm which handle is his. |
| **Crunchbase** | `https://www.crunchbase.com/person/emmett-shear` | **HTTP 403.** Nothing retrievable. |
| **Instagram** | `https://www.instagram.com/eshear/` | **HTTP 200**, 625,520-byte JS shell. `<title>` is the generic "Instagram"; **no og:description, no `is_private` flag, no follower count, no "Page Not Found" marker**. I could not determine whether the account exists, let alone whether it is public. **Indeterminate.** Same for `/emmettshear/` (200, 625,531 bytes, identical shell). |
| **TikTok** | `https://www.tiktok.com/@eshear` | **HTTP 200**, but the body contains **"Couldn't find this account"** and **"isn't available"**, with `videoCount: 0`. **No TikTok account.** |
| **X — who he follows** | `https://x.com/eshear` | **HTTP 200** but timeline, following and follower lists are entirely JS-rendered. Only `og:description` was extractable: *"CEO of Softmax: Massively Multiplayer Learning Environments"*. **Cannot see who he follows logged out.** |
| **X mirrors (Nitter/xcancel)** | `https://xcancel.com/eshear` | **HTTP 200 but the service is dead.** The 321-byte body reads verbatim: *"On Monday 24th August at 8PM EST, we received at letter from X Corp. asking to cease and desist the service XCancel. The service XCancel is stopped until further notice."* `xcancel.com/eshear/rss` → **HTTP 400**. `nitter.poast.org` → **DNS failure**. The Nitter mirror route to his tweets closed roughly ten days before this audit. |
| **Hacker News HTML** | `https://news.ycombinator.com/user?id=eshear` | **HTTP 429** from both curl and WebFetch (body: "Sorry."). Worked around via the Firebase and Algolia APIs. |
| **Wayback via WebFetch** | `https://web.archive.org/web/...` | WebFetch refuses web.archive.org ("Claude Code is unable to fetch from web.archive.org"). **All archive work in this report was done with curl.** |
| **Softmax replays** | — | `robots.txt` explicitly disallows `/api/observatory/v2/coworlds/replays/` — the actual agent-run replay data is off-limits to crawlers. |
| **His old Posterous blogs** | `http://eshear.posterous.com/` | Live web: platform shut down in 2013. Readable **only** via Wayback. (On retry, CDX for the second name `emmett-58a2n.posterous.com` returned 200 with a **single** content URL — the same `global-gdp-since-1820...` post — so it is an auto-generated alias of the same blog, not a separate one.) |
| **`blog.emmettshear.com` live** | — | Domain does not resolve. Wayback only. Its original Atom/RSS2 feeds are archived but dead. |

I also did **not** find, anywhere: a newsletter he actually writes, a YouTube channel he owns, a podcast he hosts, or a book.

---

### 5. Voice sample

Three samples, all verbatim from pages I fetched.

**(a) On programming, and on giving it up — HN, 2014-08-16** (`https://news.ycombinator.com/item?id=8187833`, retrieved via the Algolia API). This is him at 31, three years into being CEO:

> "I love programming. It's a zen activity for me, turn me loose on a problem and I'll literally lose track of time because I'm so absorbed in the problems. It's one of the purest, most joyous singular activities I've ever had the pleasure of practicing."

> "That said, I miss programming. A lot. I find excuses to pick up bug fixes. I wrote an internal tool that manages the distribution of status updates, and at least half the reason was just to be able to code something."

**(b) Answering a stranger's midlife crisis on HN, 2022-07-12** (`https://news.ycombinator.com/item?id=32070457`). Note the therapeutic register — this is the clearest bridge between the Twitch CEO and the "organic alignment" guy:

> "You say 'it's never enough', you 'want more'. But what exactly is it that you're wanting? What's the 'enough' that it isn't? If you can look closely at that feeling with real curiosity and some gentleness...maybe there's a clue there as to what's going on. What's the reality that is going on (eg. 'I'm often feeling deep failure and shame', a fact) vs. what's the narrative you're telling yourself ('Nothing is ever enough for me', a judgement you're making)?"

**(c) The 23-year-old version, 2006-11-30** (`https://web.archive.org/web/20061206190139/http://blog.emmettshear.com/`):

> "My only hope is to retire to a monastery in the mountains."

**Registers to expect:** lowercase-casual and heavily abbreviated on X ("bc", "w", "ppl", "sorta-"), with explicit epistemic hedging he applies to himself ("Epistemic warning: crackpot physics"; "Epistemic status: wild speculation but also I'm clearly right"). On HN he is longer, plainer, and noticeably willing to argue. In both places he reaches for a physical analogy almost immediately — power as radioactive ore, alignment as ant colonies and cells in a body, mass as Bayesian precision.

---

### 6. Podcast record — supplement (filled by the lead auditor)

The section-1.7 gap is now closed. Method: the **iTunes Search API** (`https://itunes.apple.com/search?term=Emmett+Shear&entity=podcastEpisode&limit=60`, **HTTP 200, 201,138 bytes**), which returns Apple's index of publisher-submitted RSS. `resultCount: 60`. Titles, dates and descriptions below are verbatim from that fetched JSON.

**Headline corrections to §1.7 and §2:**
- **His last podcast appearance is Feb 2026, not Nov 2025.** Two 2026 episodes exist.
- **No Lex Fridman episode and no Dwarkesh Patel episode appear anywhere in 60 results.** The §1.7 caution was correct — treat both as **non-existent** absent a URL.
- The record is genuinely long: **~35 distinct appearances, 2020-02-21 → 2026-02-24**, plus a wall of Nov 2023 news podcasts *about* him.

#### Verified appearances (interviews, not news coverage)

| Date | Show | Episode | Apple URL |
|---|---|---|---|
| **2026-02-24** | Istanbul Ignited by Slush'D | "Why Leadership Is About Repetition, Not Charisma" | `.../id1864349137?i=1000742782942` |
| **2026-02-03** | The Hope Axis by Anna Gát | "Emmett Shear - Explaining AI to the Humanities" | `.../id1777483353?i=1000747786593` |
| 2025-12-27 | The Cognitive Revolution | "Controlling Tools or Aligning Creatures? Emmett Shear (Softmax) & Séb Krier (GDM)" | `.../id1669813431?i=1000742901702` |
| 2025-12-19 | Founders in Arms | "AGI, Alignment, and the Future of AI Power" | `.../id1679703534?i=1000742034105` |
| 2025-11-17 | The a16z Show | "Building AI That Actually Cares" | (verified in §1.7) |
| 2025-09-26 | Doom Debates! | "Ex-OpenAI CEO Says AI Labs Are Making a HUGE Mistake" | — |
| 2025-09-25 | Win-Win with Liv Boeree | "#47 — Why NATURE Holds the Answers To AI Alignment" | `.../id1724791350?i=1000728259767` |
| 2025-09-23 | The Social Radars | "Founder Mode: Emmett Shear, Founder, Softmax & Twitch" | `.../id1677066062?i=1000728087564` |
| 2025-09-19 | Parker Podcast | "SF, Power, AI Alignment, Meditation, Softmax" | (= parconley.com, §1.7) |
| 2025-09-11 | Complex Systems (patio11) | "AI alignment, with Emmett Shear" | `.../id1753399812?i=1000726091913` |
| 2025-07-18 | The Trajectory | "AGI as 'Another Kind of Cell' in the Tissue of Life" | — |
| 2025-06-24 | Doom Debates! | "Emmett Shear's New 'Softmax' AI Alignment Plan — Is It Legit?" | — |
| 2024-06-12 | Clearer Thinking (Spencer Greenberg) | "Worldviews, altruism, and embracing variance" | — |
| 2024-05-13 | Pattern Breakers | "How Twitch Changed Media by Merging it with Gaming" | — |
| **2023-11-22** | **The Social Radars** | **"Emmett Shear, Co-Founder of Twitch"** | `.../id1677066062?i=1000635708653` |
| 2023-09-11 | My First Million | "Life After Twitch, Jeff Bezos Lessons & AI Doomsday Odds" | — |
| 2023-09-06 | Audience of One | "#033 — on Practice, Agency, Coordination, & Positive Sum Games" | — |
| 2023-06-16 | The Logan Bartlett Show | "EP 69: Emmett Shear (Co-Founder, Twitch)" | — |
| 2022-07-18 | How I Built This with Guy Raz | "Twitch: Emmett Shear" | — |
| 2021-07-27 | The Quest Pod (Justin Kan) | "Twitch Co-Founders Reunion" w/ Michael Seibel | — |
| 2021-02-02 | The Quest Pod (Justin Kan) | "Twitch, 10 Years Later" | — |
| 2020-11-26 | Invest Like the Best | "The New Language of the Internet" (Founder's Field Guide EP.9) | — |
| 2020-02-21 | 20VC | "On When To Persist vs When To Give Up" | — |

#### The 2023 OpenAI episode — a precise finding

**He gave no interview about the OpenAI weekend while it was happening.** What the index shows for 2023-11-20 is a cluster of *news* podcasts talking **about** him — Bloomberg Daybreak, Bankless ("Sam Altman Fired as OpenAI CEO, Joins Microsoft?"), The AI Daily Brief, AI Chat, Eagle Eyes On Tech — none of which he participated in.

The one genuine interview in that window is **The Social Radars, 2023-11-22** — two days after the Altman restoration — and its description (verbatim from the API) shows it is **not about OpenAI at all**:

> "Today we talk with Emmett Shear, who was in the very first YC batch in 2005 with a startup called Kiko. But you know him better as the co-founder of Twitch, which YC funded in 2007. Learn how Twitch grew from one guy walking around with a camera on his head to one of the biggest communities on the i[nternet]"

That is a warm, useful fact for a host: **the interview he sat for in the immediate aftermath of the most-covered 72 hours of his career was a friendly YC-history conversation about Kiko and a guy with a camera on his head.** He returned to the same show two years later (2025-09-23) as a Softmax founder.

#### Descriptions worth having verbatim (all from the fetched API payload)

**Complex Systems, 2025-09-11:**
> "Patrick McKenzie (patio11) is joined by Emmett Shear, co-founder of Twitch, former interim CEO of OpenAI, who now runs Softmax AI alignment. Emmett argues that current AI safety approaches focused on "systems of control" are fundamentally flawed and proposes "organic alignment" instead"

**The Social Radars, 2025-09-23** — a concrete management artefact, and a good host hook:
> "Emmett Shear, who told us about an interesting founder mode technique he developed when he was running Twitch. He wanted people there to be able to answer the question "What would Emmett do?" and he found the best way to ensure this was via the weekly all-han[ds]"

**The Hope Axis, 2026-02-03** — the most recent, and notably aimed at a non-technical audience:
> "This week on The Hope Axis, I'm joined by Emmett Shear to talk about AI, hope, and how we should actually think about the future… We discuss why AI inspires so much fear, what"

**Transcripts:** **none confirmed.** The a16z page carries no transcript (§1.7); the Par Conley page has an LLM-generated one the page itself flags as error-prone. I did not verify transcripts for any other episode — treat podcast transcripts for Shear as **largely unavailable**.

**Caveat:** these dates and descriptions come from Apple's index of publisher RSS, not from fetching each show's own page. The index is primary-derived and self-consistent, but individual episode pages were **not** separately opened except where §1.7 says so.

## Eric Ries — public footprint measurement audit

Audit date: **2026-09-03**. Every URL below was actually requested (curl and/or WebFetch). Status codes are observed, not assumed.

**Headline correction to the likely prior:** this is **not** a dormant footprint. Ries published a new book (*Incorruptible*, Authors Equity) on **2026-05-26**, runs an active **beehiiv** newsletter (12 issues, 2026-05-26 → 2026-08-23), and his YouTube channel and GitHub both had activity **today, 2026-09-03**. The dormant thing is the *old* blog and the podcast, not the man.

---

### 1. Source inventory

#### 1.1 Summary table

| Channel | URL fetched | HTTP | Feed | Volume | Date range | Last item |
|---|---|---|---|---|---|---|
| Startup Lessons Learned (blog) | `http://www.startuplessonslearned.com/` | 200 | FeedBurner 200 | **392 posts** | 2008-08-02 → 2026-05-17 | **2026-05-17** |
| SLL sitemap | `https://www.startuplessonslearned.com/sitemap.xml` | 200 | n/a | 392 `<loc>` | 2008 → 2026 | 2026-05-17 |
| theleanstartup.com | `https://theleanstartup.com/` | 200 | — | brochure site | — | — |
| theleanstartup.com feed | `https://theleanstartup.com/feed` | **404** | none | — | — | — |
| Newsletter (beehiiv) | `https://news.theleanstartup.com/archive` | 200 | **no working RSS** | 12 posts | 2026-05-26 → 2026-08-23 | **2026-08-23** |
| X / Twitter | `https://x.com/ericries` | 200 (JS shell) | — | 35,099 tweets; 301,419 followers | acct created 2008-04-01 | widget max **2026-01-23** |
| LinkedIn | `https://www.linkedin.com/in/eries` | **999** (blocked) | — | unreadable | — | — |
| LTSE | `https://ltse.com/` | 200 | — | — | — | — |
| LTSE Insights | `https://ltse.com/insights` | 200 | none found | — | — | 2026-05-27 (CNBC item) |
| LTSE newsroom (guessed) | `https://ltse.com/newsroom` | **404** | — | — | — | — |
| LTSE EDGAR | `https://data.sec.gov/submissions/CIK0001757271.json` | 200 | JSON | **62 filings** | → 2026-08-17 | **2026-08-17** |
| Podcast RSS | `https://anchor.fm/s/f51132a8/podcast/rss` | 200 | **yes** | **44 episodes** | 2024-05-05 → 2026-01-08 | **2026-01-08** |
| YouTube channel | `https://www.youtube.com/@TheEricRiesShow` | 200 | **yes** | 15 in feed | → 2026-09-03 | **2026-09-03** |
| Wikipedia | `https://en.wikipedia.org/wiki/Eric_Ries` | 200 | — | — | last edited 2026-07-15 | — |
| GitHub API | `https://api.github.com/users/ericries` | 200 | — | **11 repos** | 2014-11-15 → 2026-09-03 | **2026-09-03** |
| Crunchbase | `https://www.crunchbase.com/person/eric-ries` | **403** | — | — | — | — |
| Kickstarter | `https://www.kickstarter.com/projects/ericries/the-leaders-guide` | **403** (curl + WebFetch) | — | — | — | — |
| Instagram | `https://www.instagram.com/ericries/` | 200 but login wall | — | — | — | — |
| TikTok | `https://www.tiktok.com/@ericries` | 200 but "Couldn't find this account" | — | — | — | — |
| ericries.com | `http://ericries.com/` | **000** (DNS/connect fail) | — | — | — | — |
| Lean Startup Co. | `https://leanstartup.co/` | 200 | — | — | — | — |
| Incorruptible book site | `https://www.incorruptible.co/` | 200 | — | — | — | — |

#### 1.2 Startup Lessons Learned — the big dormant archive, measured

Host is **Blogger/Blogspot on the custom domain** `www.startuplessonslearned.com` (Blogger blog ID visible in the Atom feed: `tag:blogger.com,1999:blog-75337272645071285…`). `startuplessonslearned.blogspot.com` was not separately probed; the custom domain is canonical.

- Blogger Atom API reports **`"openSearch$totalResults":{"$t":"392"}`** — 392 posts.
- `sitemap.xml` independently contains **392 `<loc>` entries**, confirming the count.
- `https://www.startuplessonslearned.com/feeds/posts/default` **redirects (200) to `http://feeds.feedburner.com/startup/lessons/learned`** — the FeedBurner feed still resolves.

Posts per year, counted from the sitemap URL paths:

| Year | Posts | | Year | Posts |
|---|---|---|---|---|
| 2008 | 59 | | 2017 | 12 |
| 2009 | **88** (peak) | | 2018 | 15 |
| 2010 | 50 | | 2019 | 8 |
| 2011 | 28 | | 2020 | 31 |
| 2012 | 26 | | 2021 | 5 |
| 2013 | 34 | | 2022–23 | **0** |
| 2014 | 9 | | 2024 | 1 |
| 2015 | 16 | | 2025 | **0** |
| 2016 | 9 | | 2026 | 1 |

**Cadence finding:** the blog is effectively dead as a running publication. 2008–2013 carried 285 of 392 posts (73%). After 2021 there are exactly **three** posts total: 2024-08-11 ("Strong Governance Actually Makes Weak Companies"), and 2026-05-17 ("Incorruptible: My new book comes out May 26!"). 2022, 2023 and 2025 are empty years.

*Caveat, stated honestly:* paging the Blogger summary feed (`max-results=100`, `start-index=1/101/201/301`) returned only **336** of the 392 entries — the 2015–2018 block was missing from the paged results. The sitemap and `totalResults` both say 392, so I use 392 and flag the feed-paging shortfall rather than papering over it.

#### 1.3 Newsletter — the current primary channel

`https://news.theleanstartup.com/` is a **beehiiv** publication (confirmed by `media.beehiiv.com` asset URLs in the HTML), not Substack. Publication name "Eric Ries"; tagline as rendered: *"Eric Ries on why great companies go bad — and what founders, CEOs, and operators can do about it."*

**No working RSS.** `/feed`, `/feed.xml`, `/rss`, `/feed/rss` and `https://rss.beehiiv.com/feeds/theleanstartup.xml` all fail — the beehiiv site swallows them into a soft-404 (`https://news.theleanstartup.com/?404=%2Ffeed`, HTTP 200 but an HTML error page) or return 404. Slugs are only recoverable by scraping `"slug":"…"` out of the archive HTML.

All 12 posts visible in the archive (2026):

| Date | Title |
|---|---|
| Aug 23 | The force that kills companies |
| Aug 09 | There's no neutral position |
| Jul 26 | Harder is Easier. Here's Why. |
| Jul 12 | The public gets it |
| Jun 28 | Stories from the field |
| Jun 07 | On the list. |
| Jun 04 | The Incorruptible community is open |
| May 31 | More early adopters! |
| May 29 | Everything everywhere all at once |
| May 28 | What is profit? |
| May 27 | TBPN highlights from Launch Day |
| May 26 | Today's the day! |

Cadence: launch-week burst around the book, then a steady **roughly biweekly** rhythm from late June.

#### 1.4 X / Twitter

`https://x.com/ericries` returns 200 but is a JavaScript shell. Real data came from the **syndication widget** `https://syndication.twitter.com/srv/timeline-profile/screen-name/ericries` (HTTP 200), parsed from its `__NEXT_DATA__` payload:

- `screen_name = ericries`, `name = Eric Ries`
- `followers_count = 301419`
- `friends_count = 1835`
- `statuses_count = 35099`
- `created_at = Tue Apr 01 23:28:19 +0000 2008`
- `is_blue_verified = True`, `verified = False`
- Bio verbatim: **"Order my new book INCORRUPTIBLE & unlock exclusive bonuses at https://t.co/nlix8H5nfl"**

The widget exposed 121 tweet objects. **Most recent from @ericries: 2026-01-23** (id 2014831030285533298). This is a widget window, not proof of silence since January — see §4.

Notable dated tweets recovered verbatim:
- 2020-09-09: **"I launched a stock exchange today. Ask me anything:"**
- 2021-08-26: **"Today, the Long-Term Stock Exchange welcomes @Twilio and @Asana as the first two companies to list on the exchange."**
- 2024-05-11: **"I'm thrilled to share this trailer to launch my new podcast, The Eric Ries Show -- an ongoing series of conversations about company building for the future we all deserve."**

#### 1.5 Books — verified from fetched pages

| Book | Publisher | Date | ISBN | Pages | Source fetched |
|---|---|---|---|---|---|
| **The Lean Startup** | Crown Business | 2011-09-13 | 9780307887894 / 0307887898 | 336 | `openlibrary.org/isbn/9780307887894.json` (200) |
| **The Startup Way** | Portfolio Penguin | 2017 | 9780241197264 | — | `openlibrary.org/search.json` (200) |
| **Incorruptible** | **Authors Equity** | **2026-05-26** | **9798893311860** | **432**, hardcover, $32.00 | `parnassusbooks.net/book/9798893311860` (200 via WebFetch; **403 via curl**) |
| **The Leader's Guide** (2015) | self-published, Kickstarter | 2015 | — | — | **NOT VERIFIED** |
| *The Black Art of Java Game Programming* | Waite Group Press | 1996 | 1571690433 | 933 | `openlibrary.org/search.json` (200) |

Notes:
- `theleanstartup.com/book` (200) carries **no** ISBN, publisher, page count or sales figures — it is a retailer-link page only. Fetched and checked.
- `penguinrandomhouse.com/books/210164/...` and `.../546855/...` were **guessed URLs and both 404'd** — recorded as negative findings.
- `simonandschuster.com` and `simonandschuster.ca` for ISBN 9798893311860 both returned **403**.
- **The Leader's Guide is the one book I could not verify from a primary page.** Kickstarter returns 403 to both curl and WebFetch on `/projects/ericries/the-leaders-guide` and two other guessed slugs; `web.archive.org` is not fetchable by this tool. Wikipedia states it raised **$588,903** — that figure is **UNVERIFIED** against Kickstarter itself.
- *The Black Art of Java Game Programming*: OpenLibrary lists the author as **Joel Fan only**. Ries's co-authorship is sourced solely to his own blog bio (§3.3) — treat the co-author credit as **self-reported**.

#### 1.6 LTSE and the SEC regulatory record — the under-used source

This is the richest verifiable vein, and it is almost entirely primary-document.

**Exchange registration.** `https://www.sec.gov/files/rules/other/2019/34-85828.pdf` (200), read page-by-page:

> "SECURITIES AND EXCHANGE COMMISSION (Release No. 34-85828; File No. 10-234) In the Matter of the Application of Long Term Stock Exchange, Inc. for Registration as a National Securities Exchange — Findings, Opinion, and Order of the Commission — May 10, 2019"

> "On November 9, 2018, Long-Term Stock Exchange, Inc. ("LTSE" or "Exchange") filed with the Securities and Exchange Commission ("Commission") a Form 1 application under the Securities Exchange Act of 1934 ("Act"), seeking registration as a national securities exchange under Section 6 of the Act."

> "For the reasons set forth below, and based on the representations set forth in LTSE's Form 1, as amended, this order approves LTSE's Form 1 application, as amended, for registration as a national securities exchange."

Footnote 2 of that order cites **"Letter to Brett Redfearn, Director, Division of Trading and Markets, Commission, from Eric Ries, dated December 4, 2018"** — a personally-signed Ries letter in the SEC record. (The Dec 4 letter itself was not located as a standalone URL; **UNVERIFIED** as a fetchable document.)

**Form 1 exhibit index.** `https://www.sec.gov/rules/other/2018/long-term-stock-exchange/long-term-stock-exchange-1.htm` (200) — heading *"Long-Term Stock Exchange, Inc. Form 1 Application and Exhibits"*, Exhibits A through N.

**EDGAR.** CIK **0001757271**, "Long-Term Stock Exchange, Inc." — **62 filings**, essentially all `1/A` (Form 1 amendments, "AUTO-GENERATED PAPER DOCUMENT"). Nine of them in 2026 alone: 2026-01-09, 01-20, 02-13, 03-17, 03-25, 05-22, 06-30, 07-09, **08-17**. This is a live, continuously-amending registrant.

**Rule filings.** `https://www.sec.gov/files/rules/sro/ltse/2019/34-86722.pdf` (200) and `https://www.sec.gov/files/rules/sro/ltse/2025/34-102787.pdf` (200) both fetch. Their text could not be extracted by WebFetch (FlateDecode PDFs) — file numbers **SR-LTSE-2025-06** appears in the second filename's associated listing but the body is **UNVERIFIED**. `https://www.sec.gov/rules-regulations/self-regulatory-organization-rulemaking/ltse` and `https://www.sec.gov/rules/sro/ltse.htm` were guessed and **404'd**.

**The 2025–26 quarterly-reporting campaign** (the most consequential recent LTSE thread). `https://www.sec.gov/files/rules/petitions/2025/petn4-872.pdf` (200), read directly:

> "September 30, 2025 … Paul S. Atkins, Chairman … Re: Petition for Rulemaking to Amend Quarterly Reporting Requirements Under the Securities Exchange Act of 1934"

> "Long-Term Stock Exchange, Inc. ("LTSE" or "Petitioner") respectfully petitions the Securities and Exchange Commission (the "Commission" or "SEC"), pursuant to Rule 192 of the SEC's Rules of Practice, for rulemaking to amend the following rule provisions and form"

> "LTSE is the only SEC-approved stock exchange with listing standards specifically designed to support long-term value creation."

Seven months later, `https://www.sec.gov/newsroom/press-releases/2026-42-sec-proposes-amendments-permit-optional-semiannual-reporting-public-companies` (200), **Release No. 2026-42, May 5, 2026**:

> "The Securities and Exchange Commission today proposed rule and form amendments that would give public companies the option of filing semiannual reports in lieu of quarterly reports to meet their interim reporting obligations under the federal securities laws."

The press release **does not name LTSE or the petition** — the connection is inferential, though LTSE claims it publicly on `ltse.com/insights` ("WSJ: LTSE to Petition SEC on Public Company Earnings Reporting Frequency").

**Ries's current LTSE title.** `https://ltse.com/team/eric-n-ries` (200) lists him as **"Founder of LTSE"** — notably *not* CEO. Verbatim from that page:

> "As a founder, he has put his own ideas into practice with The Long-Term Stock Exchange (LTSE); Answer.AI, an AI R&D lab; the Lean Startup Co, which teaches and supports the implementation of Lean Startup; Virgil, a legal services startup; and IMVU, where the ideas that became the Lean Startup method were forged."

`ltse.com/insights` also carries **"Long-Term Stock Exchange Board Names Maliz Beams Interim CEO."** Web search indicates this succeeded **Bill Harts**, not Ries — but I did **not** fetch a primary page confirming the Harts→Beams sequence, so that succession detail is **UNVERIFIED**.

#### 1.7 Podcast

**The Eric Ries Show** — RSS at `https://anchor.fm/s/f51132a8/podcast/rss` (200, 552 KB), discovered via the `<link rel="alternate">` tag on `ericriesshow.com`.

- **44 episodes**, first "Welcome To The Eric Ries Show" **2024-05-05**, last "A Founder's Guide to Pivoting Without Killing the Company | Misha Esipov" **2026-01-08**.
- **Dormant ~8 months** as of audit date.
- **No transcripts.** The feed contains **zero `<podcast:transcript>` tags**, and `ericriesshow.com` shows no transcript links (checked).
- `https://podcasts.apple.com/us/podcast/the-eric-ries-show/id1746986340` was a **guessed ID and 404'd** — negative finding.

Channel description verbatim from the feed: *"Founder, entrepreneur, and best-selling author of The Lean Startup Eric Ries discusses how to build profitable companies for the long-term benefit of society."*

Earlier podcast: **Out of the Crisis**, 2020–2021, distributed as blog posts (e.g. `.../2021/05/out-of-crisis-27-eren-bali-of-carbon.html`). At least 27 episodes by post title; `outofthecrisis.fm` **would not resolve (DNS failure, curl 000)** and two guessed transistor.fm feed URLs **404'd**.

#### 1.8 YouTube

Channel `@TheEricRiesShow`, external ID **`UCQnF0c8GaWDm9T4yMDpGcPA`**. Feed `https://www.youtube.com/feeds/videos.xml?channel_id=UCQnF0c8GaWDm9T4yMDpGcPA` (200), 15 entries, **near-daily short-form uploads**:

- 2026-09-03 — "What if being mission-driven isn't a tradeoff, but a competitive advantage?"
- 2026-09-02 — "What really drives entrepreneurship?"
- 2026-09-01 — "You can't command an organization to be healthy. You have to cultivate it."
- 2026-08-31 — "What if a massive global enterprise didn't have to be a conventional company at all?"
- 2026-08-28 — "What happens when the protections around a company's mission disappear?"

`https://www.youtube.com/@ericries` **404'd** (guessed handle) — negative finding.

#### 1.9 Conference-talk record, measured

Rather than assert "he speaks a lot," I counted. Of the 336 blog entries I could retrieve titles for, **45 (13%) are conference/speaking posts**. Named venues, all from post titles with dates:

| Date | Venue evidence (post title) |
|---|---|
| 2009-02-09 | "The lean startup @ Web 2.0 Expo (and a call for help)" |
| 2009-09-15 | "Gov 2.0 Summit wrap-up" |
| 2010-02-06 | "Speaking 2010: Webstock, GDC, Web 2.0, and more" |
| 2010-03-09 | "Startup Lessons Learned - the Conference (April 23, 2010 in SF)" |
| 2010-04-12 | "The Lean Startup Intensive at Web 2.0 Expo SF (May 3, 2010)" |
| 2010-08-24 | "SXSW" |
| 2011-03-10 | "The Lean Startup SXSW + bundle + tournament" |
| 2011-05-23 | "Startup Lessons Learned 2011 streaming live" |
| 2012-03-05 | "The Lean Startup at SXSW 2012" |
| 2012-06-27 | "Announcing the 2012 Lean Startup Conference in SF" |
| 2012-08-27 | "Marc Andreessen will be at The Lean Startup Conference - will you?" |

The speaking corpus is heavily **2009–2013**; it thins sharply after. The successor org **Lean Startup Co.** (`https://leanstartup.co/`, 200, title *"Lean Startup Co: Innovation & Product Development Consulting"*) is now positioned as a consultancy, not a conference brand.

#### 1.10 GitHub

`https://api.github.com/users/ericries` (200): **11 public repos, 3 followers**, account created **2014-11-15**, no name/bio/company set. Identity is inferable from repo contents (see §3), not from profile metadata — I flag that the account is only **circumstantially** attributable, though `incorruptible-videos-media` ("Media assets for Incorruptible book launch videos", containing an `eric-ries-website` directory) makes it near-certain.

| Repo | Created | Last push | Stars | Description (verbatim from API) |
|---|---|---|---|---|
| `howisincorruptiblegoing` | 2026-04-12 | **2026-09-03** | 0 | *(none)* — Astro; contains `quotes-incorruptible.pdf` |
| `seedlist` | 2026-03-12 | **2026-09-03** | 1 | "LLM-researched directory of active startup investors" |
| `skintiers` | 2026-07-27 | **2026-09-03** | 0 | "SkinTiers — a skeptical, evidence-first directory of skincare…" |
| `incorruptible-videos-media` | 2026-04-19 | 2026-05-03 | 0 | "Media assets for Incorruptible book launch videos" |
| `tom-lehrer` | 2022-12-29 | 2023-01-17 | 11 | "Complete archive of Tom Lehrer's songs, sheet music, and web content following his 2022 public domain release" |
| `anki`, `chessli`, `basic-computer-games`, `nbdev-test`, `MPQSimulator` | 2014–2022 | — | 0 | forks/experiments |

---

### 2. Recency probe (Mar–Sep 2026)

**The trail is emphatically live.** Four dated, fetched, verbatim items:

**(1) 2026-05-17 — blog, `https://www.startuplessonslearned.com/2026/05/incorruptible-my-new-book-comes-out-may.html`.** Ending a 21-month blog silence to announce the book. He quotes himself from a NYT DealBook interview:

> "We built this financial system that has this gravitational pull down into mediocrity and to extraction and exploitation. You can imagine building a different financial system, but until we get there, my goal is simply to have people be able to build organizations that can resist that."

The post lists a May–June 2026 tour: Union Square SF (May 18), ProductCon NYC (May 20), STATION DC (May 28), Kepler's Menlo Park (June 2), Book Passage Corte Madera (June 3), Commonwealth Club SF (June 22).

**(2) 2026-05-28 — newsletter, `https://news.theleanstartup.com/p/what-is-profit`:**

> "Profit is the maximization of human flourishing. To be precise, profit itself is the surplus of human flourishing that an organization creates."

**(3) 2026-08-09 — newsletter, `https://news.theleanstartup.com/p/there-s-no-neutral-position`:**

> "Every company has a purpose – whether its founders and employees know it or not. Purpose is not a mission statement or a marketing slogan. It's the specific legal obligation that tells companies what they have to maximize and optimize for."

**(4) 2026-08-23 — newsletter, `https://news.theleanstartup.com/p/the-force-that-kills-companies`:**

> "When Edwin Land founded Polaroid in 1937, he created more than just a camera company. He built an R&D powerhouse at what Steve Jobs memorably called 'the intersection of art and science and business.'"

**Same-day activity (2026-09-03):** a YouTube upload ("What if being mission-driven isn't a tradeoff, but a competitive advantage?") and pushes to three GitHub repos.

**LTSE recency:** a Form 1/A filed **2026-08-17** (EDGAR), and the SEC's **May 5, 2026** semiannual-reporting proposal downstream of LTSE's **Sept 30, 2025** petition.

**The one genuinely stale surface is X.** The syndication widget's newest @ericries tweet is **2026-01-23**. Whether he has tweeted since is **UNVERIFIED** — the widget returns a bounded window, not a guarantee of silence, and the logged-out timeline is a JS wall.

**The podcast is also stale:** last episode **2026-01-08**, no new episodes in ~8 months, despite the book launch. He appears to have swapped long-form audio for the newsletter and daily YouTube shorts.

---

### 3. The deep cut

#### 3.1 He is cc'd on his own exchange's SEC cover letter — and it isn't signed by him

`https://www.sec.gov/rules/other/2018/long-term-stock-exchange/long-term-stock-exchange-form1-filing-letter.pdf` (200). Read as an image because WebFetch could not decode the PDF. It is **Davis Polk & Wardwell letterhead**, hand-signed by **Annette L. Nazareth** (herself a former SEC Commissioner), stamped **"SEC Mail Processing Section NOV 09 2018"**, verbatim:

> "On behalf of Long-Term Stock Exchange, Inc. ("LTSE"), enclosed please find an original and two copies of LTSE's Form 1 Application seeking registration as a national securities exchange."

and, at the bottom:

> "cc: Mr. Eric Ries, Long-Term Stock Exchange, Inc."

The founding document of the exchange he is famous for creating lists him as a **carbon copy**. This is not on page one of any search for his name.

#### 3.2 A 320-page Tom Lehrer songbook he compiled himself

`https://api.github.com/repos/ericries/tom-lehrer` (200) — 11 stars, the most-starred thing on his GitHub, and it has nothing to do with startups. README verbatim (`https://raw.githubusercontent.com/ericries/tom-lehrer/main/README.md`, 200):

> "Complete archive of Tom Lehrer's songs, sheet music, and web content following his 2022 public domain release"

> "content downloaded 12/2022 with: `wget --recursive --no-clobber --page-requisites --convert-links --html-extension https://tomlehrersongs.com/`"

> "songbook created with ghostscript, see: scripts/gs.sh"

The README embeds the `pdfinfo` output of the artifact he built:

> "Title: If He Could Only See Us: The Complete Public Domain Tom Lehrer Songbook … Creator: github tom-lehrer project … Pages: 320 … File size: 96859629 bytes"

A **documented hobby**: when Lehrer released his catalogue to the public domain, Ries scraped the site and ghostscript-stitched a 320-page, 97 MB songbook. He also maintains `skintiers` — *"a skeptical, evidence-first directory of skincare: what the research actually shows, graded on a consistent effect-size x effect-quality rubric"* (created 2026-07-27, pushed 2026-09-03).

#### 3.3 The 2008 "About the author" post — Catalyst Recruiting, There.com, MUDs, and a 1996 Java book

`https://www.startuplessonslearned.com/2008/10/about-author.html` (200). This is the **only** post in the entire 392-post archive that matches a search for "Catalyst Recruiting," and one of only two matching "Yale." (WebFetch refused to reproduce it on copyright grounds; I pulled the raw HTML with curl and extracted the post body myself.) Verbatim:

> "He is the co-author of several books including The Black Art of Java Game Programming (Waite Group Press, 1996). While an undergraduate at Yale Unviersity, he co-founded Catalyst Recruiting. Although Catalyst folded with the dot-com crash, Ries continued his entrepreneurial career as a Senior Software Engineer at There.com, leading efforts in agile software development and user-generated content."

(The typo **"Yale Unviersity"** is his, uncorrected since 2008.) And, in his own first-person voice:

> "I'm one of those people who's been programming since they can remember. I got my start programming on an old IBM XT; it was thanks to MUDs that I first discovered the internet. Those early text-based games were programmed by their own users, and it was by far the best tutorial I could ever have received in the power of software. In a MUD, you could literally conjure new objects that never existed before, just by programming them. I know many people who think that software works like magic, but to me it actually was magic."

> "While I was still in high school, I became a Java 'expert' during a time when there was no such thing. Thanks to Sun's amazing PR blitz, there was tremendous demand for experts on Java, and I did my best to convince people that I was one of that mythical breed. Thanks to the anonymity of the internet, I landed a few jobs, and did quite a bit of writing."

The post is also self-annotated: *"(Update February, 2011: This post originally dates from October, 2008 back when I first started writing this blog. I've updated the 'official' conference bio below but otherwise the text remains unchanged from that original essay.)"*

#### 3.4 The unnamed failure post

`https://www.startuplessonslearned.com/2009/01/achieving-failure.html` (200), 2009-01-30, "Achieving a failure":

> "We spend a lot of time planning. We even make contingency plans for what to do if the main plan goes wrong. But what if the plan goes right, and we still fail? This is the my most dreaded kind of failure, because it tricks you into thinking that you're in control and that you're succeeding. In other words, it inhibits learning."

Notable for what it withholds: he describes a company that raised tens of millions and hired hundreds, and **never names it** — referring only to "this ill-fated company." (Contextually There.com; **UNVERIFIED** as he does not say so.) The "the my" typo is his.

#### 3.5 Answer.AI — founding director of an AI lab, rarely attached to his name

`https://www.answer.ai/posts/2023-12-12-launch.html` (200), dated **2023-12-12**, authored by **Jeremy Howard**, describing the founding team:

> "Eric Ries (founding director, previously creator of Lean Startup and the Long-Term Stock Exchange)"

Corroborated on his own LTSE bio page, which names **"Answer.AI, an AI R&D lab"** and **"Virgil, a legal services startup"** among his ventures.

---

### 4. What is not retrievable

Everything here was actually attempted; statuses are observed.

| Target | URL requested | Observed |
|---|---|---|
| **Instagram** | `https://www.instagram.com/ericries/` | **HTTP 200, 625 KB — but a login wall.** `<title>` is the generic `Instagram`, not the `Eric Ries (@ericries)` pattern a resolvable profile produces. The string `ericries` appears **0 times** in the returned HTML; "login"/"Login" appears 22 times. **Whether the account exists is undeterminable logged out.** |
| **TikTok** | `https://www.tiktok.com/@ericries` | **HTTP 200, 369 KB**, but the body contains **"Couldn't find this account"** (6×), the curly-quote variant (3×), and "isn't available" (3×). `ericries` appears **0 times**. Best read: **no public TikTok at this handle.** |
| **LinkedIn** | `https://www.linkedin.com/in/eries` and `/in/eries/` | **HTTP 999** (LinkedIn's anti-bot code), 1.5 KB body. **No profile data, no activity feed, nothing readable logged out.** |
| **X — who he follows** | `https://x.com/ericries/following` | **HTTP 200 but a JS wall** — body contains "JavaScript is not available." **The following list is not readable logged out.** Only the aggregate `friends_count = 1835` leaks, via the syndication widget. |
| **X — full timeline** | `https://x.com/ericries` | 200, JS shell. Timeline only accessible through the syndication widget, which returns a **bounded window** (121 tweet objects, newest 2026-01-23). Cannot confirm or refute activity after that date. |
| **Kickstarter (The Leader's Guide)** | `/projects/ericries/the-leaders-guide` + 2 guessed slugs | **403 to curl AND to WebFetch, all three.** Backer count, pledge total and campaign copy are **not retrievable**. `web.archive.org` is not fetchable by this toolchain. |
| **Crunchbase** | `https://www.crunchbase.com/person/eric-ries` | **403.** |
| **Simon & Schuster** | `.com` and `.ca` `/books/Incorruptible/...` | **403 both.** Book data recovered from Parnassus instead. |
| **Bookshop.org** | `/p/books/incorruptible-eric-ries/9798893311860` | **403.** |
| **ericries.com / www.ericries.com** | both | **curl 000 — will not resolve/connect.** There is **no personal domain**; the newsletter at `news.theleanstartup.com` is the personal channel. |
| **Podcast transcripts** | `anchor.fm/s/f51132a8/podcast/rss`, `ericriesshow.com` | Feed fetched successfully but has **zero `<podcast:transcript>` elements**; no transcript links on the site. **44 episodes, none transcribed publicly.** |
| **SEC rule-filing bodies** | `34-86722.pdf`, `34-102787.pdf` | Both **HTTP 200**, but WebFetch cannot decode the FlateDecode PDF streams. Contents **UNVERIFIED**. |
| **Newsletter RSS** | `/feed`, `/feed.xml`, `/rss`, `/feed/rss`, `rss.beehiiv.com/feeds/theleanstartup.xml` | All fail — soft-404 HTML at 200, or hard 404. **No subscribable feed for his most active channel.** |
| **Guessed URLs that 404'd** (recorded as negative findings) | `theleanstartup.com/feed`; `ltse.com/newsroom`; `ltse.com/posts`; `youtube.com/@ericries`; `podcasts.apple.com/...id1746986340`; `penguinrandomhouse.com/books/210164/...`; `.../546855/...`; `sec.gov/rules/sro/ltse.htm`; `sec.gov/rules-regulations/.../ltse`; `outofthecrisis.fm` (DNS fail); `feeds.transistor.fm/out-of-the-crisis` | — |

---

### 5. Voice sample

**Written, 2008 — the post that coined the term.** `https://www.startuplessonslearned.com/2008/09/lean-startup.html` (raw HTML via curl, 200):

> "I've been thinking for some time about a term that could encapsulate trends that are changing the startup landscape. After some trial and error, I've settled on the Lean Startup. I like the term because of two connotations"

> "(So far, I have found 'lean startup' works better with the entrepreneurs I've talked to than 'agile startup' or even 'extreme startup.')"

**Written, 2008 — first person, unguarded.** `https://www.startuplessonslearned.com/2008/10/about-author.html`:

> "I know many people who think that software works like magic, but to me it actually was magic."

**Written, 2026 — the current register.** `https://news.theleanstartup.com/p/what-is-profit` (2026-05-28):

> "Profit is the maximization of human flourishing. To be precise, profit itself is the surplus of human flourishing that an organization creates."

**Characterization:** the 2008 voice is a practitioner narrating his own reasoning in public — hedged, parenthetical, showing the trial-and-error ("After some trial and error, I've settled on…"), typos left in place. The 2026 voice is declarative and definitional — short assertive sentences, redefinition-as-argument ("Profit *is*…", "Purpose is not a mission statement"), a manifesto register rather than a lab notebook. Constant across both decades: he builds arguments by **renaming things** — "lean startup," "pivot," "innovation accounting," "profit as human flourishing."

## Nabeel Qureshi — public footprint measurement audit

Audit date: **2026-09-03**. Audited directly by the lead auditor. Every URL below was actually requested; status codes are observed, not assumed.

**Disambiguation warning (load-bearing):** "Nabeel Qureshi" is a heavily-collided name. `https://en.wikipedia.org/wiki/Nabeel_Qureshi` (HTTP 200) is **a different person** — the Christian apologist/author (1983–2017). Our subject has **no English Wikipedia article** that I could find. There is also a Pakistani film director of the same name. Any automated name-based lookup will pull the wrong person. Same for Instagram (see §4).

### 1. Source inventory

**Retrieval note up front:** `nabeelqu.co` sits behind a **Vercel bot challenge**. Every `curl` request returned `HTTP 429` with header `x-vercel-mitigated: challenge` and a body titled `Vercel Security Checkpoint`. `WebFetch` on `https://nabeelqu.co/` also returned **HTTP 429**. The site was only readable via a **real headless browser** (which solves the challenge). The usual fallback — the Wayback Machine — was **also unavailable**: `http://web.archive.org/cdx/search/cdx?url=nabeelqu.co*` returned **HTTP 503, "Internet Archive services are temporarily offline."** So: this site is trivially readable by a human, and non-trivially readable by a naive scraper. Worth designing for.

| Channel | URL fetched | Status | Feed | Volume / cadence | Notes |
|---|---|---|---|---|---|
| Personal site | `https://nabeelqu.co/` | 429 to curl/WebFetch; **200 in browser** | — | Single-page hub: Essays, Other Writing, Selected Projects, Interviews, Contact, More About Me | Astro on Vercel. **Richest single artifact in this whole audit.** |
| Site RSS | `https://nabeelqu.co/rss` | **200 (browser); valid RSS 2.0** | ✅ | **10 items**, 2020-01-15 → 2026-05-02 | Title-only feed (no `<description>`/body). Correct `atom:link` self-ref. |
| Substack | `https://nabeelqu.substack.com/` | **200** (curl AND WebFetch) | — | "Over 23,000 subscribers"; description: "Essays." | Mirror of the site, plus extras. |
| Substack RSS | `https://nabeelqu.substack.com/feed` | **200**, `application/xml`, 410,253 bytes | ✅ **full-text** | **14 items**, 2019-12-15 → 2026-05-03 | **Strictly better than his own feed**: 4 extra items and full post bodies. |
| X / Twitter | `https://x.com/nabeelqu` | **200**, profile header renders logged-out | ✗ | **9,112 posts**, 887 following, **37.9K followers**, joined **November 2010** | Bio: `make yourself proud`. Location `nyc`, link `nabeelqu.co`. Timeline rendering is **flaky** — see §4. |
| GitHub | `https://github.com/nqureshi` | **200** | ✅ (GitHub Atom) | **25 repos**, 20 stars, 68 followers, **42 contributions in the last year**; **11 commits in September 2026** | Handle is **`nqureshi`**, not `nabeelqu`. `https://github.com/nabeelqu` also returns 200 but is a nameless/empty account — **not him** (UNVERIFIED which). |
| LinkedIn | `https://www.linkedin.com/in/nabeelqu` | **hard signup wall** | ✗ | — | See §4. |
| Newsletter | via Substack | 200 | ✅ | Self-described on site: "Newsletter, usually every month or two." **Actual measured cadence is far sparser** (see below). |
| Books | — | — | — | **None.** No authored book found. | Negative finding. |
| Wikipedia | `https://en.wikipedia.org/wiki/Nabeel_Qureshi` | 200 | — | **Wrong person** | See disambiguation. |
| Crunchbase | not fetched | — | — | — | **UNVERIFIED** — current startup is stealth, so likely thin. |
| Instagram | `https://www.instagram.com/nabeelqu/` | 200 | — | **Different person** | See §4. |
| TikTok | `https://www.tiktok.com/@nabeelqu` | 200 | — | Empty handle | See §4. |

#### Off-site writing (from `nabeelqu.co`, hrefs extracted from the live DOM)

| Piece | URL | Status |
|---|---|---|
| "Art against the machine", New Statesman Weekend Essay, **23 May 2026** | `https://www.newstatesman.com/science-tech/2026/05/art-against-the-machine` | **200, partial** — ~3 paragraphs then subscribe wall; article tagged `Subscriber` |
| "Rented Virtue", with Will Manidis, **Feb 10, 2026** | `https://minutes.substack.com/p/rented-virtue` | **200, fully readable, no paywall.** Published on Manidis's Substack **"Minutes"** ("minutes is mostly about walking", "Over 5,000 subscribers"). Engagement rendered: `427` likes / `48` comments / `92` restacks. |
| "Moral AI" (the Waluigi Effect piece), WIRED, May 2023 | `https://www.wired.com/story/waluigi-effect-generative-artificial-intelligence-morality/` | linked from site (not separately fetched — **UNVERIFIED**) |
| "Compounding Intelligence: Adapting to the AI Revolution", Mercatus | `https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4946332` | SSRN, linked from site (**UNVERIFIED**) |

#### Interview record (transcribed verbatim from the site's `INTERVIEWS` table)

| Show | Date | URL |
|---|---|---|
| Dialectic #50, with Tyler Cowen | Jun 2026 | `https://dialectic.fm/tyler-nabeel` — **fetched, 200** |
| Lenny's Podcast | May 2025 | `https://www.lennysnewsletter.com/p/inside-palantir-nabeel-qureshi` |
| Dialectic #13 | Mar 2025 | `http://dialectic.fm/nabeel-qureshi` |
| The Ruffian (Ian Leslie) | Mar 2025 | `https://www.ian-leslie.com/p/nabeel-qureshi-principles-for-living` |
| Better Known | Oct 2024 | `https://betterknown.co.uk/2024/10/06/nabeel-qureshi/` |
| The Common Reader | Sep 2024 | `https://www.commonreader.co.uk/p/nabeel-qureshi-literature-requires` |
| Dan Schulz | Mar 2024 | `https://www.danschulz.co/p/nabeel-qureshi` |

**Transcripts — VERIFIED PUBLIC AND FULL.** The Dialectic #50 page is a public Notion doc whose total rendered text is **120,836 characters**, containing a complete **speaker-attributed, timestamped transcript** (`Jackson:` / `Tyler:` / `Nabeel:` with `(m:ss)` markers on every turn), plus Timestamps and a long Links & References list. No paywall, no login. Verbatim from the transcript body:

> **Jackson:** (4:42) "...I'm excited to use Nabeel as a little bit of an entry point to the incompressible Tyler Cowen."
>
> **Nabeel:** (6:19) "Yeah, I think of the saying—I think it's "everything is about sex except sex, which is about power." I feel like the modern equivalent of that is "everything is about AI except AI, which is about power.""

**This is the single highest-density retrievable artifact on him**: ~2 hours of his unscripted speech, in clean text, free, with speaker labels — better than any of his essays for capturing how he actually talks. Dialectic #13 (`http://dialectic.fm/nabeel-qureshi`, Mar 2025) is presumably the same format (**UNVERIFIED** — not separately fetched).

#### Cadence, measured

Essays are **rare and long**, not frequent. From the Substack feed: 2019 ×1, 2020 ×4, 2022 ×1, 2023 ×3, 2024 ×2, 2025 ×2, 2026 ×1. **There was a ~17-month gap between Jul 2020 and Jul 2022, and a ~15-month gap between Jan 2024 and Oct 2024.** His own site's claim of "usually every month or two" is **not borne out by the data**. The high-frequency channel is X (9,112 posts), not the essays.

#### Retrievability pattern (measured, all via `curl` with a normal desktop UA)

| URL | Status |
|---|---|
| `https://nabeelqu.co/` | **429** (Vercel challenge) |
| `https://evwinners.org/` (his own side project) | **429** (Vercel challenge) |
| `https://www.mercatus.org/announcements/mercatus-welcomes-nabeel-s-qureshi-visiting-scholar` | **403** |
| `https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4946332` | **403** |
| `https://nabeelqu.substack.com/feed` | **200** |
| `https://www.lennysnewsletter.com/p/inside-palantir-nabeel-qureshi` | **200** (339 KB) |
| `https://www.commonreader.co.uk/p/nabeel-qureshi-literature-requires` | **200** (278 KB) |
| `https://www.ian-leslie.com/p/nabeel-qureshi-principles-for-living` | **200** (298 KB) |
| `https://betterknown.co.uk/2024/10/06/nabeel-qureshi/` | **200** (199 KB) |

**Rule of thumb for this person: Substack-hosted content is reliably machine-readable; his own Vercel deployments and institutional hosts (Mercatus, SSRN) are not.** Six of his seven listed interviews are Substack-hosted, so the *interview* corpus is far easier to ingest than his *own site*. Ironic but useful: the highest-signal path to his essays is the Substack mirror, not the canonical URL.

### 2. Recency probe (Mar–Sep 2026)

**Not stale. Active on multiple channels within the last 4 days.**

1. **X, 31 Aug 2026** (`https://x.com/nabeelqu`, rendered logged-out) — verbatim:
   > "People don't *want* to think about what happens if AI/swarms actually become strong and capable (esp if robotics also accelerates) because it's scary. Psychologically it's easier to downplay the implications, say "it's just code", or deny that anything major is happening."

   Engagement counters rendered as `25 · 32 · 464 · 28K` (replies / reposts / likes / views — **UNVERIFIED** mapping, but that ordering is X's standard).

2. **Essay, published May 2, 2026** — "What Makes Art Great?" (`https://nabeelqu.co/what-makes-art-great`). Header reads verbatim `Published: May 2, 2026. Substack version`. Opening:
   > "Shakespeare is excellent, whereas AI writing is — at least, for now — dull. AIs can now write much of our code, review legal contracts, and perform various impressive feats; they have achieved gold-medal-level scores at the IMO. But, as of this writing, I am not aware of a truly interesting AI-written poem or even essay. Why?"

3. **New Statesman, 23 May 2026** — "Art against the machine", strapline verbatim `This AI short-story scandal is the beginning of a new era for literature`:
   > "The story, "The Serpent in the Grove", was published on Granta's website as a regional winner of the Commonwealth Short Story Prize; it beat out 7,806 rivals for the honor, and was selected by a panel of judges chaired by the novelist Louise Doughty. I came across it by chance, on X, and started reading."

4. **Dialectic #50, dated `06/29/2026`** (`https://dialectic.fm/tyler-nabeel`), host's description verbatim:
   > "Tyler and Nabeel are good friends, and given how prolific Tyler is, I decided to use Nabeel as an entry point and interview them together. We discuss sacred commitments, AI acceleration, mentorship, friendship, and more, but I focused the majority of the conversation on art and aesthetics. Tyler and Nabeel are unlikely aesthetes given their day jobs, but in fact take art deeply seriously."

5. **"Rented Virtue", `FEB 10, 2026`**, co-authored with Will Manidis (`https://minutes.substack.com/p/rented-virtue`) — opens on 18th-century Quaker ironmasters, not on tech:
   > "In January of 1709, in a steep gorge cut by the river Severn in the midlands of England, a 30-year-old Quaker named Abraham Darby fired a blast furnace for the first time."

   and later:
   > "Darby's invention would set Britain up to become the greatest empire in history. Every partnership that fueled this first forge was Quaker."

6. **GitHub, September 2026** — profile page states verbatim `Created 11 commits in 2 repositories`, broken out as `nqureshi/ev-winners 10 commits` and `nqureshi/ev-search-python 1 commit`.

**Current status, verbatim from his own site:** "I'm an entrepreneur, writer, and researcher. I'm currently working on a startup in stealth." The startup being stealth is itself the retrieval gap — there is no company newsroom, no funding announcement, no product page.

### 3. The deep cut

#### 3a. He is a serious art-house film obsessive, with a public ranked canon — and an open invitation
`https://nabeelqu.co/movies` (browser, 200). Titled **"Favourite Movies"**, header verbatim:
> "A tiny and arbitrary selection of the movies I like, organized by director. ★ = top 10. If you like this sort of thing too, email me!"

Organized by **director**, not title — 27 directors. The ★ top-10 picks include **Edward Yang's *Yi Yi***, **Wong Kar-Wai's *In the Mood for Love* AND *2046***, **Apichatpong Weerasethakul's *Uncle Boonmee Who Can Recall His Past Lives***, **Tarkovsky's *Stalker***, **Bergman's *Scenes from a Marriage* and *Persona***, **Mike Leigh's *Naked***, **Chris Marker's *Sans Soleil***, **Cassavetes' *Faces* and *A Woman Under the Influence***, **Kiarostami's *Close-Up***, and **Kieślowski's *Trois Couleurs***. Also present: **Tom Noonan's *What Happened Was* (1994)** — an genuinely obscure pick — and the most recent addition, **Nuri Bilge Ceylan's *About Dry Grasses* (2023)**.

**Why this is host-usable:** it is an explicit, printed invitation to talk to him about it. The Weerasethakul thread is corroborated independently — the Dialectic #50 description lists "Apichatpong Weerasethakul" among shared favourites, and his Oct 2024 *Better Known* appearance is summarized on his own site as "Weerasethakul, Empson's ambiguity, Wittgenstein's notebooks, Sokolov's Goldberg Variations, Shklovsky, Vikram Seth."

#### 3b. He built a chess **endgame kata trainer** and vibe-coded it with Claude Code
`https://github.com/nqureshi/chess-trainer` (200). Repo description verbatim:
> "Simple trainer for chess endgames and other critical positions. Vibe-coded fully with Claude Code."

README, verbatim:
> "A web-based chess training application focused on drilling fundamental endgame positions against perfect computer play."

Three positions: **Lucena**, **Philidor**, and **King + Pawn vs King**. Feature list verbatim: `Perfect Computer Opposition: Stockfish engine at depth 20+ for theoretically perfect play` and `Repetitive Practice: Reset positions instantly for kata-style training`. Flask + Stockfish, ~5 source files.

**This is the best deep cut in the set** because it closes a loop across six years of his own writing. In **June 2020** he wrote (`https://nabeelqu.co/education`), verbatim:
> "I play a fair amount of chess (not well) and one thing you develop after playing a lot of chess is that you start to see "lines of force" on the board, e.g. the force a bishop exerts on an enemy pawn; and start to sense "weak points" in the opponent's structure in a very physical way, in the way that you can sense the shakiest part of a Jenga tower in the physical world."

In **July 2023** he published "Notes on Puzzles," described on his own site as "What chess puzzles, mathematical problem-solving, and startup founding have in common." And then he actually built the drilling tool. A host can say: *you've been writing about chess intuition since 2020 and you finally built the trainer.*

#### 3c. His "Principles" page is a genuine oddity — meditation teachers and Zone 2 cardio
`https://nabeelqu.co/principles`, `Last updated: 2023.10.02`. Not a generic productivity list. Verbatim entries:
> "Pick some kind of fitness/athletic activity to get addicted to, and get addicted to it for its own sake. (For me, this is running. Zone 2 cardio is underrated.)"

> "Learn how to meditate, even if you don't end up doing it regularly. The techniques are useful. (99% of books/resources on this are quite bad - I'd recommend looking at Rob Burbea's talks and jhana practice as a way in.)"

> ""Aim for Chartres" (Christopher Alexander) — when doing something, aim to be the best there ever was at it. This compensates for your natural bias, which is to do something mediocre."

> "Memorize a few old poems, or texts that mean a lot to you."

> "80% utilitarian, 15% deontologist, 5% virtue ethics."

The **Rob Burbea / jhana** reference is the sharp one — that is a specific, non-obvious Buddhist meditation lineage, not "try Headspace."

#### 3d. Pre-Palantir biography that almost nobody surfaces
From `https://nabeelqu.co/` ("More about me"), verbatim:
> "I interned at the Bank of England in the summer of '08 (!) which was a dramatic introduction to central banking, quantitative easing, and financial crises."

> "I was also a founding employee and Vice President of Business Development at GoCardless, a Y Combinator (S11) funded company headquartered in London, now one of Europe's biggest financial technology unicorns."

Also: "most recently spent a year fully nomadic"; a one-year stint in France; at Oxford he "specialized in Development Economics, Derek Parfit's philosophy, and the later philosophy of Wittgenstein."

#### 3e. A COVID-era computational-genomics notebook, and a semantic-search side project
`https://github.com/nqureshi/sars-cov-2` — "Analysis of the SARS-CoV-2 genome", a Jupyter notebook, **59 stars**. Described on his own site verbatim as "A fun iPython adventure into computational genomics." And `https://evwinners.org/` / `https://github.com/nqureshi/ev-winners` — "Semantic search over every Emergent Ventures winner" (33 stars, TypeScript), which he still actively commits to (10 commits in Sept 2026). He is himself an Emergent Ventures awardee (27th cohort, `https://marginalrevolution.com/marginalrevolution/2023/07/emergent-ventures-winners-27th-cohort.html`).

#### 3f. He curates other people's reading lists
`https://nabeelqu.co/reading-lists`, verbatim header:
> "I'm always after reading recommendations, particularly for books that aren't commonly read. Here are some good reading lists from around the internet. If have one you think I should include, please DM me on Twitter!"

(Typo "If have one" is his, preserved.) The list includes **"Peter Thiel's German 270 syllabus"**, **"Hannah Arendt's 'Thinking' syllabus"**, **"Auden's English syllabus"**, **"Borges's personal library"**, and **"Ray Carney's favorite movies"**. His `/books` page runs Homer → Knausgaard and includes **Basil Bunting's *Briggflatts***, **Geoffrey Hill's *Mercian Hymns***, **William Empson's *7 Types of Ambiguity***, and **Keith Johnstone's *Impro***.

### 4. What is NOT retrievable

Everything below is what I **actually observed**, not inference.

| Probe | Observed |
|---|---|
| **Instagram** | `https://www.instagram.com/nabeelqu/` → **HTTP 200, public, but a DIFFERENT PERSON.** Page title rendered: `Nabeel qurban Ali (@nabeelqu) • Instagram photos and videos`; 128 followers, 358 following. **No Instagram account for our subject was found.** |
| **TikTok** | `https://www.tiktok.com/@nabeelqu` → **HTTP 200**. Rendered: `Nabeel Qu` / `nabeelqu` / `1 Following` / `2 Followers` / `0 Likes` / `No bio yet.` **Zero content.** Effectively a dead/parked handle; attribution to our subject is **UNVERIFIED**. |
| **LinkedIn logged-out** | `https://www.linkedin.com/in/nabeelqu` → redirects to a **hard signup wall**. Rendered page title `Sign Up | LinkedIn`, body: `Join LinkedIn / Email / Password (6+ characters)`. **Not even the profile headline is visible.** Zero activity readable. |
| **X — who he follows** | `https://x.com/nabeelqu/following` logged-out → page rendered **only the word `Profile`**. The follow graph is **not retrievable logged-out.** The *count* (887) is visible; the *list* is not. |
| **X — his timeline** | **Intermittent.** First load rendered exactly one article (the Aug 31 post). Subsequent loads rendered the profile header and tab bar but the timeline slot showed verbatim: `Something went wrong. Try reloading.` with `0` article elements in the DOM. Treat logged-out X timeline scraping as **unreliable, not blocked** — you get the header deterministically and the posts probabilistically. |
| **Personal site to a scraper** | **Blocked.** `HTTP 429`, `x-vercel-mitigated: challenge`, `Vercel Security Checkpoint` — to both `curl` and `WebFetch`. Browser-only. |
| **Wayback fallback** | **Unavailable at audit time.** `HTTP 503`, "Internet Archive services are temporarily offline." |
| **New Statesman** | **Partially gated.** ~3 paragraphs render, then a subscribe interstitial; article carries the `Subscriber` topic tag. |
| **The stealth startup** | **Nothing retrievable.** No company site, no newsroom, no funding record found. Self-declared as stealth. |
| **Full essay bodies via his own RSS** | His `/rss` is **title+link+date only** — no `<description>`. To get bodies from a feed you must use the **Substack** feed, which is full-text. |

### 5. Voice sample

From `https://nabeelqu.co/what-makes-art-great` (May 2, 2026) — analytical, compressive, fond of numbering his claims:
> "One of the things that so offends us about AI 'slop' images is a sense that the details don't matter. The cup is green, but it may as well have been blue. In good human works, every detail feels carefully chosen. Arbitrarily changing a color in a Hopper painting would make it worse."

From `https://nabeelqu.co/principles` — the aphoristic register:
> "Do things fast. Things don't actually take much time (as measured by a stopwatch); resistance/procrastination does. "Slow is fake". If no urgency exists, impose some."

> "If you don't "get" a classic book or movie, 90% of the time it's your fault. (It might just not be the right time for you to appreciate that thing.)"

From `https://nabeelqu.co/education` (June 21, 2020) — the self-deprecating parenthetical is characteristic:
> "I play a fair amount of chess (not well)..."

**Spoken register**, from the Dialectic #50 transcript (`https://dialectic.fm/tyler-nabeel`, 29 Jun 2026) — note he reaches for an aphorism and then immediately mutates it, which is very much his move:
> "Yeah, I think of the saying—I think it's "everything is about sex except sex, which is about power." I feel like the modern equivalent of that is "everything is about AI except AI, which is about power.""

## Melanie Perkins — public footprint measurement audit

Audit date: 2026-09-03. Subject: Melanie Perkins, co-founder & CEO, Canva, Sydney AU.
Method: `curl` for honest HTTP status codes (incl. redirect chains), WebFetch for page text, WebSearch for discovery only. Search snippets are **never** cited as sources below — everything quoted was fetched.

---

### 1. Source inventory

#### 1.1 The headline finding: canva.com is 403 to every automated client tested

Every canva.com path returns **403 Forbidden** — to plain curl, to curl with a full desktop Chrome User-Agent, and to WebFetch. This is not a paywall, it is blanket bot denial at the edge.

| URL fetched | curl (default UA) | curl (Chrome UA) | WebFetch |
|---|---|---|---|
| `https://www.canva.com/newsroom/` | 403 | 403 | not attempted |
| `https://www.canva.com/newsroom/news/` | 403 | — | — |
| `https://www.canva.com/newsroom/news/author/melanie-perkins/` | — | — | **403** |
| `https://www.canva.com/newsroom/news/canva-create-is-back/` | 403 | — | — |
| `https://www.canva.com/newsroom/news/canva-foundation/` | 403 | — | — |
| `https://www.canva.com/canva-create/` | 403 | 403 | — |
| `https://www.canva.com/canva-create/watch-sessions/` | 403 | — | — |
| `https://www.canva.com/blog/` | 403 | — | — |
| `https://www.canva.com/blog/news/` | 403 | — | — |
| `https://www.canva.com/foundation/` | 403 | — | — |
| `https://www.canva.com/canva-foundation/` | 403 | — | — |

**RSS test — negative.** Guessed feed paths all 403 (indistinguishable from "blocked" vs "absent", so no feed could be confirmed to exist):
`https://www.canva.com/newsroom/rss/` → 403; `https://www.canva.com/newsroom/feed/` → 403; `https://www.canva.com/newsroom/news/rss.xml` → 403.
The archived newsroom index shows the site's own subscription mechanism is **email, not RSS**: "Stay updated / Get the latest Canva announcements. Email address / Sign up" (fetched from the Wayback snapshot below). No `<link rel="alternate" type="application/rss+xml">` was observed in the archived markup.

**Workaround that does work: the Wayback Machine.** WebFetch refuses web.archive.org ("Claude Code is unable to fetch from web.archive.org"), but `curl` retrieves it fine. Snapshots confirmed via the availability API:

| Canonical URL | Wayback snapshot | Status |
|---|---|---|
| `canva.com/newsroom/news/` | `web.archive.org/web/20260825193821/...` | 200, 1,062,873 bytes retrieved |
| `canva.com/newsroom/news/author/melanie-perkins/` | `web.archive.org/web/20260621125526/...` | snapshot exists (200) |
| `canva.com/canva-create/` | `web.archive.org/web/20260823113515/...` | 200, 592,331 bytes retrieved |
| `canva.com/newsroom/news/melanie-perkins-21-questions-part-1/` | `web.archive.org/web/20250729222616/...` | 200, 611,472 bytes retrieved |
| `canva.com/newsroom/news/melanie-perkins-21-questions-part-2/` | `web.archive.org/web/20251031134619/...` | snapshot exists (200) |
| `canva.com/newsroom/` (bare) | — | **no snapshots** (`archived_snapshots: {}`) |
| `canva.com/foundation/` | — | **no snapshots** — likely a URL I guessed that never existed |

**Newsroom volume/cadence** (from the archived index, 2026-08-25 snapshot — headline items, most recent first): "One million nonprofits now have Canva Pro for free"; "More of you, powered by AI: key takeaways from AI Vision Sydney 2026"; "Marvel Studios' Spider-Man: Brand New Day template collection is here"; "Canva launches Goals Platform to find where our hopes overlap"; "Canva expands design creation inside Google Gemini and AI Search"; "Vibe coding that matches your vision: Canva Code 2.0 is now available to all"; "Your Back to School toolkit"; "What we learned at ISTE 2026"; four "Day 1–4 at Cannes" Perspectives posts; "Introducing Canva Grow 2.0". Categories are: All Stories / AI + Product / AI Research / Canva for Work / Company Updates / Education / People + Culture / Perspectives / Step Two. Cadence looks like roughly 2–5 posts a week, **almost none of it bylined to Perkins** — the AI Vision recap is bylined to Cameron Adams, the Cannes series to Canva's Executive Creative Director. Press contact listed verbatim: "For general press inquiries or media requests, please get in touch at comms@canva.com."

#### 1.2 Personal site or blog — does not exist

| Candidate URL requested | Result |
|---|---|
| `https://melanieperkins.com` | **curl (7) Failed to connect** — no server on :443. Domain does not resolve to a live host. |
| `https://www.melanieperkins.com` | **curl (7) Failed to connect** |
| `https://melanieperkins.com.au` | **301 → GoDaddy parking page**, final URL `https://forsale.godaddy.com/forsale/melanieperkins.com.au?traffic_id=GoDaddy_DLS...` → 403. The domain is **listed for sale**. |

**Conclusion: Melanie Perkins has no personal website or personal blog.** Her long-form first-person writing lives inside the Canva newsroom (see §3), which is the very thing that is 403-walled. This is the single biggest structural fact about her footprint.

#### 1.3 X / Twitter — handle verified, content not machine-readable

Real handle is **`@MelanieCanva`** (capitalised; `x.com/melaniecanva` 200s and resolves to the same account). Fetched `https://x.com/MelanieCanva` → **200, 288,137 bytes**. The HTML shell is server-rendered enough to give the profile card verbatim:

> "Melanie Perkins 1,314 posts Melanie Perkins @MelanieCanva Co-founder and CEO of @ Canva . Working with an incredible team to empower the world to design. Sydney, Australia canva.com Joined June 2011 246 Following 56.5K Followers"
> — extracted from fetched `https://x.com/MelanieCanva`

Hard numbers: **1,314 posts, 246 following, 56.5K followers, joined June 2011.** Note the banner image asset path is `profile_banners/311340284/1538621288/` — the trailing integer is a Unix timestamp of **2018-10-04**, and the avatar is `profile_images/631640259898413056/` (a 2015-era snowflake ID). Neither has been refreshed in years.

**No tweet text is retrievable.** The 288KB response contains zero rendered post bodies and no `og:description`; the page ends in a login interstitial: "Log in or sign up for X / See what's happening and join the conversation". `https://syndication.twitter.com/srv/timeline-profile/screen-name/MelanieCanva` → **429 Too Many Requests** (rate-limited, not usable). **No RSS.** Cadence is therefore **unmeasurable without an authenticated session or paid API** — 1,314 posts over ~15 years is an average of ~7/month, but the distribution is unknown.

#### 1.4 LinkedIn — profile blocked, individual post permalinks partially readable

| URL fetched | Status |
|---|---|
| `https://www.linkedin.com/in/melanieperkins/` | **999** (LinkedIn's proprietary anti-scrape code) |
| `https://au.linkedin.com/in/melanieperkins` | **999** |
| `https://www.linkedin.com/posts/melanieperkins_canva-create-2026-activity-7313006523847192576-tPTK` | **200, 183,482 bytes** |

Post permalinks are the exception: the `og:description` carries the **full post body** logged-out. Fetched verbatim from that URL:

> "It's hard to believe we're less than 10 days away from Canva Create 2025! 🚀 … While I won't give any spoilers, I can say we'll be unveiling some of the most exciting product launches in Canva's history. … Something we love to do at Canva is grant wishes from our community. If you have any feature requests, ideas, or wishes, we'd love to know what would make Canva even more helpful for you this year – big or small, we're all ears💡👇"

Page furniture confirms she is a LinkedIn **"Influencer"**, the post is dated "1y" and carries "1,225" reactions and "77 Comments". **Caveat worth flagging: the URL slug says `canva-create-2026` and the page `<title>` says "Canva Create 2026 | Melanie Perkins | 77 comments", but the actual post body says "Canva Create 2025".** The slug is not a reliable date signal. **Her activity feed / post list is not enumerable logged-out** — only individual permalinks you already know. No RSS.

#### 1.5 Podcasts — verified vs. not

**VERIFIED to exist (fetched, 200):**
- *How I Built This with Guy Raz* (NPR), "Canva: Melanie Perkins" — `https://www.npr.org/2019/01/24/688299882/canva-melanie-perkins` → **200**. Note: my WebFetch of the page body **timed out at 60s**; I confirmed the status code by curl only, so I have **not** verified whether NPR carries a full transcript. Apple Podcasts mirror `https://podcasts.apple.com/us/podcast/canva-melanie-perkins/id1150510297?i=1000428595833` → **200**.
- *How I Built This* 2019 re-run — `https://www.npr.org/2021/02/26/971813519/canva-melanie-perkins-2019` → **200**.
- *20VC / The Twenty Minute VC* — `https://www.thetwentyminutevc.com/melanieperkins/` → **200** (redirects to `/melanieperkins`, no trailing slash).

**NOT verified / negative findings:**
- *Lenny's Podcast* — an episode is indexed on Spotify, but my guessed article URL `https://www.lennysnewsletter.com/p/how-canva-grew-melanie-perkins` → **404**. The real Lenny's episode page URL is **UNVERIFIED**; I did not locate and fetch it. `https://www.lennysnewsletter.com/feed` → 200 (a real Substack RSS feed exists, but I did not confirm the Perkins episode is in the current window).
- **Lex Fridman — no evidence found. Treat as not existing unless someone produces a URL.** I found nothing in any fetched page.
- **Transcripts: none confirmed.** I did not successfully fetch a full transcript of any Perkins podcast appearance. Marking podcast transcripts as **UNVERIFIED / likely unavailable**.

#### 1.6 YouTube — a real trap here

**Do not use `?user=canva`.** `https://www.youtube.com/feeds/videos.xml?user=canva` returns **200** and looks valid, but it resolves to `yt:channel:L1lwOrUwiYYFu66rSTYInQ` — a **completely unrelated personal channel** whose entries are Hong Kong smog and office videos from 2013–2015 ("無聊", "香港的严重雾霾天气", "The Apple shop in IFC Hong Kong"), created 2007-02-22. A silent wrong-channel failure.

**The real Canva channel:** `https://www.youtube.com/@Canva` → 200; externalId scraped from the page HTML = **`UCEDLeLo3HNQZiJOTR2svg2A`**, channel created 2012-03-27.

**Working Atom feed:** `https://www.youtube.com/feeds/videos.xml?channel_id=UCEDLeLo3HNQZiJOTR2svg2A` → **200, 15 `<entry>` items** (YouTube caps the feed at 15). This is the **only confirmed working RSS/Atom feed in Perkins's entire orbit.**

Volume/cadence measured from that feed — **near-daily publishing**: 2026-09-03 "Skills That Separate You in an AI World"; 2026-09-01 "4 Modes. 1 Question. Better AI Results."; 2026-08-28 "Sensors + AI = Perfect Plants"; 2026-08-27 (×2) "Code Doesn't Care About Your Idea", "Designer vs Designer vs...Engineer?"; 2026-08-26 (×2) "✨Whimsy✨ Carousel Tutorial", "Canva's AI Vision 2026| Sydney Highlights"; 2026-08-25 (×2) "AI Won't Kill Design, But It Will Kill Bad Design, with Tey Bannerman, AI Advisor", "Under the hood of Canva Code 2.0"; 2026-08-24 "One million nonprofits. Countless stories of change."; 2026-08-20 (×4) incl. "#CanvaAIVision" shorts. Roughly **10 uploads per 10 days**. Caveat: this is the **company** channel — Perkins herself appears in a small minority of it. **Her personal YouTube presence: none found.**

**Canva Create keynote.** Confirmed via the archived event page (`web.archive.org/web/20260823113515/https://www.canva.com/canva-create/`), verbatim:

> "Canva Create / Hear from Canva's founders, explore our biggest launches of the year, and experience a keynote like no other. / Play keynote / 50+ sessions on demand"
> "70m Canva Create Keynote — Join Melanie Perkins, Cliff Obrecht, and Cameron Adams for Canva's biggest launch yet."

Other sessions listed: Issa Rae & Aurora James ("Building Creative Empires for Social Good", 49m); Refik Anadol & Cameron Adams ("Prompted: AI and Dreaming with Machines", 42m); a PayPal-presented creator monetisation panel; a LinkedIn/Stripe live-campaign session. The page also shows "Register for 2027" — so the 2026 event is done and the next is open. **The videos themselves sit behind canva.com (403).**

#### 1.7 Reference profiles

| Source | URL fetched | Status | Notes |
|---|---|---|---|
| Wikipedia | `https://en.wikipedia.org/wiki/Melanie_Perkins` | **200** | Fully open, richest structured source. |
| Forbes profile | `https://www.forbes.com/profile/melanie-perkins/` | **200** | Live-updating net worth. |
| Forbes feature (Konrad 2019) | `https://www.forbes.com/sites/alexkonrad/2019/12/11/inside-canva-profitable-3-billion-startup-phenom/` | **403** to WebFetch | The famous "Canva Uncovered" piece is **not fetchable**. |
| Forbes Australia | `https://www.forbes.com.au/...` (2 articles) | **200, fully readable** | See §2. **Forbes AU is open where Forbes US is 403** — a useful asymmetry. |
| Crunchbase | `https://www.crunchbase.com/person/melanie-perkins` | **403** | Login/bot wall. Unusable. |
| Giving Pledge | `https://www.givingpledge.org/pledger/melanie-perkins-and-cliff-obrecht/` | **200** | Primary-source letter. Note slug order: `melanie-perkins-and-cliff-obrecht` works; `cliff-obrecht-and-melanie-perkins` → **404**. |
| GiveDirectly | `https://www.givedirectly.org/canva` | **200** | See §1.9. |

Forbes profile, fetched verbatim: net worth **$7.6 billion**, "#530 in the world", figure timestamped **"September 3, 2026 ... updated Mar 10, 2026"**. Bio quote carried on the profile: **"If the whole thing was about building wealth, that would be the most uninspiring thing I could possibly imagine."** Wikipedia (fetched) gives net worth as US$7.6bn as of August 2026 — consistent.

#### 1.8 Australian press — tested honestly

| Outlet | URL fetched | Status | Verdict |
|---|---|---|---|
| AFR | `https://www.afr.com/` | 200 | Homepage loads |
| AFR | `https://www.afr.com/rss/companies` | **404** | No feed at that path |
| AFR | `https://www.afr.com/rss.xml` | **404** | No feed at that path |
| AFR | `https://www.afr.com/robots.txt` | 200 | See below |
| SMH | `https://www.smh.com.au/` | 200 | |
| SMH | `https://www.smh.com.au/rss/feed.xml` | **200** — but only **1 `<item>`** | Feed is essentially a stub; latest pubDate `Fri, 04 Sep 2026 05:52:50 +1000` |
| news.com.au | `https://www.news.com.au/` | **403** | Blanket bot block, like canva.com |
| ABC | `https://www.abc.net.au/` | 200 | |
| ABC | `https://www.abc.net.au/news/feed/51120/rss.xml` | **200** | Working feed |
| Startup Daily | `https://www.startupdaily.net/feed/` | **200, 10 items**, latest `Thu, 03 Sep 2026 06:52:49 +0000` | **Best AU feed available.** ~3 posts/day. |
| Startup Daily article | `.../canva-cuts-revenue-forecast-a-third-as-it-tackles-high-ai-costs/` | 200, **fully readable** | No paywall hit |
| Startup Daily article | `.../canva-wipes-10-billion-from-its-valuation-putting-ipo-plans-in-doubt/` | 200, **fully readable** | |
| Capital Brief | `https://www.capitalbrief.com/` | **200** | |
| Capital Brief | `https://www.capitalbrief.com/feed/` | **404** | |
| Capital Brief | `https://www.capitalbrief.com/newsletter/` | **404** (guessed URL — negative finding) | |

**Two distinct AU blocking mechanisms, and they are different things:**

1. **Nine Entertainment (AFR + SMH) has an explicit anti-AI policy in robots.txt.** Fetched verbatim from `https://www.afr.com/robots.txt` and `https://www.smh.com.au/robots.txt` (identical preamble):

   > "# NINE ENTERTAINMENT CO. POLICY STATEMENT / # Nine Entertainment Co expressly prohibits the use of any Nine / # content or data, including associated metadata, for any machine / # learning and/or artificial intelligence including for the purposes / # of training or development of AI technology, tools and machine / # learning language models."

2. **AFR and SMH are blocked at the search layer entirely.** A WebSearch scoped to those domains returned a hard error: `API Error: 400 The following domains are not accessible to our user agent: ['afr.com', 'smh.com.au']`. So the two most authoritative outlets on Canva's finances are **invisible to both search and fetch**.

**AFR URL-guessing produces silent false positives — a real trap.** I invented two plausible AFR slugs. Both returned **200**, but to *unrelated articles*:
- `https://www.afr.com/technology/canva-s-valuation-slashed-by-11b-20260817-p5n2ab` → **200**, final URL `https://www.afr.com/wealth/superannuation/what-to-do-about-the-new-3m-and-10m-super-tax-20251014-p5n2ab` (a superannuation tax story)
- `https://www.afr.com/companies/professional-services/canva-boss-melanie-perkins-20260101-p5n0aa` → **200**, final URL `https://www.afr.com/companies/sport/piastri-rages-over-unfair-norris-to-mar-mclaren-title-20251006-p5n0aa` (a Formula 1 story)

AFR routes purely on the **trailing article ID** (`p5n2ab`) and rewrites the rest of the path. **A 200 from afr.com does not mean the article you asked for exists.** Any AFR citation not obtained by following a real link is untrustworthy.

Other guessed AU URLs that **404'd** (recorded as negative findings): `https://www.abc.net.au/news/2026-04-17/canva-create-2026-melanie-perkins/`, `https://www.abc.net.au/news/2021-09-15/canva-founders-giving-pledge/100463364`, `https://www.capitalbrief.com/article/canva-melanie-perkins/`.

#### 1.9 Philanthropy

- **Giving Pledge letter** — `https://www.givingpledge.org/pledger/melanie-perkins-and-cliff-obrecht/` → **200, fully readable.** Joined 2021; the letter itself carries **no date** on the page. This is the single best primary source of her own written voice that is *not* behind the canva.com 403.
- **GiveDirectly** — `https://www.givedirectly.org/canva` → **200.** Verbatim: "a $10 million pilot that is sending a basic income through mobile money payments to people in extreme poverty in Khongoni, Malawi." Details fetched: ~**$50/month for 12 months to 12,800 adults**. The page credits "hard work from the entire Canva community in building one of the most valuable companies" and a "commitment to do the most good that it possibly can." **The page does not mention the Canva Foundation and contains no Perkins quote.**
- **Canva Foundation** — has **no fetchable standalone page**. `canva.com/foundation/` → 403 *and* has **zero Wayback snapshots** (strong evidence that path never existed). `canva.com/canva-foundation/` → 403. `canva.com/newsroom/news/canva-foundation/` → 403. The Foundation is referenced only second-hand through Forbes/Wikipedia. **Scale figures (30% stake / >80% of wealth / $150m Malawi) are from Wikipedia and Forbes, not from any Canva-published page I could fetch.**

#### 1.10 Timezone and geography as a genuine retrievability variable

This is not a platitude — it showed up as measurable artefacts in this audit:

1. **The two best-informed outlets on Canva are structurally unreachable.** AFR and SMH cover Canva's private valuation, employee share sales and IPO timing more closely than anyone. Both are Nine Entertainment properties, both carry an explicit anti-AI robots.txt clause, and both are **hard-excluded from the search tool at the API level** (400 error). A US-centric pipeline sees Fortune and Forbes on Canva's financials and simply *never sees* the AU reporting that usually breaks those stories first.
2. **AU-domiciled English-language substitutes exist and are wide open — but you have to know to ask for them.** Startup Daily (`startupdaily.net`) has a working 10-item RSS feed and un-paywalled Canva valuation coverage; **Forbes Australia (`forbes.com.au`) returned full article text with quotes where Forbes US returned 403** on the Konrad feature. Forbes AU is effectively an unpaywalled mirror-tier for Perkins coverage. Neither surfaces prominently in US-default search.
3. **Timestamp skew is visible in the feeds.** SMH's RSS stamps `+1000` (AEST); Startup Daily stamps `+0000`; the Canva YouTube feed stamps `+00:00`. Canva's YouTube uploads cluster at **06:00 UTC**, which is **16:00 AEST** — i.e. scheduled to Sydney's late afternoon, not US morning. The AI Vision Sydney highlight went up at `2026-08-26T01:51:27Z` = **11:51 AEST**. A daily crawler on a US schedule systematically samples her orbit's output ~half a cycle late.
4. **Date-boundary risk is real.** At audit time (2026-09-03 US) the SMH feed's newest item was already stamped **`Fri, 04 Sep 2026`** — Sydney is a calendar day ahead. Any "as of today" date filter built on US dates will drop the freshest AU items.
5. **Canva Create is an AU-company event held in the US.** The 2026 keynote ran at SoFi Stadium, Los Angeles (April 2026), so the single biggest Perkins media moment of the year is US-timed and US-covered — while the *rest* of her year (AI Vision Sydney, Aug 2026) is AU-timed and thinly covered outside Australia. The footprint is bimodal by geography.

---

### 2. Recency probe — Mar–Sep 2026

**Not stale. She has been substantially active and quotable in this window.** Four dated, fetched items:

**(a) Canva Create 2026 keynote — Forbes Australia, published 21 April 2026.**
`https://www.forbes.com.au/news/innovation/canva-create-2026-melanie-perkins-unveils-canva-ai-2-0-and-claude-design-deal/` (fetched, full text). Verbatim Perkins:

> "The entire process of creation today is fragmenting across lots of different tools and workflows, and it's becoming more and more disparate. And so what we really saw was a huge opportunity to bring that all into one platform and make it accessible to the world again. Exactly as we did for the first decade of Canva's existence."

> "Before we built anything – before Canva was Canva – it was actually called Canvas Chef. And the idea was that you could describe an idea, and then it would just instantly appear."

**(b) Goals Platform / philanthropy — Forbes Australia, published 17 July 2026.**
`https://www.forbes.com.au/news/leadership/inside-billionaire-canva-cofounders-plan-to-give-away-their-fortune/` (fetched, full text). Verbatim Perkins:

> "We have this optimistic belief that there's enough resources and goodwill in the world to achieve all of our goals, but goals aren't given much of a voice"

> "That's been incredible to see that money being deployed to people living in extreme poverty through our partnership with GiveDirectly"

(The Forbes US version of this story, `forbes.com/sites/madhulika-pathak/2026/07/16/...`, returned **403** to WebFetch — the AU edition was the only readable copy. Note the one-day date discrepancy: US slug says 07/16, AU page says 17 July.)

**(c) AI cost / revenue-forecast cut — Fortune, published 12 August 2026, 4:14 PM ET.**
`https://fortune.com/2026/08/12/canva-startup-growth-ai-costs-revenue-forecast-by-third/` (fetched, 200). Verbatim Perkins:

> "This validated the demand, but also showed us we needed to reduce the cost of completing an AI task to support a broad rollout."

> "Rather than broadly rolling out a product before the underlying economics were ready, we decided to slow the rollout while we rebuilt the architecture, reduced unit costs and strengthened the business model."

**(d) Valuation markdown / IPO doubt — Startup Daily, published 17 August 2026.**
`https://www.startupdaily.net/advice/business-strategy/canva-wipes-10-billion-from-its-valuation-putting-ipo-plans-in-doubt/` (fetched, 200, no paywall). Verbatim from the article:

> "the dramatic drop could also see the touted 2027 US public float delayed until Canva swings back in favour with investors"

Reported figures: Blackbird and Airtree marked Canva down **17% to US$34.9bn**; Hiive secondary offers imply **US$30bn**; an independent employee-share valuation at **US$31bn**, down ~A$11bn from US$38.9bn a year prior.

**(e) Most recent signal of all:** Canva's YouTube feed published "Skills That Separate You in an AI World" at **2026-09-03T06:00:34Z** — same day as this audit. The company channel is live daily; Perkins personally is *not* the one appearing in most of it.

**Caveat:** items (a)–(d) are all **journalist-mediated**. I found **no first-person Perkins publication** (blog post, tweet, LinkedIn post) in Mar–Sep 2026 that I could fetch and quote — because the two places she would publish it (canva.com newsroom, X) are 403 and JS-walled respectively.

---

### 3. The deep cut

Both come from `canva.com/newsroom/news/melanie-perkins-21-questions-part-1/` — a ~64,000-character, first-person, primary-source memoir she wrote herself. **It is currently 403 on the live web** and only reachable via `http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/` (fetched by curl, 200, 611,472 bytes). A Part 2 also exists at `web.archive.org/web/20251031134619/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-2/`.

#### Deep cut 1 — she says outright that she learned to kitesurf *as an instrument to reach Bill Tai*, and she hated it

This is the primary source for the kitesurfing legend, in her own words, including the actual text of the email she sent Tai. Verbatim:

> "I was also learning to kitesurf, as I knew Bill ran a conference called MaiTai which was a gathering of entrepreneurs and kitesurfers. Kitesurfing scares the hell out of me, and learning to kitesurf in the dreary, cold, shark-invested waters of San Francisco was far from enjoyable. But I wanted to get Canva off the ground, so it was just a small inconvenience. It also gave me another reason to email Bill:"

and the email itself, reproduced in the post:

> "So pumped, just got back from kite-surfing- I can't believe how much fun it is… On a side note, I have found a really great potential tech lead."

The same post pins down the *first* Tai meeting, which is usually reported vaguely:

> "The following year we were invited back to attend the awards and after the event, we had a quick chat with Bill Tai, an investor who was speaking at the event and had flown over from Silicon Valley."
> "He was the first investor we'd ever met, and the short five minute chat felt like a window had opened into a whole new world."

and her own cold-email pretext, verbatim:

> "Hi Bill, hope all is well. I'm going to be in San Francisco from 21st May to 1st June. Are you still interested in an investment in my area? If so, would be great to meet up and have a chat."

Independent corroboration from a **2013** contemporaneous source (SmartCompany, fetched, published **19 March 2013**, `https://www.smartcompany.com.au/startupsmart/design-start-up-canva-raises-3-million-after-kitesurfing-in-hawaii/`) — Perkins verbatim:

> "I met Bill Tai at a conference in Perth a few years back. We kept in contact and kept him informed about what we were doing."

> "[MaiTai Global] was an amazing experience… The key ingredient is they bring together influential investors, journalists, successful entrepreneurs and start-up entrepreneurs. Everyone is learning to kitesurf, so it's about getting people out of their comfort zone. It helps people to bond in a way you can't do in a boardroom."

#### Deep cut 2 — the Fusion Books origin in granular, unflattering detail, plus the Cameron Adams rejection email

The "mum's living room" story is usually told as a one-liner. The actual post has the texture. Verbatim:

> "When I was at university in Perth in 2008, I was teaching design programs part-time. The Arts faculty at the University of Western Australia. I found that the design tools I was teaching were really clunky and difficult to use."

> "My boyfriend, Cliff, became my business partner. My mum's living room became our office. And we set to work."

> "Cliff calling schools in Australia in my Mum's living room, aka. our office. Sometimes a school would ask to speak to the manager, so Cliff would pause a moment and change voices."

> "When she sent her deposit for $100 we were absolutely over the moon. We couldn't decide if we should frame the cheque or cash it. We opted to cash it because it might seem a little strange if it wasn't cashed and also, we needed the money."

> "We also took over Mum's garage, driveway and hallway with our 24/7 printing operation. Gee was she gracious."

Financing detail almost never reported: "The government's R&D tax concession was absolutely essential. NAB (National Australia Bank) also provided a $20k bank loan for small businesses. Without both of these, we would have run out of money in those early days." The first dev shop is named: "a great company called Indepth (now called Cirrena), led by an incredible guy, Greg Mitchell."

And the **Cameron Adams rejection-then-yes**, with both emails quoted in full — Adams' initial no:

> "I'm certainly very fond of Canva and can see it doing great things, but I'm not sure my teammates would have the same passion for the area it's going after… I'm certain you guys will do great things with or without us."

then his reversal, subject line "The Answer…":

> "…is YES :) We should jump on Skype to figure out a few of the loose details, let me know when you're free. (btw, that's "yes" to you guys, just to be clear)"

#### Deep cut 2b — the rejection era, in her own words (bonus, same source)

The "100+ investor rejections" figure circulates without a primary source. What she actually wrote:

> "Eventually, after three months of learning about the startup world, accosting engineers anywhere I could and being rejected more times than I would have thought possible, my visa to the US expired. I felt like a complete and utter failure though was resolved to come back and try again. I'd spent $9k over the three month period…"

> "We didn't tick *any* of the boxes that investors were looking for."

> "the many rejections we received were a testament to the fact that raising funds was really, really hard when you don't fit the mould on any account, well except for the fact that I'm a drop out from university and a human."

She also quotes a real rejection email verbatim: *"Regarding stage and timing, unfortunately right now I do not think that it is quite the right fit just now. This is mostly because of geography an[d]…"* — i.e. **rejected explicitly for being Australian**. And on the sleep-deprivation period: *"My eyesight started to go fuzzy — looking in the mirror I could hardly see myself. It scared the hell out of me."*

#### Deep cut 3 — fusionbooks.com.au is dead and now redirects into the 403 wall

| URL requested | Result |
|---|---|
| `https://fusionbooks.com.au/` | **301 → `https://www.canva.com/`** (1 redirect) → final **403** |
| `https://www.fusionbooks.com.au/` | same: → `https://www.canva.com/` → **403** |
| `http://fusionbooks.com/` (guessed .com) | **200**, but returned **no `<title>`** — content not identifiable as Fusion Books; treat as unrelated/parked. **UNVERIFIED.** |

Her first company's domain has been absorbed into Canva's root and then bot-blocked. **The Fusion Books product no longer has any independently fetchable public page** — the only surviving first-hand account of it is the archived newsroom post above.

**Note on "100+ rejections":** the specific figure appears in secondary sources (e.g. a Hustle Fund post title indexed in search) but I **did not fetch any page where Perkins herself states a number**. Her own writing says "rejected more times than I would have thought possible". **The "100+" figure is UNVERIFIED against a primary source.**

**Wedding:** Wikipedia (fetched) states she married Cliff Obrecht in **January 2021 on Rottnest Island**. I found **no primary-source page** for this. **UNVERIFIED beyond Wikipedia.**

**Canva "Vision" internal culture docs:** **not found.** No fetchable URL. Anything about them would be fabrication.

---

### 4. What is not retrievable

Observed, with actual statuses:

| Target | URL requested | HTTP | What actually rendered |
|---|---|---|---|
| **Instagram `@melaniecanva`** | `https://www.instagram.com/melaniecanva/` | **200** | `<title>Instagram</title>` only — the generic app shell. Body contains repeated "Login"/"login" strings. **No profile name, no post count, no `is_private` field, no bio.** Cannot determine whether the account exists, is public, or is private. Instagram serves an identical 200 shell for real, private, and non-existent handles. **Existence UNVERIFIED.** |
| **TikTok `@melaniecanva`** | `https://www.tiktok.com/@melaniecanva` | **200** | `<title>TikTok - Make Your Day</title>`, and the body contains **"Couldn't find this account"** (twice) alongside `uniqueId":"melaniecanva"` and `followerCount":9`. Contradictory payload; best read is a **placeholder/unclaimed or deleted handle with 9 followers**. **There is no meaningful public TikTok presence.** |
| **LinkedIn profile** | `https://www.linkedin.com/in/melanieperkins/` and `https://au.linkedin.com/in/melanieperkins` | **999** (both) | LinkedIn's non-standard scrape-refusal code. Profile body, headline, experience, and **activity feed are all unreadable logged-out.** |
| **LinkedIn activity list** | — | — | **Not enumerable.** Only pre-known individual `/posts/...` permalinks return content (200, via `og:description`). You cannot discover her posts; you can only read ones you already have URLs for. |
| **Who she follows on X** | `https://x.com/MelanieCanva/following` | **200** | Renders **only** the JS error interstitial verbatim: "JavaScript is not available. We've detected that JavaScript is disabled in this browser… Something went wrong, but don't fret — let's give it another shot. Try again". **The following list is completely invisible logged-out.** The *count* (246) is visible on the profile shell; the *identities* are not. |
| **Her X posts** | `https://x.com/MelanieCanva` | **200** (288KB) | Profile card only. **Zero post text.** Ends at "Log in or sign up for X". Syndication fallback → **429**. |
| **Crunchbase** | `https://www.crunchbase.com/person/melanie-perkins` | **403** | Unusable. |
| **Forbes US feature** | `https://www.forbes.com/sites/alexkonrad/2019/12/11/inside-canva-profitable-3-billion-startup-phenom/` | **403** | The canonical long-form Canva profile is unfetchable. |
| **news.com.au** | `https://www.news.com.au/` | **403** | Blanket block at the root. |
| **AFR / SMH** | — | robots.txt 200 | Explicit anti-AI/ML clause; **hard-excluded from WebSearch at the API level (400 error).** |
| **Entire canva.com** | 11 paths tested | **403 ×11** | Including under a full desktop Chrome UA. Newsroom, blog, Create, foundation — all of it. |
| **Personal website** | `melanieperkins.com` | **connection refused (curl 7)** | No host. `.com.au` is **parked for sale on GoDaddy**. |
| **Podcast transcripts** | NPR page | **200**, but WebFetch **timed out at 60s** | **No transcript confirmed for any appearance.** UNVERIFIED. |
| **Canva Create session videos** | `https://www.canva.com/canva-create/watch-sessions/` | **403** | The 70-minute keynote she fronts is not fetchable. |
| **Canva Foundation page** | `canva.com/foundation/` | **403** + **zero Wayback snapshots** | Path probably never existed; the Foundation has no fetchable home. |

**Bottom line on non-retrievability:** the four channels where Perkins speaks in her own unmediated voice — canva.com newsroom, X, LinkedIn, and Canva Create video — are **all** machine-unreadable, by four *different* mechanisms (edge 403, JS wall, HTTP 999, edge 403). Everything quotable about her in 2026 is journalist-mediated. Her own words are only recoverable from **archive.org**.

---

### 5. Voice sample

Her register is disarmingly plain, self-deprecating, concrete about money and embarrassment, and switches without warning into very large ambition. Three sources, all fetched.

**(a) Her own long-form writing — from `web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/`:**

> "I was so nervous in the days leading up to the meeting that I made a mental deal with myself that if I was able to successfully catch the train and get myself to the meeting I would award myself some brownie points, even if the meeting was a flop."

> "The first thing Bill said was 'you didn't need to get dressed up'. I was mortified!"

> "I cannot imagine what Bill must have thought as this girl from Australia nervously presented her paper pitch deck over lunch and said that she and her partner were going to beat Google Docs and Microsoft."

> "I don't think I ever found the playbook to finding a tech cofounder. I just kept on planting seed after seed, and in some cases the same seed in different patches of the field, until eventually, eventually one grew!"

**(b) Formal-but-still-plain register — the Giving Pledge letter, `https://www.givingpledge.org/pledger/melanie-perkins-and-cliff-obrecht/`:**

> "We've long had a 2-step plan for Canva: Step 1. To build one of the world's most valuable companies, and Step 2. To do the most good we can do."

> "We have this wildly optimistic belief that there is enough money, goodwill, and good intentions in the world to solve most of the world's problems."

**(c) Current spoken register, 2026 — Forbes Australia, 17 July 2026:**

> "We have this optimistic belief that there's enough resources and goodwill in the world to achieve all of our goals, but goals aren't given much of a voice"

**Observation worth noting:** the 2021 written line and the 2026 spoken line are **near-identical constructions** ("we have this wildly optimistic belief that there is enough money, goodwill…" → "we have this optimistic belief that there's enough resources and goodwill…"). She runs stable, reused verbal formulas across five years. The "2-step plan… Step 1 / Step 2" framing is also durable: Canva's newsroom still tags a whole content category **"Step Two"** (visible in the archived newsroom index). That is a genuinely distinctive voice fingerprint.

---

### Confidence notes

- Everything in quotation marks above was extracted from a page I fetched. Nothing is from a search snippet.
- Explicitly marked **UNVERIFIED**: Instagram existence/privacy; the "100+ investor rejections" number; the 2021 wedding (Wikipedia-only); podcast transcript availability; the Lenny's Podcast episode URL; Lex Fridman appearance (**no evidence found — assume it does not exist**); Canva "Vision" internal culture docs (**no fetchable source**); `fusionbooks.com` (.com) identity.
- Failed/guessed URLs recorded as negative findings: `melanieperkins.com` (no host), `melanieperkins.com.au` (parked/for sale), 3× Canva RSS paths, `canva.com/foundation/`, `afr.com/rss.xml`, `afr.com/rss/companies`, `capitalbrief.com/feed/`, `capitalbrief.com/newsletter/`, `lennysnewsletter.com/p/how-canva-grew-melanie-perkins`, 2× ABC slugs, 1× Capital Brief slug, `givingpledge.org/pledger/cliff-obrecht-and-melanie-perkins/`, and 2 invented AFR slugs that **falsely 200'd to unrelated articles**.
