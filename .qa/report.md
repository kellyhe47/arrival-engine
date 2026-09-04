# Manual QA — Arena Hall Arrival Engine

> **SUPERSEDED IN PART, 2026-09-04 (DEC-15).** The operator withdrew the Do Not Brief opt-out
> entirely — members are never told this service exists, so none of them could ever have declined
> it. **QA-9 is void**: the state it asked for no longer exists, and seeding a holder for the flag
> was reverted along with the flag. **QA-10 is moot** for the same reason, though the rail-gating
> fix it produced was kept and still guards `not_found`. **QA-11**'s opt-out handling in
> `scripts/urls.py` was likewise removed. Everything else below stands. The seeded roster is also
> gone: the app now starts with nobody in the room.
>
> **Re-walked 2026-09-04 after fixes.** Resolution status is recorded under each finding.
> `OPENAI_API_KEY` is now loaded from `.env`; all ten members render.

```yaml
sha: e3bd576
branch: codex/ingest-m-feld
tree: dirty          # this report describes working-tree code that exists nowhere else
launched: make serve PORT=8112   (http://127.0.0.1:8112/d3f0-arrival-9c1a/)
form_factor: 390px wide (the design handback's width); desktop sanity pass only
```

**Spec sources.** By instruction, `docs/PRD.md` was NOT used. Compared against:
- the design handback, `Arrival Engine - Room (390).html` / `Arrival Engine - Card (390).html`
- `docs/design-additions.md` (A-1…A-9)
- `docs/ui-states.md` (state table and journeys)

## Flows walked

| # | Flow | Result |
|---|---|---|
| 1 | Room → Fire the webhook → member card | pass (on current code) — see QA-1 |
| 2 | Room → member name → card → why → back to card | pass |
| 3 | Room → Mark departed → Room updates | pass |
| 4 | Room → Live re-run → Ingesting → Open the card | pass |
| 5 | Card states: unknown_coverage, withheld, not_found | pass with findings |
| 6 | Card states: ready (full 5-block card) | **BLOCKED** — QA-3 |
| 7 | Card states: do_not_brief | **BLOCKED** — QA-9 |
| 8 | Resolution chooser: resolved / not found | renders; **no UI entry point** — QA-6 |
| 9 | Resolution chooser: ambiguous (>1 candidate) | not reachable with current roster data |
| 10 | Say rail: appears, hides when the real block arrives | **UNVERIFIED** — see Escalations |
| 11 | Repeat arrival / back-then-resubmit | **FAIL** — QA-2 |

## Findings

### QA-1 · The reported bug: "Fire the webhook" is dead on port 8111 (stale build)
**RESOLVED (environmental).** Not a code defect — kill PID 36963 and restart on 8111.

**Flow 1.** The button itself is fine. A stale uvicorn (PID 36963) is still listening on
`127.0.0.1:8111` running a pre-change build; the card it redirects to 500s, so the click looks
like it did nothing.

Repro:
```
POST /d3f0-arrival-9c1a/arrive  person_id=m_tavel
  :8111 -> 303 -> GET /card/7e5f712c5ab0 -> 500 Internal Server Error
  :8112 -> 303 -> GET /card/7e5f712c5ab0 -> 200 OK
```
Expected: 303 then a rendered card. Observed on 8111: 303 then `Internal Server Error`.
Fix: `kill 36963`, then `make serve PORT=8111`.

### QA-2 · A repeat arrival duplicates the member in the Room and quadruples them in scoring
**FIXED.** `Store.arrive()` closes any open row before inserting; `present_ids()` and `roster_rows()` group by person. Re-walked: three arrivals for one member 9s and 22s apart → one Room row, one entry in presence, five distinct `why` targets on the card.

**Flow 11. High.**

Repro:
1. `POST /d3f0-arrival-9c1a/arrive` with `person_id=m_ries`
2. wait >1 second
3. repeat step 1
4. open Room

Expected: one row for Eric Ries; the banner counts people.
Observed: two "Eric Ries" rows, both with `arrived 04:45`, and the banner reads **"8 present"**
for 7 distinct people. He also appears twice in the Live re-run picker.

The same duplication reaches the card. On Steve Huffman's card the "Who's here" miss row emitted
**nine `why` links, four of which point to the same member token** (`cab0bc6e22ba` = Eric Ries).
A host tapping them lands on the same page four times.

The room-list duplication is 2×; the scoring duplication is 4× — the presence list squares the
duplicate before scoring runs.

Two arrivals inside the same second collapse and do not reproduce it. Back-then-resubmit is the
easiest way to hit it by accident; a webhook retry or a second badge scan is the real one.

### QA-3 · Every card with a match is withheld — the designed card is unreachable
**FIXED.** `.env` is now loaded at import (`arena/config.py:load_dotenv`). All ten cards render five blocks; Eric Ries correctly shows the opt-out card instead.

**Flow 6. High (may be intentional; flagging because it is the demo path).**

With no `OPENAI_API_KEY` in the environment, 5 of 10 members render:

> WHAT FAILED — GATE `narrator available` · OBSERVED `False`

Fred Wilson, Brad Feld, Josh Kopelman, Eric Ries, Emmett Shear, Sarah Tavel and Hunter Walk all
show the withheld greeting. The four that do render (Huffman, Perkins, Qureshi, Shear) are all
`no_strong_match`, so **no five-block card with a "Who's here" match can be observed at all** —
the exact screen the Card design specifies.

This is R-048 degrading correctly, not a crash. But as shipped it means the primary surface is
unavailable for every member the product exists to brief.

### QA-4 · "Why each pair missed" renders N indistinguishable `why` links
**FIXED.** Each pair is its own anonymous ranked row with its own score — `1. Scored, not surfaced · 3/16 · why`. Still no names (R-038).

**Flow 5. Medium.** Steve Huffman's card, "Who's here":

> Why each pair missed: why · why · why · why · why · why · why · why · why

Nine identical links, no name, no score, no ordinal. R-038 correctly forbids naming the
candidates, but the host has no way to pick one deliberately. The anonymous score row above it
(`Top score, no candidate named · 3 · needs 6`) proves a figure can be shown without a name —
the links could carry theirs.

### QA-5 · The resolution screen still says "SAY"
**FIXED.** `resolve.html` goes through `block_title` — reads "Your opening line".

**Flow 8. Medium.** `/d3f0-arrival-9c1a/resolve?name=zzz%20nobody`

Expected: "YOUR OPENING LINE" — every other surface renamed with the block titles
(design-additions A-6).
Observed: **"SAY"**. `arena/templates/resolve.html:30` hardcodes the old bare noun instead of
going through `block_title`.

### QA-6 · The resolution chooser has no entry point in the UI
**FIXED.** Room has a "Name at the door" field posting to `/resolve`. Walked end to end.

**Flow 8/9. Medium.** `ui-states.md` navigation says
`Card --(ambiguous name)--> Resolution prompt --(host picks)--> Card`.

No template links to `/resolve`. The page only renders if you type the URL. The arrival webhook
returns a 409 with candidate tokens as JSON, but nothing navigates a host to the chooser, so an
ambiguous arrival is a dead end for the person standing at the door.

### QA-7 · Degraded cards double-dash the identity line and drop the stale-label warning
**FIXED.** Degraded cards share one `identity_line` macro that runs the label through `affiliation_line`, and carry the stale-label correction. The correction was simultaneously removed from the RENDERED path, where the narrator's own prose already said it — it was printing twice.

**Flow 5. Medium.** Emmett Shear's withheld card:

> Emmett Shear — Softmax — CEO.

Two em-dashes in one line, because the stored label already contains one. The banner eyebrow
handles the same string correctly ("SOFTMAX · CEO") — the withheld / thin-profile /
do-not-brief branches build the line by hand instead.

Same screen, second half: Shear's supplied label is stale (`Twitch` → `Softmax`, `stale=1`). The
rendered card shows that correction; the **withheld** card does not. The host is not actively
misled — the current label is shown — but the "the door said X" line that exists specifically
because the host may have read the door never appears on the degraded path.

### QA-8 · The banner eyebrow renders an unbounded stored string
**FIXED.** `affiliation_line(..., max_parts=2)` for the eyebrow — Ries now reads `LTSE · AUTHOR`. Prose keeps the full string.

**Flow 5. Low.** Eric Ries's card:

> LTSE · AUTHOR · INCORRUPTIBLE (2026-
> 05-26)

Two lines at 11px with 3.5px tracking, broken mid-date. The eyebrow is meant to be "where they
are and what they do there"; `member_label.current_label` for Ries carries a book title and a
publication date. No horizontal overflow (page width stays 390), so this is legibility, not
breakage. Capping the eyebrow at two parts would fix it without touching the store.

### QA-9 · The do-not-brief state cannot be exercised — no member carries the flag
**FIXED.** `seed/synthetic.sql` gives the opt-out a holder (Eric Ries, matching the Room mock). The card renders name and role only.

**Flow 7. Low (data, not UI).** `member_flags` is empty in `var/arena.serve.db`, so no member is
opted out. The Room design mock lists **"Eric Ries — do not brief"** in Simulate arrival; the
template renders that marker correctly but has no flagged member to render it for. The
`do_not_brief` card — one of the states `ui-states.md` specifies — is unreachable in this build.

### QA-10 · The Say rail followed a member who opted out  *(found during the re-walk)*
**FIXED.** With the key in place, Eric Ries's Do Not Brief card — the screen that says "no
dossier, no matches" — rendered his full opening line pinned in the Say rail, because the digest
had been built before the opt-out was checked. The card also claims in so many words that
"nothing was built and then thrown away", which was false.

`web.py` now short-circuits before `generate_digest` when a member is opted out, and the rail only
renders when the body actually renders the card. Verified: `sayrail` occurs 0 times in that page's
HTML, 2 times on every other card. `scripts/urls.py` was given the same short-circuit.

### QA-11 · The operator listing reported states the app does not show  *(found during the re-walk)*
**FIXED.** `make serve` prints a pre-flight table that ran without the narrator, so it said
`withheld` for seven members whose cards render fine, and ignored the opt-out. It now labels that
column honestly (`withheld (no narrator)`) and honours `do_not_brief`. It deliberately still does
NOT call the model — buying ten Say lines to print a table is not what the key is for.

### QA-12 · Two spellings of "sayable" disagreed, and the disagreement withheld whole briefs
**FIXED.** Reported as "Emmett Shear's brief is failing". Deterministic, and the model was right.

For a thin fact — `{"useful_fact": "Emmett Shear follows Nabeel Qureshi"}` — the narrator returned
`"Emmett, Nabeel Qureshi is here this evening."` four times out of four. Both checks rejected it
for the same reason, a missing literal "you":

- `narrator.validate_say_line` — "a Say line without direct second-person speech"
- `card.is_sayable`, the `closing_block_is_sayable` hard gate

The rule also fought the prompt. `SAY_INSTRUCTIONS` forbids routing the member and demands "a
declarative observation, not a suggestion, question, offer, or command" — and on a thin fact
almost every natural way to work in a "you" leans toward the routing it was told to avoid. So the
model dropped the pronoun, kept the vocative, and the whole brief was withheld over it: name,
recency, matches and deep cut, all gone, on a card that then said "a hard gate failed".

Both checks now accept a **vocative** — the line opening by naming the person it is spoken to —
as direct address, which is what it is. `is_sayable` takes an optional `addressee` and keeps the
old strict behaviour when the caller cannot supply one, so nothing a fixture asserts moved. A line
addressing nobody ("Fred Wilson is here tonight.") is still rejected.

Verified: all ten cards render. Shear closes on *"Emmett, Nabeel Qureshi is here this evening."*
— 261 words, gates passed, grade 4/4. `make test`: 85 passed.

Nabeel Qureshi was collateral, not a second bug: he sits on the other side of the same pair, and
his own card had already been rendering.

## Escalations

- **No `OPENAI_API_KEY`.** I cannot exercise the model narrator, so the full five-block card, the
  Say-rail-with-real-content, and the "Who's here" match rows were never rendered. QA-3 is that
  escalation stated as a finding; flows 6 and 10 are blocked by it.
- **IntersectionObserver does not fire in this browser pane.** A fresh observer attached to an
  element 100% inside the viewport produced zero callbacks, and screenshots intermittently fail
  with "the page is not compositing frames". The Say rail therefore never gained its `gone` class
  during testing. **I am not reporting that as a bug** — I could not distinguish it from the
  harness. It needs a look in a real browser: scroll a rendered card to the bottom and confirm the
  rail fades out when "Your opening line" comes into view.
- **Ambiguous resolution** could not be triggered: no two members in the roster share a name
  fragment that resolves to more than one candidate.

## State left behind

The QA walk wrote to the roster in `var/arena.serve.db`: Steve Huffman, Sarah Tavel, Josh
Kopelman and Eric Ries were marked arrived, Brad Feld departed, and Eric Ries is deliberately left
**duplicated** as live evidence for QA-2. `make store` rebuilds the demo roster from scratch.

No `.tdd/` directory exists, so no tickets were filed — this report is the deliverable.
