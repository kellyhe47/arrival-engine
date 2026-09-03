# Audit 02 — Measured public footprint: Sarah Tavel, Hunter Walk, Steve Huffman

**Audit date:** 2026-09-03
**Method:** Every URL below was actually fetched (curl with a browser User-Agent, or WebFetch). HTTP
status codes are real, observed values. Quotes are verbatim from the page body, not from search-result
snippets. Anything not confirmed by opening a primary artifact is marked **UNVERIFIED**.

**Headline comparison**

| | Tavel | Walk | Huffman |
|---|---|---|---|
| Richest machine-readable source | Substack RSS + archive API (20 posts) | WordPress REST API (**1,761 posts**) | **SEC EDGAR** (478 filings) — *not* Reddit |
| Owned-channel recency | **STALE** — last post 2025-09-03 (12 months) | **Live** — 27 posts since 2026-03-01 | **Live but bursty** — newest 2026-08-05 |
| Open API without auth? | Yes (Substack) | Yes (WP REST + Bluesky XRPC + YouTube RSS) | **No — Reddit 403s every method.** SEC is open. |
| Wikipedia article? | **404 — none** | **404 — none** | 200 — exists |
| Best deep-cut vein | Archived 2006–15 blog *Adventurista* | 1,761-post blog + concert-clip YouTube | Archived u/spez comments + SEC boilerplate |
| Verified trap | Aug 2026 podcast is a **rerun** | — | **`@spez` on X is a different person** |

---

## 1. Sarah Tavel — Benchmark

### 1.1 Source inventory

| Channel | URL fetched | HTTP | What is actually there |
|---|---|---|---|
| Newsletter (primary) | `https://www.sarahtavel.com/` | 200 (75 KB) | Substack. `sarahtavel.substack.com` 301s to this custom domain. |
| **RSS feed** | `https://www.sarahtavel.com/feed` | **200**, `application/xml`, 215 KB | **Feed fetch succeeded.** 20 items, range **2023-04-24 → 2025-09-03**. |
| Archive API | `https://www.sarahtavel.com/api/v1/archive?sort=new&limit=12&offset=0` | 200 | Confirms newest post = `2025-09-03T16:38:57Z`. All items `"audience":"everyone"` — **nothing paywalled**. |
| Substack Notes API | `https://substack.com/api/v1/reader/feed/profile/883898?types[]=note&limit=20` | 200 | Only **2 notes ever**: 2025-06-08 and 2023-07-31. Notes are not a live channel. |
| Substack profile API | `https://www.sarahtavel.com/api/v1/publication/users/ranked?public=true` | 200 | Bio verbatim: `"Blogging since 2006. Partner @benchmark. formerly: product @pinterest. vc @greylockvc, @bessemervp."` Profile created `2023-01-04`. |
| Medium (HTML) | `https://medium.com/@sarahtavel` | **403** | Blocked to anonymous curl. |
| **Medium (RSS)** | `https://medium.com/feed/@sarahtavel` | **200**, `text/xml`, 35 KB | **Feed works where HTML does not.** 10 items, **2023-01-04 → 2024-04-02**. Dormant — she migrated to Substack. |
| Firm site | `https://www.benchmark.com/` | 200, **2,297 bytes** | Deliberately near-empty. Full visible text is the firm name, two office addresses, and `"More info: @benchmark »"`. **No partner bios, no blog, no RSS.** |
| Firm site (people) | `https://www.benchmark.com/people` | **404** | No such page. |
| X / Twitter (HTML) | `https://x.com/sarahtavel` | 200 (257 KB) | **JS shell only.** `"has tweet text? False"`; no `og:description`. Zero post content retrievable. |
| X (public API mirror) | `https://api.fxtwitter.com/sarahtavel` | 200 | Metadata IS retrievable: **52,896 followers, following 1,435, 9,417 tweets, 8,110 likes**, joined `Sat May 24 2008`, `"protected":false`. |
| LinkedIn profile | `https://www.linkedin.com/in/sarahtavel` | 200 (644 KB) | Profile shell loads. |
| LinkedIn activity | `https://www.linkedin.com/in/sarahtavel/recent-activity/all/` | **999** | LinkedIn anti-bot. 1,530 bytes of cookie/redirect JS. **Not readable without login.** |
| Wikipedia | `https://en.wikipedia.org/wiki/Sarah_Tavel` | **404** | **No Wikipedia article exists.** |
| Crunchbase | `https://www.crunchbase.com/person/sarah-tavel` | **403** | Login/bot-walled. |
| TikTok | `https://www.tiktok.com/@sarahtavel` | 200 | Account **exists**: `"uniqueId":"sarahtavel"`, `"nickname":"Sarah Tavel"`, **`followerCount: 717`, `videoCount: 1`**. One video, ever. |
| Instagram | `https://www.instagram.com/sarahtavel/` | 200 (625 KB) | Login wall (17 `login` markers, no `og:` tags). See §1.4. |
| Podcast (guest) | `https://every.to/podcast/what-s-missing-from-ai-tools-is-other-people` | 200 | Every's *AI & I*. **Public transcript linked from the page.** `article:published_time = 2025-04-30`. |
| Old blog (archived) | `https://web.archive.org/web/20140110041657/http://www.adventurista.com/` | 200 | See §1.3 — this is the big one. |

**Cadence, measured:** 20 posts across ~29 months (Apr 2023 → Sep 2025) ≈ **0.7/month**, and highly
bursty: 8 posts in Jan–Sep 2025, then **nothing for 12 months**. Total lifetime written corpus across
all three platforms is roughly **113 (Adventurista) + 10 (Medium) + 20 (Substack)**, i.e. she is a
low-volume, high-effort writer — which she says outright herself (§1.3).

**Podcasts:** she is a **guest**, never a host. No podcast of her own was found (UNVERIFIED that none
exists, but none surfaced in any fetch). Transcripts of the Every appearance are public.

### 1.2 Recency probe — Mar–Sep 2026

**Her owned channel is stale. This is a finding.** Newest Substack post is `2025-09-03` — exactly
**one year** before this audit. Newest Substack Note is `2025-06-08`. Medium dormant since `2024-04-02`.

She is nonetheless *present in press* in 2026. Dated, verbatim, from pages I opened:

1. **2026-04-16** — Fortune, "Exclusive: Eigen raises a seed round from Benchmark to build the world's first 'mutual friend'"
   `https://fortune.com/2026/04/16/exclusive-eigen-seed-round-benchmark-capital-ben-silbermann-mutual-friend/` (200)
   > "I'd long felt that one of the most important consumer opportunities in the AI era was going to be something that felt like a friend."

2. **2026-04-16** — same article, on the founder:
   > "The elements of Paul's vision were completely contrarian, and when I pushed him, deeply thought through."

3. **2026-06-03** — TechCrunch, "Benchmark raises its first-ever growth fund as part of $2B capital haul"
   `https://techcrunch.com/2026/06/03/benchmark-raises-its-first-ever-growth-fund-as-part-of-2b-capital-raise/` (200). She is described, not quoted:
   > "Then, last year, Sarah Tavel — Benchmark's first and only female general partner to date — took on the less-involved role of venture partner, while Victor Lazarte departed to start his own VC firm."

4. ⚠️ **Trap flagged.** `https://podcasts.apple.com/us/podcast/why-the-next-hit-ai-product-will-be-social-why-the/id1719789201?i=1000780083451`
   released **2026-08-05** looks like a fresh Tavel podcast. Confirmed via
   `https://itunes.apple.com/lookup?id=1719789201&entity=podcastEpisode` (200) that its title is
   **"Why the Next Hit AI Product Will Be Social (Best of the Pod)"** — it is a **rerun** of the
   2025-04-30 episode. Do not treat it as 2026 activity.

**Net:** her 2026 footprint is *other people writing about her*, plus one genuine role change
announced in her own words on **2025-04-29** (`https://www.sarahtavel.com/p/my-new-role-at-benchmark`).

### 1.3 The deep cut

**A. She ran a blog called *Adventurista* from Dec 2006 to Oct 2015 — and the "-ista" was a deliberate feminist joke.**
Confirmed by her own About page (`https://www.sarahtavel.com/about`, 200):
> "I'm also a long time blogger, first at Adventurista from Dec 2006-Oct 2015, and then on Medium @sarahtavel."

The old domain `sarahtavel.com` 302'd to `adventurista.com` as late as 2014 (Wayback CDX). **113 distinct
archived posts** enumerated via
`http://web.archive.org/cdx/search/cdx?url=adventurista.com*` . She explains the name herself in
`https://web.archive.org/web/2014/http://www.adventurista.com/2009/09/my-ista-take-on-larry-chengs-vc-blog.html` (200):
> "Because I initially started my blog with the intention of blogging from the perspective of a female, junior professional (hence the "ista" in Adventurista), I've created two sub-sets of Larry's: 1) Junior (i.e. non-dealmaker) professionals and 2) females."

The blog's own tagline in later years was **"Old school blogger..."** and the sidebar carried the
line **"don't mess with me"** plus a Last.fm "Recent Top Tracks / Weekly Fave Artists" widget.
Post labels, with counts, from the archived sidebar: `La Feminista (10)`, `Start up (9)`, `pop (7)`,
`Blogging (5)`, `La Environmentalista (5)`, `Personal (5)`, `Vents (5)`, `Youngins (5)`, `Webkinz (1)`.

**B. She played rugby for four years.**
`https://web.archive.org/web/2014/http://www.adventurista.com/2009/04/this-video-made-me-miss-my-rugby-days.html` (200),
Thursday, April 16, 2009, filed under label `Personal`, in full:
> "(The "try" starts at second 40.) I can't believe I played for four years..."

Corroborated in the wild: a commenter on her very first post (2006-12-05) wrote
> "I'm salivating already! can't wait for more. also the rugger picture is hot."

— i.e. her original blog avatar was a rugby photo. *(Which club/school is **UNVERIFIED**.)*

**C. "I regret to inform you that Bessemer does not have a corporate jet."**
From her 2012 associate job posting,
`https://web.archive.org/web/2014/http://www.adventurista.com/2012/03/hiring-associate-at-bessemer.html` (200), Monday, March 12, 2012:
> "A lot of people want to work in VC for the wrong reasons. I regret to inform you that Bessemer does not have a corporate jet."

Same post, on credentials — useful because it contradicts the usual VC script:
> "But graduate degrees are purely optional; neither of us have an MBA, so you certainly don't need one."

**D. In 2007 she publicly tore a sponsor badge off her own blog on ethical grounds.**
`https://web.archive.org/web/2014/http://www.adventurista.com/2007/07/carbon-indulgences-and-why-im-removing.html` (200),
Sunday, July 8, 2007, "Carbon Indulgences (And Why I'm Removing My NativeEnergy Badge)":
> "But when you think about it, these programs sound incredibly like the church selling indulgences back in the 1500s. Sin all you want, "offset" your sins by donating to the Church, and you still get a one-way ticket to Heaven."
> "Although I like the original intention of these programs, I can't in good conscience keep the NativeEnergy badge on my blog anymore."

**E. She coined "accomplishment arbitrage" in 2011 and then never used it again.**
`https://web.archive.org/web/2014/http://www.adventurista.com/2011/05/accomplishment-arbitrage.html` (200), Monday, May 23, 2011:
> ""Accomplishment arbitrage" occurs if someone refers to an accomplishment that occurred in the past when the value of that accomplishment was different than it is now."

**F. Her first post, Dec 3 2006, is a feminist manifesto — not a tech post.**
`https://web.archive.org/web/2014/http://www.adventurista.com/2006/12/its-time-to-start-blogging.html` (200):
> "For example, currently I am the only female in my firm of 30. (Perhaps Guy should have added that as one of his test questions? "If you are white / Indian / Asian, +2 pts. If you are male, +3 additional points".)"
> "Being an empowered woman (aka feminist), and having been involved in feminist organizations in college, I am inclined (make that, starved) to talk about these things."

**G. Her X bio names her partner and three children.**
Verbatim from `https://api.fxtwitter.com/sarahtavel` (200):
> "Partner at @Benchmark. Student of escaping competition. Formerly product @pinterest. Ball and chain for @cklemke and 🧒🏽👧🏻👶🏻."

`https://api.fxtwitter.com/cklemke` (200) resolves `@cklemke` to **Christine Lemke**, bio
`"Diving into the deep end again (AI+Health)"`. *(The bio phrasing implies spouse/partner; I am
reporting the bio verbatim rather than asserting the relationship — treat the label as
**UNVERIFIED** even though the inference is strong.)*

**H. She has a TikTok account with exactly one video.**
`https://www.tiktok.com/@sarahtavel` (200): `followerCount: 717`, `videoCount: 1`. A channel she
opened and abandoned — a small, human, very non-first-page detail.

### 1.4 What is NOT retrievable

| Test | URL | Observed |
|---|---|---|
| Instagram public/private? | `https://www.instagram.com/sarahtavel/` | 200 but **login-walled**: 625 KB with **17 `login` markers and zero `og:title`/`og:description`**. Cannot determine public vs private, cannot see a single post, bio, or follower count anonymously. |
| Public TikTok? | `https://www.tiktok.com/@sarahtavel` | **Yes, retrievable.** Exists; 717 followers; 1 video. |
| LinkedIn activity without login? | `https://www.linkedin.com/in/sarahtavel/recent-activity/all/` | **HTTP 999.** Body is 1,530 bytes of cookie-parsing JS. **No.** |
| Who she follows on X without an account? | `https://x.com/sarahtavel/following` | 200, 293 KB, but **`screen_name` occurrences: 0**, `"JavaScript is disabled"` present, no `og:description`. **The count (1,435) is available via the fxtwitter API; the list itself is not.** |
| Wikipedia | `en.wikipedia.org/wiki/Sarah_Tavel` | **404 — no article.** |
| Crunchbase | `crunchbase.com/person/sarah-tavel` | **403.** |
| Her own X timeline | `x.com/sarahtavel` + 4 Nitter/RSSHub mirrors | All failed: `nitter.net` serves "nitter.net is offline"; `nitter.poast.org` DNS failure; `nitter.privacydev.net` connection refused; `xcancel.com/sarahtavel/rss` **400**; `rsshub.app/twitter/user/sarahtavel` **404**. **Her 9,417 tweets are effectively unreadable anonymously.** |

### 1.5 Voice sample

Self-deprecating, bracketed asides, admits friction openly. From
`https://www.sarahtavel.com/p/the-benefits-of-writing-code-two` (200), 2025-08-20:
> "[I'm embarrassed how long this post took me to sit down to write. Got distracted by a couple other drafts, vibing, and a lot of reading this summer. Hopefully better late than never!]"

And on why the newsletter exists at all, from `https://www.sarahtavel.com/about` (200):
> "I used to spend hours and hours on posts for my Medium, and it was creating a mental block for me to write more consistently. This newsletter is my attempt to break that."

⚠️ **Attribution warning for hosts:** the widely-shared "codes two days a week with no AI" line is
**not about Tavel** — in that post she is quoting **Borislav Nikolov, CTO of Rekki**. The verbatim
quote `"I open a blank terminal and then I just code."` is his, not hers. Do not attribute it to her.

---

## 2. Hunter Walk — Homebrew

### 2.1 Source inventory

| Channel | URL fetched | HTTP | What is actually there |
|---|---|---|---|
| **Blog (primary)** | `https://hunterwalk.com/` | 200 (219 KB) | WordPress + Jetpack. Tagline: **"Self-Aware Self-Promotion"**. |
| **WP REST API** | `https://hunterwalk.com/wp-json/wp/v2/posts?per_page=1` | **200** | **`x-wp-total: 1761`** — verified independently by me. Lifetime post count. Fully open, no auth. |
| REST, since 2026-03-01 | `...?per_page=1&after=2026-03-01T00:00:00` | **200** | **`x-wp-total: 27`** — verified independently by me. |
| REST, since 2026-01-01 | `...?after=2026-01-01T00:00:00` | 200 | `x-wp-total: 35` (2026 YTD ⇒ **~4.4 posts/month**) |
| REST, since 2025-01-01 | `...?after=2025-01-01T00:00:00` | 200 | `x-wp-total: 75` |
| **RSS feed** | `https://hunterwalk.com/feed/` | **200**, `application/rss+xml`, 97 KB | **Feed fetch succeeded.** Rolling **10-item** window, `2026-06-25 → 2026-08-30` (~2 months). |
| Sitemap | `https://hunterwalk.com/sitemap.xml` | 200 | Jetpack index, `lastmod 2026-08-30T22:19:36Z`. Video sitemap stale (`2024-10-19`). |
| Sitemap (core WP) | `https://hunterwalk.com/wp-sitemap.xml` | **404** | Disabled. |
| Archive page | `https://hunterwalk.com/archives` | **404** | No such path — use the REST API instead. |
| Firm blog | `https://www.homebrew.co/blog` | 200 | **Separate corpus**, firm/portfolio news, not his essays. Latest: *"Nava Benefits Acquired By Alliant Insurance…"*, **2026-08-19**. ~16 posts back to Apr 2026. Author byline not exposed in HTML — **UNVERIFIED** whether he writes them. |
| Firm RSS | `https://www.homebrew.co/feed` | **404** | **No firm feed.** |
| **Bluesky (profile API)** | `https://public.api.bsky.app/xrpc/app.bsky.actor.getProfile?actor=hunterwalk.com` | **200** | Verified independently by me: **`postsCount: 573`, `followersCount: 5371`, `followsCount: 213`**, `createdAt 2023-02-28`, displayName **`👨🏻‍💻☕️`**, bio: `"Introvert IRL, Extrovert URL\nBlogging forever at https://hunterwalk.com/"` |
| **Bluesky (feed API)** | `https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=hunterwalk.com` | **200** | **Fully readable, no auth.** Most recent post `2026-09-02T23:42:55Z` — *yesterday*. |
| Substack | `https://hunterwalk.substack.com/` + `/api/v1/archive?sort=new&limit=12` | 200 | **Exists but empty** — archive returns `count 0`. A claimed placeholder handle, zero posts. |
| X / Twitter | `https://x.com/hunterwalk` | 200 (68 KB) | JS shell, no tweet text. |
| LinkedIn profile | `https://www.linkedin.com/in/hunterwalk` | 200 (670 KB) | Shell loads. |
| Medium | `https://medium.com/@hunterwalk` | **403** | Blocked; existence **UNVERIFIED**. |
| TikTok | `https://www.tiktok.com/@hunterwalk` | 200 | Exists, `"followerCount": 3`. Dormant placeholder. |
| Wikipedia | `https://en.wikipedia.org/wiki/Hunter_Walk` | **404** | **No article.** |
| Crunchbase | `https://www.crunchbase.com/person/hunter-walk` | **403** | Walled. |
| Hacker News | `https://news.ycombinator.com/user?id=hunterwalk` | **429** (retried twice) | Body is the single word `Sorry.` Rate-limited both attempts; **not retrievable this session**. |
| GitHub | `https://api.github.com/users/hunterwalk` | **200** | **Identity confirmed** — `"name": "Hunter Walk"`, `"blog": "www.hunterwalk.com"`, created `2012-02-24`. But **`public_repos: 0`, `public_gists: 0`, `followers: 1`**. A claimed handle, **not a code presence**. |
| **YouTube channel** | `https://www.youtube.com/@HunterWalk` | **200** | **Identity confirmed** — `og:title = "Hunter Walk"`, channel `UC68ai6rdol6MOTe_4b6T-wQ`. |
| **YouTube RSS** | `https://www.youtube.com/feeds/videos.xml?channel_id=UC68ai6rdol6MOTe_4b6T-wQ` | **200**, 16 KB | **Feed works.** Channel created `2006-01-03T02:39:45Z`; **15 videos**, `2012-12-18 → 2024-12-22`. Content: see deep cut **G**. |
| Threads | `https://www.threads.com/@hunterwalk` | 200 | 267 KB JS shell, no `og:` tags. Existence **UNVERIFIED**. |

**Podcasts:** **no podcast he hosts was found.** His long-running interview series
**"Five Questions With…"** — `https://hunterwalk.com/wp-json/wp/v2/posts?search=Five+Questions+With`
returns **`x-wp-total: 103`** — is **text, on his own blog**, not audio. So the "are transcripts
public?" question is moot for it: the whole series *is* the transcript, fully open. Treat
"Hunter Walk hosts a podcast" as **UNVERIFIED / likely false**; he guests elsewhere.

### 2.2 Recency probe — Mar–Sep 2026

**Not stale. The opposite: 27 posts in the audit window**, plus Bluesky activity yesterday.
Verified via the REST API date filter. Dated verbatim items:

1. **2026-08-30** — most recent blog post.
   `https://hunterwalk.com/2026/08/30/does-your-startup-have-an-ai-writing-policy-yet-heres-one-from-clay/` (200)

2. **2026-07-31** — `https://hunterwalk.com/2026/07/31/airlines-are-using-ai-to-maximize-prices-heres-how-you-fight-back/` (200):
   > "TLDR: I'm fanboying for Junova because it uses AI to claim $$ credit when an airline ticket drops below the price I've paid for it"

   and, disclosing his own numbers:
   > "So far I've saved $3,000+ on tickets for me and my family in less than a year. And the people using my referral link have saved $13,000+."

3. **2026-03-29** — `https://hunterwalk.com/2026/03/29/dont-worry-26-34-41-year-old-friend-in-tech-youre-not-too-old/` (200):
   > "For context, I'm 52 and have been out in Bay Area since 1998 — many of the folks in my network were born later, the Millennial cohort especially over-represented on Facebook I'd imagine."

4. **2026-09-02T21:13:54Z** — Bluesky, public API, no auth:
   > "@pablo.show how many victory laps are in a victory marathon? Just asking...."

*(One visible pause in 2026: **2026-05-09 → 2026-06-02**, 24 days — the only real gap of the year.)*

### 2.3 The deep cut

**A. He has been in therapy since 2011 and blogged the ten-year anniversary.**
`https://hunterwalk.com/2021/10/02/celebrating-10-years-of-therapy/` (200) — I re-fetched and
confirmed this text myself. Subtitle: *"How My Attitude Towards Mental Health Changed From My 20s
to 30s to 40s."*
> "2011 and I was at a low point. Most alarmingly, it wasn't clear that I could get out of my situation by myself. The mental stress and overwork at my job helped catalyze a physical disability of repetitive strain which created a vicious cycle."
> "In my 20s I wasn't prepared to embrace therapy. I'd been exposed to it via friends and family members but generally felt that I could solve my own problems by myself."
> "I've now been seeing him for 10 years."

**B. The "failure tiger" — a private metaphor he has reused for 7+ years.**
`https://hunterwalk.com/wp-json/wp/v2/posts?search=failure+tiger` returns **9 posts, 2019 → 2026**,
including `https://hunterwalk.com/2019/12/19/how-i-calmed-the-failure-tiger-nipping-at-my-heels/`.
In the therapy post he ties it to becoming a father:
> "This fed into my failure tiger fear, which was already heightened by the impending birth of my daughter."

This is a genuinely private idiom — not a public catchphrase — and it recurs for years. Excellent
warm reference material.

**C. Documented hobby: coffee and paper notebooks. He curated a list.**
`https://hunterwalk.com/2017/11/06/my-favorite-instagram-accounts-coffee-and-notebooks/` (200):
> "My Instagram feed is purposefully dominated by coffee cups and notebooks (the paper kind). If you like these things too, here are some of my favorite accounts."

He then lists ~18 coffee accounts and 8 notebook/bullet-journal accounts (Field Notes, Baron Fig,
showmeyourplanner). **Corroborated independently:** his Bluesky display name is literally
**`👨🏻‍💻☕️`** — a coffee cup — confirmed in the profile API response above.

**D. His first concert was Madonna in 1985, and the Beastie Boys opened and got booed.**
`https://hunterwalk.com/2022/04/28/what-was-the-first-concert-you-attended%ef%bf%bc/` (200):
> "Madonna, Like a Virgin Tour, June 1985 … Radio City Music Hall in NYC."
> "I hadn't heard of the opening band, some local group called the Beastie Boys, but they weren't very good and people booed. Of course just about 18 months later they'd release an album that became very important to me and begin a multi-decade fandom."

Follow-on — he collects vintage concert tees:
`https://hunterwalk.com/2023/01/12/the-economics-of-war-and-vintage-concert-t-shirts/` (200):
> "I never should have tossed those hair metal concert relics and other memorabilia from my teens."
> "I did manage to locate a Grateful Dead Giants Stadium (NJ) tie dye and a Poison tour short (unfortunately later era — by that I mean third album)."

**E. Recurring ritual: a "Books I've Read [year]" post he edits all year long.**
`https://hunterwalk.com/2019/01/19/books-ive-read-2019/` (200), opening line states the mechanic:
> "Just a post I'll update throughout the year. Here's 2018."

Companion: `https://hunterwalk.com/2018/01/02/books-i-read-in-2018/`. One-line verdicts ending in
"Definitely recommended" or "you can skip it."

**F. Comic-book roots, 2007–2010 — he went to WonderCon at least twice.**
Surfaced only via REST full-text search (`?search=comics`), invisible to normal search:
`https://hunterwalk.com/2008/02/24/geeking-out-at-wondercon/`,
`https://hunterwalk.com/2007/03/04/wondercon-glory/`,
`https://hunterwalk.com/2007/01/22/graphic-novelty/`,
`https://hunterwalk.com/2010/03/28/stupid-comics/`.

**G. ⭐ His personal YouTube channel is 15 shaky phone videos of rock concerts — and he opened it on 3 January 2006, before he ever worked at YouTube.**
This is the single least-discoverable artifact I found for him: the `@hunterwalk` handle 404s the
usual way, but the channel resolves at `https://www.youtube.com/@HunterWalk` (200, `og:title = "Hunter Walk"`)
and its **RSS feed is fully open**:
`https://www.youtube.com/feeds/videos.xml?channel_id=UC68ai6rdol6MOTe_4b6T-wQ` (200).
Channel `<published>2006-01-03T02:39:45+00:00</published>`. The complete 15-video list, verbatim titles:

| Published | Title |
|---|---|
| 2024-12-22 | December 22, 2024 |
| 2024-04-27 | Wake me up when September ends |
| 2024-04-27 | Green Day so good |
| 2022-08-13 | Pup |
| 2017-06-03 | Bush - Comedown - 2017 live in San Francisco Warfield |
| 2016-08-10 | Sweet Child o Mine - Guns N Roses |
| 2016-08-10 | Welcome to the Jungle - Guns N Roses |
| 2015-10-25 | "Stop" by Jane's Addiction 2015 |
| 2014-06-22 | Pink & No Doubt |
| 2013-01-05 | Strolling |
| 2012-12-24 | Green Day |
| 2012-12-24 | The sea was angry that day my friends |
| 2012-12-24 | Raging River |
| 2012-12-18 | Hunter mentioned on Bloomberg |
| 2012-12-18 | Linkin Park |

A man who ran product at YouTube uses his own YouTube account almost exclusively to post concert
footage he shot from the crowd — Guns N' Roses, Jane's Addiction, Bush, Linkin Park, Pink & No Doubt,
and **Green Day three separate times**. This independently corroborates deep cuts **D** (Madonna 1985,
Beastie Boys, multi-decade fandom) and the vintage-concert-tee collecting. The music thread is the
strongest, most consistent, least-reported personal signal in his entire footprint.

### 2.4 What is NOT retrievable

| Test | URL | Observed |
|---|---|---|
| Instagram public/private? | `https://www.instagram.com/hunterwalk/` | 200, 625 KB shell. `<title>Instagram</title>` (**generic — not "Hunter Walk (@hunterwalk)"**), **no `og:description` at all**, no login-wall markers either. **Cannot determine public vs private; no posts, bio, or follower count retrievable.** |
| Public TikTok? | `https://www.tiktok.com/@hunterwalk` | **Exists but effectively empty — `followerCount: 3`.** |
| LinkedIn activity without login? | `https://www.linkedin.com/in/hunterwalk/recent-activity/all/` | **HTTP 999**, 1,530 bytes of cookie/redirect JS. **No.** |
| Who he follows on X without an account? | `https://x.com/hunterwalk/following` | 200, 293 KB, **zero `screen_name` occurrences**, `"JavaScript is disabled"` notice. **No.** |
| Wikipedia | `en.wikipedia.org/wiki/Hunter_Walk` | **404 — no article.** |
| Crunchbase | `crunchbase.com/person/hunter-walk` | **403.** |
| Hacker News | `news.ycombinator.com/user?id=hunterwalk` | **429**, 6-byte body. Rate-limited. |
| Medium | `medium.com/@hunterwalk` | **403.** |

**The structural asymmetry worth designing around:** every walled garden (LinkedIn, X, Instagram,
Threads, Crunchbase) is opaque, while his two **highest-volume** channels — the WordPress REST API
(1,761 posts, full-text searchable) and the Bluesky XRPC API (573 posts) — are **completely open and
machine-readable with no auth whatsoever**. His Bluesky bio points back at the blog. Of the three
people in this audit, Walk is by a wide margin the most tractable to ingest.

### 2.5 Voice sample

Self-deprecating, all-caps interjections, applies product-manager framing to his own life.
`https://hunterwalk.com/2026/03/29/dont-worry-26-34-41-year-old-friend-in-tech-youre-not-too-old/` (200):
> "Each morning I hand in my too cool GenX card for a few minutes and go STRAIGHT BOOMER while using Facebook to wish my friends a Happy Birthday. That's right Birthday Notifications Product Manager, I'm your 365 DAU."
> "Rarely does it help to tell someone they shouldn't feel the way they do, so dismissing their 'I'm getting so old' without recognizing the power of those thoughts would be ineffective, despite the bluntness of this post's title."

And the register drops to pure fan in the 1985 concert post:
> "AND SHE SPANKED! I mean, it's hard to remember how on fire she was at this time."

---

## 3. Steve Huffman — Reddit (u/spez)

**Headline inversion:** the "crown jewel" source is the *hardest* one. Reddit itself is
**completely closed to logged-out programmatic reads in Sept 2026** — every method failed. His most
open, richest, most quotable durable channel is **the SEC**.

### 3.1 Source inventory

#### The u/spez comment history — direct access is fully blocked

Independently confirmed by me (not just delegated):

| URL | Method | HTTP |
|---|---|---|
| `https://www.reddit.com/user/spez/about.json` | curl, browser UA | **403** (189,908-byte challenge page) |
| `https://www.reddit.com/user/spez/comments.json?limit=100` | curl, UA `arena-hall-audit/1.0` | **403** |
| `https://www.reddit.com/user/spez/comments.json?limit=100` | curl, UA `Mozilla/5.0 (compatible; researchbot/1.0)` | **403** |
| `https://www.reddit.com/user/spez/submitted.json?limit=100` | curl, descriptive UA | **403** |
| `https://old.reddit.com/user/spez/` | curl, browser UA | **200 → redirect** to `/login/?reason=lor2&dest=…` |
| `https://old.reddit.com/user/spez/comments/.json?limit=5` | curl, descriptive UA | **200 but body is `<title>Welcome to Reddit</title>`** — a login page, not JSON |
| `https://www.reddit.com/user/spez/` | **WebFetch** | **Refused at tool level** — "Claude Code is unable to fetch from www.reddit.com" |

**The descriptive-User-Agent trick no longer works.** Reddit 403s regardless of UA. There is **no
logged-out programmatic read path to Reddit at all.**

#### What DID work: web.archive.org

| URL | HTTP | Finding |
|---|---|---|
| `http://web.archive.org/cdx/search/cdx?url=old.reddit.com/user/spez/comments/` | **200** | 10 snapshots, `2019-03-16 → 2025-09-17` |
| `https://web.archive.org/web/20250917173149/https://old.reddit.com/user/spez/comments/` | **200**, 151 KB | **25 parsed comments**, `2025-07-31 → 2025-08-27` |
| `https://web.archive.org/web/20220623234630/https://old.reddit.com/user/spez/comments/` | **200** | **25 parsed comments**, `2021-05-27 → 2022-05-18` — the deep-cut motherlode (§3.3) |
| `https://web.archive.org/web/20190316073422/…` | 200 | **0 comment blocks parsed** — snapshot captured, content did not render. |
| `https://web.archive.org/web/20260309111320/https://www.reddit.com/user/spez/submitted/` | **200**, 576 KB | 2026 submissions incl. the Feb 2026 earnings AMA |
| `https://web.archive.org/web/20260831041255/https://www.reddit.com/user/spez/?solution=…&js_challenge=1&token=…` | **200**, 612 KB | **Freshest readable profile: 2026-08-31.** |

⚠️ **Technique that makes this work** (record it — it is the whole trick): Reddit's Wayback captures
are **useless at the plain archived URL** (you get a ~3.5 KB "Please wait for verification" JS-challenge
page). The captures that contain real content are the ones whose archived URL carries the
**`?solution=…&js_challenge=1&token=…` query string** — the Internet Archive crawler solved the
challenge and archived the post-challenge page. Query CDX *without* `collapse`, then fetch the large
captures. Retry on 503; the Archive intermittently returns "Temporarily Offline."

**Account state, verbatim from the 2026-08-31 archived profile (200):**
> "940,934 · 184454 post karma, 756480 comment karma · Karma · 4,051 Contributions · 21 y · Cake day: Jun 6, 2005 · Reddit Age"

Flair: `Reddit Admin`, `spez has Reddit Premium` (`Reddit Premium · Since July 2015`), bio `Reddit CEO`.
Moderator of r/announcements among others.

**How many comments, how recent?** There is **no way to enumerate the full history**. Across all
snapshots roughly **40–50 distinct comments** were recovered, spanning **2018 → 2026-08**. His newest
verifiable comments are **2026-08-05**. Cadence is bursty, not continuous: a long post every 2–3
months, then he answers replies hard for about an hour, then silence.

#### Reddit's own 2026 posts by u/spez (recovered from archive)

| Date (UTC) | Title |
|---|---|
| 2026-03-25 | Humans welcome, bots must wear name tags |
| 2026-05-05 | Reddit looked old the day it was born. I joined my friend D. Scott Phoenix on the Progress podcast… |
| 2026-06-16 | 21 years of Reddit |
| 2026-08-05 | Modernizing Reddit's infrastructure with you |

#### SEC / EDGAR — wide open, and the richest source

Requires a UA carrying a contact email. **Everything returned 200.**

| Item | URL | HTTP |
|---|---|---|
| Reddit CIK lookup | `https://www.sec.gov/files/company_tickers.json` | **200** — `{'cik_str': 1713445, 'ticker': 'RDDT', 'title': 'Reddit, Inc.'}` |
| Reddit filing index | `https://data.sec.gov/submissions/CIK0001713445.json` | **200**, 76 KB, **478 recent filings**, NYSE |
| Huffman's **personal** CIK | `https://data.sec.gov/submissions/CIK0001827011.json` | **200** — "Huffman Steve Ladd", 88 filings back to 2020-10-01. *(CIK 0001690226, "Huffman Steve," is a different person.)* |
| EDGAR full-text search | `https://efts.sec.gov/LATEST/search-index?q=…&forms=10-Q` | **200** |
| **Q2 2026 earnings 8-K** | `https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm` | **200** |
| Q2 2026 shareholder letter | `…/000171344526000098/exhibit992q226.htm` | **200** |
| **Q1 2026 earnings 8-K** | `…/000171344526000067/earningspressreleaseq126.htm` | **200** |
| Q2 2026 10-Q | `…/000171344526000100/rddt-20260630.htm` | **200** |
| Officer-change 8-K | `…/000171344526000107/rddt-20260812.htm` | **200** |
| His latest Form 4 | `https://www.sec.gov/Archives/edgar/data/1827011/000182701126000038/wk-form4_1788388675.xml` | **200** |

Reddit 2026 filings of substance: 10-K (2026-02-06), DEF 14A (2026-04-23), 10-Q (2026-05-01, 2026-07-31),
8-Ks on 2026-02-05, 04-30, 06-10, 07-30, 08-12.

#### Earnings calls

**Transcripts exist but are NOT retrievable.** The press releases point to `investor.redditinc.com`
and r/RDDT — both blocked (§3.4). **The SEC-filed press release and shareholder letter are the
quotable substitute**, and the shareholder letter is signed by him personally.

#### Everything else

| Channel | URL | HTTP | Notes |
|---|---|---|---|
| Wikipedia | `https://en.wikipedia.org/wiki/Steve_Huffman` | **200**, 322 KB | Exists — unlike Tavel and Walk. |
| Reddit Inc newsroom | `https://redditinc.com/blog` → `/news` | **200** | Fetchable, 35 pages. Company voice, rarely his. |
| Udacity (he taught a course) | `https://www.udacity.com/blog/2012/05/steve-huffman-has-something-to-teach.html` | **200** | Still live. |
| Mixergy interview | `https://mixergy.com/interviews/steve-huffman-reddit-interview/` | **200**, 153 KB | **Full free transcript, ~60 KB.** |
| Progress podcast (May 2026) | `https://www.youtube.com/watch?v=eAu9gTilxA0` | **200** | Metadata + description extractable; **captions empty (4 bytes)**. |
| Investor relations | `https://investor.redditinc.com/` | **403** curl; WebFetch refused | |
| X / @spez | `https://x.com/spez` | **200** | **NOT HIM** — see §3.4. |
| LinkedIn | `https://www.linkedin.com/in/shuffman/` | **999** | Authwall. |
| Instagram | `https://www.instagram.com/spez/` | **200** | Login-gated shell. |
| TikTok | `https://www.tiktok.com/@spez` | **200** | Generic not-found page. |
| Crunchbase / personal site / conference talks | — | — | **UNVERIFIED**; no personal website found. |

### 3.2 Recency probe — Mar–Sep 2026

**Active, not stale.** Four dated items, all opened:

1. **2026-04-30** — Q1 2026 earnings press release, SEC-filed. **I fetched and confirmed this text myself:**
   > "Reddit is a one-of-one business powered by deeply engaged communities and authentic human conversation," said Steve Huffman, Founder and CEO of Reddit. "That foundation is driving a rare combination of growth, profitability, and efficiency, and giving Reddit a unique advantage in the age of AI."

   `https://www.sec.gov/Archives/edgar/data/1713445/000171344526000067/earningspressreleaseq126.htm` (200)

2. **2026-07-30** — Q2 2026 earnings press release, SEC-filed. **Confirmed myself:**
   > "In an increasingly automated web, the value of real human perspective has never been higher. Reddit's commercial momentum reflects that," said Steve Huffman, Founder and CEO of Reddit. "Crossing $1 million in revenue per employee and maintaining eight consecutive quarters of over 60% revenue growth shows the strength of our community model and the value we deliver to advertisers."

   Q2'26: revenue **$805M (+61% YoY)**, net income $253M, DAUq 130.3M, **WAUq 514.6M — "crossing half a billion."**
   `https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm` (200)

3. **2026-08-05** — u/spez, "Modernizing Reddit's infrastructure with you." He reversed his own prior
   promise not to sunset Old Reddit. **I re-fetched the archived profile and confirmed this text myself:**
   > "I love Old Reddit. It's the platform I largely built—as a kid, 21 years ago—that somehow turned into the amazing platform and company we have today. We will preserve as much of it as we can. My dream would be to recreate the UI, if not the guts, including the HTML+CSS itself, on a modern foundation so it can live on (note: Between when I wrote this and when I posted it, u/keysersosa made a demo of exactly this approach. Fingers crossed.)."

   In the same thread, replying to u/shiruken — **confirmed myself in the archived render**:
   > "If we replace every line of code but the output is the same, is it still old Reddit?"

   And to a mod worried the karma/age gates would go before abuse detection was proven:
   > "That's the plan. We're testing it now with a few volunteer mods / subs. Still have some work to do."

   `https://web.archive.org/web/20260831041255/https://www.reddit.com/user/spez/?solution=…&js_challenge=1&token=…` (200)

4. **2026-03-25** — u/spez, "Humans welcome, bots must wear name tags":
   > "The internet feels different lately. It's getting harder to tell who—or what—you're interacting with. But Reddit's purpose is for people to talk to people. And we want it to stay that way."

   His own TL;DR bullet: **"We don't need or want your identity."** Two replies from the same day:
   > "We know, but hear me out, no ID, but you need to send us a copy of your diary."
   > "We'll accept an eyeball."

   `https://web.archive.org/web/20260325225338/https://old.reddit.com/user/spez/comments/1s3ezrc/humans_welcome_bots_must_wear_name_tags/` (200)

*Also dated:* 2026-08-12 8-K — CLO Benjamin Lee resigning effective 2026-09-14, Paul Cappuccio replacing;
filing signed **"/s/ Steven Huffman, President and Chief Executive Officer."** And Reddit was added to
the **S&P 500 effective 2026-08-18** (`https://redditinc.com/news/reddit-will-be-added-to-the-s-p-500`, 200 —
quotes the CFO, not Huffman).

### 3.3 The deep cut

**A. ⭐ The SEC formally designates his shitposting account as a Regulation FD disclosure channel.**
Buried in the boilerplate of every earnings release. **I fetched the Q2 2026 release and confirmed this
sentence character-for-character myself:**
> "Reddit uses the investor relations page on its website https://investor.redditinc.com, user accounts of Reddit's Chief Executive Officer, Steve Huffman (u/spez); Reddit's Chief Operating Officer, Jen Wong (u/adsjunkie); and Reddit's Chief Financial Officer, Drew Vollero (u/TimingandLuck), as well as the subreddits r/RDDT and r/reddit … as means of disclosing material non-public information and for complying with its disclosure obligation under Regulation FD."

`https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm` (200).
The COO's handle is **u/adsjunkie** and the CFO's is **u/TimingandLuck**. Neither is on any first page.

**B. ⭐ The food opinions. He has a fully-worked licorice doctrine.**
From the archived 2022 comment page (`https://web.archive.org/web/20220623234630/https://old.reddit.com/user/spez/comments/`, 200).
**2022-01-07T19:31:11Z, r/ModSupport**, live thread `https://old.reddit.com/r/ModSupport/comments/ryer5p/`:
> "Red vines. I grew up on the east coast with Twizzlers and had a hard time transitioning, but Red Vines are clearly superior. But if you want to know the best licorice, it's Good & Plenty. Jelly Belly's are disgusting, which shouldn't be a controversial statement considering they are designed to be disgusting. Last year at my house we went through a phase where we and some guests ate a lot of Jelly Belly's for about a week. We all got a terrible stomach bug (i.e. both ends at the same time) that we now refer to as "the jelly belly." Never again."

**2021-10-15T21:17:19Z, r/ModSupport** (`https://old.reddit.com/r/ModSupport/comments/q8w59q/`), in full:
> "Cottage cheese is the perfect food."

**2021-09-03T20:26:19Z, r/ModSupport** (`https://old.reddit.com/r/ModSupport/comments/phb2up/`):
> "This poll is flawed. It's missing a middle option, "Coffee is a drug, but I drink it for the side effects and maintaining a coffee addiction isn't too hard." Also, not sure if anyone else had tried this because it's a little weird: put milk in your coffee. It turns coffee from a bitter poison to a delicious balanced meal."

**C. His first concert was Weird Al Yankovic.**
**2022-05-18T19:23:55Z, r/ModSupport** (`https://old.reddit.com/r/ModSupport/comments/usilou/coming_to_you_liveon_a_wednesday/`), in full:
> "It's Reddit and nobody has mentioned Weird Al yet? 'twas my first concert. Maybe not the best, but definitely not the worst."

*(Host note: this pairs beautifully with Hunter Walk's Madonna-1985 post — a ready-made table conversation.)*

**D. He has a Cavapoo and posts in r/CavaPoo about it.**
**2021-06-07T18:44:46Z**, `https://old.reddit.com/r/CavaPoo/comments/nuboco/when_do_you_feel_like_your_cavapoo_reached/h0xuw5y/`:
> "We have an 8 year old puppy. When he's on, he's 100%. He's just on a little less now."

**E. His trophy case — he played r/place, twice, and took the mod certification course.**
Verbatim badge descriptions from the 2026-08-31 archived profile (200), which I read myself:
> "First Placer '22 — Unlocked by placing one of the first tiles on an untouched section of the 2022 r/place canvas."
> "End Game '22 — Unlocked by placing one of the final white tiles on the 2022 r/place canvas."
> "Place '17 — Unlocked by taking part in the 2017 r/place."
> "Mod 101 — Unlocked by completing the online mod course, "Mod 101: Moderator Certification"."
> "ModSupport Helper Level 2 — Unlocked by earning 250 karma and becoming a Helper in r/ModSupport."
> "Not Forgotten — Unlocked by taking part in the 2019 r/gameofthrones Throne Pool event."
> "Spared — Unlocked by being one of those spared in The Snap, also known as The Snappening."
> "Reddit Gifts Exchanges — 2 Exchanges"

The CEO of Reddit sat the moderator certification course and placed both a *first* and a *final* tile
on the 2022 r/place canvas. That is an exceptionally warm, exceptionally non-obvious detail.

**F. Recurring ritual: he does a live AMA in r/RDDT every single earnings quarter.**
Confirmed from the archived 2026-03-09 submissions page (200). His own TL;DR on the Q4'25 post, verbatim:
> "TL;DR: Solid end to a strong year for Reddit. Ask your questions for me, Jen, and Drew in r/RDDT."

And from the post body:
> "Reddit's CEO, Steve Huffman (u/spez); COO, Jen Wong (u/adsjunkie); and CFO, Drew Vollero (u/TimingandLuck) will answer a couple during the Q&A portion of today's conference call and a few more in the comments below later today."

Earlier instance, **2025-07-31T23:21:30Z**, r/RDDT (`https://old.reddit.com/r/RDDT/comments/1mec0sa/reddit_announces_q225_earnings_plus_ama/n698uqf/`):
> "Thank you for this question. We took it on the call. You're exactly right: the folks previously working on user economy will join our efforts to improve the core app, including onboarding and personalization."

**G. He taught a free university-level web-dev course, and used it to tell the real YC rejection story.**
Udacity **CS253 Web Application Engineering**. `https://www.udacity.com/blog/2012/05/steve-huffman-has-something-to-teach.html` (200):
> "This class is a lot of lessons that I learned, on my own, working on Reddit. There were so many pieces to writing web applications and I didn't really understand any of them."
> "We applied to Y-Combinator with a completely different idea from Reddit and were rejected. Then Paul invited me and Alexis back and said, 'If you want to work on something else, we'll fund that, I just don't like your previous idea.'"
> "For a while we were just pretending it was working until it actually started working."

**H. He cried at his desk the day before the Condé Nast sale — and Hacker News exists because Paul Graham lost an argument with him.**
Full free transcript, `https://mixergy.com/interviews/steve-huffman-reddit-interview/` (200):
> "I remember I got really emotional that day. I was sitting there at my desk in Boston, and I just cried. I don't know if I was excited or relieved."
> "He wanted his own Reddit so that he could have that community. We disagreed quite vehemently there to the extent that he built his own version of Reddit."

The one design rule he carried forward:
> "He insisted that we put as much content in the upper left of the page as possible, and I think that was the first time I had heard that idea. And that's what we did. We've done that for all of Reddit, and I do that now in other products like HipMunk that I'm working on."

**I. A May 2026 podcast where he argues human mortality is a good thing.**
**2026-05-05**, *Progress* podcast (channel: Fifty Years) with D. Scott Phoenix, 33:34. Title verbatim:
**"Reddit's CEO: 'We're meant to die' and other things he's right about (Steve Huffman)."** From the
description, verbatim:
> "Steve outlines his unfashionable argument for a future where nothing really changes: that human nature, community, and mortality are constants the future won't (and shouldn't) override."

Listed topics include, verbatim: *"Steve's belief that it's a good thing we are destined to die and be
forgotten"*, *"The reason Steve says please and thank you to ChatGPT"*, *"Why science will eventually
have to apologize to the hippies"*, *"Why Steve is pro Universal Basic Income."*
`https://www.youtube.com/watch?v=eAu9gTilxA0` (200). **Captions returned empty — what he actually says
inside is UNVERIFIED.**

**J. Micro-quirks.**
> "It means I like em dashes. AI had to learn them from somewhere."
> — u/spez, 2025-12-03T18:54:30Z, on being accused of using AI to write a post.

> "The technical term is "Snooling" and yes I have one. It's hard to type out what a great experience it has been so far. And all the clichés are true."
> — u/spez, 2022-02-17T19:00:21Z, on having a baby (Snoo + child). `https://old.reddit.com/r/reddit/comments/suvhyq/reddit_community_values/`

> "I've evolved from a Trickster to a Timid Piece of Shit. My apologies, but it's a better strategy."
> — u/spez, 2022-02-07T17:37:05Z, in **r/PlaySpies**, on his playstyle in the game *Spies*. `https://old.reddit.com/r/PlaySpies/comments/sm4um7/which_type_of_player_are_you/`

**⚠️ On hobbies: no primary source was found for guitar, flying, paragliding, or gearhead interests.
Treat all such claims as UNVERIFIED.** The closest verified personal statement, from Mixergy:
> "My favorite memories are basically the same things that I used to do in college… hanging out with my friends, playing video games or playing cards."

*(Note on the famous stuff: the 2016 comment-editing incident, the New Yorker doomsday-prepper quote,
and the 2023 API protests are all first-page and deliberately excluded above.)*

### 3.4 What is NOT retrievable

| Test | URL | Observed |
|---|---|---|
| Instagram public/private? | `https://www.instagram.com/spez/` | **200**, 625 KB login-gated shell. No `og:title`, no `og:description`, no `is_private` flag, no media edges. **Cannot determine whether the account is public, private, or exists at all.** |
| Public TikTok? | `https://www.tiktok.com/@spez` | **200** but generic `TikTok - Make Your Day` title with a not-found marker and no `og:description`. **No evidence of a Huffman TikTok.** |
| LinkedIn activity without login? | `https://www.linkedin.com/in/shuffman/` | **HTTP 999**, 1,530 bytes, authwall. **Nothing visible logged out.** |
| Who he follows on X? | `https://x.com/spez/following` | **200**, 293 KB, `"JavaScript is not available"`, **zero `UserCell` entries. No.** |
| Reddit investor relations | `https://investor.redditinc.com/` and `/overview/default.aspx` | **403** via curl; **WebFetch refused.** The earnings **webcast replay, full call transcripts, and the r/RDDT community Q&A answers are all unreachable**, though the company says they are published there. |
| Reddit logged-out wall | `old.reddit.com/*`, `www.reddit.com/*.json` | `old.reddit.com` 302s every user/post URL to `/login/?reason=lor2&dest=…`. `www.reddit.com` serves **403 + a 189,908-byte challenge body to any UA** on `.json`. The modern UI emits a ~3.5 KB "Please wait for verification" page to non-browser clients. **No logged-out programmatic read path exists.** |
| Podcast audio | YouTube caption tracks (`fmt=json3`, `srv3`, `vtt`, default) | All returned **4-byte empty bodies.** No transcript. |
| Crunchbase / personal site / conference talks | — | Not located. **UNVERIFIED.** |

**⚠️ THE BIGGEST TRAP IN THIS ENTIRE AUDIT — `@spez` on X is not Steve Huffman.**
I verified this myself via `https://api.fxtwitter.com/spez` (200):
> `name: Щуклин Юрий | followers: 103 | following: 0 | tweets: 0 | joined: Fri Mar 23 2012`

Alternates I also checked myself:
- `https://api.fxtwitter.com/stevehuffman` (200) → `name: Steve Huffman | followers: 38 | following: 24 | tweets: 4 | joined: Wed May 13 2009`
- `https://api.fxtwitter.com/shuffman` (200) → `name: shuffman | followers: 4 | following: 0 | tweets: 17`
- `https://x.com/spez_reddit` → **404**

**None is a CEO-scale account. Huffman has no meaningful X presence.** Any system that maps
"u/spez" → "@spez on X" will attribute a Russian-named account with zero tweets to the CEO of Reddit.
**Hard-code this exclusion.**

### 3.5 Voice sample

The register gap between his SEC prose and his subreddit comments is the most useful thing about him.

**Unguarded, on Reddit (2026-06-16, "21 years of Reddit"):**
> "Reddit turns 21 next week. Funny enough, it's the same age I was when we started it. Save your jokes about r/13or30, I've already heard them."
> "Over the last couple of decades, I've learned that when people gather around shared interests, they act less like performers and more like neighbors (even if sometimes the r/neighborsfromhell kind)."

**Terse, in the wild (2025-08-18, r/redditstock, in full):**
> "I am here, at your service."

and (2025-08-06, r/redditstock, asked how confident he was — the entire comment):
> "Very."

**In SEC-filed prose, signed "Steve Huffman, Co-Founder & CEO" (Q2 2026 shareholder letter,
`https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/exhibit992q226.htm`, 200):**
> "The internet is divided between machines and humans. There is room for both, but we know who we're building for. People will always want to hear from other people: real opinions, expertise, stories, and communities where they can ask, learn, argue, and belong."
> "While our visibility in referral traffic remains low, we're not building for drive-by traffic. We're building a daily destination."

**Candid about his own holdings (2025-08-27, r/redditstock,
`https://old.reddit.com/r/redditstock/comments/1n1o7b3/`):**
> "It was far less than that. I sold a single digit percent of my holdings last year under my plan, and will do so again this year. … Anyway, Jen and I are as committed as ever to Reddit!"

---

## 4. Cross-cutting findings

1. **Owned channels beat platforms, decisively.** Walk's WordPress REST API (1,761 posts, full-text
   searchable, no auth) and Tavel's Substack archive API are the only two sources in this audit that
   allow *enumeration*. Every walled garden — LinkedIn (999 for all three), Instagram (login shell for
   all three), X (JS shell for all three), Crunchbase (403) — yields nothing.

2. **Two of the three have no Wikipedia article.** Tavel **404**, Walk **404**, Huffman **200**. Any
   design that assumes Wikipedia as a baseline biography source fails on 2 of 3.

3. **Recency is wildly uneven and must be measured, not assumed.** Walk: 27 posts in the window.
   Huffman: 4 substantial items, all high-signal. Tavel: **zero owned-channel output in the entire
   window** — she has been silent for 12 months.

4. **Two verified traps to hard-code:**
   - `@spez` on X is a different person (§3.4).
   - Tavel's Aug 2026 podcast episode is a **rerun** of an Apr 2025 recording (§1.2).
   Both would survive a naive pipeline and produce a confidently wrong dossier line.

5. **web.archive.org is not a fallback, it is a primary instrument.** It is the *only* way to read
   u/spez, and the *only* way to read Tavel's 2006–2015 blog — which between them hold the best
   deep-cut material in this entire audit.

6. **A ready-made table pairing:** Hunter Walk's first concert was Madonna in 1985 with the Beastie
   Boys opening and getting booed; Steve Huffman's first concert was Weird Al. Both are documented
   verbatim. Both men are documented music obsessives (Walk's YouTube is 15 concert clips). That is a
   host's opening line, sourced.
