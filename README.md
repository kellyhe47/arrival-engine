# THE ARRIVAL ENGINE

A staff-facing arrival brief for a private members club. A webhook fires with a name; within ninety
seconds a host reads a card telling them **who arrived**, **who present they should meet and why**,
and **one thing they can say out loud**.

Three surfaces, mobile-first, no login: **Card** (primary), **Why-this-score** (one tap from Room),
**Room** (presence list plus simulate-arrival, standing in for the webhook).

```bash
make install     # uv venv, python 3.12
make store       # build the serving store outside db/ (db/ is never written)
make run         # rebuild the store, then serve on http://localhost:8000/
make serve       # serve the store as it is — no rebuild
make urls        # print every card URL
make test        # validate-spec + test-golden + red-first + unit tests
```

The live Card surface uses an LLM for the final `Say` line. Set `OPENAI_API_KEY` before `make run`;
`ARENA_NARRATOR_MODEL` optionally overrides the default `gpt-5.4-mini`. The request contains only
the arriving member's name, the matched person's name, and the strongest fired match fact, uses no
tools, and is not stored. Without a key—or when the narrator is unavailable—the existing withheld
card state is shown rather than substituting fabricated copy. Successful lines are reused from a
bounded, process-local cache for identical contexts; the API request itself sets `store: false`.

---

## Read this first: what this is *not*

**This is a staff instrument on an open URL carrying ten real, named people, and nothing prevents a
member from opening it.** The brief forbids auth and accounts, so there is no access control — and
since **DEC-14** there is no unguessable path either: the surfaces answer at the root, so anyone who
can reach the host reaches the Room, and from the Room every card is one tap away.

What is left is search-visibility control, not access control, and it is worth having on its own
terms: `X-Robots-Tag: noindex, nofollow, noarchive`, a `robots.txt` disallow,
`Referrer-Policy: no-referrer`, and **no member name in any URL or page title** — card URLs carry an
opaque token, so a name cannot leak through a referrer header, a proxy log or a browser-history
entry. That last one is independent of the path and still holds.

`ARENA_PUBLIC_ROOT=0` puts the surfaces back behind `/<ARENA_PATH_SECRET>/` only. It is offered as a
deployment option and is deliberately **not** described here as protection: knowing a string is not
a credential. This is the accepted P0-5 risk, reopened in PRD §10 rather than left marked closed.

If this goes anywhere public, the fix is not a longer path. It is a session behind the door.

## The invariant

> **The engine must never assert what it merely failed to observe.**

Every defect the audit found was a variant of it: the `@spez` handle collision, the operator's own
social graph leaking into member profiles, a tagged post naming the wrong Fred Wilson, and "Eric
Ries is dormant" the month he shipped a book.

The check, for any claim on a card: can you name the source that was actually read, and distinguish
*we looked and there was nothing* from *we could not look*? If not, it does not render.

It bit during this build, twice, in ways worth naming:

- The Who block borrows "one attributed line" the host can repeat verbatim. Lifting a quoted span
  out of a fact body put **Josh Kopelman's X bio** on **Fred Wilson's** card under the words *in
  their own words*. The store was right; the fact was right; the card still put one member's words
  in another member's mouth. Fixed by a schema request (`fact.quote`) rather than by more care —
  a quoted span inside a fact body carries no information about who said it.
- The template said "what **he** has been doing lately" and rendered that over Sarah Tavel's
  profile. No pronoun is guessed for anybody anywhere in the output now.

---

## `db/` was frozen, and stayed frozen

Live ingest agents were writing into `db/` throughout this build. Nothing here writes to it:

- the DDL and seeds (`schema.sql`, `vocabulary.sql`, `roster.sql`) are read as **text**;
- live `.db` files are opened `sqlite3.connect("file:...?mode=ro", uri=True)` and never otherwise;
- `scripts/build_store.py` refuses, with a non-zero exit, to build anything inside `db/`
  (`tests/test_engine.py::test_build_store_refuses_to_write_inside_db`);
- the serving store is `var/arena.serve.db`, disposable and gitignored;
- CI fails the build if `git diff -- db/` is non-empty.

**Four schema changes were needed. None were applied to `db/`.** They are written up in
`docs/schema-requests.md` with exact DDL, applied to the scratch store only by
`scripts/build_store.py`, and a human merges them when ingest is quiet:

| request | why |
|---|---|
| `fact.recorded_at`, `fact.is_rerun` | a republished podcast cannot be dated by its recording without them, so R-040/G-014 cannot be honoured in the store |
| `fact.suppression_class` | the suppression counter (R-028/R-029) has nowhere to record *this fact is renderable and we chose not to* |
| `fact.quote` | see the invariant above — this one is a correctness fix, not an enhancement |
| **`ON DELETE` on six foreign keys** | **`db/schema.sql` says `DELETE FROM person` is "a real purge". It is not.** `fact.subject_id`, `roster.person_id` and `card.subject_id` reference `person(id)` with no `ON DELETE` action, so with `PRAGMA foreign_keys = ON` the delete raises `FOREIGN KEY constraint failed` and **nothing is removed**. R-032 is not enforceable against the schema as written. Measured: `tests/test_engine.py::test_deleting_a_person_cascades` |

---

## The acceptance contract

Two commands, never conflated, both in CI:

| | what it does | what it proves |
|---|---|---|
| `make validate-spec` | `scripts/validate_golden.py` + `eval/verify_fixtures.py` | the fixtures are well-formed and arithmetically self-consistent. **Executes no product code.** |
| `make test-golden` | `eval/golden_runner.py` | the **real implementation** produces them |

`validate_golden.py` used to live outside the repo, in a skill directory, so half the contract was
not reproducible from a clean clone. It is vendored into `scripts/`.

`test-golden` dispatches on `when.operation` — the eleven operations are the module map — and
compares the four observation surfaces every fixture asserts. `result` is compared as a
**projection**: every asserted key must match recursively, lists must be exactly the asserted
length, and extra keys in the actual result are allowed (they must be: G-019 and G-022 assert card
blocks as `{order, label}` while a real block obviously carries text too). `state_changes`,
`emitted_events` and `external_calls` are compared the same way, so an unasserted event fails.

**`external_calls: []` is not taken on trust.** A socket tripwire is installed around every case, so
any attempt to open a network connection is recorded as an external call and fails the fixture that
asserted none. Every fixture asserts none.

### Every fixture was observed red for its intended reason

`make red` is that requirement as a mechanism rather than a memory. For each of the eighteen
fixtures it breaks *exactly the rule that fixture defends* — makes scoring symmetric, lets S8 fire
without substrate, makes the floor a strict `>`, dates a rerun by publication, resolves identity on
handle equality, orders a tie by the oldest evidence, blacklists instead of whitelisting — and
asserts the fixture goes red, and red for the right reason. A mutation that leaves its fixture
green is reported as a failure **of the harness**: it means the fixture is not pinning what it
claims to.

    red-first: 18 fixture(s) proven load-bearing, 0 not

One of those mutations is worth reading: loosening `render_trust_classes` alone does **not** make
G-034 fail, because `v_renderable_fact` excludes `third_party_open` structurally and configuration
cannot open that door. The mutation had to hand-roll the predicate in Python instead — which is a
demonstration that the gate really does live in the store.

### One fixture was corrected

**G-022 asserted `score(m_feld → m_wilson) = 11` including S8.** S8 requires B's prominence tier
strictly above A's; `db/roster.sql` measures both at tier 4 (640,845 and 388,685 followers). G-001
was re-baselined for exactly this on 2026-09-03 and says so in its own `why`; G-022 was the stale
twin, and it survived because it passed `present_members` as bare ids, which
`eval/verify_fixtures.py` cannot re-derive. Spec and fixture were fixed together: the member records
are now inline (verbatim from G-001 and G-005), the expectation is **10**, and S8 is removed from
the Room block's `cited_signal_ids` (forced by R-037). Block text is untouched, so the derived
`word_count` is still 253. The engine computed 10 before the fixture was touched — which is how the
discrepancy was confirmed rather than assumed. Full write-up: `docs/fixture-notes.md`, PRD §10 row
P0-10.

---

## The arrival webhook

`POST /<path>/webhook/arrival` is the real thing R-001 asks for, not a stub. It is authenticated and
integrity-checked with HMAC-SHA256 over `timestamp.body` (a modified body fails the same check a
forged sender does, because the signature covers both), replay-protected by a signed timestamp
window plus single-use signatures, and it rejects a malformed or unknown identity **before** any
profile or Room data is read. The shared secret is `ARENA_WEBHOOK_SECRET`, operator-local, never in
the repo, the store, a log line or a URL.

```bash
BODY='{"name":"Eric Ries"}'; TS=$(date +%s)
SIG="sha256=$(printf '%s.%s' "$TS" "$BODY" | openssl dgst -sha256 -hmac "$ARENA_WEBHOOK_SECRET" -r | cut -d' ' -f1)"
curl -X POST "$URL/webhook/arrival" -H "X-Arena-Timestamp: $TS" -H "X-Arena-Signature: $SIG" -d "$BODY"
```

Room's simulate-arrival control exercises the same path with the signature step already satisfied,
which is what `docs/ui-states.md` means by Room standing in for the webhook. A name that resolves to
more than one member goes to the chooser and emits no brief — the engine never guesses identity.

Per-requirement coverage for all sixty requirements, including the six this build could only
partially close: **`docs/requirements-coverage.md`**.

## The determinism boundary

**Deterministic:** resolution, scoring, buckets, ranking, the floor, disclosure, every gate.
**Probabilistic:** fact extraction at ingest, prose at compose. Nothing else.

`arena/narrator.py` is the only seam, and it makes no decisions. Three implementations:
`SuppliedNarrator` (the fixture-backed fake — prose comes in with the case), `TemplateNarrator`
(deterministic prose for fixtures and for the first four blocks), and `ModelNarrator` (the deployed
hybrid). The core selects one fired match fact; the model receives that fact plus the two names and
writes only the warm, directly spoken `Say` line. It cannot change any other block or decision.

The narrator reaches the 250–350 word band by **including more sourced material, never by padding**:
optional sourced lines are added in a fixed order until the floor is reached, skipping any that
would breach the ceiling. When the available material cannot carry the band the card comes out
short and fails the gate honestly — that is the thin-profile state, and it is not a defect.

**Gates live in the store, not in application code.** `select_renderable_facts` loads
`v_renderable_fact`'s definition out of `db/schema.sql` into a scratch in-memory database and asks
the view; the per-fact rejection reasons are diagnostic labels, and an import-time self-check
asserts the diagnostics and the view always agree, so a divergence raises instead of quietly
changing what renders. `v_present`, `v_recency_state`, `v_collectable_source`,
`v_assertable_absence` and `v_traversable_person` are queried the same way.

---

## Design

The visual language is Arena Hall's own, taken from the tokens the live site publishes as CSS custom
properties: olive `#3b4626` as the arrival ground, paper `#F1EADB` as the reading ground, bronze
`#7B5732` and gold `#B89257` for labels and rules, Cormorant Garamond for prose, Inter for every
label and control. **Zero border-radius anywhere.** Hairlines and space, never boxes-in-boxes,
never shadows. Italic serif in gold is the emphasis device, not bold, and it marks the two places
the host reads aloud: the borrowed line in Who, and the Say line.

**One deliberate deviation, stated as the brief asks.** Cormorant Garamond at weight 300 is a
display face and is genuinely hard to read small, in low light, at arm's length — which is exactly
the reading condition R-033 is built around. So card prose is never below 19px and never below
weight 400, and anything dense or numeric (the score, provenance chips, source dates, the
Why-this-score signal table) is set in Inter. That is what the site itself does with its own
numerals, and it keeps the ninety-second read honest instead of pretty.

Fonts are preloaded rather than self-hosted, with a real fallback stack (Georgia for Cormorant,
system UI for Inter), so a slow webfont degrades to something readable rather than to a flash of the
wrong typeface. Self-hosting is a one-command follow-up and the better answer for production.

---

## The store, and what is measured vs. synthetic

    make store        # db/*.sql + measured ingest output + the synthetic demo seed  (the demo)
    make store-real   # measured only — thin until ingest lands, and honest about it
    make store-empty  # schema + vocabulary + roster only — proves the app degrades, not crashes

`seed/synthetic.sql` is mine and lives outside `db/`. Every row it writes names
`run_id = 'run_synthetic_demo'`, so synthetic material is separable from measured material by one
predicate; **the surfaces mark it** — a provenance chip from the seed reads `· DEMO SEED`, and the
page footer counts both. Every URL in the seed is a real, measured URL from `db/roster.sql`'s
allow-list, and every fact body is grounded in something already in this repository. A fifth quote
was drafted for Josh Kopelman and deleted before it shipped: nothing in this repository records him
saying it.

`career_start_decade` is **deliberately left NULL**, exactly as `db/roster.sql` leaves it. S1 fires
nowhere, every score is two points lower than it would otherwise be, and that is correct: asserting
a cohort nobody measured is the error the whole engine exists to prevent.

With the measured ingest that had landed at time of writing, seven of the ten render full cards and
three (Perkins, Qureshi, Ries) come back as **thin profiles** — fewer facts, no Notice block,
nothing invented. That is the system working.

---

## Deliverables

- **The repo** — this.
- **A live URL** — the container is built and runs (`make docker`; `Dockerfile` builds the store at
  start-up so the ingest/serve split stays a file copy). It is **not deployed to a public host**:
  that needs a hosting target and credentials that are yours to choose, and publishing a page
  carrying ten real named people is not a decision to make on your behalf. Say where, and it is one
  command.
- **Hours** — `docs/HOURS.md`, with the cut line.

### What to build next, given a month and real member data

Spend the month on **the loop the demo does not have: what the host did next.** Everything here is
open-loop — the engine scores, the card renders, and nobody ever finds out whether the introduction
happened or landed. One tap on the card (*made it · did not · they already knew each other*) turns
every arrival into a labelled example, and with real member data that is the only signal that can
tell you which of the eight signals actually predicts a conversation, whether the floor of 6 is in
the right place, and which deep cuts read as *seen* rather than *dossiered* — the question RUBRIC-4
asks and no amount of specification can answer. Keep the buckets and the floor deterministic and
hand-tuned against that feedback rather than learned from it, because the moment a model sets a
weight the Why-this-score page stops being an explanation and starts being a rationalisation. The
same month should close the two things this build could only mitigate: a session behind the card so
"staff-only" is enforced rather than asserted, and the four merged schema requests, of which the
`ON DELETE` one is the difference between R-032's promised purge and a delete that silently fails.
