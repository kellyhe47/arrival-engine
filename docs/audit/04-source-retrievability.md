# 04 — Source Retrievability Audit

**Date of testing:** 2026-09-03. All HTTP status codes below were observed personally via `curl` from a
US residential-adjacent egress on this date. Every price or limit is either quoted from the vendor's
own page (URL given) or marked **UNVERIFIED**.

**Method.** `curl -sS -o /dev/null -L --max-time N -w '%{http_code} ct=%{content_type} sz=%{size_download}'`
for reachability; full body fetch + parse for shape. Where a library was the only working path, it was
installed into a clean venv and executed.

**Legend.** GREEN = build on it. YELLOW = works with caveats/keys/fragility. RED = do not build on it.

---

## Tier A — commodity sources

| # | Source | Access path that works TODAY | Auth | Cost | Rate limits | Got 200? shape seen | ToS posture | Verdict |
|---|---|---|---|---|---|---|---|---|
| A1 | **avc.com (Fred Wilson)** | `https://avc.com/feed/` | none | free | none observed | **200**, `application/rss+xml`, 43,368 B, 10 `<item>`, `<content:encoded>` **full text** (max 7,590 chars) | personal blog, standard RSS | **GREEN** |
| A2 | **feld.com (Brad Feld)** | `https://feld.com/feed` → 301 → `https://feld.com/index.xml` | none | free | none observed | **200**, 111,093 B, 20 items, `<content:encoded>` **full text** (max 10,312 chars) | personal blog | **GREEN** |
| A3 | **Hunter Walk** | `https://hunterwalk.com/feed/` | none | free | none observed | **200**, 10 items, `<content:encoded>` **full text** (max 16,055 chars) | personal blog | **GREEN** |
| A4 | Homebrew blog | `https://homebrew.co/feed` → **404**; `homebrew.co/` → 200 (no feed); `blog.homebrew.co` → **TLS cert mismatch** | — | — | — | no feed exists | — | **RED** (use A3 instead) |
| A5 | **Nabeel Qureshi** | `https://nabeelqu.substack.com/feed` | none | free | none observed | **200**, `application/xml`, 410,253 B | Substack public feed | **GREEN** |
| A6 | nabeelqu.co (primary site) | all paths incl. `/` → **429** on both browser and custom UA | — | — | hard-blocks datacenter egress | never got a 200 | — | **RED** from server egress |
| A7 | First Round Review | site-declared feed is `https://review.firstround.com/glossary/rss/` | none | free | none observed | **200**, 190,668 B, 15 items, `content:encoded` max 20,235 — but this is the **glossary**, not the articles | — | **YELLOW** (feed ≠ the content you want) |
| A8 | **Wikipedia / Wikimedia REST** | `/api/rest_v1/page/summary/{title}`, `/w/api.php`, `api.wikimedia.org/core/v1/...` | none (descriptive UA expected) | free | no `x-ratelimit-*` headers returned | **200** ×3. Summary JSON: `title`, `description` ("Australian technology entrepreneur (born 1987)"), `extract`, `timestamp` | CC BY-SA, attribution required | **GREEN** |
| A9 | **Reddit public JSON** | **BROKEN.** See note R below | — | — | — | `www.reddit.com/user/spez/about.json` → **403** (189 KB HTML); `old.reddit.com/**.json` → **302 → `/login/?reason=lor2`** on every UA tried | login-walled | **RED** (keyless JSON) |
| A9b | Reddit `.rss` | `https://www.reddit.com/user/spez/.rss` | none | free | **brutal** — 1st request 200, next 5/5 **429** | **200** once: Atom, 35,789 B | — | **YELLOW** (unreliable) |
| A10 | **SEC EDGAR full-text search** | `https://efts.sec.gov/LATEST/search-index?q=...&forms=...` | none, but **declarative UA mandatory** | free | fair-access policy (10 req/s documented) | **200** JSON, Elasticsearch shape: `hits.total.value`, `hits[]._source{ciks, display_names, form, file_date, adsh, file_type}` | SEC fair access | **GREEN** |
| A10b | EDGAR submissions / XBRL | `https://data.sec.gov/submissions/CIK##########.json` | same | free | same | **200**, 164 KB | — | **GREEN** |
| A11 | **YouTube transcripts** | `youtube-transcript-api` (pip) — **the only method that worked** | none | free | IP-sensitive | **WORKS**: `dQw4w9WgXcQ` → 61 snippets; `5MgBikgcWnY` → 329 snippets | unofficial; YouTube ToS forbids scraping | **YELLOW** (works, unofficial) |
| A11b | YouTube raw `timedtext` scrape | scrape `captionTracks` from watch HTML then GET `baseUrl` | none | free | — | `captionTracks` **present** (6/1/26 tracks on 3 videos) but every `baseUrl` GET returned **200 with 0 bytes** — all of `fmt=`, `json3`, `srv3`, `vtt` | — | **RED** (dead) |
| A11c | YouTube oEmbed | `https://www.youtube.com/oembed?url=...&format=json` | none | free | — | **200**, title/author_name/author_url/thumbnail | official | **GREEN** (metadata only) |
| A12 | **Podcast RSS** | resolve via iTunes Search API → `feedUrl`, then fetch | none | free | none observed | **200** ×4: Acquired 216 items, 20VC 1,504, Lenny's 359, a16z 1,000 | public feeds | **GREEN** (metadata/show notes) |
| A12b | Podcast transcripts **in feed** | `<podcast:transcript>` tag | — | — | — | **Effectively absent.** Only Acquired had any: **2 tags across 216 items**. 20VC, Lenny's, a16z: **0** | — | **RED** |
| A13 | Company newsrooms | mixed — see note N | none | free | — | `redditinc.com/news/rss.xml` **200** (10 items); `usv.com/writing/feed` **200** (6 items, full text); `techstars.com/newsroom` **200** no feed; `canva.com/newsroom/` **403**; `ltse.com` no feed (404 on /feed,/rss) | — | **YELLOW** |
| A14 | **GitHub public API** | `https://api.github.com/users/{u}`, `/events/public`, `/search/users` | none (PAT optional) | free | **measured unauth: core 60/hr, search 10/hr** | **200** ×4 | public API | **GREEN** (add a free PAT) |
| A15 | Wayback Machine | `archive.org/wayback/available?url=` → **200** fast. CDX: **narrow queries only** | none | free | slow | bare `cdx?url=avc.com` **timed out twice (30 s, 0 B)**; `url=avc.com/*&collapse=urlkey&filter=statuscode:200&limit=8` → **200**, CSV-in-JSON array | IA public | **YELLOW** |
| A16 | Google Books | `https://www.googleapis.com/books/v1/volumes?q=` | keyless works in theory | free tier | — | **429** on every attempt: `"Quota exceeded ... for consumer 'project_number:624717413613'"` — keyless callers share one exhausted global quota | — | **YELLOW** (needs own free key) |
| A17 | **Open Library** | `openlibrary.org/search.json`, **`openlibrary.org/search/inside.json`** | none | free | none observed | **200** both. `search/inside.json?q="Brad Feld"` → 46,866 B — **full text search INSIDE scanned books** | open data | **GREEN** |

### Note R — Reddit is the biggest Tier A regression
The widely-cited "just append `.json`" trick is **dead logged-out**. Observed today:
- `https://www.reddit.com/user/spez/comments/.json` → **403** with all three UAs tried (default curl, browser, custom).
- `https://old.reddit.com/user/spez/about.json` → **302**, `location: https://old.reddit.com/login/?reason=lor2&dest=...`
- Same 302 for `/r/{sub}/top.json`, `/search.json`, `/user/{u}/submitted.json`.
- `old.reddit.com` does still emit `x-ratelimit-remaining: 196.0` / `x-ratelimit-reset: 52` headers before redirecting.
- `.rss` is the only keyless survivor and it 429'd on 5 of 6 consecutive requests.

**Implication:** any Reddit signal for Steve Huffman must come from the **official OAuth API** (free tier,
app-only client-credentials token) or be dropped. Budget a Reddit app registration into the build.

### Note N — newsrooms
Feed autodiscovery is worth doing before hand-writing URLs. `https://www.usv.com/` declares two feeds in
`<link rel="alternate">` (`/writing/feed`, `/team-posts/feed`); `redditinc.com/blog` declares
`https://redditinc.com/news/rss.xml`. Canva, Techstars and LTSE declare **none** — those need HTML scraping,
and Canva actively 403s a plain curl.

---

## Tier A (cont.) — Web search & retrieval APIs

| Vendor | Free tier | Lowest paid | Rate limit | Storage allowed? | Verdict |
|---|---|---|---|---|---|
| **Brave Search API** | "$5 in free credits every month" (card required for identity, not charged) | "$5 per 1,000 requests" | "50 queries per second" (Search plan) | **No** — needs a storage-rights plan | **GREEN** |
| **Exa** | "$20 in free credits (around 2,800 searches)" + "$10 in credits every month" | Search "$7 / 1k requests"; Contents "$1 / 1k pages" | UNVERIFIED for free tier | UNVERIFIED | **GREEN** |
| **Tavily** | "1,000 API credits / month", "No credit card required" | "$0.008 / credit" pay-as-you-go | not stated on pricing page | UNVERIFIED | **GREEN** |
| **Serper** | "Get 2,500 free queries", "No credit card required" | per-1k price UNVERIFIED (not on homepage) | UNVERIFIED | UNVERIFIED | **GREEN** |
| **Perplexity Sonar** | none mentioned | Sonar $1/$1 per M tokens + "$5, $8, $12 per 1,000 requests" (low/med/high context) | UNVERIFIED | UNVERIFIED | **YELLOW** |
| **Google Custom Search JSON** | "100 search queries per day for free" | "$5 per 1000 queries, up to 10k queries per day" | 10k/day hard cap | UNVERIFIED | **YELLOW** (100/day is thin) |
| **Bing Web Search API** | — | — | — | — | **RED — RETIRED** |
| **Firecrawl** | "1,000 credits / month", "2 concurrent requests" | Hobby "$16/month" (billed yearly), 5,000 credits | concurrency-based | n/a | **GREEN** |
| **SerpAPI** | UNVERIFIED (page not fetched) | UNVERIFIED | UNVERIFIED | UNVERIFIED | UNVERIFIED |
| **Jina Reader** (`r.jina.ai`) | keyless in theory | — | — | — | **RED from server egress** |

**Bing evidence.** `https://learn.microsoft.com/en-us/bing/search-apis/bing-web-search/overview` now serves
page metadata `is_archived: true`, `is_retired: true`, `ROBOTS: NOINDEX,NOFOLLOW`, and
`canonicalUrl: https://learn.microsoft.com/en-us/previous-versions/bing/search-apis/bing-web-search/overview`.
The exact retirement **date** is **UNVERIFIED** — I could not fetch a date-bearing official announcement.

**Jina Reader evidence.** `https://r.jina.ai/https://avc.com/` → **401**:
> "You have been blocked from performing anonymous queries due to bad network reputation (AS7018). Please authenticate."

**Brave storage clause** (https://brave.com/search/api/):
> "If you would like to store the API results in part or whole (for example, to train or tune an LLM), you will need to subscribe to a plan that explicitly grants storage rights."

This matters: an arrival-digest app that **caches dossiers** is storing results. Budget the storage-rights
plan or cache only your own derived summaries, not raw result payloads.

---

## Tier B — the contested ones

### B1. X / Twitter — **RED for anything beyond profile counters**

**The 2026 pricing model is not tiers any more — it is metered credits.**
From https://docs.x.com/x-api/getting-started/pricing:
> "pay-per-usage pricing. No subscriptions—pay only for what you use."
> "Pay-per-usage plans are capped at 3 million Post reads per monthly billing cycle."

- Post reads **$0.005 per resource**; user/DM-event reads **$0.010**; interaction reads **$0.001**.
- Owned-data reads discounted to "$0.001 per resource (1,000 resources for $1)".
- "All resources are deduplicated within a 24-hour UTC day window."
- No minimum spend stated.

**Logged-out read:** `https://x.com/fredwilson` → **200**, 246,718 B — but the body contains **no tweet text**.
Only `<meta property="og:description" content="I am a VC">`, 20 bare `/status/{id}` links with no bodies, and
zero `__INITIAL_STATE__`. It is a shell.

**Free unofficial mirrors that DO work** — `api.fxtwitter.com/fredwilson` and `api.vxtwitter.com/fredwilson`
both **200**, no auth, and return: `followers: 640854`, `following: 1345`, `tweets: 19911`, `likes: 50114`,
`media_count: 617`, bio, `joined: "Mon Mar 12 10:47:57 +0000 2007"`, location, website, verification.
**Counts only — not the following LIST.**

**Nitter is dead.**
- `nitter.net` → 200 but the page is `<meta name="description" content="nitter.net is offline.">`
- `xcancel.com` → 321-byte notice, quoted verbatim:
  > "On Monday 24th August at 8PM EST, we received at letter from X Corp. asking to cease and desist the service XCancel. The service XCancel is stopped until further notice."
- `nitter.tiekoetter.com` 429 · `nitter.kavin.rocks` 502 · `lightbrd.com` 403 · `nitter.space` 403 · `nitter.privacyredirect.com` 404 · `nitter.1d4.us`, `nitter.moomoo.me`, `nitter.poast.org` DNS/connection failure.

**Following list:** only via `GET /2/users/:id/following` (confirmed to exist in docs). Priced as user reads at
**$0.010/resource** → Fred Wilson's 1,345 following ≈ **$13.45 per full pull**, per 24-hour dedup window.
Ten members × monthly refresh is real money for a hobby project. Per-endpoint access-level gating is
**UNVERIFIED** (docs pages did not state it).

### B2. LinkedIn — **RED**

**Logged-out read:** `https://www.linkedin.com/in/reidhoffman/` returned **HTTP 999** (LinkedIn's block code),
1,530 bytes, `authwall`, on **5 of 5** consecutive attempts. (One earlier request returned a 200/818 KB body —
not reproducible; treat as a cache artifact, not an access path.)
`https://www.linkedin.com/in/melanieperkins/` → **999** immediately.

**Programmatic access for a non-partner:** none for third-party profile data. Per
https://learn.microsoft.com/en-us/linkedin/, the only **self-serve** items are under Consumer Solutions —
"Sign in with LinkedIn using OpenID Connect", "Share on LinkedIn", "Plugins", "Verified on LinkedIn". Marketing,
Talent, Sales and Learning Solutions all route through "Apply for Access" / "Request Access" partner programs.
**No API returns an arbitrary third party's profile.**

**User Agreement, "Don'ts"** (https://www.linkedin.com/legal/user-agreement), verbatim:
> Clause 2: "Develop, support or use software, devices, scripts, robots or any other means or processes (such as crawlers, browser plugins and add-ons or any other technology) to scrape or copy the Services, including profiles and other data from the Services"
> Clause 13: "Use bots or other unauthorized automated methods to access the Services..."

**hiQ v. LinkedIn — the part everyone gets wrong.** The Ninth Circuit (2019, reaffirmed April 2022 after the
Supreme Court vacated and remanded in light of *Van Buren v. United States* (2021)) held only that scraping
**public** data likely does not violate the **CFAA**'s "without authorization" prong. That is a criminal-statute
holding, not a licence. In **November 2022 the N.D. Cal. district court granted LinkedIn summary judgment that
hiQ had breached the User Agreement**, and the case ended in a consent judgment with a **permanent injunction
against hiQ**; hiQ's business did not survive. *Verbatim quotes of the Nov-2022 order and the consent judgment
are* **UNVERIFIED** — CourtListener's docket returned **403** to my fetch.

**Practical takeaway:** CFAA is not the barrier. **Breach of contract is**, and LinkedIn wins it. Plus HTTP 999
means you cannot get the bytes anyway. Do not build on LinkedIn.

### B3. Instagram — **RED**

**Logged-out:** `https://www.instagram.com/melanieperkins/` → **200**, 625,519 B, and the body contains
**zero** occurrences of `edge_owner_to_timeline_media`, `og:description`, `biography`, `"shortcode"`,
`profile_pic_url`, or `PolarisQueryPreloader`. `<title>` is the bare string `Instagram`. It is a pure JS shell
with no server-rendered profile data. `…/api/v1/users/web_profile_info/?username=melanieperkins` → **400**.

**Graph API for non-owned accounts:** `business_discovery` still exists
(https://developers.facebook.com/docs/instagram-platform/instagram-graph-api/business-discovery) — "Get basic
metadata and metrics about other Instagram professional accounts" — but it is queried
"on the app user's Instagram professional account ID" using "YOUR_APP_USERS_INSTAGRAM_USER_ACCESS_TOKEN".
So it requires **you to own a professional IG account**, and the target must also be a **professional** account
(personal and age-gated accounts return nothing). Our ten stand-ins are mostly not IG professional accounts.

**Meta ToS** (https://www.facebook.com/terms.php) §3.2(3), verbatim:
> "You may not access or collect data from our Products using automated means (without our prior permission) or attempt to access data you do not have permission to access, regardless of whether such automated access or collection is undertaken while logged-in to a Facebook account."

Note the "regardless of whether ... logged-in" — a logged-in scraper is explicitly covered.

### B4. TikTok — **RED**

**Logged-out:** `https://www.tiktok.com/@tiktok` → **200**, 369,305 B. `__UNIVERSAL_DATA_FOR_REHYDRATION__`
**is** present and does carry real data (`"followerCount":95600000`, an `itemList` key) — so it is technically
parseable, **but the same body contains 25 occurrences of `captcha`**, i.e. you are one heuristic away from a
challenge wall on any sustained crawl.

**Research API eligibility** (https://developers.tiktok.com/products/research-api/) — a hobby app is excluded
by definition:
> "Academic institutions in the U.S., EEA, UK, Canada, or Switzerland" or "Not-for-profit and/or independent research institution, organization, association, or body in the EU"
> "Independent of commercial interests and able to conduct research on a not-for-profit or non-commercial basis"
> "Evidence that the research has undergone an ethical review"

Approval "within 4 weeks of submission", then access only via a Virtual Compute Environment. The Display API
covers only the authenticated user's own content.

### B5. Facebook — **RED**

`https://www.facebook.com/zuck` logged out → **HTTP 400**, 1,542 B, `<title>Error</title>`. Not readable.
Page Public Content Access requires App Review plus Business Verification (approval scope **UNVERIFIED** —
docs page not fetched). Same Meta ToS §3.2 quoted above applies.

### B6. Dating apps — **RED. Non-starter.**

There is no public or programmatic API for Tinder, Hinge or Bumble; all three gate everything behind an
authenticated mobile client, and their terms prohibit automation and scraping (specific clause text
**UNVERIFIED** — I did not fetch the three terms pages). Beyond ToS, this is the wrong call on the merits:
dating-profile data routinely implies **sexual orientation**, which is special-category personal data under
GDPR Art. 9 and requires explicit consent that a third-party club app cannot obtain. Even if it were
technically reachable, a "who should you meet" product that ingests dating profiles is a privacy incident
waiting to be written up. **Do not design for this. Do not prototype it.**

---

## Tier C — the creative ones (18 verified, 12 GREEN)

| # | Source | Endpoint tested | Auth | Cost | Got 200? shape | Verdict |
|---|---|---|---|---|---|---|
| C1 | **Hacker News (Algolia)** | `hn.algolia.com/api/v1/search?tags=comment,author_spez` | none | free | **200**. `nbHits: 67`; hits carry `author`, `created_at`, `story_title`, `objectID`, full `comment_text` | **GREEN** |
| C2 | **HN user profile** | `news.ycombinator.com/user?id=spez`; `hacker-news.firebaseio.com/v0/user/sama.json` | none | free | **200** both. karma 615, created, about | **GREEN** |
| C3 | **FEC (OpenFEC)** | `api.open.fec.gov/v1/schedules/schedule_a/?contributor_name=` | api.data.gov key (free) | free | **200**. `count: 413`; rows give `contributor_name`, `contributor_employer`, `contributor_occupation`, `contributor_city`, `contribution_receipt_date`, `contribution_receipt_amount`, `committee.name` | **GREEN** |
| C4 | **CourtListener** | `courtlistener.com/api/rest/v4/search/?q="Brad Feld"` | none (keyless worked) | free | **200**. `caseName`, `dateFiled`, `court`, `docketNumber`, `absolute_url` | **GREEN** |
| C5 | **ProPublica Nonprofit Explorer** | `/api/v2/search.json?q=`, `/api/v2/organizations/{EIN}.json` | none | free | **200** both. search → `total_results: 11`, `ein`/`name`/`city`/`state`/`income_amount`; org → `filings_with_data[]` | **GREEN** |
| C6 | **OpenAlex** | `api.openalex.org/authors?search=Eric%20Ries` | none (`mailto=` polite pool) | free | **200**. `display_name: "Eric Ries"`, `works_count: 51`, `cited_by_count: 4593` | **GREEN** |
| C7 | **Crossref** | `api.crossref.org/works?query.bibliographic=` | none (`mailto=`) | free | **200**. `title`, `DOI`, `type`, `published.date-parts` | **GREEN** |
| C8 | **arXiv** | `export.arxiv.org/api/query?search_query=` | none | free | **200**, `application/atom+xml` | **GREEN** |
| C9 | **Open Library `search/inside`** | `openlibrary.org/search/inside.json?q="Brad Feld"` | none | free | **200**, 46,866 B — **full-text search inside scanned books**. This is the book-acknowledgements play | **GREEN** |
| C10 | **Internet Archive search** | `archive.org/advancedsearch.php?q="Brad Feld"&output=json` | none | free | **200**, `numFound: 17`, docs give `identifier` + `title` (e.g. a podcast ep. "Venture Capitalist Brad Feld on How Nietzsche Empowers the Entrepreneur") | **GREEN** |
| C11 | **Wikidata** | `wbsearchentities` + `query.wikidata.org/sparql` | none | free | **200** both (`application/sparql-results+json`) | **GREEN** |
| C12 | **iTunes Search API** | `itunes.apple.com/search?term=&entity=podcast` | none | free | **200**. Resolves any show name → `feedUrl`. This is the universal podcast-RSS resolver | **GREEN** |
| C13 | **Federal Register** | `federalregister.gov/api/v1/documents.json` | none | free | **200** | GREEN (low relevance) |
| C14 | **Congress.gov** | `api.congress.gov/v3/bill?api_key=DEMO_KEY` | free key | free | **200** | GREEN (low relevance) |
| C15 | **Goodreads (HTML)** | `goodreads.com/search?q=Brad+Feld`, `/author/show/4395710.Brad_Feld` | none | free | **200**, server-rendered: `bookTitle` ×11, `ratingValue`, real author IDs and book slugs (`/book/show/11865558-venture-deals`) | **YELLOW** (scrape; API retired 2020) |
| C16 | **Companies House (UK)** | web search **200**; `api.company-information.service.gov.uk` → **401** | free key | free | web readable | **YELLOW** |
| C17 | **Awards / rankings indexes** | `webbyawards.com/winners/` **200**; `forbes.com/midas/` **200**; `schedule.sxsw.com/` **200**; `ted.com/speakers` **200** | none | free | HTML only, no APIs | **YELLOW** (scrape) |
| C18 | **Google Patents** | `patents.google.com/?inventor=` → **200** but 4,149 B (JS shell) | none | free | not server-rendered | **YELLOW** |

### Tier C sources that FAILED verification

| Source | Observed | Why it fails |
|---|---|---|
| **Strava public profiles** | `strava.com/athletes/2304939` **200** but 577 KB **login wall** — "Log In" ×57, "Sign Up" ×91, `athlete-name` ×0, `Recent Activity` ×0. `/clubs/1` returned a near-identical 576 KB body | login-walled |
| **Letterboxd member pages** | `/crew/` **403**; `/members/popular/` 200; film pages 200 | member data blocked |
| **Product Hunt** | `producthunt.com/@rrhoover` **403**; `api.producthunt.com/v2/api/graphql` **404** on GET | needs OAuth |
| **Crunchbase** | API **401**; `crunchbase.com/organization/canva` **403** | paid only |
| **OpenCorporates** | `api.opencorporates.com/v0.4/companies/search` **401**; web page 200 but 1,536 B | paid key |
| **Semantic Scholar** | **429** keyless, twice: "Too Many Requests... or apply for a key" | needs free key |
| **PodcastIndex** | `api.podcastindex.org` **401** | needs free key + HMAC |
| **ListenNotes** | `api.listennotes.com/api/v2/search` **404** keyless | needs key |
| **regulations.gov** | **403** | needs key |
| **Case.law (CAP)** | `api.case.law/v1/cases/` returns **HTML**, not JSON | project retired |
| **PatentsView** | `api.patentsview.org` and `search.patentsview.org` → **DNS failure** | endpoint moved/dead |
| **USPTO PEDS** | `ped.uspto.gov` → **DNS failure** | retired |
| **Substack recommendation graph** | `/api/v1/recommendations/from/publication` **400**; `api.substack.com/api/v1/publication/home/recommendations` **404** | no public endpoint found; the `/recommendations` HTML page renders (154 KB) so scraping is the only route |

---

## Cross-cutting operational findings

1. **Declarative User-Agent is load-bearing on SEC.** `data.sec.gov` with an empty UA → **403**; with
   `ArenaHall kellyqhe47@gmail.com` → **200**. Set a contact UA globally.
2. **EDGAR full-text search only covers 2001 onward.** A `1995-01-01`→`2000-12-31` query for "Fred Wilson"
   returned `hits.total.value: 0` while the unbounded query returned real 2001 hits. Do not expect
   dot-com-era filings from FTS.
3. **The `DEMO_KEY` on api.data.gov is 10 requests/hour** (measured: `x-ratelimit-limit: 10`,
   `x-ratelimit-remaining: 7`). Get a real free key before writing any FEC code.
4. **Unauthenticated GitHub is 60 req/hr core and 10 req/hr search** (measured from `/rate_limit`). Ten
   members × several calls each will exhaust search in one refresh. Use a PAT.
5. **Feed autodiscovery beats guessing.** Three of my hand-guessed feed URLs 404'd while the correct URL was
   sitting in a `<link rel="alternate" type="application/rss+xml">` tag on the homepage. Always parse the
   homepage first.
6. **Keyless "shared quota" APIs are a trap.** Google Books returned 429 attributed to
   `project_number:624717413613` — someone else's exhausted quota. Same class of failure for Semantic Scholar
   and Jina Reader (the latter blocking my whole ASN). Anything keyless-but-shared must have a keyed fallback.

---

## RECOMMENDED STACK

Eight sources, ordered by signal per unit of build time. All are GREEN or GREEN-with-a-free-key, all returned
200 today, and together they cover all ten stand-in figures.

1. **Personal-blog RSS with `content:encoded`** — avc.com, feld.com, hunterwalk.com, nabeelqu.substack.com,
   usv.com/writing/feed. One parser, full article text, zero auth, zero cost. This is the single highest-yield
   source and it directly serves the "one fact not on the first page of search" requirement, because a
   2019 post buried at item 400 of an archive is exactly that.
2. **Wikipedia REST summary + `w/api.php` extracts** — instant reliable spine (name, one-line description,
   canonical bio) for every figure. Free, no key, no rate limit observed.
3. **Hacker News Algolia API** — free, keyless, and returns *full comment text* by author. Huffman, Shear and
   Qureshi all have real HN histories. Verbatim comments are the best "something a host could say out loud"
   raw material in the whole audit.
4. **SEC EDGAR FTS + `data.sec.gov`** — free, structured, and genuinely non-obvious. Form 4s, SC 13Ds and S-1
   exhibits name individuals and board seats that no profile page lists. Costs one UA header.
5. **YouTube transcripts via `youtube-transcript-api` + oEmbed for metadata** — the only working transcript
   path, and podcast/conference talks are where these people speak unguardedly. Pin the library version and
   expect IP sensitivity.
6. **Podcast RSS via iTunes Search → `feedUrl`** — show notes and episode descriptions are rich and free.
   Do **not** plan on `<podcast:transcript>`; pair with #5 for the YouTube versions of the same interviews.
7. **One paid-ish search API — Brave or Tavily** — Brave for its $5/mo free credits and 50 qps; Tavily for
   1,000 credits/mo with no card. Use it for gap-filling only, and read Brave's storage clause before caching
   raw results.
8. **Open Library `search/inside` + Internet Archive advancedsearch** — the deep-cut mining layer.
   Full text *inside books* finds acknowledgements, blurbs and passing mentions that no web search surfaces.
   This is where the "not on the first page" fact actually comes from.

**Two cheap add-ons if time allows:** FEC OpenFEC (political donations, with a free key — surprising, specific,
verifiable) and ProPublica Nonprofit Explorer (board seats and officer compensation on 990s).

**Total marginal cost: $0–5/month.** Total auth setup: one SEC UA string, one GitHub PAT, one api.data.gov key,
one Brave or Tavily key.

---

## DO NOT BUILD ON

| Source | Reason |
|---|---|
| **LinkedIn** | HTTP **999** authwall on 5/5 attempts — you cannot get the bytes. No self-serve API returns third-party profiles. User Agreement §"Don'ts" cl. 2 expressly bans scraping profiles. And the case everyone cites as permission, *hiQ*, ended with hiQ **losing on breach of contract** and eating a permanent injunction. Wrong on access, wrong on law. |
| **Instagram** | Logged-out page is a 625 KB JS shell with **zero** profile data server-rendered; `web_profile_info` → 400. `business_discovery` needs *you* to own a professional account and only reads *other professional* accounts. Meta ToS §3.2(3) bans automated collection "regardless of whether ... logged-in". |
| **Facebook** | `facebook.com/zuck` → **HTTP 400** logged out. Page Public Content Access requires App Review + Business Verification. Same ToS clause. |
| **TikTok** | Research API is academic/non-profit-only with an ethics-review requirement and a 4-week approval; a club concierge app is categorically ineligible. The public page is parseable but ships **25 `captcha` references** — it will wall you under load. |
| **X/Twitter timelines & following lists** | Logged-out HTML carries **no tweet text**. Nitter is **dead** — `nitter.net` self-reports offline and `xcancel` was shut down by an X Corp cease-and-desist letter dated Monday 24 August. The only legitimate path is metered: **$0.005/post read, $0.010/user read, capped at 3M post reads/month**. Fred Wilson's following list alone is ~$13.45 per pull. *(Narrow exception: `api.fxtwitter.com` / `api.vxtwitter.com` return follower/following **counts** and bio free and unauthenticated — fine as a low-stakes profile stat, useless for content.)* |
| **Dating apps** | No public API, ToS prohibit automation, and the data implies GDPR Art. 9 special-category personal data. This is a legal, ethical and reputational non-starter regardless of technical feasibility. Cut it from the design. |
| **Reddit keyless `.json`** | The classic trick now **302s to `/login`** (old.reddit) or **403s** (www.reddit) on every UA. `.rss` survived exactly one request before 429ing 5/5. Use the official OAuth app or drop Reddit. |
| **YouTube raw `timedtext` scraping** | `captionTracks` are still in the watch HTML, but every `baseUrl` fetch returns **200 with 0 bytes** across `fmt=json3/srv3/vtt`. Use the library instead. |
| **Bing Web Search API** | Microsoft Learn now serves the docs page with `is_retired: true`, `is_archived: true`, canonicalised under `/previous-versions/`. Retired. |
| **Jina Reader (anonymous)** | **401** — "blocked from performing anonymous queries due to bad network reputation (AS7018)". Needs a key from any cloud/datacenter egress. |
| **Podcast in-feed transcripts** | 2 `<podcast:transcript>` tags across 216 Acquired episodes; **0** across 20VC (1,504), Lenny's (359) and a16z (1,000). The tag exists in the spec and effectively not in the wild. |
| **PatentsView / USPTO PEDS / Case.law** | `api.patentsview.org`, `search.patentsview.org` and `ped.uspto.gov` all fail **DNS resolution**; `api.case.law` returns HTML. These endpoints are gone — any tutorial recommending them is stale. |
