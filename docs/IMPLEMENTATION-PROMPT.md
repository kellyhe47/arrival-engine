# Implementation prompt — THE ARRIVAL ENGINE

You are building a staff-facing arrival brief for a private members club. A webhook fires with a
name; within ninety seconds a host reads a card telling them who arrived, who present they should
meet and why, and one thing they can say out loud.

**Your job is the whole application and its infrastructure, scaffolded now so it runs the moment the
data lands.** Separate agents are collecting member data in parallel right now. You are not one of
them. Build against the schema and the fixtures; the data arrives underneath you.

---

## 1. Hard boundary — `db/` is FROZEN. Do not write to it.

**Separate agents are collecting member data into `db/` right now, while you work.** A concurrent
edit from you can corrupt a run that is expensive to redo and, worse, silently change data whose
whole value is that it was measured.

**`db/` is read-only to you. All of it. For the entire build.** As of this writing it holds:

```
db/schema.sql  db/vocabulary.sql  db/roster.sql   the DDL and seeds — load order, in that order
db/arena.<person_id>.db                            one live per-member ingest file, being written NOW
db/arena.db                                        the combined store
```

The `.db` files are the collectors' working output and they grow while you build. `arena.m_wilson.db`
already carries 20 person rows (ten members plus ten one-hop non-members), 38 facts, 12 edges, 18
contexts and 19 source attempts.

- **Do not create, edit, delete, move or reformat any file under `db/`** — not `schema.sql`, not
  `roster.sql`, not `vocabulary.sql`, not a new file of your own. No migrations, no `ALTER TABLE`
  committed there, no "just adding an index", no tidying.
- **Do not open any live database file in `db/` for writing**, and do not run any script that would.
  Open it read-only or not at all: `sqlite3.connect("file:...?mode=ro", uri=True)`.
- **Do not run ingest, do not fetch member data, do not touch `docs/ingest-prompts/`.**

**Where you actually work.** Build your own scratch database somewhere outside `db/` — a working
directory, a temp path, whatever your stack prefers — by *reading* `db/schema.sql` +
`db/vocabulary.sql` + `db/roster.sql` and executing them into a fresh file, then adding a synthetic
fact/edge/context seed you write yourself and keep outside `db/` too. That scratch file is yours to
write, drop and rebuild as often as you like. The application writing rows at runtime — `card`,
`roster` — is writing to *that* file, not to the repo's `db/`. The freeze is on the source directory,
not on your app's own storage.

Load order is always `schema.sql` → `vocabulary.sql` → `roster.sql`, with `PRAGMA foreign_keys = ON`.

**If you need a schema change — and you may well — propose it, do not apply it.** The schema is the
contract between you and the ingest agents, so changing it under them is the one edit that breaks
both sides at once. Write the exact DDL you want, plus why, to `docs/schema-requests.md` (create it
if absent), state it prominently in your report, and **carry on against your scratch database with
the change applied there only**. A human merges it into `db/` when ingest is quiet. Do not work
around a missing column in application code and say nothing — that is how the store stops being the
contract.

**If you believe something in `db/` is wrong, say so; do not fix it.** Seeded rows are measured
values with audit provenance, and a plausible-looking correction can erase a real finding.

## 2. Read before you write code

| file | what it decides |
|---|---|
| `eval/golden/*.json` | **the acceptance contract.** 18 fixtures, 24 behaviours |
| `docs/PRD.md` | 60 requirements (R-001–R-059 plus R-027a). §10 open defects, §11 implementation contract |
| `docs/scoring-model.md` | the scoring oracle — signals, buckets, gates, threshold, ties |
| `db/schema.sql` | storage, and the gates enforced as **views** rather than by care |
| `db/roster.sql` + `db/vocabulary.sql` | the canonical cast and the controlled vocabulary |
| **all of `db/`** | **READ-ONLY. Live ingest is writing here — see §1** |
| `docs/ui-states.md` + `docs/wireframes.html` | every surface and all ten card states |
| `docs/knowledge-graph.md` | node and edge types, which signal each feeds |
| `docs/decisions/DECISIONS.md` | DEC-1…DEC-12. **Settled — do not relitigate** |
| `docs/ingest-spec.md` | the fetch contract; you implement the adapter *interface*, not the collection |
| `docs/audit/01–07` | ground truth behind every number, URL-backed |

There was an adversarial spec review; it has been retired and its surviving findings are the
defects in PRD §10. Do not go looking for it.

**Precedence: fixtures > PRD > everything else** — except where PRD §10 marks a fixture defective.
Fix the spec and the fixture together and record it. **Never edit an expectation to make code pass.**

## 3. The one decision to make before anything else

**No stack has ever been chosen.** No language, framework or deployment target appears in any
document. Pick one, record it in `docs/decisions/DECISIONS.md` as DEC-13 with a one-paragraph
rationale, and proceed.

My recommendation, which you may overrule: **Python 3.11+, FastAPI, stdlib `sqlite3`,
server-rendered HTML with no build step, deployed to a single container.** Reasons: `sqlite3` is
already the store and needs no ORM for a read-only serving path; `eval/verify_fixtures.py` is already
Python, so one language covers the checkers and the app; server-rendered HTML with no bundler removes
a whole class of deployment failure for a demo that must survive being opened on a phone at a door;
and the deployed app opens a **read-only** file, so the ingest/serve split (DEC-3, R-053) is a file
copy rather than architecture. Whatever you pick, the runtime must make **zero external calls** —
`external_calls: []` is asserted by fixtures.

## 4. Build order — dependencies first

**1. `test-golden`. It does not exist, everything else consumes it, build it first.**
It must drive the *real* implementation and deep-compare the four observation surfaces that every
fixture asserts: `result`, `state_changes`, `emitted_events`, `external_calls`. It dispatches on
`when.operation`; the eleven that appear are `resolve_identity`, `resolve_label`,
`score_pair_both_directions`, `rank_room`, `select_renderable_facts`, `build_now_block`,
`validate_reason`, `render_card`, `generate_digest`, `run_ingestion`, `extract_session_fields`.
That list is also your module map.

**Observe each fixture failing for its intended reason before you make it pass.** A fixture that was
never seen red proves nothing.

**2. Vendor `validate_golden.py` into `scripts/`.** It currently lives at
`~/.claude/skills/product-inception/scripts/validate_golden.py`, outside the repo, so half the
acceptance contract is not reproducible from a clean clone. Then wire both commands:
```
validate-spec   # schema + traceability + arithmetic — green today
test-golden     # drives the real implementation
```
Never conflate them. Both in CI.

**3. The narrator seam, with a fixture-backed fake.** The narrator writes prose and makes **no
decisions**. Temperature 0. No fixture asserts model prose and no model output may change a score.
Build the seam and the fake before any card work, so card work is not blocked on a model.

**4. The deterministic core**, in order: identity resolution → label resolution → scoring → ranking
→ fact selection → gates. All deterministic, all fixture-covered.

**5. Surfaces.** Card, Why-this-score, Room.

**6. Deployment.**

## 5. The determinism boundary — do not blur it

**Deterministic:** resolution, scoring, buckets, ranking, floor, disclosure, gates.
**Probabilistic:** fact extraction at ingest, prose at compose. Nothing else.

Enforced by the fixture set itself: no golden test asserts model prose, and no model output changes
a score. If you find yourself asking a model to decide something, you have crossed the line.

## 6. Rules that are easy to implement wrongly

- **Gates live in the store, not in application code.** Six views carry rules you must not
  re-implement in Python: `v_renderable_fact`, `v_recency_state`, `v_present`,
  `v_collectable_source`, `v_assertable_absence` (an absence with no named corpus is not readable —
  K-5) and `v_traversable_person` (`do_not_traverse`, honoured at ingest — K-11).
  `v_renderable_fact` already enforces
  "no source ⇒ cannot render", "inferred without `composed_from` ⇒ cannot render", and
  "`third_party_open` ⇒ never renders". Query the views. Do not re-implement the predicates.
- **`quiet` vs `unknown`.** Only `quiet` may state silence. One unreached source downgrades the whole
  profile to `unknown` — `v_recency_state` derives this from `source_status`. A 200 with zero items
  is **not** silence.
- **S8 has two separate rules.** It cannot fire unless a substrate signal (S2/S3/S5/S7) fired, *and*
  the surfacing threshold is evaluated on the score **excluding S8**. The displayed score includes it.
- **Tie-breaking has three tiers and the second one has a trap.** LARGE-signal count, then evidence
  recency, then member id ascending. Signals carry no dates — only facts do — so a fired signal's
  date comes from the fact backing it, and a match's recency is the latest such date.
  **Exclude S8 from that maximum.** Its date is when a follower count was last read, not a dated
  event between two people; include it and every match ties at today's date, silently collapsing
  tier 2 into tier 3. G-017 covers tiers 2 and 3, G-037 covers tier 1.
- **Genericity is a property of the vocabulary, not the room.** Read `topic.discriminating`. Never
  recompute it from who is present.
- **Retry must not relax a gate.** The obvious implementation of the retry button is
  re-render-until-pass, which silently converts a hard gate into a retry loop. Retry re-runs render
  only; it does not re-ingest and does not lower a threshold.
- **`word_count` is derived, never supplied.** Fixtures hand in block text; your runner counts. The
  band is 250–350 words and outside it is a hard gate failure, not a warning. `_count_words` in the
  checker is the reference implementation; a card asserting a count that cannot be derived from its
  own block text is an error.
- **SESSION adapters must be structurally absent from the deployed runtime registry.** Not disabled —
  absent. There are five: LinkedIn, X, Instagram (measured working) plus Facebook and TikTok
  (attempted, still UNVERIFIED — DEC-6/K-2). No adapter may evade a captcha or bot-detection wall at
  any tier; a wall is `unavailable`, never something to work around. The runtime serves the cached file. The read-only adapter interface must declare **no write
  operation at all**, so posting, liking or following is unreachable by bug, retry, or injected
  instruction.
- **The cast is closed.** `person.is_member = 1` is the complete membership. People reached by
  traversal are `is_member = 0`: never scored, never surfaced.
- **DEC-12:** facts reached through a `family_or_partner` edge render on their own merits, tagged
  `via_edge_type`. The edge itself never scores and is never named on a card. Attributing the
  partner's activity to the member is `provenance_class='inferred'` and must name `composed_from`.

## 7. Surfaces

Three, mobile-first, no login: **Card** (primary), **Why-this-score** (one tap from Room), **Room**
(presence list plus simulate-arrival, standing in for the webhook).

The card is **five ordered bare-noun blocks — Who, Now, Room, Notice, Say** — no summary, no
transitions, 250–350 words, ending on a sayable line rather than a fact. Reason first, score small.
Every rendered fact carries a provenance chip (host + date); the host will be asked "how do you know
that?" out loud, in a lobby.

**Ten card states, all required:** ready · no-strong-match · cold trail · unknown coverage · empty
room · ingesting · withheld · ambiguous · not-found · thin profile. `docs/ui-states.md` gives the
trigger and exact content of each. Empty room is **not** an error.

Why-this-score shows fired signals with weights, signals that did **not** fire and why, excluded
generic topics, and the reverse-direction score. It is the whole answer to "expose the reasoning",
and it is one tap away, never on the card.

### The design system — take it from `arenahall.com`

Use the club's own visual language. These tokens were read off the live site (computed styles, not
eyeballed), and the site publishes them as CSS custom properties, so copy them verbatim:

```css
--olive:#3b4626;  --olive-d:#2c3520;                 /* dark ground */
--cream:#F1EADB;  --cream-dim:#cdc7b3;               /* type on dark */
--paper:#F1EADB;  --paper-2:#E7DECC;                 /* light ground */
--ink:#26241d;    --ink-soft:#403c32;  --mut:#6f685a;/* type on light */
--bronze:#7B5732; --gold:#B89257;                    /* accents, labels, rules */
--serif:'Cormorant Garamond',serif;  --ui:'Inter',sans-serif;
```

**Two typefaces, two jobs, and the split maps exactly onto the card.**
`--serif` (Cormorant Garamond, weight 300–400) carries all prose. `--ui` (Inter, weight 400–500,
uppercase, letter-spacing 0.16–0.32em, 10–12px) carries every label, eyebrow and control. The card's
five bare-noun labels — Who, Now, Room, Notice, Say — **are** the site's eyebrow treatment: Inter,
11px, uppercase, `letter-spacing: 3.5px`, `--bronze` on paper or `--gold` on olive. The blocks under
them are Cormorant.

**Type scale, measured at both ends** (the site is responsive; these are the real numbers):

| | mobile 375 | desktop 1280 |
|---|---|---|
| display | 32 / 35.2 w300 | 58 / 63.8 w300 |
| section head | 26 / 28.6 w300 | 40 / 44 w300 |
| italic head | 24 / 38.4 w300 *italic* | 33 / 52.8 w300 *italic* |
| body prose | 20 / 32.4 w400 | 24 / 38.88 w400 |
| UI label | 12 / 19.2 w500, ls 2.16px | same |

**Rules that carry the whole look:**
- **Zero border-radius. Anywhere.** The site has not one rounded corner. Square edges are the single
  most identifiable thing about it — one `border-radius: 4px` and it stops looking like Arena Hall.
- **Hairlines, not boxes.** `1px solid rgba(123,87,50,0.18)` on paper, `1px solid #3b4626` on olive.
  Separate with rules and space, never with cards-in-cards or shadows.
- **Italic is the emphasis device**, not bold. The site sets its emphasised phrase in italic serif and
  tints it `--gold`. Use that for the borrowed attributed line in **Who** and for the **Say** line —
  the two places the host reads aloud.
- **Buttons:** `--olive` fill, `--cream` text, Inter 12px/500 uppercase, `padding:16px 36px`,
  square. That is the only button in the system.
- **Two grounds.** Olive is the arrival/attention ground; paper is the reading ground. The card body
  is read standing in a dim lobby, so set it on `--paper` with `--ink`, and keep Room and
  Why-this-score consistent with it.

**One deliberate deviation, and state it in the README.** Cormorant Garamond at weight 300 is a
display face and it is genuinely hard to read small, in low light, at arm's length — which is exactly
the reading condition R-033 is built around. So: **never set card prose below 19px**, use weight 400
not 300 for body, and put anything dense or numeric (the score, provenance chips, source dates,
Why-this-score's signal table) in Inter. That is what the site itself does, and it keeps the 90-second
read honest instead of pretty.

Both faces are on Google Fonts. Self-host or preload them — a webfont that arrives late turns the
first paint into a flash of the wrong typeface, on a surface with a ninety-second budget.

## 8. Open defects

**None.** Every P0 is closed and every risk is either mechanised or accepted by a logged decision
(PRD §10, DEC-1…DEC-12). Two things are worth knowing anyway:

- **G-037 is deliberately synthetic** and says so in its own `why`. An exhaustive search over all ten
  members and all pairs found no equal-score tie with differing LARGE counts anywhere in the real
  graph, so tie-break tier 1 cannot be grounded in real data. G-017 carries the one real tie and
  covers tiers 2 and 3. If ingest ever produces a real differing-LARGE-count tie, re-ground G-037.
- **P0-5 was closed by decision, not by mechanism.** The card is staff-only by assertion: unguessable
  path, `noindex`, `robots.txt` disallow, and no member name in any URL or page title. That is
  discovery mitigation, not access control, and the README must say so plainly (R-059).

## 9. Definition of done

- All 60 requirements met.
- **`db/` is untouched.** `git status` shows no modification under `db/`, and any schema change you
  needed is written up in `docs/schema-requests.md` rather than applied.
- `validate-spec` and `test-golden` both green **from a clean clone**, both in CI.
- Every fixture observed failing for its intended reason before passing.
- The app runs against an empty store and against a populated one, and degrades honestly in between —
  a member with no facts yet gets a thin-profile or unknown-coverage card, never a crash and never an
  invention.
- Deliverables: **a live clickable URL**, the repo, and **one paragraph** on what to build next given
  a month and real member data.
- **An hours ledger against a visible cut line.** RUBRIC-1 scores "in how many hours" and DEC-0
  requires an explicit "first N hours" line the demo can be narrated against. Keep it as you go;
  it cannot be reconstructed afterwards.
- The run is resumable from disk: ticket board, scope, criteria, commands and resume procedure as
  files, written **before** you dispatch any sub-agent.

## 10. The invariant

**The engine must never assert what it merely failed to observe.**

Every defect the audit found was a variant of it: the `@spez` handle collision, the operator's own
social graph leaking into member profiles, a tagged post naming the wrong Fred Wilson, and "Eric Ries
is dormant" the month he shipped a book.

Check yourself against it: for any claim on a card, can you name the source that was actually read,
and distinguish "we looked and there was nothing" from "we could not look"? If not, it must not
render. The second failure mode is not incompleteness, it is creepiness — *a member who feels SEEN
renews and brings friends; a member who feels DOSSIERED quits and tells people why.* The shippable
test is whether the member would be pleased to read the card over the host's shoulder.
