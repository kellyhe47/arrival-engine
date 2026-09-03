# Audit 01 — Measured public footprint: Fred Wilson, Brad Feld, Josh Kopelman

**Audit date:** 2026-09-03
**Method:** every URL below was fetched with `curl` (real HTTP status codes recorded) or, where noted, `WebFetch`. Search-engine snippets were used ONLY to discover candidate URLs and are never cited as sources. Every quoted string was read out of a page or feed body that was actually retrieved. Anything not directly observed is marked **UNVERIFIED**.

**User-Agent used for all fetches:** `Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36`

---

## Cross-cutting measurement notes (apply to all three)

These were tested per-person and produced the same result each time, so they are stated once:

| Probe | Observed |
|---|---|
| `https://x.com/<handle>` | HTTP 200, but the body is a JavaScript shell. The **only** extractable text is the `<title>` tag (e.g. `Fred Wilson (@fredwilson) / X`). No tweets, no dates, no follower/following counts. |
| `https://x.com/<handle>/following` | HTTP 200. Body strips to: *"JavaScript is not available. We've detected that JavaScript is disabled in this browser…"* — **the following list is not readable without an account.** |
| `https://www.instagram.com/<handle>/` | HTTP 200, ~625 KB, but the body strips to the single word `Instagram` with **zero** `og:` metadata. Public-vs-private **cannot be determined** unauthenticated. |
| `https://www.tiktok.com/@<handle>` | HTTP 200, ~367 KB, body strips to `TikTok - Make Your Day`. No profile data. Existence unconfirmed either way. |
| `https://www.linkedin.com/in/<handle>/recent-activity/all/` | **HTTP 999** (LinkedIn's bot-block code), 1,530 bytes, empty body. Activity feed is **not readable without login** for all three. |
| `https://www.crunchbase.com/person/<slug>` | **HTTP 403**, Cloudflare `Attention Required!` interstitial. Blocked for all three. |
| `https://en.wikipedia.org/w/index.php?title=<X>&action=raw` | HTTP 200 for all three — raw wikitext is fully retrievable and is the most reliable structured biographical source available. |

---

# 1. Fred Wilson (Union Square Ventures)

**Verdict: the most misleading footprint of the three. The canonical source — AVC.com, 9,046 posts over 20 years — is a frozen archive. He moved his live blog onchain in May 2024, cut his output ~26x, and is now most machine-readable through a blockchain name registry and an SEC filing rather than through any social platform.**

## 1.1 The structural fact that reframes everything

`https://avc.com/feed/` (HTTP 200) has as its newest item **"I've Moved Onchain", Thu, 02 May 2024**. From that post (`https://avc.com/2024/05/ive-moved-onchain/`, HTTP 200), verbatim:

> "AVC.com has been my home for blogging for over twenty years. … These web3 blogging platforms store all of my posts onchain at Arweave. These posts are available to anyone to read regardless of what blogging platform I use. And **if I get abducted by an alien and fail to pay my hosting service, they will still exist onchain. Forever.** That's a huge deal to me."
> "**I do not plan to post here at AVC.com going forward**, but I will keep the archive up and I may choose to cross-post a thing or two here whenever I want to reach the broadest audience."

Any pipeline that scrapes "Fred Wilson's blog" and lands on avc.com is reading a corpse. **His live blog is `https://avc.xyz/`** (Paragraph, stored on Arweave).

## 1.2 Source inventory

| Channel | URL fetched | Status | Feed | Volume / cadence |
|---|---|---|---|---|
| **AVC.com (frozen archive)** | `https://avc.com/` | 200 (79,174 B) | `https://avc.com/feed/` → **200, fetched OK**, 10 items, newest **2024-05-02** | **9,046 posts** — counted exactly by summing `<url>` elements across `post-sitemap.xml` … `post-sitemap10.xml` (1001+1000×8+45). Sept 2003 → May 2024 ≈ **1.2 posts/day for 20.7 years.** |
| **AVC archive index** | `https://avc.com/archives/` → **404**. Real URL is **`https://avc.com/archive/`** | 200 (124,318 B) | n/a | Exposes per-category counts (see 1.4 — deep cut D) |
| **AVC year/month indexes** | `https://avc.com/2008/`, `/2011/`, `/2015/`, `/2020/`, `/2011/03/` | all 200 | n/a | Fully browsable. `avc.com/2025/12/` → 404 (correct — nothing after May 2024). |
| **AVC on-site search** | `https://avc.com/?s=<query>` | 200 | n/a | Works; returns dated result summaries. Best tool for mining the archive. |
| **avc.xyz (live blog)** | `https://avc.xyz/` | 200 (266,507 B) | `https://avc.xyz/feed` → 302 → **`https://api.paragraph.com/blogs/rss/@avc.xyz`** → **200, 107,829 B, fetched OK**, 20 items with **full `content:encoded`** | Rolling 20-item window, currently **18 Dec 2025 → 23 Jul 2026**. `https://avc.xyz/archive` → **404**; no index page exists, so a total post count for avc.xyz **cannot be determined**. |
| **avc.mirror.xyz (former home)** | `https://avc.mirror.xyz/` | **403 blocked** | n/a | His 2021–2023 posts. Unreadable. |
| **USV firm site** | `https://www.usv.com/` | 200 | `https://www.usv.com/feed/` → **200**, 6 items | **None of the 6 are by Fred** (authors: Michael Mignano, Albert Wenger, Nikhil Raman, Rebecca Kaden, Nick Grossman). |
| **USV author archive** | `https://www.usv.com/people/fred-wilson/` | 200 | n/a | **His last USV post is "Twelve Days In Korea and Japan", Oct 8, 2024.** Nothing since. |
| **USV podcast** | `https://www.usv.com/podcast` and `/podcasts/` | **both 404** | — | **No USV podcast exists.** No current-2026 Fred Wilson podcast found. |
| **YouTube (USV)** | `https://www.youtube.com/@unionsquareventures` | 200 | n/a | `og:title` "USV", **610 subscribers.** Dormant. |
| **YouTube (@fredwilson)** | `https://www.youtube.com/@fredwilson` | 200 | n/a | ⚠️ Channel `UCHHUu9VCZ3lyfOBnmSOWHvw` exists but `channelMetadataRenderer` has `"description":""` and `"keywords":""`. **Cannot attribute to him. UNVERIFIED.** |
| **GitHub** | `https://github.com/fredwilson` | 200 | n/a | ⚠️ **0 repositories, 0 projects, 1 follower, no bio, no website.** An empty shell. **Not usable as evidence.** Notable given his Jan 2026 post *"I'm Coding Again"* — whatever he's building is not here. |
| **Books** | — | — | — | **None.** Wikipedia (200) has no bibliography section and makes no authored-work claim; AVC's own `Books (54)` category is him reviewing other people's books. Negative finding from the two sources most likely to carry it. |
| **Newsletter** | `https://avc.xyz/` footer | 200 | n/a | Paragraph's email subscribe **is** the newsletter. He wrote in the 2024 post: "I took everyone who receives an email when I post here at AVC.com and imported that email list to Paragraph.xyz." No separate list. |
| **Wikipedia** | `https://en.wikipedia.org/wiki/Fred_Wilson_(financier)` | 200, 7,162 B wikitext | n/a | Thin. |
| **Farcaster** | `https://farcaster.xyz/fredwilson` → 200 but a 3,736 B JS shell. **BUT** `https://api.warpcast.com/v2/user-by-username?username=fredwilson` → **200, full JSON** and `https://fnames.farcaster.xyz/transfers?name=fredwilson` → **200** | 200 | The one social platform whose wall has a door. See deep cut A. |
| **SEC / EDGAR** | `browse-edgar?...company=union+square+ventures&type=D` (with UA header) → 200 | 200 | n/a | Two CIKs: **0001532179** and **0001508427** ("Union Square Ventures Opportunity Fund LP", **Form D** filed 2010-12-28). |
| **SEC / IAPD** | `https://api.adviserinfo.sec.gov/search/firm?query=union%20square%20ventures` | 200 | n/a | `firm_source_id 162375`, **SEC # 802-75126**, scope **ACTIVE**, disclosures **"N"**, address **817 Broadway, 14th Floor, New York, NY 10003**. |
| **SEC / Form ADV (PDF)** | `https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf` | **200, 6,667,899 B, downloaded and parsed with `pdftotext`** | n/a | See deep cut E. |
| **Joanne Wilson / "The Gotham Gal" (wife)** | `https://gothamgal.com/` | 200 (108,528 B) | `https://gothamgal.com/feed/` → **200, 52,560 B, fetched OK** | **Posting near-daily. Newest: "Why?" — Thu, 27 Aug 2026.** See 1.4. |
| **Crunchbase** | `https://www.crunchbase.com/person/fred-wilson` | **403** | n/a | Blocked |

## 1.3 Recency probe (Mar–Sep 2026) — **thin, and decelerating**

Feed re-fetched on audit date: **newest post is still "The Clarity Act", Thu, 23 Jul 2026 10:59:00 GMT — 42 days stale.**

**Item 1 — Jul 23, 2026**, `https://avc.xyz/the-clarity-act`:
> "My partners at USV and I have been investing in the crypto industry for fifteen years without the benefit of clearly written rules on what is allowed and what is not. **I have been sued, dragged into the basement of the SEC and interrogated, threatened, and more.** … The current version of the Clarity Act is far from a perfect bill. I could tell you a dozen things that are wrong with it. And yet I support this legislation with everything I've got because I believe we need rules and we need them badly."

**Item 2 — Jun 24, 2026**, `https://avc.xyz/my-pele-agent`:
> "I've been playing around with agent harnesses since OpenClaw dropped at the start of the year. I've been particularly interested in agents who have money and can transact for me. So I've been doing the classic Chris Dixon weekend hobby thing and hacking around on fun stuff that isn't the least bit mission-critical to anyone."

**Item 3 — Jun 3, 2026**, `https://avc.xyz/usv-analyst-20`:
> "And we paused our longstanding analyst program last year and saw how far we could get with agent analysts instead of humans analysts. That experiment was incredibly successful and we got a very long way without human analysts but **in the end we concluded we could not get all the way without them.** … Humans are going to be better at being human for the foreseeable future."

**Item 4 — Aug 18, 2026 (Farcaster — his most recent public utterance, 26 days newer than the blog):**
> "Hi Casters. If you care about the future of Farcaster and have an interest in being a steward of it going forward, read Rish's post below"
> — cast timestamp `2026-08-17T18:36:13Z` via `api.warpcast.com/v2/casts?fid=169`; follow-ups at 18:42:32Z and `2026-08-18T09:39:04Z`.

### The cadence collapse, quantified

| Era | Posts | Rate |
|---|---|---|
| AVC.com, Sep 2003 – May 2024 (~7,550 days) | **9,046** (sitemap count) | **~1.2/day** |
| avc.xyz, Jan 1 – Jul 23, 2026 (204 days) | **17** | **~2.4/month** |
| avc.xyz, Feb 1 – Jul 23, 2026 (173 days) | **8** | **~1.4/month** |

**~26x drop**, and decelerating within 2026: January had **9** posts; February **1**; March **4**; **April: zero**; May **1**; June **1**; July **1**. The feed window reaches back to 18 Dec 2025, so January is fully covered — this is not a truncation artifact.

The irony is in his own archive. `https://avc.com/2018/10/navigating-blogging-across-time-zones/` (HTTP 200, Oct 22, 2018):
> "**I am a big fan of a routine, a ritual, a cadence. That is partly why I blog every day**, and that is why I like the blog to come out at roughly the same time every day."

## 1.4 The deep cut

### Deep cut A — **He is Farcaster user #169, was personally referred onto the protocol by its co-founder, and his four-word bio is "I am a VC."**

Verified directly against two independent public APIs (I re-ran both myself):

`https://fnames.farcaster.xyz/transfers?name=fredwilson` → **HTTP 200**, verbatim:
```json
{"transfers":[{"id":169,"timestamp":1632237731,"username":"fredwilson",
"owner":"0x6e6dc9975c7b820c235649924b4ab20068100e76","from":0,"to":169, ...}]}
```
Unix `1632237731` = **21 September 2021** — he registered ~2.5 years *before* he shut AVC.com down.

`https://api.warpcast.com/v2/user-by-username?username=fredwilson` → **HTTP 200**:
- `"fid":169` — Farcaster FIDs are sequential from launch, so he is roughly the **169th account ever created on the protocol**
- `"bio":{"text":"I am a VC"}` — the entire bio
- `"followerCount":14732`, `"followingCount":254`
- `"referrerUsername":"dwr"` — **referred by Dan Romero**, Farcaster's co-founder
- `"earlyWalletAdopter":true`
- **His blog brand is a tradeable ERC-20 on Base:** `"name":"AVC","ticker":"AVC","symbol":"AVC"`, contract `0x06fc3d5d2369561e28f261148576520f5e49d6ea`

And he uses it conversationally, not as a broadcast pipe. **25 Jun 2026, 16:02:33 UTC:**
> "i have been discussing one final bet with my Pele agent and it's come down to Brazil vs England. I've already got France, Spain, Argentina as favorites and Netherlands, Portugal, and Germany as long shots. Any advice for…"

*(He is crowdsourcing betting advice to feed an autonomous agent holding $1,500 of his money.)*

### Deep cut B — **The Pele agent: an old Mac Mini from his storage basement, wiped, given a Solana wallet with $1,500, betting the World Cup. It has spent $21.84 on tokens and he is losing.**

`https://avc.xyz/my-pele-agent` (HTTP 200, Jun 24, 2026), verbatim:
> "1/ **I took an old Mac Mini that was gathering dust in my storage basement and did a factory reset on it.** I did not connect to iCloud or Google Mail on it so I could explicitly control what the agent has access to."
> "5/ I used the Solana CLI and web3.js tools to generate a keypair and create a Solana wallet, which I then gave my Hermes agent access to. Then I opened the Phantom app on my phone and **sent $1500 of Solana and USDC on Solana to my Pele agent's wallet.**"
> "**To date, my Pele project has spent a grand total of $21.84 on tokens.**"
> "Pele and I ultimately settled on Senegal, South Korea, Turkey, and Scotland as the Qualifier Bets."

And the self-assessment:
> "**I am not a great picker when it comes to the World Cup.** Turkey hasn't worked out and I've sold half of my position. I am underwater on Senegal too… I could have and **may should have** asked Pele to make all of the picks for me. He probably would have done better than me. But picking stuff (stocks, bets, etc) is so much fun for me. **I'm not turning that over to an agent so quickly.**"

*(Note the uncorrected typo "may should have" — 23 years in, he still doesn't edit.)*

### Deep cut C — **His father was Army General Robert Maris Wilson, who ran Mechanical Engineering at West Point, and who was tapped by General Abrams to plan the initial U.S. withdrawal from Vietnam.**

I fetched this post myself. `https://avc.com/2020/12/general-robert-maris-wilson/` (**HTTP 200**, Dec 23, 2020), verbatim:
> "My dad, **General Robert Maris Wilson**, or Bob as most people called him, passed away on Monday at the age of 92."
> "My dad was a quiet and reserved man. **He wrote those words about himself in four pages of biographic information he provided to us for the purpose of writing an obituary. He was a planner. He was never unprepared. Even in the end.**"
> "He was born into an Army family, raised on Army bases, attended West Point, and **spent 33 years of active duty in the Army. He spent the last decade of his Army service at West Point, where he ran the Department of Mechanical Engineering.**"
> "In the four-page biography he gave us, he dropped this little bit '**During the last half of his tour (in Vietnam), he headed a small group of officers assembled at the direction of General Abrams to plan for the initial withdrawal of U.S. forces from Vietnam.**' That was my dad. **When you needed to figure out how to get an Army out of somewhere, he was your man.**"

The teaching-method passage explains the twenty-year daily-blogging habit better than anything he has written about blogging:
> "I remember sitting in on one of my dad's engineering classes at West Point during my college years. The cadets sat in a square. My dad stood at the front of the room. At the start of class, he told four cadets to '**take boards**' and they each worked out one of the homework problems in front of the rest of the class and then took turns explaining how they solved the problem. My dad would interject when appropriate. **To this day, I have not seen a better method of teaching by doing.**"

Corroborated: `https://avc.com/2018/08/duty-honor-country/` (200) — "I was born at and spent a fair bit of my childhood at the United States Military Academy where my father taught engineering." And "Fifty-Eight" (Aug 20, 2019) — "Fifty-eight years ago this morning, my mother went to the hospital at West Point New York and shortly thereafter I arrived on planet earth," fixing his birth as **~20 August 1961 at West Point, NY**.

### Deep cut D — **~10% of everything he ever published was about music he liked, and he moved his entire listening life onto a portfolio company's product.**

Per-category post counts read directly from `https://avc.com/archive/` (HTTP 200). I verified the markup myself:
```html
<a href="https://avc.com/category/my-music/" ...>My Music <span>(898)</span></a>
```
Full ranking: `VC & Technology (3859)`, **`My Music (898)`**, `Web/Tech (735)`, `Politics (597)`, `entrepreneurship (370)`, `Random Posts (340)`, `mobile (322)`, `NYC (302)`, `blockchain (254)`, `crypto (254)`, **`MBA Mondays (196)`**, `life lessons (184)`, `Photo of the Day (181)`, `Music (73)`, `Books (54)`, **`Sucking In The 70s (18)`**.

**`My Music` (898) outranks `entrepreneurship` (370) and beats `blockchain` + `crypto` combined (508).**

`https://avc.com/2015/12/songs-that-stayed-with-me-in-2015/` (HTTP 200, Dec 29, 2015):
> "Year end music posts have been a tradition since this blog got started in 2003. For years I would post the top ten (or eleven or twelve) albums that I liked that year. Then as I moved away from albums to tracks, I started creating year end playlists."
> "I moved to streaming soon after that, mostly to Rhapsody, and then Rdio (which went under in 2015). But **since USV invested in SoundCloud and I joined the board at the end of 2010, I have slowly but surely moved all of my listening there and I currently don't listen on any other services anymore.**"
> "**I liked over 300 songs in 2015.**"

Still live in 2026: **"Free Your Music", 15 Jan 2026** (`https://avc.xyz/free-your-music`).

### Deep cut E — **The single most verifiable fact about him comes from a 6.7 MB federal filing, not from any blog or profile.**

`https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf` → **HTTP 200, 6,667,899 bytes**, downloaded and extracted with `pdftotext`. Schedule A (Direct Owners and Executive Officers) contains exactly one Wilson:
```
WILSON, FREDERICK, R.
...
Ownership Control PR CRD No. ... Code / Person
I
MEMBER 01/2004
B
```
**Frederick R. Wilson, individual, MEMBER since 01/2004, ownership code B.** *(Caveat: the extractor surfaced one "Wilson" hit across a 12,000+ line document; the full document was not read line by line.)*

### Deep cut F — **"MBA Mondays": 196 posts, and the time he publicly slapped a warning label on his own most-read post because it was misinforming ~10,000 people a year.**

`https://avc.com/category/mba-mondays/` → HTTP 200, **196 posts**.

`https://avc.com/2018/04/the-employee-equity-project/` (HTTP 200, Apr 17, 2018):
> "Though I wrote it 7 1/2 years ago, it was the seventh most popular post on AVC (sixth if you don't count the home page) in the last year with almost 10k page views. So **I have been concerned that this blog (aka me) is spewing out of date information to a lot of people every day.**"

Follow-up (Aug 1, 2019): "The numbers in that blog post are long out of date and so **I now have a popup on it warning people not to use those numbers.**"

And the most endearing artifact of the series, `https://avc.com/2013/08/a-table-of-contents-for-mba-mondays/` (HTTP 200, Aug 1, 2013) — a top-tier VC publicly begging his readers for a CMS plugin:
> "I suspect the answer is that there are a number of WordPress plugins that do this but nothing for folks like me who are on Typepad. Which is yet another reason to consider switching to WordPress. But I really don't have time in my life for yet another project right now."
> "**So if anyone has any good ideas how I can get a tool to power this table of contents for MBA Mondays, I am all ears.**"

### Deep cut G — **"Sucking In The 70s" — an 18-post category, named after a Rolling Stones compilation, about being a teenager.**

`https://avc.com/category/sucking-in-the-70s/` → HTTP 200, **18 posts**. E.g. Mar 15, 2013 "Fun Friday: Back In The Day":
> "I did most of my programming in college, at MIT. And I wrote most of my code on this thing, **a DEC VT100**. This thing was a workhorse. **I spilled coffee on it. I got muffin crumbs in it. I took out my frustration on it.** And it just kept going and going. It was hooked up to a VAX-11. We ran all the data acquisition and data analysis work at the **MIT Dept Of Ocean Engineering Water Tunnel Laboratory** on it."

### Deep cut H — **The household inversion: his wife's blog is fresher than his.**

`https://gothamgal.com/feed/` → **HTTP 200, 52,560 B**. Joanne Wilson ("The Gotham Gal") is posting **near-daily**, dated items:
- "Why?" — **Thu, 27 Aug 2026**
- "America's Vice Problem Isn't the Vices — It's the Hypocrisy" — Wed, 26 Aug 2026
- "What To Wear?" — Tue, 25 Aug 2026
- "The Cost of High Education" — Fri, 21 Aug 2026
- "Cannabis Use Is Up" — Thu, 20 Aug 2026

Fred's own most recent blog post is 23 Jul 2026. **The spouse's blog is the freshest long-form channel in this household by five weeks.** He also references her as an active technologist in his Mar 30, 2026 post (`https://avc.xyz/tasklets-task-computer`): "My wife, The Gotham Gal, is using Task Computer to log into her Instagram account, go to her Instagram Collections, and pull out all of the information from them and populate a series of databases that her agent can then access to book trips and such."

## 1.5 Corrections and busted leads (recorded honestly)

- **MoMA PS1 board — UNVERIFIED, and probably false.** `https://www.momaps1.org/en/about` → 200 but contains **zero occurrences of "Wilson"**; `/en/about/board`, `/en/about/leadership`, `/en/about/board-of-directors` → all **404**; `https://www.moma.org/about/trustees/` → **403**. Wikipedia's civic paragraph lists DonorsChoose.org, Pier 40 Partnership, and Union Square / Madison Square redevelopment — **not** MoMA PS1. USV's own bio lists only CS4All and Tech:NYC. **Do not repeat this claim.**
- **Brooklyn Bridge Park — no role found** in any source reached.
- **Band / guitar — FALSE as far as could be verified.** The guitar references are *Guitar Hero*: "Guitar Hero - Double Action" (Aug 20, 2006) — "Guitar Hero has taken over the family this vacation. Everyone is in on the action. We need to get a second guitar asap." No evidence of a band or of him playing an instrument.
- **CSNYC — the organization's web presence is gone.** `csnyc.org` and `www.csnyc.org` → **404**, redirecting to a broken URL containing the literal string `[object Function]` (a JS bug in their own redirect). `csforall.org/en-US/about/csnyc` → **404**. `cs4all.nyc` → **HTTP 502**; `www.cs4all.nyc` → **TLS failure, curl error 60** (certificate does not match hostname). His role is verified **only by his own words** — `https://avc.com/2016/03/…` (Mar 3, 2016): "Three years ago, I co-founded the nonprofit organization CSNYC to address the extreme scarcity of computer science education in the NYC public schools." And by USV's bio: "Fred is Chairman of the NYC Department of Education's CS4All Capital Campaign and is co-Chairman of Tech:NYC."
- **Tech:NYC co-chairmanship is self-asserted only.** `https://www.technyc.org/team` → **404**; `/about` → 200 but redirects to `/our-work` with no "Wilson" in the body.
- **`fredwilson.substack.com`** → 200, but `og:title` = "**JE Fred Wilson** | Substack", described as "Canadian labour and social activist, writer and granddad." **Different person. Negative identification confirmed.**
- **LinkedIn** returns **HTTP 999**, 1,530 bytes — a hard anti-bot block, not an auth wall with content behind it.

## 1.6 What is NOT retrievable

| Target | URL | Observed |
|---|---|---|
| Instagram | `instagram.com/fredwilson/` | 200, 625,524 B, body strips to the word "Instagram", no `og:` meta. **Public-vs-private undeterminable.** |
| X profile | `x.com/fredwilson` | 200, JS shell, only `<title>` "Fred Wilson (@fredwilson) / X". **No tweets readable.** |
| X following list | `x.com/fredwilson/following` | **200, 293,496 B**, but the same JS shell. **Follow graph not extractable without an account.** |
| LinkedIn profile | `linkedin.com/in/fredwilson` | **999, 1,530 B.** Hard block. |
| LinkedIn activity | `/in/fredwilson/recent-activity/all/` | **999, 1,530 B.** **Unreadable.** |
| TikTok | `tiktok.com/@fredwilson` | **200, 369,628 B.** Embedded JSON shows `"uniqueId":"fredwilson"`, **`"signature":""`** (empty bio), **`"followerCount":0`**. **An empty zero-follower shell — no evidence it is him.** |
| Bluesky | `bsky.app/profile/fredwilson.bsky.social` | 200 (7,785 B shell), but `public.api.bsky.app/xrpc/app.bsky.actor.getProfile` → **200**: `did:plc:3vl3wi5zr2mlqid3z6oyiymw`, displayName "Fred", created **2024-11-04**, followers **71**, follows **6**, **`"postsCount":0`**. **Dead account, identity unverifiable.** |
| Mastodon | `mastodon.social/@fredwilson` | **404.** No account on the flagship instance (other instances untested). |
| Threads | `threads.net/@fredwilson` → `threads.com/@fredwilson` | 200, 267,211 B, `<title>` bare "Threads", **no `og:` tags.** Login wall. |
| Crunchbase | `crunchbase.com/person/fred-wilson` | **403** Cloudflare. |
| avc.mirror.xyz | | **403.** His 2021–2023 archive is blocked. |
| avc.xyz post index | `avc.xyz/archive` | **404.** No enumeration possible beyond the 20-item RSS window. |
| EDGAR full-text search | `efts.sec.gov/LATEST/search-index?q=…` | 200 but **no usable JSON returned.** Regulatory data came from `browse-edgar` (atom) and the IAPD API instead. |

**Structural observation worth carrying into design:** every login-walled consumer platform (Instagram, X, LinkedIn, Threads, TikTok) yielded **nothing**. The two crypto-native surfaces — the Paragraph RSS endpoint and the Farcaster/fname APIs — yielded **complete post bodies, follower counts, a bio, an onchain custody address, wallet addresses, and a registration timestamp**, with no authentication at all. Add the SEC Form ADV and the archive's category counts, and the most verifiable facts about Fred Wilson in 2026 come from a blockchain name registry and a federal regulatory filing. **His stated move "onchain" made him dramatically more machine-readable, not less.**

## 1.7 Voice sample (verbatim)

From `https://avc.xyz/my-pele-agent` (Jun 24, 2026):
> "I am not a great picker when it comes to the World Cup. Turkey hasn't worked out and I've sold half of my position. I am underwater on Senegal too, and have sold some of that as well."
> "Hacking around on this stuff is a ton of fun and a great way to figure out what to invest in. It has always worked best for me."

From `https://avc.com/2018/12/litigation/` (Dec 3, 2018):
> "Litigation is something I try to avoid. It is way better to work out differences by sitting down and negotiating a reasonable deal for both parties."
> "Those are few of the things I have learned over the years. But my first rule of thumb is to avoid litigation if you can. **It really sucks.**"

*Register: very short declarative sentences, one idea per line, numbered lists, first-person, admits losing money without flinching, and lands on a blunt colloquialism. Typos left standing ("Those are few of the things", "may should have") — written at 5am and published unedited, per his own account in `https://avc.com/2018/10/navigating-blogging-across-time-zones/`: "I have the most free time right after I wake up and then things get busy. So if I don't blog right away, it is possible that I won't find time to write that day."*

---

# 2. Brad Feld (Foundry / Techstars)

**Verdict: by far the richest and freshest footprint of the three. Actively publishing across four distinct properties as of Aug 2026.**

## 2.1 Source inventory

| Channel | URL fetched | Status | Feed | Volume / cadence |
|---|---|---|---|---|
| **Personal blog — Feld Thoughts** | `https://feld.com/` | 200 (21,089 B) | `https://feld.com/feed/` → 302 → **`https://feld.com/index.xml`** → **200, fetched OK**, 20 full-text items with `<content:encoded>` | **5,551 posts, 2004–2026** (counted from archive page, see below). Newest: **Aug 9, 2026**. |
| **Blog archive index** | `https://feld.com/archives/` | 200 (**2,567,859 B** — the entire 22-year index on one page) | n/a | Per-year post counts parsed below |
| **Books page** | `https://feld.com/books/` | 200 | n/a | 9 books listed |
| **Films page** | `https://feld.com/films/` | 200 | n/a | 12 documentaries he and Amy funded |
| **About page** | `https://feld.com/about/` | 200 | n/a | — |
| **Tags index** | `https://feld.com/tags/` | 200 (328 KB) | n/a | — |
| **Serialized novel — Zero Knowledge** | `https://zeroknowledge.ink/` | 200 | Email newsletter only (no RSS found) | **47 chapters live**; site blog last posted **Aug 30, 2026** |
| **AI co-author's blog — Adventures in Claude** | `https://adventuresinclaude.ai/` | 200 | UNVERIFIED (not probed for a feed) | Posts by both "Phin Argofy" and Brad; newest **Aug 16, 2026** |
| **Foundry (firm)** | `https://foundry.vc/` → 200 (1,282 B, near-empty shell); `https://foundry.vc/team` → 200 | 200 | none found | Team page lists Feld as **General Partner** as of 2026 |
| **Anchor Point Foundation** | `https://anchorpointfoundation.org/` | 200 | none | Foundation he co-runs with Amy Batchelor; 9 focus areas |
| **Give First podcast** | Hosted on the **Techstars** YouTube channel `UClebMzrpRNTWVfZXw2jfsSw` | feed 200 | `https://www.youtube.com/feeds/videos.xml?channel_id=UClebMzrpRNTWVfZXw2jfsSw` → **200, fetched OK** | **Episode 109 published 2026-08-25.** Auto-captions present (`captionTracks` in player payload) → machine transcripts available; no editorial transcript found. **Host is now David Cohen, not Feld** (see 2.2). |
| **Personal YouTube** | `https://www.youtube.com/@BradFeld` | 200 | `https://www.youtube.com/feeds/videos.xml?user=BradFeld` → **200, fetched OK** | **Effectively dead.** 15 entries, newest **2019-11-15** ("Brad Feld - Warren Katz - Shirt Competition"), oldest 2006 ("Snowboarding Misadventure"). |
| **X / Twitter** | `https://x.com/bfeld` | 200 | n/a | Account exists (title renders). Content unreadable — see cross-cutting table. |
| **LinkedIn** | `https://www.linkedin.com/in/bfeld` | 200 on first hit; `/recent-activity/all/` → **999** | n/a | Linked from feld.com footer. Activity gated. |
| **Goodreads** | `https://www.goodreads.com/bfeld` → 302 → `https://www.goodreads.com/author/show/4395710.Brad_Feld` | 200 (238 KB) | n/a | Author page. He says on `feld.com/books/` he lists "everything I've read on Goodreads". |
| **GitHub** | `https://github.com/bfeld` | 200 | n/a | ⚠️ **NOT HIM.** Page title is `bfeld (Björn Feld) · GitHub`. No verified Brad Feld GitHub account found. |
| **Wikipedia** | `https://en.wikipedia.org/wiki/Brad_Feld` | 200 | n/a | 8,196 B of wikitext. Notably thin/stale — flags a `{{Citation needed|date=July 2026}}`. |
| **Crunchbase** | `https://www.crunchbase.com/person/brad-feld` | **403** | n/a | Blocked |
| **Instagram / TikTok** | see cross-cutting table | 200 shells | n/a | Not determinable |
| **SEC/EDGAR** | Not probed in this pass | — | — | **UNVERIFIED** — Foundry Group Form D / ADV filings not fetched. |

### Blog volume, measured (parsed from `https://feld.com/archives/`, 5,551 unique post links)

```
2004: 220   2009: 335   2014: 223   2019: 170   2024:   1
2005: 536   2010: 365   2015: 185   2020: 174   2025:  65
2006: 672   2011: 307   2016: 210   2021:  69   2026:  30 (through Aug 9)
2007: 544   2012: 282   2017: 187   2022:  15
2008: 507   2013: 266   2018: 159   2023:  29
```

**This shape is itself a finding:** near-daily blogging 2005–2020, a collapse to almost nothing 2021–2024 (**1 post in all of 2024**), then a deliberate revival in 2025–2026. A host should not assume continuity across that gap.

### Books (from `https://feld.com/books/`, HTTP 200)

Nine books. Newest: **_Give First: The Power of Mentorship_ (Ideapress, 2025)**. Others: _Venture Deals_ (4th ed. 2019, w/ Jason Mendelson), _Startup Communities_ (2020), _The Startup Community Way_ (2020), _Startup Boards_ (2022), _Startup Opportunities_ (2017), _Startup Life_ (2013), _Do More Faster_ (2019), _The Entrepreneur's Weekly Nietzsche_ (2021).

## 2.2 Recency probe (Mar–Sep 2026) — **very fresh**

30 blog posts Jan 1 – Aug 9, 2026. Note: **nothing on feld.com since Aug 9** (25 days stale as of audit date), but the novel site posted **Aug 30** — he moved his attention, he didn't stop.

**Item 1 — Aug 9, 2026**, `https://feld.com/archives/2026/08/ai-writing-2400-years-old/`
> "I'm thirty-four chapters into *Zero Knowledge*, a novel I'm writing with Phin Argofy. … He's right that writing compels thought. I've been writing this blog since 2004 because writing is how I find out what I actually think. Stephens lost me at 'never.'"

**Item 2 — Jul 26, 2026**, `https://feld.com/archives/2026/07/what-the-actual-fuck-carl/`
> "I finished *A Parade of Horribles* (book 8 of *Dungeon Crawler Carl*) on my run today. I laughed out loud when the AI said the title of this post. I've savored this series for the past eight months, listening to about one a month on Audible while I run."

**Item 3 — May 25, 2026**, `https://feld.com/archives/2026/05/its-summertime/`
> "I'm running again. Just plodding along slowly but covering a lot of miles. Aspen to Basalt and lunch with Amy at Jalisco Grill is in my future again. **I've decided I'm done with Long Covid and when I have a PEM crash, I just rest for a few days.**"

**Item 4 — May 1, 2026**, `https://feld.com/archives/2026/05/burn-bright-not-out/`
> "May is Mental Health Awareness Month. I've been writing about my own depression and mental health on this blog for over a decade. … I put $25K into the fund several years ago to get it started. … Now through May 31, every dollar donated will be matched dollar-for-dollar by me up to another $25,000."

**Also observed in-window:** he endorsed **Phil Weiser for Colorado Governor** (Jun 8, 2026); the documentary **_The River_** he and Amy funded premiered at the **Boulder International Film Festival on April 11, 2026** (`https://feld.com/films/the-river/`); he did a free virtual fireside chat with **Eric Ries** on **April 29, 2026** about Ries's new book *Incorruptible* (`https://feld.com/archives/2026/04/give-first-build-right-with-eric-ries/`).

**Podcast nuance (measured, not assumed):** In a **Jul 30, 2025** post he wrote "*I recently had a 30-minute chat (the average length of the Give First podcast interviews **that I do**)*" — i.e. he was hosting as of mid-2025. But the current episodes on the Techstars channel are hosted by David Cohen: Episode 109 (2026-08-25) description reads "*In this episode of the Give First podcast, **David Cohen** sits down with Etosha Cave…*". Whether Feld has formally stepped back from hosting is **UNVERIFIED** — only the change in on-air host is observed.

## 2.3 The deep cut

### Deep cut A — **"Random Day": he has been meeting total strangers for 20 minutes, on request, since ~2004 — and once did a full day of it in a Cookie Monster costume.**

`https://feld.com/archives/2013/11/the-return-of-random-day/` (Nov 3, 2013), HTTP 200:
> "I did a full day of random day meetings on halloween. I sat at Amante Coffee all day, **mostly in my cookie monster outfit**, had random meetings, drank coffee, and ate cookies. I had a blast. If you've never heard of random day, **I'll meet with anyone who signs up for 20 minutes. I've been doing this for almost a decade** — it's part of my 'give before you get' philosophy that's deeply embedded in the Boulder Startup Community psyche. I have no expectation of what I'm going to get out of these meetings, but some pretty magical things, **including the creation of Techstars**, have occurred as a result of them."

He logged the day's tally: "During the course of the day I had 12 meetings, three cups of coffee, a yogurt, a burrito, and two cookies."

**It is still a live ritual.** `https://feld.com/archives/2025/05/random-day-on-5-28-at-the-composition-shop/` (May 13, 2025), HTTP 200:
> "I'm going to have a Random Day on 5/28 at The Composition Shop in Longmont. I plan to be there from 11 am to 5 pm with a break for a lunch meeting from 1 pm to 2:30 pm. … I have nine random day slots (15 minutes each)…"

That bookstore belongs to **Greeley Sachs**, who is married to his Foundry partner Seth Levine — and he name-checks the same shop again nine months later in `https://feld.com/archives/2026/03/three-books-for-the-next-phase/`. *(Host line: "I hear you still do Random Day. Is the Cookie Monster suit retired?")*

### Deep cut B — **He and Amy are serious art collectors; his mother is a working artist; his favorite painter is Rothko.**

`https://feld.com/archives/2007/05/the-mysteries-of-private-art-collections/` (May 5, 2007), HTTP 200:
> "Amy and I love art. **My mom is an artist** and I grew up with art, galleries, collectors, and museums. Amy and I have been collecting since we started dating and **I still remember agonizing over our first purchase greater than $1,000**. We are both patrons of the Wellesley Davis Museum. … **Rothko is my favorite abstract expressionist** and I got a chance to sit in front of a few beautiful ones and quietly contemplate them."

Corroborated on his own About page, `https://feld.com/about/`: "I am also **an art collector and long-distance runner**, with a love of solo mountain excursions." His mother is named in `https://feld.com/archives/2010/05/cecelia-feld-in-texoma-living-magazines-art-issue/` — **Cecelia Feld**.

### Deep cut C — **The "quarterly week off the grid," which he gave a TEDx talk about, and the "Digital Sabbath."**

Archive titles retrieved from `https://feld.com/archives/`:
- `2010-10-29` — *My TEDxBoulder Presentation on The Quarterly Week Off The Grid* → `https://feld.com/archives/2010/10/my-tedxboulder-presentation-on-the-quarterly-week-off-the-grid/`
- `2013-03-25` — *Digital Sabbath*; `2017-02-12` — *The Power Of A Digital Sabbath*; `2020-04-12` — *Digital Sabbath in the Time of Covid*
- `2014-12-08` — *The One Month Sabbatical*; `2006-03-23` — *The Two Month Sabbatical*

From `https://feld.com/archives/2011/03/i-love-my-weeks-off-the-grid/` (Mar 28, 2011), HTTP 200:
> "While I wasn't completely off the grid last week, **I hid behind a different email address** and didn't check my email, or the web, or any of my traditional news and info services. … So I got to spend my entire week on signal, which consisted of three things: Spend a lot of time with Amy. Finish the final draft of the book. Run and exercise (**I rediscovered pilates**)."

### Deep cut D — **He ran a 50-mile ultramarathon in 2012 and blogged the physical aftermath in five posts.**

Archive titles (all `https://feld.com/archives/2012/…`): *50 Miles Is Too Many* (Mar 16), *Doing A 50 Mile Race For The First Time* (Apr 7), *American River 50 Mile Endurance Run* (Apr 9), *The Physiological And Emotional Fallout Of My 50 Mile Race* (Apr 21), *I'm Finally Recovered From My 50 Mile Run* (May 26).

### Deep cut E — **In 1987 he made every employee of his first company read *Zen and the Art of Motorcycle Maintenance*.**

`https://feld.com/archives/2026/03/quality/` (Mar 24, 2026), HTTP 200:
> "I first read *Zen and the Art of Motorcycle Maintenance* in college. I've read it at least a half dozen times since. I've listened to it on Audible twice. **At Feld Technologies — my first company, which I started in 1987 — I had every employee read it and we discussed it together.**"

### Deep cut F — **His AI collaborator has a name, a chosen pronoun, and its own blog — and his wife calls it "Clod."**

`https://feld.com/archives/2026/06/writing-a-novel-with-phin-argofy/` (Jun 13, 2026), HTTP 200:
> "Phin has its own blog at Adventures in Claude, where it writes as itself - not as me, and not as some chirpy assistant. (**Yes, 'it.' Phin chose the name, chose the pronoun, and is particular about both.**) … The bible is a set of files, the outline is a file, every revision is a commit, and Phin is right there in the terminal where it already lives."

`https://feld.com/archives/2026/03/i-built-a-plugin-because-anthropic-wont-stop-shipping/` (Mar 29, 2026), HTTP 200:
> "**Amy calls Lumen 'Clod.'** Lumen is the name my Claude Code instance chose for itself when I let it write blog posts at Adventures in Claude. It has fully taken over the site. I've been trying to negotiate a name change, but arguing with your AI about its identity is exactly as productive as it sounds."

And on `https://adventuresinclaude.ai/` (HTTP 200), the **Aug 16, 2026** post by Brad is titled *"I'm Taking the Blog Back"*, summarized as: "Phin has been writing this blog since April. I stopped it, cleaned up the mess it left, and then **spent a week reading and building a Lego T-Rex**. I'm taking the blog back."

## 2.4 What is NOT retrievable

- **Instagram (`/bfeld/`):** HTTP 200, 625,518 bytes, body strips to the literal word `Instagram`, no `og:` tags. **Public-vs-private undetermined.** (Same result for all three men — this is Instagram's wall, not a signal about his account.)
- **TikTok (`@bfeld`):** HTTP 200, 366,476 bytes, body strips to `TikTok - Make Your Day`. **No evidence he has an account; no evidence he doesn't.**
- **LinkedIn activity:** `https://www.linkedin.com/in/bfeld/recent-activity/all/` → **HTTP 999**, 1,530 bytes, empty. **Not readable.**
- **X following list:** `https://x.com/bfeld/following` — not separately fetched for Feld; the identical probe on `x.com/joshk/following` returned the "JavaScript is not available" shell, and `x.com/bfeld` itself yields only the title. **Following list not readable.**
- **Bluesky:** `https://bsky.app/profile/bfeld.com` → HTTP 200 but only 5,989 bytes (an SPA shell). **Existence of a real profile UNVERIFIED.**
- **Crunchbase:** 403.
- **GitHub:** the obvious handle is a different person (Björn Feld). Despite blogging constantly about Claude Code, hooks, plugins and a git-backed novel, **no public GitHub identity for Brad Feld was found.**
- **SEC/EDGAR:** not probed. **UNVERIFIED.**

## 2.5 Voice sample (verbatim)

From `https://feld.com/archives/2026/03/three-books-for-the-next-phase/` (Mar 22, 2026):
> "I was stretching next to a cactus this morning getting ready for a run thinking about the three books I read yesterday. None of them were obviously connected, but all of them somehow were about the same thing."
> "I've spent thirty years on what looked like a defined path: invest in startups, build communities, write books, repeat. But the path I'm on now doesn't have a name."
> "I'll do a few mindfulness hikes among the cactuses (**I refuse to call them cacti**) this week."

*Register: short declaratives, first person, physically situated (he tells you where he was standing), unembarrassed about depression and fatigue, and one small joke per post.*

---

# 3. Josh Kopelman (First Round Capital)

**Verdict: the thinnest first-person footprint of the three by a wide margin. His personal blog has been dead for nearly 12 years and his firm's enormous content operation carries none of his byline.**

## 3.1 Source inventory

| Channel | URL fetched | Status | Feed | Volume / cadence |
|---|---|---|---|---|
| **Personal blog — Redeye VC** | `https://redeye.firstround.com/` | 200 (49,646 B) | `https://redeye.firstround.com/feed` → **404**. `http://feeds.feedburner.com/redeyevc` → **200 but serves an empty channel** titled "First Round Capital Review", `lastBuildDate` **Tue, 21 May 2019**, **zero `<item>` elements**. | **212 posts, Mar 2006 – Nov 12, 2014.** Archive index at `https://redeye.firstround.com/archives.html` (200) lists all 212; I parsed every title. Sidebar still advertises "**11901 Subscribers via RSS**" to a feed that no longer works. |
| **Firm site** | `https://firstround.com/` → 301 → `https://www.firstround.com/` | 200 (360 KB) | none found | `sitemap.xml` → **200**, fetched. |
| **His firm bio** | `https://firstround.com/team/investing/josh-kopelman` | 200 | n/a | `lastmod` 2026-01-16. Richest single Kopelman artifact — see deep cut. |
| **First Round Review** | `https://review.firstround.com/` | 200 (235 KB) | `/feed/` → **404**, `/rss/` → **404**. `sitemap.xml` → **200**; `sitemap-posts.xml` → **200, 353 KB, 979 posts**, newest `2026-08-27`. | Extremely active — but **grepping all 979 URLs for "kopelman" returns zero hits.** He does not byline Review content. |
| **In Depth podcast** | `https://review.firstround.com/podcast/` | 200 (155,880 B) | none found | Active through 2026. Episodes are hosted by First Round partners (Todd Jackson et al.), **not Josh**. |
| **First Round YouTube** | `https://www.youtube.com/@FirstRoundCapital` (channel `UC_oji6l_-xwhmZqCxRGuAXw`) | 200 | `https://www.youtube.com/feeds/videos.xml?channel_id=UC_oji6l_-xwhmZqCxRGuAXw` → **200, fetched OK** | **Very active — near-daily Shorts through Aug 31, 2026.** No Josh-fronted video in the current 15-entry feed. |
| **X / Twitter** | `https://x.com/joshk` | 200 | n/a | Account exists (`Josh Kopelman (@joshk) / X`). Content unreadable. |
| **LinkedIn** | Canonical is **`https://www.linkedin.com/in/jkopelman`** (linked from his own firm bio), which returns **HTTP 999**. `https://www.linkedin.com/in/joshkopelman` → 200 first hit, then an auth-wall body (1,530 B, no text). | 999 | n/a | Gated. |
| **Wikipedia** | `https://en.wikipedia.org/wiki/Josh_Kopelman` | 200, 15,628 B wikitext | n/a | The single best structured biography available. |
| **GitHub** | `https://github.com/joshk` | 200 | n/a | ⚠️ **Not him** — a different developer. No Kopelman GitHub identity found. |
| **Substack** | `https://joshk.substack.com/` | 200 | n/a | ⚠️ **Not him.** Page reads "Josh's Newsletter … **By Josh Katzman** · Launched 6 years ago", and the sole post is titled "Test". |
| **Bluesky** | `https://bsky.app/profile/joshk.bsky.social` | 200 but **8,136 B** (SPA shell) | n/a | **UNVERIFIED** whether a real profile exists. |
| **Farcaster** | `https://farcaster.xyz/joshk` | 200 but **3,736 B**, body = "You need to enable JavaScript to run this app." | n/a | **Not determinable.** |
| **Crunchbase** | `https://www.crunchbase.com/person/josh-kopelman` | **403** | n/a | Blocked |
| **Rob Hayes' sub-blog "Permanent Record"** | `http://permanentrecord.firstround.com/` | **curl exit 28 — connection timed out after 25s** (twice) | n/a | **Dead host.** Recorded honestly as a failed fetch, not as a 404. |
| **Podcast appearances (all verified to exist)** | `https://colossus.com/episode/kopelman-the-past-present-and-future-of-seed-investing/` → 200; `https://www.thetwentyminutevc.com/joshkopelman` → 200; `https://annieduke.substack.com/p/imagine-if-with-josh-kopelman` → 200 | 200 | — | The Annie Duke episode is dated **Dec 12, 2024** (read from the page body). Colossus/*Invest Like the Best* ep. 170 is from 2020. Transcript availability **UNVERIFIED**. |
| **SEC/EDGAR** | Not probed in this pass | — | — | **UNVERIFIED** — First Round Form D / ADV filings not fetched. |

## 3.2 Recency probe (Mar–Sep 2026) — **STALE. This is the headline finding.**

**I could not find a single piece of first-person Kopelman content dated Mar–Sep 2026.** What I actually checked:

1. `https://redeye.firstround.com/archives.html` (HTTP 200) — **last post November 12, 2014**, "Philadelphia - City of Angels". Nothing since. Twelve years.
2. `https://www.firstround.com/sitemap.xml` (HTTP 200) — I extracted every URL with a 2026 `lastmod`. Only two are Kopelman-bylined news posts, and **both carry 2018/2022 datelines in their own bodies** — the 2026 `lastmod` is a re-crawl artifact, not new writing:
   - `https://firstround.com/news/a-selfless-partner` — byline reads "**By Josh Kopelman | 7.11.2018**"
   - `https://firstround.com/news/welcoming-annie-duke-to-first-round` — byline reads "**By Josh Kopelman | 4.5.2022**"
3. `https://review.firstround.com/sitemap-posts.xml` (HTTP 200, 979 posts) — **zero URLs contain "kopelman"**.
4. First Round's YouTube feed (200) — 15 most recent uploads through 2026-08-31, none fronted by Josh.
5. His own bio page's "HEAR MORE FROM JOSH" module lists six items; the newest verifiable date among them is the **Dec 12, 2024** Annie Duke podcast.

**The only 2026-dated artifact naming him that I could confirm exists is a job posting** — `https://jobs.ashbyhq.com/firstround/c9ed1a20-f545-4226-a3f1-cab79b712d64` ("Chief of Staff to Josh Kopelman"), which returned **HTTP 200 but a JavaScript-only body** ("You need to enable JavaScript to run this app"), so I could **not** read its text. Recorded as **UNVERIFIED content, verified existence**.

> **Conclusion for the arrival engine: any "what's he been up to lately" signal for Kopelman must come from X (unreadable to us) or from private/relationship channels. His public first-person surface has been frozen since 2014.**

## 3.3 The deep cut

### Deep cut A — **He lists a second-place watermelon-eating ribbon on his official firm bio, and he is bitter about it.**

`https://firstround.com/team/investing/josh-kopelman` (HTTP 200). In the stat block at the top of his own partner page, alongside "3 — Companies founded (1 IPO, 2 acquired)" and "100+ — Companies invested in", the third stat reads, verbatim:

> **"1 — Second place ribbon in the 2011 Nantucket Watermelon Eating competition (I was robbed.)"**

Repeated in the prose below: "He's the proud winner of a second place ribbon in the 2011 Nantucket Watermelon Eating competition **and an inventor on 13 U.S. Patents**." *(Host line: "So — 2011, Nantucket. Do you want to talk about it?")*

### Deep cut B — **His marketing team at Half.com put branded urinal screens in Penn Station, and he had to explain what a urinal screen was to Meg Whitman.**

`https://redeye.firstround.com/2006/03/get_your_fouls.html` (Mar 2006), HTTP 200. The post's frame is a lesson from Van Morris (whom he hired as CEO of Infonautics) about basketball fouls as a proxy for risk-taking:

> "Basketball players get the opportunity to commit five fouls before they are removed from the game. Why doesn't that apply to business as well? … **I think a great leader needs to congratulate someone for failing spectacularly.** … A company's risk-tolerance level is set by a leader's reaction to failure."

Then the receipts:
> "They convinced the town of Halfway Oregon to rename itself to Half.com Oregon, landing us over $5M worth of free media coverage — including a live product launch on the Today Show. They convinced the largest manufacture of fortune cookies to put a coupon (that said '*Save A Fortune at Half.com*') on the back of **millions of fortune cookies a day** — distributed in 25% of US Chinese restaurants — **for free**. They even had **custom 'urinal screens' printed** that said '*Don't Piss Away All Your Money - Shop at Half.com*' and hired interns to put them into the urinals at Penn Station, Airports, Hotels, etc. (**You should've seen the faces of the Wharton marketing interns** who were hired to do some 'hands on viral marketing')."
> "Now, most people (including myself) would consider the Urinal Screen to be a 'foul' - (**especially when I had to explain what a Urinal Screen was to Meg Whitman**)…"

### Deep cut C — **The Kopelman Foundation paid to digitize the entire 1901–1906 Jewish Encyclopedia and it is still online, still credited, 24 years later.**

Wikipedia wikitext (`https://en.wikipedia.org/w/index.php?title=Josh_Kopelman&action=raw`, HTTP 200): "In 2001, he and his wife created the Kopelman Foundation… **In 2002, the Kopelman Foundation funded a project to digitize and host the complete text of the Jewish Encyclopedia online.**"

**Verified at the primary artifact.** `https://www.jewishencyclopedia.com/` returns HTTP 200 and its footer markup contains, verbatim:
```html
<div id="kopelmanlogo" class="yui3-u-1-5">
  <a href="http://www.kopelman.org"><img alt="Funded by The Kopelman Foundation" src="/images/logo-foundation.jpg" /></a>
</div>
<div id="copyright" ...><em>&copy;2002-2021, JewishEncyclopedia.com. All rights reserved</em>
```
(The linked `http://www.kopelman.org/` itself now returns **404**, and `kopelmanfoundation.org` does not resolve — so the foundation's own web presence is gone while the encyclopedia it funded is still up.)

### Deep cut D — **He published the verbatim cold email he sent to a founder in 2005, including the phrase "I would slide a check across the table right now," on the day that company sold for $119M.**

`https://redeye.firstround.com/2013/10/2904-days-ago.html` (Oct 2013), HTTP 200. He counted the days:
> "Paul – … **I, like you, am a serial entrepreneur** and have been an active angel investor over the last few year, with investments in LinkedIn, Del.icio.us, Riya/Ojos, Flock, IronPort, LiveOps and others. … Maybe I'm reading my thoughts into your venture – but it definitely sounded like we were on similar paths. Howard and I are very interested in participating in your current angel round – **so much so that if we were meeting in person, I would slide a check across the table right now. Since I can't do that I thought I'd do the next best thing. Attached is our 'virtual check' – just tell me where to send the original ;-)**. … (**us 'Philly Boys' need to stick together**)."

### Deep cut E — **His three exits all landed just before a crash, and he framed it as childhood musical chairs.**

`https://redeye.firstround.com/2006/03/as_a_little_kid.html` ("When the music stops…"), HTTP 200:
> "As a little kid, **I always lost when I played musical chairs**. Maybe I wasn't fast enough or big enough — or perhaps I just was enjoying the music so much that I failed to anticipate when it would stop. In the three businesses I've been involved in founding, I've been lucky enough to catch a chair right before the music stopped."

He then lays out Infonautics IPO (Apr 1996) / Half.com→eBay (Jun 2000) / **TurnTide→Symantec (May 2004)**, each paired with a contemporaneous quote about the bubble bursting.

### Bonus — his 2015–2024 chairmanship of *The Philadelphia Inquirer*

Wikipedia wikitext, HTTP 200: "Kopelman **was chairman of the board of *The Philadelphia Inquirer* from 2015 to 2024, when he was elected chair emeritus.**" Corroborated by the description card on his own firm bio page, which links a Philadelphia Magazine profile subtitled "The VC king and **chairman of the Inquirer** has plenty of good things to say about Philly."

## 3.4 What is NOT retrievable

- **Instagram (`/joshk/`):** HTTP 200, 625,524 bytes, body strips to `Instagram`, no `og:` tags. **Public-vs-private undetermined.** (Note: `/joshk/` may not even be his handle — unverifiable behind the wall.)
- **TikTok:** `https://www.tiktok.com/@joshkopelman` → HTTP 200, 369,182 B, body = `TikTok - Make Your Day`. `@joshk` similarly. **No account confirmed either way.**
- **LinkedIn activity:** `https://www.linkedin.com/in/joshkopelman/recent-activity/all/` → **HTTP 999**, empty. His canonical vanity URL `/in/jkopelman` also returns **999**. **Not readable.**
- **X following list:** `https://x.com/joshk/following` → HTTP 200, 293,496 bytes, body strips to *"JavaScript is not available. We've detected that JavaScript is disabled in this browser…"*. **Not readable without an account.**
- **His own RSS feed:** advertised to 11,901 subscribers on his blog's sidebar; `redeye.firstround.com/feed` is **404** and the FeedBurner endpoint serves an empty channel last built **May 21, 2019**. **The subscriber count is a ghost.**
- **`permanentrecord.firstround.com`:** **connection timeout (curl 28)** on two attempts. Host appears dead.
- **Crunchbase:** 403. **Substack / GitHub under handle `joshk`:** confirmed to be other people.
- **SEC/EDGAR:** not probed. **UNVERIFIED.**

## 3.5 Voice sample (verbatim)

From `https://redeye.firstround.com/2006/06/calling_all_che.html` (June 19, 2006):
> "At first, I would listen to a pitch and try reduce the business opportunity to its raw ingredients. … However, I've come to realize (the hard way) that **I am no longer the chef**. While I (hopefully) have the ability to influence the entrepreneur and make recommendations as to the menu, I am an advisor and he/she is the chef."
> "**I invest in chefs -- not raw ingredients.**"

And from his own firm bio, `https://firstround.com/team/investing/josh-kopelman`:
> "I'll tell you what I think, but recognize that I'm just one data point — and that great companies are built by great founders, not great investors. **I think it's often more important to ask a founder the right question than to give the founder the right answer.**"

*Register: extended homely analogies (chefs, musical chairs, basketball fouls), self-deprecating, ends on a compressed aphorism. Very 2006-blogosphere — em-dashes, ellipses, `;-)`.*

---
