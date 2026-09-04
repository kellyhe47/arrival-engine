# Ingest blockers

## run_ingest_wilson_20260903 — m_wilson / Fred Wilson

- **AUTH BLOCKED — m_wilson/x_session · https://x.com/fredwilson/following · no HTTP code, the
  page redirected to the profile and rendered "Something went wrong. Try reloading."; the profile
  itself shows Log in / Sign up · need: the operator to log the browser into X on this machine ·
  impact: the 1,345-entry follow graph. Wilson→Kopelman `follows` cannot be confirmed this run, and
  the asymmetry the prompt flags (reverse not found in two passes) cannot be re-tested at all.
  Also lost: `bgurley`, `mattturck`, `semil`, `ttunguz`, `joshelman` and the rest of the measured
  first page.**

- **AUTH BLOCKED — m_wilson/instagram_session · https://www.instagram.com/fredwilson/ · no HTTP
  code, a Sign up / Log in dialog overlays the profile and "Show more posts from fredwilson" is
  the wall · need: the operator to log the browser into Instagram on this machine · impact: the
  full 414-post grid and the post count. Only 12 tiles are reachable logged out, newest 2021-04-24.
  The S4 contexts the prompt expects from captions — an LA house, Venice CA, Venice Italy, France,
  Berlin, cycling — are all behind this wall. The two-Venices ambiguity case could not be measured
  from his own captions; it is stored `resolved=0` on Wikipedia evidence instead.**

Neither wall was authenticated against (00-COMMON rule 4: that is the user's to do). No write
operation of any kind was issued against any account.

- ~~AUTH BLOCKED — m_wilson/linkedin_session~~ **RESOLVED 2026-09-04.** The in-app browser is
  logged out, but the operator's own Chrome holds a live LinkedIn session, and the profile read
  cleanly there (SESSION tier, operator machine only, read-only, no write op issued). Identity is
  no longer provisional: the headline "Managing Partner, Union Square Ventures" is
  `subject_self_identifies` against the firm Form ADV binds him to as a Control Person.
  `linkedin_public` (logged out) remains `unavailable`; that is the correct record of what a
  GREEN-tier client can see.

  **The generalisable finding: the in-app browser being logged out does not mean the operator is.**
  Two walls in this run — X and Instagram — were called blockers on the in-app browser alone.
  Both should be retried in the operator's Chrome before anyone reports them as lost.

## run_ingest_tavel_20260903 — m_tavel / Sarah Tavel

- **AUTH BLOCKED — m_tavel/facebook_session · https://www.facebook.com/sarah.tavel · HTTP 200,
  the page rendered a logged-out "Email or phone / Password / Log In" bar and the body
  "This content isn't available right now — When this happens, it's usually because the owner only
  shared it with a small group of people, changed who can see it or it's been deleted." · need: the
  operator to log the browser into Facebook on this machine · impact: Facebook stays UNVERIFIED for
  her at every login state (K-2 unchanged). Note the URL was a GUESSED vanity slug, so even a
  successful read would have needed independent corroboration before a single fact came off it —
  logged out it establishes neither existence nor identity in either direction.**

Not blockers, recorded here so nobody re-files them as ones:

- **m_tavel/instagram_session is `ok`, and the grid is still closed.** The operator's Instagram
  session works; `instagram.com/sarahtavel` returns bio, external handle references and all three
  counters (119 posts, 623 followers, 358 following). The account is **private** — "This profile is
  private" — which is her setting, not a wall we hit. This resolves the open question in the
  m_tavel prompt ("Public vs private cannot be determined. Don't guess"): it is **private**,
  measured 2026-09-03. No caption, location tag or post date is obtainable, so Instagram
  contributes no S4 context for her.
- **m_tavel/tiktok_public is `unavailable` for an identity reason, not an access one.** There is no
  TikTok session on this machine, but the profile renders logged out anyway: "Sarah Tavel",
  @sarahtavel, 378 following, 716 followers, 312 likes, bio "💫💯", and exactly **one video, ever**
  (107 views). It is **not accepted as hers**: `handle_matches` + `display_name_matches` from the
  same platform is precisely the pair R-012 forbids, and the bio carries no backlink. Written as a
  `negative_probe` row so `v_collectable_source` excludes it. No fact was written from it.
- No captcha was presented and none was solved. No write operation of any kind — no follow, like,
  connect, message, subscribe or consent click — was issued against any account on any platform.

## run_ingest_huffman_20260903 — m_huffman / Steve Huffman

- **AUTH BLOCKED — m_huffman/reddit_live · https://www.reddit.com/user/spez/ · no final HTTP code
  retained; the measured keyless paths are old.reddit redirecting to login, www.reddit returning
  403, and RSS rate-limiting · need: approved Reddit OAuth credentials or an operator session ·
  impact: no complete live first-person corpus or reliable current-post date, so Huffman's profile
  is `unknown`, never `quiet`. Wayback partially mitigated the loss: CDX exposed 15 unique HTTP-200
  captures, five snapshots were fetched successfully, and three subject-authored deep cuts were
  recovered.**

Not a blocker, but a load-bearing identity correction: the supplied LinkedIn URL
`linkedin.com/in/shuffman/` belongs to Sarah Huffman. YC's official Reddit founder record links
Steve Huffman to `linkedin.com/in/shuffman56/`; that profile rendered in the operator's session and
its Activity page supplied the missing prominence figure. No account write operation was issued.

## run_ingest_shear_20260903 — m_shear / Emmett Shear

- **AUTH BLOCKED — m_shear/facebook_session · https://www.facebook.com/emmett.shear · HTTP 200,
  the page rendered a logged-out "Log In / Forgot Account?" bar over "This content isn't available
  right now — When this happens, it's usually because the owner only shared it with a small group
  of people, changed who can see it or it's been deleted." · need: the operator to log the browser
  into Facebook on this machine · impact: Facebook stays UNVERIFIED for him at every login state.
  Note the slug is NOT a guess — it is `{{Facebook|emmett.shear}}` from the External links section
  of his own Wikipedia article — so unlike the Tavel case a successful read would arrive with a
  corroboration path already attached. Logged out the page distinguishes nothing between "no
  account", "restricted audience" and "deleted".** Same wall Tavel's run hit; the operator's Chrome
  carries LinkedIn, X and Instagram sessions but no Facebook one.

Not blockers, recorded here so nobody re-files them as ones:

- **m_shear/x_following is a PLATFORM CEILING, not an auth wall.** The operator's Chrome is logged
  into X and the list still stops at **70 of 1,193 claimed (5.9%)** — no spinner, no error, no 429,
  the page simply ends. Two full passes with real wheel events and a reload between them; the
  second pass returned a **strict subset** of the first, so the reload-fixes-a-stalled-virtualizer
  remedy was applied and did not help. This is the same silent ceiling measured on Wilson (69 of
  1,345). Authenticating harder will not fix it. Consequence recorded in the store: `follows` edges
  exist only for the six reached, and **no `no_edge_confirmed` was written off the follow walk**.
- **m_shear/x_session is `ok` and the timeline is NOT fully JS-walled.** Logged out, the in-app
  browser pane renders og:description *and the newest five posts*; only `/following` redirects to
  the profile with "Something went wrong. Try reloading." His newest post is **2026-08-31**, three
  days before this run. Recency for him is **active**, not `unknown` — the standing note that his
  X timeline is unretrievable is wrong, and it was the sole basis for calling him `unknown`.
- **m_shear/instagram is `ok` and the open question is CLOSED.** `instagram.com/eshear/` returns
  "Sorry, this page isn't available" **read logged in**, so the account does not exist;
  `instagram.com/emmettshear/` is a real public profile with bio, counts and 4 posts. They are not
  "identical shells" and the pair is not indeterminate. Accepted on `subject_self_identifies` (text
  inside the pinned post image: "This is my official account") plus a softmax.com bio backlink —
  with the caveat, kept in `person_identity.notes`, that 11 followers against 123,009 on X makes it
  a claimed account rather than a used one.
- **m_shear/tiktok_public is `unavailable` for an identity reason.** No TikTok session exists on
  this machine, but `@eshear` renders logged out and is **"Ramdas Paladi"** — a different person on
  the handle he uses everywhere else. New `person_identity_negative` row. `@emmettshear` renders
  with no display name, no bio and no video: handle_matches alone, accepted as nothing, no deny row
  because nothing wrong was measured — only nothing.

## run_ingest_perkins_20260903 — m_perkins / Melanie Perkins

Not a blocker, and the most important line here: **LinkedIn WORKED.** `linkedin.com/in/melanieperkins/`
read cleanly and read-only in the operator's own Chrome — headline, location, company, school,
370,636 followers, experience block, and 20 public activity posts with full bodies. **The newest post
was ONE DAY old.** She is `active`. AUD-03's retracted "no fetchable first-person 2026 publication"
is not repeated. X is live in the same session too. No write operation of any kind was issued on
any platform, and no captcha was presented or solved.

- **AUTH BLOCKED — m_perkins/facebook_session · https://www.facebook.com/melanieperkins · HTTP 200,
  the page rendered a logged-out "Email or phone / Password / Log In" bar over the body "This content
  isn't available right now" · need: the operator to log this Chrome into Facebook · impact: Facebook
  stays UNVERIFIED for her at every login state (K-2 unchanged). Note the URL was a GUESSED vanity
  slug, so even a successful read would have needed independent corroboration before a single fact
  came off it — logged out it establishes neither existence nor identity in either direction.**

- **BLOCKED (not auth) — m_perkins/openlibrary_inside · https://openlibrary.org/search/inside.json ·
  curl exit 7, "Failed to connect to openlibrary.org port 443", on two separate attempts, while
  archive.org, wikipedia.org, x.com and canva.com all resolved from the same host in the same
  minutes · need: network egress to openlibrary.org · impact: the planned in-book co-mention search
  of Perkins against each of the other nine DID NOT RUN. Any earlier "0 hits for all nine" from Open
  Library is NOT re-confirmed by this run, and `f_perkins_050` deliberately does not rest on it.**

- **BLOCKED (not auth) — m_perkins/podcast_guest · https://www.npr.org/2019/01/24/688299882/canva-melanie-perkins ·
  unreachable from this host: HTTP/2 died with "stream 1 was not closed cleanly: INTERNAL_ERROR",
  and an HTTP/1.1 retry timed out after 60s with 0 bytes · impact: the How I Built This transcript
  was already UNVERIFIED and now the page status is unknown too. The only evidence of the appearance
  this run actually read is her own LinkedIn post about it.**

- **BLOCKED BY DESIGN — m_perkins/canva_live · every `canva.com` path · HTTP 403 to a plain curl AND
  to a full desktop-Chrome UA (`/`, `/newsroom/`, `/newsroom/news/`) · impact: a guessed RSS path
  returns the same 403, which is INDISTINGUISHABLE from "absent". This run may neither confirm nor
  deny that a feed exists, and nobody should re-file this as "she has no feed".**

- **PARTIAL, not blocked — m_perkins/x_session · https://x.com/MelanieCanva/following · reached
  56 of a claimed 246 (23%) across two passes with a reload between them, real wheel events only,
  then the list stopped at `@alexrkonrad` with no spinner, no error and no 429. The silent ceiling
  again, exactly as measured for Wilson. No `no_edge_confirmed` rests on this read.
  Also recorded so nobody repeats it: a first, naive selector (`UserCell a[href^="/"]`) harvested
  **bio @-mentions from inside each cell** and produced 117 "handles" — five of them from Mike
  Cannon-Brookes' bio alone (`@Atlassian @UtahJazz @SSFCRabbitohs @Grok_Ventures @SunCable1`).
  Scoping to `[data-testid="primaryColumn"]` is necessary but NOT sufficient; the handle must come
  from the cell's own `@handle` line.**

Two open questions this run CLOSED, recorded here so they are not re-opened:

- **Instagram is resolved, and the answer is identity, not access.** Read through the operator's
  **logged-in** Instagram session, `instagram.com/melanieperkins/` still returns "Sorry, this page
  isn't available. The link you followed may be broken, or the page may have been removed." The
  audit's "Profile isn't available" was therefore **not** a logged-out artifact. Written as a
  `negative_probe`; nothing was collected.
- **The date trap is real and is now measured.** LinkedIn activity `7313006523847192576` carries
  Canva Create 2026 branding around it, and its own body reads "we're less than 10 days away from
  **Canva Create 2025**". Body and platform date field agree; the slug and title do not. Stored as
  `f_perkins_045`.

One thing this run threw away on purpose: LinkedIn's **"More profiles for you"** rail on her profile
named **Cliff Obrecht and Cameron Adams** — both genuinely her co-founders. It was still discarded.
A recommendation rail is not evidence of an edge; both edges are written from her own memoir and her
own posts instead.

## run_ingest_ries_20260903 — m_ries / Eric Ries

**No auth blockers.** LinkedIn, X, Instagram and TikTok were all read. Recorded here only so nobody
re-files the following as auth walls — they are infrastructure, and every one was measured:

- **`openlibrary.org` refuses TCP on 443 from this machine.** DNS resolves (207.241.234.205); curl
  exits 7 on both attempts and the in-app browser pane also fails to navigate. Not a 429, not a 404,
  not a bot wall. `books` is `unavailable` for m_ries and the Google Books fallback 429'd on its
  first request. Any agent whose member has an `openlibrary.org` allow-list row should expect this.
- **`youtube.com/feeds/videos.xml` 404s for a CONTROL channel.** Tested `channel_id=` and
  `playlist_id=` forms for m_ries's channel and `channel_id=UC_x5XG1OV2P6uZZ5FSM9Ttw`
  (Google Developers): all 404. The endpoint is broken or blocked from this host. A 404 here is
  **not** evidence about anyone's channel — the channel page itself returns 200.
- **archive.org was 503 mid-run.** `web.archive.org/cdx/search/cdx` returned the "Internet Archive
  services are temporarily offline" page. The `archive.org/wayback/available` API kept answering
  200 with an **empty** `archived_snapshots` object while this was true, so an empty availability
  result during the outage must not be read as "no snapshot exists". Anyone who wrote a
  Wayback-based `unavailable` this run should re-check the timestamp against that outage.
- **`syndication.twitter.com` 429'd twice** (20-byte body "Rate limit exceeded"), so it is
  `unavailable` for the run per the fetch contract. Nothing was written from remembered content.

Two findings worth carrying to the other nine:

- **A partial follow-graph walk can look complete twice.** Two independent passes over
  `x.com/ericries/following` — each a fresh reload, then real wheel events scoped to
  `[data-testid="primaryColumn"]` — halted on the *identical* 70th entry, 70 of a claimed 1,835
  (3.8%), with no spinner, no error and no 429. Convergence between passes is **not** evidence the
  list was exhausted; it is the same silent ceiling twice. No absence in that shard rests on it.
- **An RSS-only co-appearance sweep misses pages that are not in any feed.** LTSE's Insights corpus
  carries profile write-ups of Hunter Walk and Steve Huffman that appear in neither of Ries's two
  podcast feeds. They are unbylined firm editorial and became no edge — but they would have been
  invisible to a feed-based sweep, and the same is likely true elsewhere.

No credential was entered, no captcha was presented or solved, and no write operation of any kind —
post, reply, like, repost, follow, connect, message, subscribe, save or consent click — was issued
against any account on any platform, in either browser.
