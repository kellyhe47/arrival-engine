# Ingest spec — the fetch contract

**What this is:** the operator-side half of the engine. `docs/PRD.md` says what may be *rendered*;
this says what may be *collected*, from whom, and how you know it is them. It is the document a
scraping agent works from.

**Precedence.** `eval/golden/*.json` > `docs/PRD.md` > this file. Where this file states a measured
figure, the measurement is in `docs/audit/01–07` and is cited inline. Nothing here is a guess; where
something was not measured it says UNVERIFIED and the rule is **refuse, do not estimate**.

**Companion data:** `db/roster.sql` is the machine-readable form of §2–§4 and is the authority.
Prose here explains why; the tables decide.

---

## 1. The invariant, stated for ingest

R-004 says the engine must never assert what it merely failed to observe. Its ingest twin:

> **Never collect from a source you have not confirmed is the subject.**

Both halves of the audit's error class live here. `@spez` on X has 103 followers and is not Steve
Huffman. `eshear.com` returns **200 on every path you ask for** because it is a GoDaddy parking
page — `/feed`, `/rss.xml`, `/blog`, even `/robots.txt`, all 200, all the same 114-byte stub
(AUD-03 §1.5). `en.wikipedia.org/wiki/Nabeel_Qureshi` returns 200 and is a different man who died
in 2017. `youtube.com/feeds/videos.xml?user=canva` silently resolves to a Hong Kong personal
channel and returns valid XML.

**A 200 is not identity confirmation.** Neither is valid XML, a matching display name, or a
matching handle.

---

## 2. The ten

| id | name | supplied label (the door) | current label (measured) |
|---|---|---|---|
| `m_wilson` | Fred Wilson | Union Square Ventures, New York | same |
| `m_feld` | Brad Feld | Foundry Group / Techstars, Boulder | Foundry, General Partner |
| `m_kopelman` | Josh Kopelman | First Round Capital, Philadelphia | same |
| `m_tavel` | Sarah Tavel | Benchmark, San Francisco | Benchmark, Partner |
| `m_walk` | Hunter Walk | Homebrew, San Francisco | same |
| `m_huffman` | Steve Huffman | Reddit | Reddit, Inc. — CEO |
| `m_shear` | Emmett Shear | Twitch | **Softmax — CEO. STALE.** |
| `m_ries` | Eric Ries | The Lean Startup / LTSE | LTSE; author, *Incorruptible* (2026-05-26) |
| `m_qureshi` | Nabeel Qureshi | writer and researcher | same |
| `m_perkins` | Melanie Perkins | Canva, Sydney | Canva — Co-founder and CEO |

Seeded in `member_label`. Two consequences an implementer will otherwise miss:

- **Shear.** An ingest keyed on "Twitch" misses his strongest edge in the whole set. The YC Summer
  2005 batch tie is **Kiko ↔ Reddit**, not Twitch ↔ Reddit — Twitch's YC page says Winter 2007,
  which is Justin.tv's batch (AUD-06 E-NEW).
- **Ries.** His label is current but incomplete, and the missing part is the live one: he shipped a
  book on 2026-05-26. This is the case R-040 is built on — he *looked* dormant and was not.

**This list is closed.** There is no discovery step that adds an eleventh person as a member.
Non-members reached by traversal enter as `person.is_member = 0` and are never scored or surfaced.

---

## 3. Targeting: allow-list, deny-list, corroboration

Three mechanisms, in this order. All three are tables, not judgement.

### 3.1 Allow-list — `person_identity`
An adapter may fetch a `(person, source)` pair **only if a row exists**. There is no
fetch-what-looks-right path and no URL-guessing path. Adding a row requires a new measurement:
fetch it, record the status code, record which corroboration kinds fired.

### 3.2 Deny-list — `person_identity_negative`
19 rows, every one a fetch that actually happened and reached the wrong person. A request whose URL,
handle or domain matches a row is **refused**, not down-weighted. The deny-list is matched by value
across all ten, because the failure being prevented is cross-attribution.

The rows worth reading before you write any code: `x.com/spez`, `eshear.com`, `emmettshear.com`,
`wikipedia.org/wiki/Nabeel_Qureshi`, `instagram.com/nabeelqu`, `github.com/nabeelqu`,
`github.com/bfeld`, `github.com/joshk`, `joshk.substack.com`, `youtube.com/@eshear`,
`youtube.com/@fredwilson`, `youtube.com/feeds/videos.xml?user=canva`, `melanieperkins.com.au`,
`wikipedia.org/wiki/Fred_Wilson` (undisambiguated).

### 3.3 Corroboration — `corroboration_kind` (closes P1-11)
G-016 hands the resolver `corroboration: ["named_in_sec_filing"]` as an opaque list. It is now
enumerated with a strength and a measured basis. The rule:

> **Accept an account on ≥1 STRONG kind, or ≥2 WEAK kinds from different sources.
> Never on `handle_matches` alone, and never on `handle_matches` + `display_name_matches`
> from the same platform** — that pair is precisely the `@spez` failure.

STRONG: `named_in_sec_filing`, `api_name_field_matches`, `linked_from_own_canonical`,
`subject_self_identifies`. WEAK: `bio_backlink_to_canonical`, `display_name_matches`,
`handle_matches`.

`named_in_sec_filing` is STRONG only when the **CIK** binds the name: `CIK 0001827011` is
"Huffman Steve Ladd"; `CIK 0001690226` is a different Steve Huffman (AUD-02 §3.1).

### 3.4 Deceased candidates
R-013: a candidate marked deceased is **never auto-resolved**, even on a STRONG match. The measured
case is Qureshi. Emit `ambiguous`, show the chooser, brief nobody.

---

## 4. Tiers and the execution split

| tier | sources | runs where |
|---|---|---|
| GREEN | blog RSS/APIs, HN Algolia + Firebase, SEC EDGAR, Wikipedia, Wayback, YouTube transcripts, podcast RSS, Open Library, Bluesky, Farcaster, fxtwitter counters | anywhere, including the deployed URL |
| METERED | X API proper | anywhere, costs money |
| SESSION | LinkedIn, X, Instagram (all three measured working, AUD-07) | **operator's machine only, never deployed** |

SESSION adapters are **absent from the deployed runtime registry** (R-053). G-015 is
defence-in-depth over that absence, not the mechanism. The deployed app opens the SQLite file
read-only; the ingest/serve split is a file copy.

**No captcha or bot-detection evasion at any tier** (R-008). TikTok's public page ships 25 captcha
references; it is not built, at any login state. Dating apps are out permanently — no API, ToS
prohibition, and GDPR Art. 9 special-category data.

---

## 5. Fetch contract

### 5.1 Identify yourself, everywhere
```
User-Agent: ArenaHall/1.0 (kellyqhe47@gmail.com)
```
Not cosmetic. `data.sec.gov` with an empty UA returns **403**; with a contact UA, **200**
(AUD-04 §Cross-cutting 1). Set it globally, including on Wayback.

### 5.2 Credentials to obtain before writing code
| what | why | measured |
|---|---|---|
| GitHub PAT | unauth is 60 req/hr core, **10 req/hr search** | AUD-04 §4 — ten members × several calls exhausts search in one refresh |
| api.data.gov key | `DEMO_KEY` is 10 req/hr | measured `x-ratelimit-limit: 10` |
| Brave **or** Tavily key | gap-filling search only | Brave $5/mo credits, 50 qps; Tavily 1,000 credits/mo, no card |

Total marginal cost $0–5/month. Keyless-but-shared APIs are a trap: Google Books returned 429
attributed to *someone else's* exhausted project quota. Anything keyless-and-shared needs a keyed
fallback or it is not in the stack.

### 5.3 Pace
Human pace, serial per host. Wayback is the one source measured to fail under concurrency — see §7.1.

### 5.4 Robots and terms
GREEN sources are fetched as documented public interfaces. `softmax.com/robots.txt` allows
everything but `/api/observatory/v2/coworlds/replays/` — honour it. SESSION access breaches platform
ToS and enforcement is account-level on the **operator's** account: raised, accepted, logged as K-1
under DEC-6. It is not extended to captcha evasion, write operations, or non-operator accounts.

---

## 6. SESSION adapters

### 6.1 Structurally read-only (R-007, G-028)
The adapter interface declares **no write operation**. Not "we don't call it" — it does not exist,
so posting, liking, following, messaging and connecting are unreachable by bug, by retry, or by an
injected instruction. The logged-in session exposes those affordances on every page (AUD-07-8); the
absence of a code path is what makes that safe.

### 6.2 Use the accessibility tree, not text extraction (AUD-07-5)
`x.com/fredwilson/following` returns **nothing** from `get_page_text` and the **full list** from
`read_page`. An implementation built on text extraction returns empty lists that look exactly like
"no data" rather than "wrong method". This is the same decoy class as YouTube's `timedtext`
endpoint, which returns 200 with 0 bytes.

The follow list is virtualized (1,345 entries for Wilson) — scroll it as a slow batch job, never a
request-time call.

### 6.3 The extraction whitelist (R-009, DEC-7, G-029)
The logged-in view is **personalized**. Those strings are facts about the *operator*, not the
member; they are not reproducible by anyone else, and they leak the operator into the member's
profile. Whitelist what may be extracted; never blacklist.

**MAY extract**
- LinkedIn: headline, location, current company, university, follower **count**, post bodies, post
  dates, in-post tag lines (`cc: A, B, C`), repost attribution line.
- X: bio, following count, follower count, joined date, location, website, following-list handles.
- Instagram: bio, external link, post count, post captions, **absolute** post date from the post
  page, structured **location tag**.

**MUST NOT extract, store, or pass onward — strip at the adapter boundary**
- `Followed by <names>`, `<name>, <name> and N others you know`
- degree-of-connection (`· 3rd`), "People you may know", suggestion rails
- the operator's own account name or handle anywhere in the page tree (measured: `/kitty_kels/`)
- notification counts, message threads, any write affordance
- **signed CDN URLs** — Instagram's carry session-derived tokens. Storing one puts an operator
  credential in the fact store. Screenshot the rendered post instead; the screenshot path needs no
  URL handling at all (AUD-07-11).

### 6.4 Tagged tabs are adversarial input (R-026, AUD-07-7)
`instagram.com/<handle>/tagged/` is the only surface in the inventory whose contents are written by
**third parties**. Anyone can tag any account in any post. It is already wrong on its very first
item: the VC Fred Wilson's tagged tab leads with a post naming **Fred Wilson the conceptual artist**.

Rule: `trust_class = 'third_party_open'`. Never attributed without independent corroboration, never
rendered (`v_renderable_fact` excludes it structurally), and **never concatenated into a model
prompt as fact**. Traversal hint only. Text recovered from an image published by a third party gets
the same class — a photographed sign can carry text shaped like an instruction (AUD-07-12).

### 6.5 Captions are claims, not geotags (AUD-07-6)
"In Venice this week" is ambiguous between Venice CA and Venice Italy, and Wilson's profile carries
evidence for **both**. Store as `context` with `resolved = 0`; a `resolved = 0` context never matches
for S4. Prefer the structured location tag from the post page ("Menotti's Coffee Stop"), which is
unambiguous. Take dates from the post page too — the grid gives relative ones ("603w", "1d").

### 6.6 Image analysis (R-031, DEC-8)
In: scene, object, activity, venue, text-in-image. Out permanently: face recognition, matching,
clustering, or any inference from a face. Subject-published images only. No image is stored, only
the derived observation. **An image-derived fact must corroborate a textual one to render** — the
worked case is Wilson, where text said "music" (898 blog posts in his "My Music" category) and the
photograph said *vinyl and a vintage Luxman receiver*.

---

## 7. Retrieval traps, measured

Each of these produced a wrong answer during the audit. They are the difference between a scraper
that works and one that silently lies.

**7.1 Count your Wayback failures.** A first bulk pass over Tavel's 152 archived Adventurista pages
at concurrency 8 returned almost **zero** hits — because `web.archive.org` began refusing
connections partway through and the errors were being discarded. A slower second pass found four
Fred Wilson references and a Hunter Walk reference. *Never trust a Wayback crawl that does not count
its own failures.* An uncounted failure becomes a false `no_edge_confirmed`, which is R-011's exact
prohibition.

**7.2 An empty feed is not silence.** `feeds.feedburner.com/redeyevc` returns **200** with a valid
channel, `lastBuildDate` 2019-05-21, and **zero items**. Kopelman's blog has been dead since 2014.
A pipeline that reads "feed OK, 0 items" as "quiet" is wrong: this is `unknown`, and it is why
`source_status` records `fact_count` separately from `status`.

**7.3 A frozen archive is not a live blog.** `avc.com/feed/` is 200 and healthy; its newest item is
*"I've Moved Onchain"*, 2024-05-02. Wilson's live blog is `avc.xyz` via
`api.paragraph.com/blogs/rss/@avc.xyz`. Reading avc.com and calling it current is reading a corpse.

**7.4 Autodiscover feeds; do not guess them.** Three hand-guessed feed URLs 404'd while the correct
URL sat in a `<link rel="alternate" type="application/rss+xml">` on the homepage. Parse the homepage
first. Corollary: `hunterwalk.com/archives` is a 404 — use the WP REST API, which reports
`x-wp-total: 1761` in a header.

**7.5 The blocked-vs-absent distinction.** Every `canva.com` path is 403 to every automated client
tested, including a full desktop-Chrome UA. Guessed RSS paths return 403, which is
**indistinguishable from "absent"** — so no feed can be *confirmed* to exist, and none may be
asserted not to. Perkins routes through Wayback (via `curl`; WebFetch refuses `web.archive.org`)
and through SESSION LinkedIn.

**7.6 Bot challenges that only a browser clears.** `nabeelqu.co` returns **429** with
`x-vercel-mitigated: challenge` to both curl and WebFetch, and its Wayback fallback was **503** at
audit time. It is trivially readable by a human and not readable by a naive scraper. Route it
through a real headless browser, or prefer `nabeelqu.substack.com/feed`, which is 200, full-text,
and carries four items his own site's feed does not.

**7.7 Handles differ per platform.** Shear on Hacker News is **`emmett`** (927 items, karma 4,858);
`eshear` on HN is 1 submission and karma 14. Qureshi on GitHub is **`nqureshi`**, not `nabeelqu`.
Perkins on X is **`MelanieCanva`**, capitalised. Kopelman's canonical LinkedIn slug is `jkopelman`,
per his own firm bio, not `joshkopelman`.

**7.8 Do not merge adjacent topics.** Tavel writes about AI-and-work, Shear about AI-alignment,
Huffman about content moderation. Three people, three tags, **no shared tag**. Collapsing them into
one `AI` bucket is the fastest way to manufacture a fake affinity between Huffman and Tavel
(AUD-06 §5).

**7.9 Do not build on:** LinkedIn logged-out (999 on 5/5), Instagram logged-out (625 KB JS shell,
`web_profile_info` → 400), Facebook (400 logged out), TikTok (captcha-walled, Research API is
academic-only), X timelines logged-out (no tweet text; Nitter is dead, xcancel was served a
cease-and-desist), Reddit keyless `.json` (302 to /login or 403; `.rss` 429s after one request),
YouTube raw `timedtext` (200 with 0 bytes — use `youtube-transcript-api`, pinned), Bing Web Search
(retired), anonymous Jina Reader (401 by ASN reputation), PatentsView / USPTO PEDS / case.law (DNS
failure — the endpoints are gone), in-feed podcast transcripts (2 `<podcast:transcript>` tags across
216 Acquired episodes; 0 across 20VC's 1,504, Lenny's 359, a16z's 1,000).

---

## 8. What a run must write

### 8.1 Every attempt, not every success
`source_status` takes a row for **every** `(person, source)` attempt — `ok`, `unavailable` or
`skipped` — with `http_code`, `reason`, `fact_count` and `run_id`. This table is the only thing that
distinguishes **quiet** from **unknown** (R-040). Without it, "Eric Ries is dormant" and
"archive.org returned 503" are the same row, which is the error the audit actually caught.
`v_recency_state` derives coverage from it: one unreached source makes the whole profile `unknown`.

### 8.2 Every fact
`fact` rows are **append-only** — correct by superseding, never `UPDATE`. Required on each:
`source_url`, `source_host`, `source_date`, `observed_at`, `provenance_class`, `trust_class`,
`run_id`. `inferred` facts must populate `composed_from`. `v_renderable_fact` enforces all of this
in the store rather than by care.

`provenance_class` (who published it) and `trust_class` (who could have written it) are
**independent**. A fact can be public, sourced, and still authored by a stranger.

### 8.3 Backfill `person_topic.evidence_fact_id`
The roster seeds topics with `NULL` evidence because no content run has happened. The first ingest
run must fill them. A topic with no evidence fact produces a reason sentence the host cannot defend,
and R-025 forbids the fact behind it from rendering anyway.

### 8.4 Fill the three NULL person columns
`career_start_decade` (S1 cannot fire without it — Wikipedia wikitext for the seven with articles,
SESSION LinkedIn for Tavel, Walk, Qureshi), `name_respelling` (must be **sourced** from a recording
of the subject saying their own name — never guessed; candidates: Tavel, Qureshi, Kopelman), and
`m_walk.prominence_tier` (currently a floor from Bluesky's 5,371; re-measure via
`api.fxtwitter.com/hunterwalk`).

---

## 9. Scope of the walk, and budget

**Depth.** Inner-circle expansion is an ingest-time walk of **exactly one hop** from a member. A
person reached at hop 1 (co-founder, board member, tagged associate, followed account) is written as
`person.is_member = 0`, exists so their edge is traversable, and is **never scored and never
surfaced**. There is no hop 2. Without this bound, a follow-graph walk from Wilson's 1,345 follows
collects strangers indefinitely — which is both the privacy failure and the compute one.

**Budget per member per run.** Newest-first, stop at whichever comes first:
- 200 items per source, or
- items older than 2016-01-01, except the three archives the deep cut actually lives in —
  Wilson's `avc.com` (9,046 posts), Feld's `feld.com` (5,551), Shear's HN (927) — which are mined by
  **targeted search**, not by walking the archive.

The deep cut is a search problem, not a crawl problem. `avc.com/?s=<query>` and the HN Algolia API
answer it in one request each; `fact_fts` is the local surface for the same job afterwards.

**Stop conditions.** A source that 429s twice is `unavailable` for the run — do not retry into a
ban, and do not silently substitute another source for it.

---

## 10. Open, and deliberately not decided here

1. ~~The prominence rule flattens.~~ **Resolved 2026-09-03.** The `OR a Wikipedia article exists`
   clause is withdrawn; prominence is now one scale, the highest measured single-platform follower
   count, and every figure was re-pulled in a single pass so they are mutually comparable. The
   measuring instrument is `api.fxtwitter.com/<handle>` — free, keyless, unauthenticated, and the
   **only** sanctioned use of an X mirror: counts and profile fields, never content. Four tiers
   moved (Kopelman 4→3, Shear 4→3, Walk 2→3, Huffman 4→NULL) and six fixtures were re-baselined
   against the table. Remaining caveats are K-9 (mixed platforms) and K-10 (Huffman unmeasured).
2. **`board-games` has no holder.** `db/vocabulary.sql` marks it a G-017 placeholder with no audit
   backing, so `db/roster.sql` assigns it to nobody. Source it or delete it and re-baseline G-017.
3. **Facebook and TikTok are UNVERIFIED at every login state** (K-2). Measure before claiming.
4. **feld.com's Pagefind WASM index could not be queried headlessly** (K-5), so in-body mentions
   there cannot be fully excluded. Never write `no_edge_confirmed` against a corpus you did not
   actually search.
