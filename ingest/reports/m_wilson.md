# m_wilson — Fred Wilson

Store: `db/arena.m_wilson.db` (per-person, to avoid colliding with the other
ingest agents). `db/arena.db` is left as the untouched roster seed. Rebuild recipe and
merge notes: `ingest/sql/m_wilson-00-README.md`.

```
Status:     complete (1 source unreached)
Sources:    17 ok, 1 unavailable
Written:    46 facts, 15 edges, 22 contexts
Recency:    active on his blog, measured quiet everywhere else. avc.xyz newest 2026-07-23;
            Farcaster is where he says he publishes. X: dormant since 2024-05-21 by his own
            announcement, one exception in 2026. Instagram: 414 posts, newest 2021-04-24 — a
            MEASURED quiet, confirmed logged in, not a wall artifact. LinkedIn: "Fred has no
            recent posts". Threads: 4 posts, all July 2023. v_recency_state still reads `unknown`
            on ONE thing — web.archive.org CDX 504'd — not on any auth wall.
Deep cuts:  Form ADV Schedule A names him "WILSON, FREDERICK, R." — individual MEMBER of Union
            Square Ventures since 01/2004, ownership code B (10-25%), Control Person Yes, CRD
            4530741. https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf
            "Pele": an old Mac Mini from his storage basement, factory-reset with no iCloud or
            Gmail, running Nous Research's Hermes on a cheap Gemini model, holding $1,500 of SOL
            and USDC and trading the World Cup on Pascal entirely through Telegram. $21.84 of
            tokens spent. https://avc.xyz/my-pele-agent
            His father, General Robert Maris Wilson, ran Mechanical Engineering at West Point and,
            per the four-page biography he wrote for his own obituary, "headed a small group of
            officers assembled at the direction of General Abrams to plan for the initial
            withdrawal of U.S. forces from Vietnam." Fred was born at West Point.
            https://avc.com/2020/12/general-robert-maris-wilson/
            He is Chairman of SoundCloud, and says so in passing while explaining why he listens
            there. https://avc.xyz/free-your-music
            He told X he was leaving, on X: "This Twitter account has been dormant... I've been
            sharing my thoughts... onchain at Farcaster." 2024-05-21. He is Farcaster user #169.
            https://x.com/fredwilson/status/1792972279934267639
Deep cuts:  X served only 69 of his 1,345 follows before silently capping — and @joshk (Josh
            Kopelman) is at position 20, so the edge the brief asks about was inside the window.
            https://x.com/fredwilson/following
Deep cuts:  His LinkedIn Experience still lists "Managing Partner, Flatiron Partners, Jun 1996 -
            Present" — a firm he and Jerry Colonna shut down in 2001. Twenty-five years stale, on
            the one profile that exists to be current. https://www.linkedin.com/in/fredwilson/
New denies: none. No new collision measured. Three new ALLOW rows instead — x_public,
            instagram_public, threads (see below).
```

## Not established

- **~~Wilson→Kopelman `follows`~~ — CONFIRMED.** Position 20 of his following list, @joshk,
  "Father. Husband. VC. INTJ. Dad Joke Lover. Partner @FirstRound." Verified twice: in the DOM
  scoped to `primaryColumn`, and visually on the rendered page. Edge written STRONG.
- **The REVERSE (Kopelman→Wilson) is still untested** and belongs to the `m_kopelman` agent. The
  asymmetry the prompt flags is preserved — no `no_edge_confirmed` written in either direction.
- **1,276 of Wilson's 1,345 follows.** X served 69 and then stopped: no spinner, no error banner,
  no 429 — a page that looks finished. Two independent passes hit the same ceiling, the first a
  strict subset of the second. Nothing is assertable about the unserved 95%. What *was* established is a different, stronger
  edge: `cited_in_own_writing`, twice, from avc.com in his own voice ("Josh Kopelman, one of my
  favorite VCs", 2016-05-16; a whole post built on Kopelman's seed-boom piece, 2015-03-11).
- **The Wilson↔Feld "~296 mutual citations".** One direction is evidenced (an entire 2008 post
  titled "Great Advice From Brad Feld"). The count is not. avc.com's search UI paginates and prints
  no result total, so 296 is unverified — do not restate it as measured.
- **"My Music" = 898 posts / ~10% of lifetime output.** The category page shows only a next-page
  link, no count. Unverified. The category itself is confirmed (`#My Music` tags the 2007 vinyl
  post).
- **~~The 414-post Instagram count.~~** CONFIRMED, logged in: 414 posts, 7,063 followers,
  110 following.
- **The two Venices — still unresolved, but now measured firsthand rather than inherited.** The
  caption is exactly `"In Venice this week"` (2015-05-11) with **no structured location tag**, and
  his profile genuinely supports both readings: a Los Angeles house in his own words ("palm trees
  in front of our house", 2015-03-27) and a Santa Monica coffee shop three days earlier, against
  European travel tagged at Charles de Gaulle. `resolved=0` is the correct terminal state here,
  not a placeholder for missing data.
- **"Spesh giving Josh a putting lesson on eight"** (IG, 2017-08-12). "Josh" is a bare first name.
  Not attributed to Kopelman. Golf is recorded; the person is not.
- **avc.com crypto=254 / blockchain=254.** Not re-measured; search prints no totals.
- **Which of the two USV start dates is right.** LinkedIn says "Partner, Union Square Ventures,
  Jan 2003"; Form ADV Schedule A says his title was acquired 01/2004 and Wikipedia dates the firm
  to 2004. The filing is the better record, so 2003 is recorded as *his profile's claim*, not as
  fact. Neither was reconciled.

## Notes an implementer needs

- **Walking a virtualized list has three traps, and all three fake a complete walk.** (1)
  `window.scrollTo`/`scrollBy` do NOT drive X's loader — only real wheel events do, so a JS-only
  scroller reports "no new entries" at whatever was already in the DOM. (2) A stalled virtualizer
  is fixed by a RELOAD, not by more scrolling: pass 1 died at 42, a reload reached 69, and the 42
  were a strict subset. (3) The "Who to follow" rail uses the SAME `data-testid="UserCell"` markup
  as the list — scope to `[data-testid="primaryColumn"]` or the operator's personalized
  recommendations end up in the member's follow graph. My first unscoped selector pulled in three.
- **THE BIG ONE: there are two browsers, and only one of them is logged out.** The in-app browser
  pane is a fresh profile. The operator's real Chrome carries their live sessions. Every SESSION
  source in this run — X, Instagram, LinkedIn — was called `unavailable` on the first pass and read
  cleanly on the second. Nothing about the sources changed; only the browser did. Any agent that
  reports a SESSION blocker without trying Chrome is reporting a false negative.

- **`avc.com/?s=<q>` 302s to `avc.com/search/<q>/`.** curl without `-L` returns **0 bytes with a
  200-shaped exit** — five queries came back empty before this was caught. This is exactly the
  7.2 failure class: an empty result that looks like silence.
- **ingest-spec §7.9 is too strong on X.** Logged out, `read_page` returns bio, location, website,
  joined date, both counters, and post bodies. It is `/following` specifically that is walled.
  `get_page_text` on a status page returns the full untruncated tweet plus its absolute timestamp.
- **Instagram logged out is more permissive than §7.9 says too.** `/p/<id>/` pages render caption,
  structured location tag and absolute date to `get_page_text`. The wall is the grid, not the post.
- **Wikipedia is stored `trust_class='third_party_open'`** and therefore does not render. Anyone
  could have written it; that is what the column asks. Nothing load-bearing depends on it —
  `career_start_decade='1980s'` is backfilled from two independent non-Wikipedia sources: his own
  "When I got into VC in the mid 80s" and USV's "a venture capitalist since 1987".
- `name_respelling` left NULL. Obvious, and no recording was sought.
- Prominence untouched. fxtwitter now reads 640,844 against the roster's 640,845 — drift of one,
  not a new measurement, not written.
- One hop only. Nine non-members written from Form ADV Schedule A and one (Mignano) from his own
  2026 X post. All `is_member=0`. Nothing traversed further.
- `/tagged/` was never fetched. It is on the deny-list as an injection surface, and no
  `third_party_open` row was created for Wilson this run.

## Blockers

- All three SESSION walls CLEARED by reading in the operator's own Chrome instead of the
  logged-out in-app browser. X, Instagram and LinkedIn all `ok`.
- linkedin_cdx — web.archive.org CDX returned 504. Counted, not discarded, and it is now the only
  thing holding coverage at `unknown`. No claim is made about how many archived copies exist.
- ~~linkedin_session~~ — RESOLVED. Read live in your own Chrome session. `linkedin_public`
  (logged out) stays `unavailable` and `linkedin_cdx` returned 504 — counted, not discarded, so
  no claim is made about how many archived copies exist.
