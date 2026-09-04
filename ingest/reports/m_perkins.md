# m_perkins — Melanie Perkins

Wrote **`db/arena.m_perkins.db`** (never `db/arena.db`). SQL: `ingest/sql/m_perkins-0{0,1,2}-*`.

```
Status:     partial (5 sources unreachable)
Sources:    7 ok, 5 unavailable, 3 skipped-by-rule
Written:    50 facts, 24 edges (15 real + 9 measured absences), 14 contexts
Recency:    active — LinkedIn read live in the operator's Chrome; newest post ONE DAY old
            (GiveDirectly / Malawi field visit). She is not quiet and not unknown.
```

**Deep cuts**
- She learned to kitesurf purely as an instrument to reach an investor, and hated it, in her own
  words: *"Kitesurfing scares the hell out of me, and learning to kitesurf in the dreary, cold,
  shark-invested waters of San Francisco was far from enjoyable. But I wanted to get Canva off the
  ground, so it was just a small inconvenience."* — `f_perkins_018`,
  `web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/`
- Her first customer's $100 deposit: *"We couldn't decide if we should frame the cheque or cash it.
  We opted to cash it because it might seem a little strange if it wasn't cashed and also, we needed
  the money."* — `f_perkins_014`, same URL
- 36 hours awake to hit a deadline she had set herself: *"My eyesight started to go fuzzy — looking
  in the mirror I could hardly see myself."* — `f_perkins_020`, same URL
- A documented journalling practice — Morning Pages, School of Life Philosophical Meditations —
  which she ties directly to the product: *"I think that may have been one of the reasons behind
  wanting the whole world to be able to design."* — `f_perkins_029`,
  `web.archive.org/web/20251031134619/…/melanie-perkins-21-questions-part-2/`

**New denies:** none. No new collision was measured.

**Not established — the valuable part**
- **Whether she has any RSS feed.** Every `canva.com` path is 403 to plain curl *and* to a
  desktop-Chrome UA, so a guessed feed path 403s too. Blocked is indistinguishable from absent here;
  this run can neither confirm nor deny one, and nobody should record "she has no feed".
- **In-book co-mentions with the other nine.** `openlibrary.org` was connection-refused twice while
  every other host resolved. That search did not run. Nothing here re-confirms an earlier "0 for
  all nine" from Open Library.
- **Her full X follow graph.** 56 of a claimed 246 reached, then a silent ceiling at `@alexrkonrad`.
  None of the nine appeared in those 56 — but at 23% that is not an assertable absence, and
  `f_perkins_050` deliberately excludes the follow list from the corpus behind the nine
  `no_edge_confirmed` edges.
- **The How I Built This transcript.** npr.org was unreachable from this host (HTTP/2 internal
  error, then a 60s timeout). Only her own LinkedIn post about the episode was read.
- **Facebook, at any login state.** Guessed slug, no session — K-2 is unchanged.
- **Her `name_respelling`.** No recording of her saying her own name was fetched; left NULL.

**What *is* established, against the four corpora named in `f_perkins_050`**
Searched in full: the complete Wikipedia wikitext (14,469 B), both memoir parts (104,287 chars),
the archived newsroom index, and 20 LinkedIn posts. She names Cliff Obrecht, Cameron Adams, Lars
Rasmussen, Bill Tai, Greg Mitchell, Niki Scevak, Lenny Rachitsky, Jonathan Shriftman and Alex
Konrad, and the funds Matrix Partners, InterWest Partners, Blackbird Ventures and Commercialisation
Australia. **None of the other nine, and none of their firms.** The only hit for any of their
keywords anywhere is the book title *The Lean Startup*, named as something that was "in vogue"
while she was raising, with no person attached. Her card is a thin-room card, and that is correct.

**Blockers** — full detail appended to `ingest/BLOCKERS.md`:
- `AUTH BLOCKED — m_perkins/facebook_session · facebook.com/melanieperkins · HTTP 200, logged-out
  login bar over "This content isn't available right now" · need: operator to log Chrome into
  Facebook · impact: Facebook UNVERIFIED at every login state; the slug was a guess besides.`
- `BLOCKED — m_perkins/openlibrary_inside · curl exit 7 ×2 · impact: the nine-way in-book
  co-mention search did not run.`
- `BLOCKED — m_perkins/podcast_guest · npr.org unreachable · impact: transcript still UNVERIFIED.`
- `BLOCKED BY DESIGN — m_perkins/canva_live · 403 to every client · impact: feed existence
  undecidable in either direction.`
- `PARTIAL — m_perkins/x_session · 56 of 246 · impact: no absence may rest on the follow graph.`

**Two audit questions this run closed**
- **Instagram is identity, not access.** Through the operator's *logged-in* session,
  `instagram.com/melanieperkins/` still returns "Sorry, this page isn't available." The earlier
  "Profile isn't available" was not a logged-out artifact. Written as a `negative_probe`.
- **The date trap is measured.** LinkedIn activity `7313006523847192576` sits under Canva Create
  2026 branding and its own body reads "less than 10 days away from **Canva Create 2025**". Dates
  came from bodies and platform fields throughout — never from a slug. (`f_perkins_045`)

**Discarded on purpose:** LinkedIn's "More profiles for you" rail named Cliff Obrecht and Cameron
Adams — genuinely her co-founders — and was still thrown away. A recommendation is not an edge;
both are written from her own memoir and her own posts. Also discarded: a first naive follow-list
selector that harvested bio @-mentions and produced 117 phantom "handles", five from Mike
Cannon-Brookes' bio alone.

**Left alone for the merge:** `prominence_tier` / `prominence_basis`, though both figures drifted
(LinkedIn 370,639 → 370,636; X 56,591 → 56,593). Recorded as `f_perkins_032`, not re-baselined.
