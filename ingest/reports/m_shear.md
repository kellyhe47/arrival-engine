# m_shear / Emmett Shear

Store: **`db/arena.m_shear.db`** (`db/arena.db` never opened for writing).
SQL: `ingest/sql/m_shear-01-facts.sql`, `m_shear-02-edges-identity-backfill.sql`, README in `-00-`.

```
Status:     partial (1 blocker + 1 partial read)
Sources:    27 attempts — 20 ok, 3 unavailable, 4 skipped (deny-listed, recorded not omitted)
Written:    60 facts (58 renderable), 29 edges (7 assertable absences), 14 contexts
Recency:    ACTIVE — newest X post 2026-08-31T16:30:53Z, three days before this run;
            23 posts 2026-05-15→2026-08-31. Store-level coverage still reads `unknown`
            because Facebook is unreached; that is coverage, not silence.
```

## Corrections to the brief — three, and the first two change the profile

- **He is not `unknown`, he is `active`, and the premise was wrong.** The brief says the X timeline
  is JS-walled, so a gap in retrievability must not be read as silence. Measured: the **logged-out**
  profile shell renders og:description *and the newest five posts*, and the logged-in read returns
  23 posts from 2026-05-15 to 2026-08-31 at roughly two a week. Only `/following` is walled logged
  out. His own *bylined long-form* is still ~16 months old (April 2025) — that part holds — but
  "nothing fetchable after April 2026" does not.
- **Instagram resolves, and the pair is not indeterminate.** `instagram.com/eshear/` **does not
  exist** ("Sorry, this page isn't available", read logged *in*). `instagram.com/emmettshear/` is a
  real public profile: bio "CEO of Softmax | Entrepreneur / Co-founder, Justin.tv & Twitch / Former
  Interim CEO, OpenAI", link softmax.com/about, 4 posts, **11 followers**. Accepted on
  `subject_self_identifies` — text inside the pinned post image reads *"I'm Emmett Shear... This is
  my official account."* Caveat kept in the row: 11 followers against 123,009 on X is a claimed
  account, not a used one, and nothing beyond the bio was taken off it.
- **`hn_api` count drift:** Algolia returns 927 (matches the roster); the Firebase `submitted`
  array holds **1,167** ids. The gap is dead/deleted items Algolia does not index. Roster row left
  alone.

## Deep cuts

- **`edbs.media` — a personal site nobody had catalogued.** "Welcome to the Educational Database
  System", styled as a database console, four pages, entirely first person: *"I made Twitch (2010)
  / I co-wrote a paper about how electronic voting machines are a bad idea (2004)"*. Reached from
  **his own LinkedIn post** (`linked_from_own_canonical`), never from a search result. This is the
  site `eshear.com`'s parking page and the dead `emmettshear.com` apex have been standing in for.
  <https://www.edbs.media/>
- **A Yale CS technical report he co-wrote as an undergraduate.** *"Tiny Systematic Vote
  Manipulations Can Swing Elections"*, YALEU/DCS/TR-1285, April 2004 — *"changing only a single vote
  per electronic voting machine can change the outcome of the election."* cpsc.yale.edu 403s every
  automated client; read via Wayback. <https://cpsc.yale.edu/sites/default/files/files/tr1285.pdf>
- **The quantum gravity thread, verbatim, 2025-08-11:** *"Epistemic warning: crackpot physics from
  someone who isn't a physicist. Epistemic upside: I think I have one maybe actually correct idea
  buried in it."* <https://threadreaderapp.com/user/eshear>
- **"Optimize Prime", 2006–2010, and the comment thread.** His post *"That's very liberal of you"*
  (2006-10-26) drew a two-comment argument whose first comment is signed **Aaron Swartz**, and he
  answers it. Also 2006-11-30, *"This Blog Is Boring"*: *"What I'm really worried about is that this
  reflects my current personality, working for a startup: boring... My only hope is to retire to a
  monastery in the mountains."*
  <http://web.archive.org/web/20071224103940/http://blog.emmettshear.com:80/post/2006/10/26/Thats-very-liberal-of-you>
- **A standing book database plus a 2024 reading log with a paragraph of commentary per book**
  (Stafford Beer, Allende and Syntegrity; MacIntyre; Hoffman), and a 2026-05-30 X post
  photographing a book stack whose spines overlap it — an image corroborating a text, which is the
  only way an image is allowed to count. `reading-and-books` assigned.
  <https://www.edbs.media/books2024>
- **The strongest edge, in his own words, HN 1821879, 2010-10-22:** *"This is where we wrote a good
  deal of the code for Kiko, and where Steve wrote a lot of Reddit. It makes me nostalgic for our
  2005 YC batch."* Written as `shared_org` **symmetric** and `cited_in_own_writing`
  **Shear→Huffman only**. He is the only one of the ten who writes Huffman's name unprompted.
- **A second, independent Huffman bridge, twenty years later:** Softmax's co-founder and board
  member **Adam Goldstein** cofounded **Hipmunk** — with Huffman. Sourced from softmax.com/team and
  the Wikipedia article, not inferred from the brief.

## New denies

- **`https://www.tiktok.com/@eshear` → "Ramdas Paladi"**, 1 following, 0 followers, "No bio yet."
  Previously that handle returned "Couldn't find this account"; it now resolves to a different
  person, which is the worse failure. `tiktok.com/@emmettshear` has no name, no bio and no video —
  indeterminate, accepted as nothing, no deny row (it is not a measured wrong person).

## Not established — the valuable part

- **The follow graph, at 70 of 1,193 (5.9%).** Two full passes on the operator's Chrome, real wheel
  events, selectors scoped to `[data-testid="primaryColumn"]`; the second pass returned a strict
  subset of the first. **Silent ceiling**, the same shape as Wilson's 69-of-1,345 — no spinner, no
  error, no 429. So: `follows` is asserted only for the six reached (incl. **`m_shear → m_qureshi`**,
  the one member in the reachable slice); **no `no_edge_confirmed` was written off the follow walk**
  (R-011). The other nine members' absence from the follow graph is *not measured*.
- **The seven absences that ARE assertable are HN-only, and the corpus is named.** All 927 indexed
  items searched for every other member by surname, first name, firm and product: Feld, Kopelman,
  Tavel, Walk, Ries, Qureshi, Perkins — **zero**. Fred Wilson occurs exactly twice and **both are HN
  story titles of threads he commented in**, never his own words, so it is not a citation. These
  edges say "not in his Hacker News writing", nothing wider.
- **Facebook is unmeasured at every login state.** Slug `emmett.shear` is Wikipedia-sourced, not
  guessed; Chrome has no Facebook session. Existence, visibility and identity all unknown.
- **LinkedIn carries no career history.** Neither the archived logged-out page nor the live
  logged-in read renders an Experience or Education section — only the top-card chips (Softmax,
  Yale). His LinkedIn headline is **"Researching organic alignment"**, the one surface that does not
  say CEO; `member_label.current_label` stays `Softmax — CEO` on the other four.
- **The Aaron Swartz comment is NOT attributed.** A blog comment name field is a display name on a
  forgeable surface — one WEAK signal, which fails R-012. Stored `third_party_open`, no person row,
  no edge. Same treatment for the Justin Kan LinkedIn recommendation (*"the smartest guy I know"*).
- **`name_respelling` still NULL.** Three talk videos exist and would carry a pronunciation; audio
  was not retrieved and a pronunciation is never guessed.
- **Vocabulary drift, reported not fixed:** `topic.reading-and-books.holder_count` reads 2 and is
  now 3 of 10. `discriminating` is **unchanged** (0.30 < 0.40), so nothing breaks — but the
  denominator in `db/vocabulary.sql` is stale by one. Left alone per 00-COMMON.
- **`prominence_basis` drift:** fxtwitter reads 123,009 against the roster's 123,007 the same day.
  Same band, row untouched.
- **`seniority_tier` = `chief-executive` is correct** and fixture G-017's `founder` is the defect
  (P0-9). The table was not bent to match the fixture.

## Blockers

- **AUTH BLOCKED — m_shear/facebook_session · <https://www.facebook.com/emmett.shear> · HTTP 200,
  a logged-out "Log In / Forgot Account?" bar over "This content isn't available right now" · need:
  the operator to log the browser into Facebook on this machine · impact: Facebook is UNVERIFIED
  for him in both directions — logged out the page distinguishes nothing between "no account",
  "restricted audience" and "deleted".** Not authenticated against; that is the user's to do.
- **PARTIAL — m_shear/x_following · 70 of 1,193 · platform ceiling, not a wall.** No auth would fix
  it; the operator's session is already logged in and the list still stops.

No write operation of any kind was issued against any account, in either browser.
`softmax.com/robots.txt`'s single disallow was honoured; the four deny-listed URLs were not fetched.
