# Design handoff — THE ARRIVAL ENGINE

## The product
A staff-facing arrival brief for a private members club. A webhook fires with a name; the host has
~90 seconds between the door and the handshake. One card tells them who arrived, who present they
should meet and why, and one line they can say out loud. It is read **standing, one-handed, in low
light, watching a door**. The failure mode is not incompleteness, it is creepiness: the shippable
test is *"would the member be pleased to read this card over the host's shoulder?"*

## Where to look — do not restate these, read them
- `docs/PRD.md` §6 (the card) and §7 (surfaces) — R-033 to R-047 are binding.
- `docs/ui-states.md` — every state, its trigger, content, actions and exit. `docs/wireframes.html`
  — the structural skeleton the built app already follows.
- `eval/golden/*.json` — **real content, not lorem ipsum.** `22-full-digest-happy-path.json` is a
  253-word card with real block text; `19`, `31`, `33`, `35` carry the degraded states. Design
  against these strings. Lorem hides exactly the states that break the layout.
- `arena/static/arena.css` — the existing Arena Hall token set and the three rules in its header
  comment. `arena/templates/*.html` — the surfaces as shipped.

## What is already built, and what you are handing back
The app is live and server-rendered (FastAPI + Jinja2, no build step). **Your deliverable is edits
to `arena/templates/*.html` and `arena/static/arena.css` in the real repo** — not a separate
prototype file that will drift. `make run` serves it; `make store` seeds it. Target viewport
**390×844**, mobile-first, light only (a phone at a door, not a dashboard).

`make test-golden` and `make validate-spec` must be green when you hand back. They assert card
structure, block order and word count — so **structure and rendered text are not yours to change.**
Type, space, rhythm, hierarchy, chip and score treatment, and every degraded state are.

## Copy that is fixed — quoting it wrong undoes a requirement
- The five block labels, in order, bare nouns, no summary and no transitions:
  **`Who` · `Now` · `Room` · `Notice` · `Say`** (R-034).
- Suppression is **class and count only**: *"2 withheld: finance, family."* Never the content (R-028).
- A stale door label reads: *"the door said [supplied]; it is [current] now."*
- A miss is stated, never hidden: *"top score 5, needs 6"* — and **never names the candidate** (R-038).
- Empty room is *"first one here"*, and is **not an error state** (ui-states).
- The state strings in `arena/view.py:STATE_COPY` are spec text. Set them; don't rewrite them.

## What the host must understand at a glance
- **Card** — the name, then *is this person mid-something or quiet*, then *one person to introduce
  and why*, then the one personal thing, then the line to deliver. The **Say** line and the borrowed
  line in **Who** are the two things read aloud; the italic serif in gold marks them, and nothing
  else may compete for that role. **Reason first, score small** (R-036): the score is an integer out
  of 16 that the host ignores unless challenged. It is never the headline.
- **Why-this-score** — one tap away, never on the card: what fired with weights, what did *not* fire
  and why, excluded generic topics, and the reverse-direction score.
- **Room** — who is here, in arrival order, plus the demo controls.

## The hardest problems, named
1. **Provenance without a debug view.** Every rendered fact carries a chip — source host and date —
   because the host will be asked "how do you know that?" out loud in the lobby. Five blocks of
   prose plus a chip per fact is the layout that most easily turns into a log file.
2. **Degraded states must read as answers, not errors.** Cold trail, no-strong-match, unknown
   coverage, thin profile and withheld are correct outcomes. They are shorter than 250 words on
   purpose and must never look broken or padded.
3. **`unknown` vs `quiet`.** "Every source was reached and there was genuinely nothing" and "a
   source could not be read" must be visually distinguishable at a glance. Collapsing them is the
   single defect this whole product exists to prevent.
4. **Cormorant Garamond at 300 is a display face** and the reading condition is hostile. The
   existing deviation — prose never below 19px / weight 400, everything numeric in Inter — is a
   starting point, not a settled answer. Improve it if you can defend it.
5. **The ingesting screen is half the argument.** Blocked adapters are shown with their reason, not
   hidden.

## Visual direction
Arena Hall's own language, already tokenised: olive `#3b4626`, cream/paper `#F1EADB`, ink `#26241d`,
bronze `#7B5732`, gold `#B89257`. **Zero border-radius anywhere. Hairlines and space, never
cards-in-cards, never shadows. Italic serif in gold is the emphasis device, not bold.** Editorial
and quiet — a printed brief, not an app UI.

## Every state, not just the happy path
Reach them from the Room surface (`make run`, then the unguessable root path printed at start):
ready · no-strong-match · cold trail · unknown coverage · empty room (`make store-empty`) ·
ingesting · withheld · ambiguous · not-found · thin profile. Each gets a screenshot
at 390×844 in your hand-back.

## Design past the spec — but label it
You will spot gaps the PRD missed; those are valuable and are part of why this step exists. For
anything you add that the spec does not cover, record **what you added, what it does, and why the
flow needed it** in `docs/design-additions.md`. Additions are welcome; *silent* additions are not.

## The bar, and judging yourself against it
Both are public, fetchable logged-out, and comparable at 390×844:
- **Card** → `basecamp.com/shapeup/1.1-chapter-02` — labelled long-form reading, no chrome. The bar
  for prose density and section rhythm on a phone.
- **Why-this-score** → a `pagespeed.web.dev` report — a score with its weighted components and its
  "did not apply" audits, which is structurally the same screen.

Before handing back, screenshot the bar at 390×844 and put it beside your surface **blind** —
neither labelled. A fresh critic that did not design it picks which one a user reads faster and
names the single biggest gap. Fix, re-run, and report the final verdict, naming every surface where
the bar still wins. Losing to the bar is fine to hand back; a self-graded "meets the bar" with no
comparison behind it is not a claim at all.
