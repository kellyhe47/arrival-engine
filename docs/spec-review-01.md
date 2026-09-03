# Spec review 01 — THE ARRIVAL ENGINE

**Date:** 2026-09-03 · **Target:** `docs/PRD.md` @ build-ready
**Method:** seven parallel adversarial dimensions, every numeric claim recomputed from
`docs/audit/*`, every fixture re-read, an 82-mutant mutation test against `eval/verify_fixtures.py`.
Findings that did not survive re-verification were dropped (listed at the end).

**Both checkers re-run and confirmed green by the reviewer:**

```
$ python3 eval/verify_fixtures.py
checks run: 197
OK — 30 fixtures re-derived from `given`

$ python3 ~/.claude/skills/product-inception/scripts/validate_golden.py eval/golden
OK — 30 fixtures cover 19 behaviors under schema v1.
```

Both pass. **Everything below is what passing checkers cannot catch.** The suite is genuinely
strong where it is strong — the weight table, the surfacing threshold at 6, min-room-4, S2/S3
exclusivity, S5 directedness and the ceiling of 16 are all pinned on both sides by mutation test.
The defects are concentrated in (a) the two thresholds whose stated justification does not match
their stated predicate, (b) the render/evaluation path, where derived values are handed in as
inputs, and (c) the taste requirements, which carry the RUBRIC-4 exposure and have no oracle at all.

---

## P0 — blocks implementation

### P0-1 · R-025 / `scoring-model.md` §3b — the genericity gate never fires on the case that justifies it

The rule excludes a topic at **strictly more than 50%** of the room. Its sole empirical
justification is a topic held by **exactly 50%**.

> R-025: "A topic is excluded from S3, S6 and S7 when the room holds ≥4 people and **>50%** of them
> hold it. AUD-EDGES measured `venture-capital-craft` on **five of the ten**; without this,
> Kopelman↔Tavel (no discoverable edge) scores as strongly as Wilson↔Feld."

> `docs/audit/06-edges.md:436`: "`venture-capital-craft` | Wilson, Feld, Kopelman, Tavel, Walk |
> **5 of 10 — the least discriminating tag in the set**"

5/10 = 0.50, which is not > 0.50. And G-026 (`topic-at-exactly-half-still-counts`) makes the strict
inequality **normative**, so this cannot be waved off as rounding.

Computed, ten-person demo room of R-050, real holders from AUD-EDGES:

```
room_size=10, venture-capital-craft holders=5, share=0.50 -> NOT excluded
Tavel -> Kopelman : score 7, fired {S1 2, S2 2, S7 3}, surfaced = TRUE
```

Kopelman↔Tavel — the pair R-025 names as the thing the gate exists to prevent — surfaces at 7 in
the canonical demo room. Coverage compounds the miss: G-025 tests share 1.0, G-026 tests 0.50, and
**nothing tests in between**. Mutation confirms `generic_topic_max_share` = 0.6 / 0.7 / 0.8 / 0.99
all pass all 30 fixtures.

**Fix:** the real defect is vocabulary granularity, not room statistics. Mark
`venture-capital-craft` `discriminating: false` in the R-020 controlled vocabulary and exclude it
from S3/S6/S7 unconditionally, room-independent — which also fixes P1-3's non-monotonicity and
room-size inversion. If the share mechanism is kept instead, change the predicate to `≥ 50%` and
re-author G-026 against a 2-of-5 room. Either way add a fixture at 3-of-4 (75%).

---

### P0-2 · R-024 — S8 *creates* matches; the substrate set and the surfacing set disagree

> R-024: "S8 cannot fire unless a substrate signal (**S2**/S3/S5/S7) has already fired …
> **Prominence breaks ties; it never creates a match.**"

> R-026: "surfaced only at `score ≥ 6` **and** with at least one of **S3/S5/S7** fired."

S2 is substrate enough to unlock prominence but not enough to justify surfacing. That one-element
asymmetry is the bug: S2+S7 = 5 sits exactly one point under the floor, and S8 supplies exactly one
point.

Worked against **G-008 itself**, changing one field:

| | fired | score | surfaced |
|---|---|---|---|
| G-008 as written (`m_tavel`→`m_kopelman`, both prominence 3) | S2 2, S7 3 | **5** | false |
| `m_kopelman.prominence_tier` 3→4 (tier-4 members exist: `m_wilson` is 4 in G-001/G-007/G-025) | S2 2, S7 3, **S8 1** | **6** | **true** |

Nothing about the relationship changed. G-008's own `why` calls this pair "too thin to spend a
host's ninety seconds on"; raising the *other* person's fame converts it into a name the host says
out loud. Every pair sitting at exactly 5 gets bumped over the line by the presence of a more
prominent member — verbatim the Fleming selection-vs-service failure mode R-024 cites as its reason
for existing.

Mutation makes it worse: the substrate set is **not pinned at all**. `SUBSTRATE incl S1`,
`incl S4`, `excl S3`, `excl S5`, `excl S7` all pass all 30 fixtures. G-003 pairs two people with
nothing in common, so it tests "score 0", not "prominence without substrate".

**Fix:** make the two sets identical — gate S8 on `{S3,S5,S7}` — or evaluate the surfacing
threshold on `score − S8`. Add: (a) S2+S7+S8 = 6 must **not** surface; (b) S1+S4 fire (score 5),
prominence gradient present, S8 must **not** fire; (c) S5-only substrate + gradient → S8 fires.

---

### P0-3 · R-038 / G-024 — the acceptance contract *mandates* rendering a family fact

> R-038: "Facts about family or intimates may inform a match via graph traversal but **never appear
> as a sentence on the card**."
> PRD line 5: "Where they disagree, **the fixtures win**."

> `eval/golden/24-sourced-facts-render-with-chips.json`, `case_type: happy`:
> `"text": "His family foundation paid to digitise the 1901-1906 Jewish Encyclopedia, still credited online."`
> expected: `"renderable_fact_ids": ["f_encyclopedia", "f_watermelon"], "rejected": []`

This satisfies R-018 literally (subject is Kopelman, a member; the foundation is an Org node, not a
Person), satisfies R-033/R-034 literally (public, sourced, chipped), and still puts a family fact on
the card. It additionally discloses religion by inference — an **Art. 9 special category**, the
exact ground on which the PRD refuses dating-app data. The fixture is normative and `happy`, so the
contract *requires* rendering it. K-4 names R-038 as one of the mitigations the entire RUBRIC-4
exposure rests on.

Three compounding defects:

- **No schema field can represent "family-derived."** The `Fact` node is
  `id, subject_id, text, provenance_class, source_url, source_host, source_date, composed_from[],
  search_first_page`. Family-ness can only live in free-text `text`, written by the narrator — so
  R-038's enforcement mechanism is a prompt instruction. That is precisely the enforcement mode
  G-028 rejects for write operations ("a prompt instruction, which a retry, a refactor, or an
  injected page instruction can defeat"). The spec applies a *structural* standard to protecting
  the operator's account and a *prose* standard to protecting the member's family.
- **The provenance chip is an unredactable side-channel.** R-038 constrains "a sentence"; R-034 and
  `ui-states.md:48` make a chip mandatory on every rendered fact. A sanitised sentence still carries
  `jewishencyclopedia.com`. Generalise: obituary hosts, wedding registries, `gofundme.com` medical
  pages.
- **`life_event` deadlock.** S4 (LARGE 3) fires on "place, institution, **life event**, pursuit".
  R-032 requires the reason to name only-and-all fired signals, and `scoring-model.md` §6 requires
  it to name "the shared substrate in plain words". If S4 fires on a shared bereavement or birth,
  the Room block must name it aloud. Note that **`life_event`, `institution` and `pursuit` appear in
  zero fixtures** — only `place` (`boulder-co`, `new-york-ny`) is ever exercised, so two-thirds of a
  LARGE signal is untested and it is the family-carrying two-thirds.

Zero coverage: `is_member`, `spouse`, `non_member`, `family_or_partner` appear in **no fixture**.
"DEC-TBD on the leak test" (`DECISIONS.md:25`) — the disclosure rule DEC-1 defers its whole
"wide collection, narrow disclosure" argument to — **was never written**.

**Fix:** add `derived_from_edges[]` to `Fact`, populated at composition; reject in
`select_renderable_facts` any fact whose `derived_from_edges` contains `family_or_partner` or whose
`subject_id` resolves to `is_member=false`. Enumerate "intimates" as edge subtypes in
`knowledge-graph.md`. Extend R-038 to "never appear on the card **in any element, including the
provenance chip**". Restrict S4 `life_event` to a public/professional vocabulary. Replace G-024's
`f_encyclopedia` and add a negative-control fixture. Write DEC-8 for the leak test.

---

### P0-4 · R-052 vs G-015 vs `architecture.excalidraw` — structural absence vs a runtime check

> R-052: "Session adapters are **absent from the runtime registry entirely** — sharing one registry
> between the ingestion job and the web app is how the live URL ends up trying to open a browser it
> does not have."

> G-015, `configuration.execution_context: "deployed_runtime"`:
> `"linkedin_profile": {"tier": "SESSION", "enabled": true, "session_present": true}`
> expected: `status: "skipped", reason: "session_tier_not_available_in_runtime"` + `adapter_skipped`

An adapter absent from the registry cannot appear in a fetch plan, cannot have a status, and cannot
emit `adapter_skipped`. G-015's `given` **is** the shared registry its own `defends_against` calls
the failure. Fixtures win, so R-052 as written is dead — and the mechanism that survives is the
weaker one R-010/G-028 explicitly reject for writes.

The architecture agrees with neither. The recovered graph (verified: 20 nodes / 23 edges, checker
clean, `arch.spec.json` a byte-faithful twin) has **no execution-context concept at all** — no
runtime node, no registry node, no deployed-app node. Grep of `arch.spec.json`: `runtime` absent,
`registry` absent, `live url` absent. GREEN and SESSION adapters sit in the same `Ingestion` frame
feeding the same extractor. An implementer reading the diagram builds exactly the failure the
fixture exists to catch.

Compounding: R-042 says the ingesting screen naming unavailable adapters is "half the argument for
RUBRIC-2" on stage — but under R-051 (GREEN only) + R-052 (SESSION absent) that screen has zero
rows to name. `wireframes.html:118-120` shows LinkedIn/Instagram/X as *attempted and unavailable*,
which is only possible if R-052 was not implemented.

**Fix:** pick one. (a) R-052 stands: rewrite G-015 so the deployed fetch plan contains only GREEN
adapters, render SESSION rows on the ingesting screen from a static manifest (data, not registry
entries), and add a negative fixture asserting `linkedin_profile` is not resolvable at all. Or
(b) soften R-052 to "registered but structurally undispatchable outside
`execution_context: operator_machine`", matching G-015. Either way add `Ingestion job registry` /
`Web app runtime registry` / `Deployed app` nodes to the diagram.

---

### P0-5 · R-037 vs R-004 / R-049 — "never member-visible" has no enforcement surface

> R-037: "The card is a **staff instrument** and is **never member-visible**. … the moment this
> becomes member-visible it violates a rule members have been given."
> §2 **Out**: "login, accounts, roles; member-facing views" · `ui-states.md:4`: "There is **no
> login**, no settings, no member-facing view." · R-049: "Ship: **a live URL**"

With no login, accounts or roles, "member-visible" is unenforceable. The deliverable is an
unauthenticated public URL rendering dossiers on **ten real, named individuals**, assembled partly
from session-scraped LinkedIn under the operator's own credentials. The spec cites the harm
(AUD-LINE-22, the Battery charter) and then ships the configuration that produces it. This exposure
appears **nowhere in the §10 risk table** — K-4 addresses only what a card *says*, never who can
read it.

**Fix:** R-004 excludes "login, accounts, roles"; a single shared secret or a signed demo link is
none of those. Add one, or serve synthetic profiles on the public URL and keep the real ten local.
Add K-7 recording the residual.

---

### P0-6 · R-020 — the controlled vocabulary does not exist, and neither do the S1/S8 inputs

> R-020: "Topics use a **controlled vocabulary** shared across people, so overlaps are computable
> rather than string-matched."

`knowledge-graph.md:25` lists four slugs and a literal `...`. The fixtures use **16 topic slugs**
and **6 industry slugs** that are enumerated nowhere — including the near-duplicate pair
**`seed-stage-financing` vs `seed-stage-investing`**, which is exactly the string-matching failure
the controlled vocabulary exists to prevent. Nothing defines who assigns topics, from what evidence,
at what granularity, or whether a topic is professional or personal — and that split is load-bearing,
since it gates S3 vs S6 (`scoring-model.md` §3a).

The **industry taxonomy** is worse: S2/S3 mutual exclusivity turns entirely on granularity, and
nothing says whether `ai-research` and `consumer-internet` are different industries. Mutation:
`S2 = "industry sets identical"` and `S3 = "industry lists not equal"` both pass, because **every
fixture uses a single-element `industries` array** — "≥1 tag in common" is never distinguished from
"sets equal". G-023's own `defends_against` names "a pair whose industry lists **partly** overlap",
and no fixture contains a partly-overlapping pair.

Equally undefined and equally load-bearing: `seniority_tier`, `career_start_decade` and
`prominence_tier` drive S1 (weight 2) and S8. Grep of `docs/audit/*` for prominence/seniority/career
decade about the ten: **zero hits**. Those assignments exist only inside fixtures, invented there,
with no audit backing.

**Fix:** ship `docs/vocabularies.md` with the closed topic list (professional/personal split), the
closed industry list, the tier enumerations and orderings, and the assignment procedure with
provenance. Add a fixture where an out-of-vocabulary slug is dropped, a partly-overlapping industry
pair, and a `verify_fixtures.py` check that every slug in every fixture is in the vocabulary.

---

### P0-7 · B-005 / G-009, G-010, G-022 — word count is an input, not a derivation

`given.inputs.narration.word_count` **is** the value the implementation is supposed to compute.
G-010 is the proof: its five block texts are literally `"..."`, `"..."`, `"..."`, `"..."`, `"..."`
— five words total — and it declares `word_count: 351`. The checker's test reduces to an identity.

Consequences, confirmed by mutation:
- the **250 floor is unpinned in every direction** (`lo` = 200 / 249 / 251 all pass; only `lo ≤ 298`
  is required). An implementation that checks only `wc > 350` passes all 30 fixtures.
- `hi` = 302 and 349 also pass; nothing asserts that exactly 350 *passes*.
- Word-count values across the whole suite are only 298, 301, 351.

And the **tokenization rule is unspecified anywhere** — do block labels count? the score integer?
provenance chip text? hyphenates? numerals? Two correct-looking implementations will disagree on the
single hard gate the spec leans on hardest.

**Fix:** put real prose in `given` and delete `narration.word_count`. Add G-031 (exactly 250 →
pass), G-032 (249 → `word_count_in_band` failure), G-033 (exactly 350 → pass). Write the
tokenization rule into `scoring-model.md` §8.

---

### P0-8 · Fixtures assign contradictory attributes to the same member ids

R-050 says all ten profiles are pre-built and cached; R-047 asserts idempotency over "same cache".
If there is one cache, a member has one attribute set. Computed across all fixtures:

```
CONFLICT m_wilson.prominence_tier    : 4 (G-001, G-007, G-025) vs 3 (G-017, G-026)
CONFLICT m_shear.prominence_tier     : 4 (G-004)               vs 3 (G-017)
CONFLICT m_kopelman.career_start_decade : 1980s (G-007/008/025) vs 1990s (G-006)
```

plus ~15 further topic/interest conflicts across `m_tavel`, `m_walk`, `m_feld`, `m_ries`,
`m_perkins`, `m_qureshi`.

This is load-bearing, not cosmetic. **G-017 is the only tie-break fixture**, and its 6–6 tie exists
only because wilson=3 and shear=3; under G-004's shear (prominence 4) S8 fires, shear scores 7 and
the tie evaporates. G-026's exactly-at-threshold-6 likewise depends on wilson=3. A `test-golden`
runner (R-046: "drives the real implementation against the fixtures") loading from one cache
**cannot satisfy G-004 and G-017 simultaneously**. `verify_fixtures.py` re-derives each fixture from
its own inline `given` only, so the 197 checks pass regardless.

**Fix:** rename synthetic-scenario members to `m_a`/`m_b` as G-023 already correctly does, reserving
the ten real ids for fixtures that read the shipped cache; or freeze one canonical set in
`eval/profiles.json` and have fixtures reference by id. Add a cross-fixture consistency check.

---

## P1 — will cause rework

### P1-1 · R-028 — the word band contradicts R-003 and its own stated binding rate

R-028 keeps both "the slow end binds" and a 350-word ceiling. They are incompatible.
The audit's own derivation table (`05-comparables.md:4349-4352`):

| Mode | Rate | 90-second budget |
|---|---|---|
| Silent, non-fiction, average adult | 238 wpm | **357 words** |
| **Silent, slow end of normal range** | **175 wpm** | **263 words** |

Recomputed: 350 words @ 175 wpm = **120.0 s**, 33% over R-003's "about ninety seconds".
250 words @ 175 wpm = 85.7 s. 90 s @ 175 wpm = **262.5 words**. So 350 is the *average*-rate figure
while the prose claims the *slow* end binds, and only 250–262 of the 101-word band actually
satisfies it. The PDB anchor the spec cites (265 words) sits at 90.9 s — essentially exactly the
limit. `ui-states.md` restates "Total read: under ninety seconds."

**Fix:** either narrow to ~250–265 to match the slow end and the PDB datapoint, or delete "the slow
end binds" and state the band is set at the average rate with 175 wpm as a documented worst case.
`G-010`'s `word_band` config must follow.

### P1-2 · The brief's deep-cut requirement is in no numbered requirement

> `docs/audit/00-AUDIT-BRIEF.md`: "a short dossier containing at least one fact that is **NOT on the
> first page of a search result**"

No requirement states it. R-033 redefines the deep cut as the *sourcing* policy ("anything public,
with the source shown") and silently drops non-obviousness. It survives only as
`search_first_page(bool)` in the schema, present in exactly **one** fixture (G-022) as inert input
that no checker reads, and as `deep_cut_non_obvious`, a **partial-credit** item under R-045. A card
putting Fred Wilson's Wikipedia opener in **Notice** passes every hard gate. Nothing defines how
`search_first_page` is determined — which engine, which query, re-checked when.

**Fix:** promote to a hard gate on R-029 block 4, define the determination procedure, add a
negative-control fixture.

### P1-3 · R-025 side-effects — non-monotonic, room-size-inverted, and it breaks R-021

- **Non-monotonic.** Extending G-026's roster by one person who shares the thesis:
  `room=4, share 0.50 → Ries→Wilson score 6, surfaced TRUE` (G-026's asserted result);
  `room=5, share 0.60 → score 0, surfaced FALSE`. One guest converts a 6 into a 0 and deletes two
  matches in the room where three people demonstrably think about the same thing.
- **Room-size inversion.** `room of 3 {Tavel, Kopelman, Walk} → score 7, surfaced TRUE` (gate off
  below 4) vs `room of 4 → score 4, surfaced FALSE` (G-025). G-025 exists to prove Kopelman↔Tavel
  must not surface; it surfaces at 3. With `ui-states.md:44` ("already-rendered cards are not
  retro-edited"), a departure crossing the boundary silently upgrades a suppressed match.
- **Breaks R-021 verbatim.** R-021: "Asymmetry arises **only** from S5 and S8. With neither, both
  directions are identical." The exclusion set is a function of *the room*, not the pair, and the
  two directions are computed on different arrivals:
  `score(X→Y) in {X,Y,Z,W} = 2, excluded=[T]` vs `score(Y→X) in {Y,X,W} = 8, excluded=[]`.
  Neither S5 nor S8 fired. G-002 cannot catch this — it uses a 2-person room where the gate is off.
  This also leaves **R-041 undefined**: the "reverse-direction score" against which roster?

**Fix:** as P0-1 (vocabulary-level exclusion is room-independent and removes all three). If the
share mechanism is kept, define the exclusion set once per roster snapshot, apply it to both
directions, and say so in R-041.

### P1-4 · Undocumented dead zone: in a homogeneous room, surfacing requires S5

R-001 says the members are founders and investors. In an all-`venture-capital` room S3 is
structurally impossible (it requires *different* industries; S2 fires instead and they are mutually
exclusive), so `surface_requires_any_of` collapses to {S5, S7}. If the shared professional topic is
generic-excluded, S7 dies too. Maximum non-surfaceable score, computed:

```
4-VC room, all holding the generic topic, shared place, shared personal interest:
a -> b : score 9, fired {S1 2, S2 2, S4 3, S6 1, S8 1}, surfaced FALSE
```

9 of a 16 ceiling — 56% of maximum — permanently unsurfaceable, with only S5 as an escape. And
R-019 records that the directed links mostly do not exist ("Feld's 5,551 posts contain zero
occurrences of Tavel, Huffman, Shear, Qureshi or Perkins"). Not a logical contradiction — R-026
intends a 6–9 unsurfaceable band — but the class is most of the demo room, and R-050's demo depends
on cards that surface.

Related: **S3 ⊆ S7 by construction** (S3 requires a shared professional topic, which is S7's entire
condition), so `surface_requires_any_of: [S3,S5,S7]` is exactly `[S5,S7]`; mutation dropping S3
passes.

**Fix:** state the measured surfacing rate over the 10×10 matrix as an acceptance criterion in §9
*before* the demo depends on it. If low, consider admitting S4 to the qualifying set and re-baseline
G-007.

### P1-5 · R-043 vs R-047 — Retry is a provable no-op and the UI ships a dead control

Retry "re-runs render only" (`ui-states.md:41`), does not re-ingest, does not relax a gate (R-043).
R-047 makes generation idempotent at temperature 0. So retry reproduces the identical card and the
identical failure, deterministically, forever. `ui-states.md:11`'s
`Withheld --(retry)--> Card` arrow is **unreachable**: re-ingest is forbidden, relaxation is
forbidden, non-determinism is forbidden.

Compounding, the two artifacts disagree on what Withheld even renders: **G-010 expects
`card: null`**; `ui-states.md:23` says "**Who block only**, plus the failed gate." And R-029 defines
Who as "name + one **borrowed, attributed** line" — a sourced fact — so if the `all_facts_sourced`
gate failed *on that line*, the fallback renders the very fact that failed.

**Fix:** delete Retry and label Withheld terminal (which "degrades to a greeting" already implies),
or redefine it as re-narrate-under-a-word-budget and scope R-047 to "same render attempt index".
Pick one Withheld output and make G-010 and `ui-states.md` agree.

### P1-6 · R-045 vs DEC-5 vs G-021 — three different hard-gate lists

- R-045: word count, blocks present **and ordered**, all facts sourced, **inferred facts name
  inputs**, correct top match, **sayable close**.
- DEC-5: word count, blocks present, facts carry provenance, **"no fact drawn from a
  disallowed-provenance class"**, correct top match.
- G-021 keys: the six from R-045.

R-045 is tagged `[decided, DEC-5]` and does not match DEC-5. DEC-5's extra gate is **vacuous** —
`scoring-model.md` §7 says "Per DEC-4 **all four** classes MAY render", so the disallowed set is
empty and the gate can never fail. `wireframes.html:129-130` shows only five gates, omitting
`inferred_facts_name_inputs` — so R-035/G-012 has no representation on the only screen that reports
gates.

Also: **`top_match_correct` is unevaluable at runtime.** Scoring is deterministic, so the engine's
top match is by construction its own top match; "correct" only has meaning against a human label,
which exists in fixtures and not in production. And it is undefined on an empty room — G-019 has
`ranked_matches: []` and asserts `gates_passed: true`, so it must pass vacuously, which nothing
states.

**Fix:** make all three lists identical at six gates; delete the vacuous provenance-class gate; drop
`top_match_correct` from the runtime gate list (keep it eval-only) or define it as
`rank == 1 && surfaced` with stated vacuous-pass behaviour.

### P1-7 · The evaluation and render fixtures hand in their own answers

- **G-021** — `given.evaluation.gates` is six pre-computed booleans and `grades` four pre-assigned
  0/1s. `verdict` = `any(not v)`; `content_grade.scored` = `sum(grades)`. Nothing computes a gate
  from a card. B-015 has no real coverage. No rubric defines the point scale, and no grader is named
  (human? LLM judge?) for "talk track reads as sayable".
- **G-022**, the full-digest happy path — `present_members` are the bare strings
  `["m_wilson","m_perkins"]` with no member records anywhere; there is no `m_feld` record either.
  `score: 11`, `score: 0`, `verdict: "pass"`, `content_grade 4/4` are all unfalsifiable, and the
  checker **skips the entire ranking branch** because `arriving_member` is absent. Four checks run,
  all on the echoed word count and config-echoed block list. Its own `defends_against` — "an
  implementation that passes every unit fixture but never assembles them" — is exactly what passes.
- **G-014** — the checker reads `expect.excluded_items` to decide which item to date from, then
  "re-derives" 365. And the fixture contradicts R-036: R-036 says a rerun "must be **dated by
  recording**, not publication" (→ 497 days), while the fixture **excludes** the rerun and dates off
  the next item (→ 365). Two different rules; `recorded_at` is never read.
- **G-018**, **G-020**, **G-027** — `invocation_count` echoes `given.invocations`; G-020's `expect`
  is a set-difference of two handed-in lists; G-027's `facts_ingested: 7` is a magic number with no
  source in `given`.

**Fix:** feed G-021 a rendered card and require the implementation to *produce* the gate booleans;
inline full member records into G-022; decide G-014's rerun rule and derive the exclusion from
`is_rerun`.

### P1-8 · Verifier blind spots — four operations unverified, including the user's read-only constraint

Four of the fourteen fixture operations have **no branch in `verify_fixtures.py`**:

```
generate_digest_repeated    (G-018, B-014 idempotency)     -> 0 checks
render_card                 (G-009, G-010)                 -> word-count identity only
resolve_adapter_operation   (G-028, B-018 read-only)       -> 0 checks
resolve_identity            (G-016, B-013 corroboration)   -> 0 checks
```

`G-018` passes against a literal `return {"invocation_count":2,"digest_hashes_identical":True,...}`.
**B-018 — the structural read-only guarantee the user stated as a hard binding constraint in DEC-6
— is verified by nothing**; G-028's rejection reason is `operation_not_declared_by_adapter`, a dict
lookup, and `allowed_operation_prefixes` is never consulted.

G-015 and G-027 each run one check gated on `adapters[*].measured_status == "blocked"` — **no
fixture sets `measured_status`**, so the `run_ingestion` validation is unreachable dead code.
G-019's `ranked_matches`/`surfaced_count` are unchecked (branch skipped on an empty roster).

Separately, **`expect.properties` is never read by anything**, and it carries two incompatible
shapes: `{left, right}` in G-001/G-002/G-005 vs `{left, expected}` in G-017/G-021/G-023. Any golden
runner will silently pass one and crash on the other.

**Fix:** add branches for the four operations; add `measured_status` to G-015/G-027; make the
id-only roster in G-022 a hard error rather than a silent skip; pick one `properties` shape and
schema-check it.

### P1-9 · Constants that survive mutation (not pinned by any fixture)

Beyond the genericity share (P0-1), the substrate set (P0-2) and the word band (P0-7):

| mutation | result |
|---|---|
| `stale_after_days` = 364 / 100 / **1** | **PASS** — no fixture ever asserts `recency_state: "warm"`; both `build_now_block` fixtures assert `cold`, and `recency_window_days: 180` is dead |
| genericity counts **professional topics only** | **PASS** — though §3b says S3, S6 *and* S7 |
| exclusion **not applied to S6** | **PASS** |
| `CEILING` = 18 / 99 | **PASS** — the `0 ≤ score ≤ 16` range check is inert |
| S4 context key = value only (ignoring `type`) | **PASS** |
| inferred rule = `len(composed_from) < 2` | **PASS** — no 1-input fixture |

**Fix:** add a warm-recency fixture (30 days → warm) and a 364-day boundary; a personal-topic
genericity case; a 1-input inferred fact.

### P1-10 · Requirements with zero fixture coverage

25 of 52 requirements have no covering fixture, and **23 map to no behavior in the manifest**. The
PRD's claim — "every behavior in `eval/golden-manifest.json` (19) is covered" — is true and
misleading: it is closed over the behavior list, and these were never admitted to it.

The ones that matter, because three of them carry the RUBRIC-4 exposure:
**R-018** (non-members never scored/surfaced — the load-bearing "wide collection, narrow disclosure"
claim; `is_member` appears in no fixture), **R-038** (P0-3), **R-037**, **R-041** (Why-this-score —
fully specced in `ui-states.md`, zero fixtures; `why_this_score`/`reverse_direction` appear nowhere),
**R-043**, **R-044** (host picks — `ambiguous` appears in no fixture), **R-019**
(`no_edge_confirmed` appears in no fixture and **no signal consumes it**, so R-019's stated
suppression mechanism does not exist), **R-011**, **R-020**.

**Fix:** add behaviors B-020 (non-member never scored or named) and B-021 (family-derived fact never
rendered in any element), plus negative-control fixtures; add `explain_pair` and `resolve_identity`
fixtures.

### P1-11 · Rules an implementer must invent because the spec ducked them

- **R-013 corroboration** — G-016 supplies `corroboration: ["named_in_sec_filing"]` as an opaque
  list. No enumeration of valid kinds, no required count, no relative strength.
  `require_corroboration: true` is a boolean with no defined semantics.
- **R-027 "evidence recency"** (tie-break #2) — names no field. Signals are computed from member
  *attribute sets*, which carry **no dates**; only `Fact` has `source_date`, and no mapping from a
  fired signal back to a dated fact exists. Tiers 2 and 3 have zero coverage; the checker only
  errors when `nh < nl`, so equal-LARGE-count ties pass unconditionally.
- **R-047 cache keying** — the key is undefined: composition, whether the roster is part of it, TTL,
  invalidation on re-ingest, and how R-050's live re-run interacts with a cache meant to be stable.
  `G-013`/`G-014` are `time_sensitive`, so a clock is load-bearing; nothing says whether it is
  injected.
- **R-002 webhook** — no payload schema, method, path, idempotency key, or error/timeout semantics.
  Roster population is equally undefined; `arch.spec.json`'s `roster` node has **no inbound edge**.
- **R-048 narrator** — no model, prompt, input contract, output contract (structured blocks or one
  string the gate must parse?), or failure behaviour.
- **R-034 chip liveness** — must the `source_url` resolve at render time? Is a 404 a gate failure?

### P1-12 · Ground-truth mis-citations

- **YELLOW sources listed as GREEN.** R-007 puts "YouTube transcripts" and "Wayback CDX" in the
  GREEN tier ("runs anywhere, including the deployed URL"). Audit 04 grades both **YELLOW**: A11
  works only via an unofficial pip library, IP-sensitive and ToS-forbidden, and A11b (raw
  `timedtext`) is dead; A15's bare CDX query **timed out twice at 30 s**. This directly undermines
  R-051's "cannot fail on stage" promise — the two most fragile adapters are inside it.
- **K-6 is stale.** It asserts three corpus gaps; audit 06 §4 marks two **RESOLVED** with
  strikethrough (Kopelman's Redeye VC: 212 posts fetched and body-searched — the very archive R-036
  dates him from; Tavel's *Adventurista*: 113 posts crawled, producing three of her edges). Only the
  co-investment gap survives, and the audit calls it "partially closed". An implementer reading K-6
  will refuse to assert `no_edge_confirmed` for pairs the audit exhaustively searched.
- **"296 mutual citations"** (R-025 and `scoring-model.md:58`) — audit 06:83 says Feld names Wilson
  in **296** of 5,551 posts and Wilson names Feld in **148**. 296 is one-directional. This matters
  because S5 is a *directed* signal and R-021's asymmetry argument rests on exactly this asymmetry.
  The wireframe's "cited them 296×" is right; the spec prose is wrong.
- **R-009 attributes "engagement" to AUD-07**, which records headline, location, company,
  university, follower count, degree, post bodies, tags and reposts — no engagement metrics. And
  Facebook/TikTok were "**not tested**", not "not logged in at test time".
- **R-013's Shear claim is false against its own audit.** "Emmett Shear is `emmett` on HN, **not**
  `eshear`" — audit 03 §3.1 concludes `eshear` **is** his original Startup News account (2006-10-09,
  HN day one, item #32 his own Scratchtop), and is his real X and GitHub handle. The intended point
  (his *corpus* is under `emmett`, 927 items) is fine; the sentence is a wrong-handle claim inside
  the requirement about wrong handles.
- **K-1 drops the audit's caveat** — the audit marks the hiQ Nov-2022 order and consent judgment
  **UNVERIFIED** (CourtListener 403); the PRD states the injunction as settled fact.
- **Header overclaim.** "~7,700 lines, every claim URL-backed with HTTP status" — actual
  **8,190** lines, and status coverage is thinnest exactly where the PRD leans hardest (audit 06:
  100 URL-bearing lines, 9 with a status). The audits carry ~198 explicit `UNVERIFIED` self-flags,
  which the framing erases.

### P1-13 · Design defects

- **The provenance chip is not a provenance chip.** All seven chips in `wireframes.html`, verbatim:
  `firstround.com` (no date) · `feld.com · 4d ago` · `cited them 296×` · `same thesis` ·
  `feld.com 2013 · self-published` · `top score 5 · needs 6` · `last seen 2014 · 4,313 days`.
  The `.chip` component carries provenance, signal labels, threshold messages and staleness
  interchangeably — so "every rendered fact carries a provenance chip" is not even checkable by eye.
  Two carry no date; one carries no host. **Frames B and D render fact boxes with zero chips.**
  Chip grammar also disagrees across artifacts: G-024 expects `{source_host, provenance_class}`,
  `scoring-model.md` and DEC-4 say `{source + date}`, R-017 defines three fields.
- **`feld.com · 4d ago` is false.** Audit 01:297 — "nothing on feld.com since Aug 9 (**25 days
  stale** as of audit date)". The happy-path reference card demonstrates the R-036 failure mode
  (dressing old material as current) for a member measured at 25 days. *(Note: the 42-day figure is
  Wilson/avc.com, not Feld — corrected during verification.)*
- **`R-031` "out of 16" is not rendered.** The card shows bare `11` and `7`; only frame E carries
  the denominator. A host challenged in the lobby sees "11" with no scale. And `.score{float:right}`
  paints it above the reason, in tension with DEC-2's "reason first".
- **Missing states.** R-040 names eight; the HTML has seven frames — **no Unknown-name frame**,
  which is the state most likely to fire on a real door. **R-015's "marked partial" has no visual
  treatment in either file** (grep for "partial" in `ui-states.md` returns nothing). The nav graph
  reaches five of eight states — Ingesting and Unknown have no edges.
- **Undefined outcomes.** The `Neither` button in the ambiguity picker has no state-table row, no
  nav edge, no fixture. **No control triggers Ingesting and none exits it**, though R-050 requires
  it be triggerable on stage. Frame E has no back control despite `ui-states.md:9` asserting one.
  The Room block's match count is **uncapped**, so four surfaced matches plus chips can overrun the
  word band and force the gate failure the surfacing rule was supposed to avoid.
- **Frame F shows the superseded audit** — `LinkedIn — unavailable (999)` and
  `X follow-graph — skipped (metered)`, both overturned by audit 07 / R-009 (LinkedIn SESSION-GREEN;
  X following free via the a11y tree).

### P1-14 · Architecture gaps beyond P0-4

The file is mechanically perfect (checker clean, `arch.spec.json` byte-identical) but models only
the happy-path compute pipeline:

- **No serving surface.** No live-URL / deployed-app node, so R-049/R-050/R-051 are unrepresentable;
  `Host card` is a terminal sink with no consumer.
- **`Content grader → Host card [quality score]`** wires the eval-time grader into the runtime
  render path and routes a quality score onto the card — but grading is §8 Evaluation, and
  `ui-states.md` says the only number on the card is the score out of 16.
- **No gate-failure path** — `Gate evaluator` emits only `[if gates pass]` and `[pass]`; a failing
  card vanishes, so R-043's invariant is invisible.
- **Why-this-score is architecturally absent** — the exclusion set has no consumer, non-fired
  signals are never emitted, nothing computes a reverse-direction score. The whole "expose the
  reasoning" answer, which AUD-GAP calls the unoccupied territory, has no node.
- **Personalization stripper sits in the Knowledge frame, not at the adapter boundary** — so the
  recovered graph says raw personalized operator data crosses into the knowledge layer before
  whitelisting, the exact topology G-029/G-030 defend against.
- **`Presence roster` feeds only the genericity gate**; the ranker never learns who is in the room.
  **`Identity resolver` has no evidence input**, so R-013 corroboration is impossible as drawn.

### P1-15 · Process and deliverable gaps

- **R-006 is unmet.** No hours number, no cut line, no ledger anywhere; `N` is never chosen. DEC-0
  explicitly requires it ("the PRD must carry an explicit *first N hours* cut line").
- **RUBRIC-1…4 are undefined identifiers.** They appear only as citations (PRD ×3, DECISIONS ×2,
  manifest ×6, fixtures ×16) and are defined in no audit file. `PLAN.md:7` claims they live in
  `00-AUDIT-BRIEF.md`; that 16-line file has no rubric text. **`AMB-1..5` appear nowhere at all.**
  **RUBRIC-3 — signal over noise, which carries the most fixtures (9) — is never mentioned in the
  PRD.** Same for `BRIEF-*` and `DEC-USER-*` trace ids.
- **The second checker is not vendored.** `validate_golden.py` exists only at
  `~/.claude/skills/product-inception/scripts/`; `scripts/` in the repo is **empty**. Half the
  acceptance contract is not reproducible from a clone. R-046's two named commands
  (`validate-spec`, `test-golden`) do not exist, and `validate-spec` is described as "schema,
  arithmetic, traceability — runs today" when only arithmetic runs.
- **No technology decision of any kind** — no language, framework, storage engine or deployment
  target anywhere in PRD, scoring-model, knowledge-graph, ui-states, `arch.spec.json`, PLAN or
  DECISIONS, though R-049 requires a live URL and R-052 requires the app to serve the cache.
- **The ten people exist only as prose** — ~2,400 lines of audit narrative, no machine-readable
  profile. R-050 requires ten pre-built cached profiles with no seed in the repo.
- **Six `[decided]` tags cite no DEC**, and none corresponds to a logged decision: R-005 (actually a
  brief constraint — mistagged, should be `[source]`), R-016, R-021, R-022, R-039, and the
  dating-app Out line. Fixtures cite a phantom `DEC-USER-BUCKETS`.
- **R-008 overstates DEC-1** — "is in scope and **is built**" vs DEC-1's "ship **DISABLED-BY-DEFAULT
  with an empty result**". The PRD carries no disabled-by-default requirement, and K-2 concedes
  three platforms are UNVERIFIED.
- **B-011 traces to the wrong decision** (DEC-5, the gate/grade rollup, says nothing about
  tie-breaking).
- **Three conflicting X follow-graph prices** — `$13.45/pull` (DEC-1), `$0` (R-009/DEC-6),
  `$0.010 per user read` (`arch.spec.json:24`), unreconciled.

---

## P2 — clarity and durability

- **P2-1 · "Capped at SMALL" is dead prose.** R-022's table already fixes S8 at 1 and forbids
  partial firings. "Capped at" implies a clamp on a computed magnitude — the only reading with
  content is a prominence-*delta*, which R-022 forbids. It is the kind of sentence an implementer
  turns into a redundant `min(w, 1)`.
- **P2-2 · `scoring-model.md` §3a contradicts §3.** §3a is titled "Signal independence" and opens
  "Signals are evaluated **independently**"; §3 says S8 fires "**only if**" a substrate signal has.
  Amend to "Signals other than S8 are evaluated independently."
- **P2-3 · R-023's parenthetical is false.** "(caught by `eval/verify_fixtures.py`, not by reading)"
  — the verifier *defines* `CEILING` using `max(W["S2"], W["S3"])`, so the exclusion is baked into
  the definition and no arithmetic check could catch an 18.
- **P2-4 · R-014's G-015 citation is wrong.** G-015 reports `skipped` / tier exclusion, not
  unavailability; only G-027 tests R-014. The `status` enum (`ok`, `skipped`, `unavailable`) is
  defined nowhere.
- **P2-5 · R-033's G-024 citation is weak.** G-024 tests provenance chips, not deep-cut *selection*,
  non-obviousness, or the breadth policy.
- **P2-6 · Two scraped HTML pages committed at repo root.** `ltse1.htm` (64 KB, SEC LTSE Form 1) and
  `nq.html` (133 KB, nabeelqureshi.com), both tracked in git, unreferenced, no fetch date, cryptic
  names, no `.gitignore` — 197 KB of unexplained scrape in a repo that is itself a deliverable
  (R-049) in a submission scored on taste.
- **P2-7 · `PLAN.md` is stale** — "26 fixtures / 16 behaviors", "21/21 edges", P7 unchecked though
  the PRD exists, P5 (grill open decisions) deferred, which is why so many thresholds are
  `[proposal]`.
- **P2-8 · `R-016` "one store" vs three peer stores** in the diagram (Profile cache, Topic index,
  Edge store) with no containing node.
- **P2-9 · Whitelist asymmetry in G-029** — `following_handles` is admitted but `following_count` is
  dropped, though cardinality is member-owned and visible logged-out.
- **P2-10 · `provenance_chips` host extraction unchecked** — `https://www.jewishencyclopedia.com/`
  → `jewishencyclopedia.com` needs a `www.`/scheme/path strip no checker performs, and no fixture
  covers a subdomain that must be *kept*.
- **P2-11 · Inert config keys copy-pasted across fixtures** — `word_band`, `required_blocks`,
  `surface_min_score` appear where they cannot apply (G-011/012/013/014/018/020/021), while
  `generic_topic_max_share`/`min_room` are **absent** from G-005/006/007/008/017/019 whose answers
  depend on them (the checker silently defaults). Dead fields include `tie_break`, `rollup`,
  `narrator_temperature`, `cache_mode`, `execution_context`, `require_corroboration`,
  `search_first_page`, `recorded_at`.

---

## Dropped during verification (false positives)

Recorded so they are not re-raised:

- **"AUD-LINE principles are not numbered."** They are — `05-comparables.md` numbers 1–25;
  principle 16 (Fleming/class filter) is at line 4216 and 22 (the Battery charter) at 4265. Both
  say what the spec cites.
- **"`validate_golden.py` does not exist."** It exists at
  `~/.claude/skills/product-inception/scripts/validate_golden.py` and the reviewer ran it green. The
  real defect is narrower and is filed under P1-15: it is not vendored into the repo.
- **"`generic_topic_min_room = 4` is unpinned."** Mutation shows it is pinned on **both** sides
  (min_room=3 fails G-005/G-017; min_room=5 fails G-025). An early reviewer suspicion, disproved.
- **"The surfacing threshold 6 is unpinned."** It is pinned on both sides (G-006 at 6 surfaced,
  G-008 at 5 not, G-007 at 7 without substrate not). The *value* 6 being unsourced is a separate,
  real point kept in P1-15's constants discussion.
- **"The S8 gate breaks the ceiling of 16."** It does not. The max configuration
  (S1+S3+S4+S5+S6+S7+S8 = 16) contains S3, S5 and S7, so the gate is satisfied; re-derived
  independently and confirmed by G-023.
- **"The wireframe's stale Feld chip should read 42 days."** 42 days is Wilson/avc.com; Feld is 25
  days (audit 01:297). The finding stands with corrected evidence (P1-13).
- **"No fixture asserts model prose" (R-048) is unverifiable.** Checked and **true** — the only
  multi-word strings under any `expect` subtree are `properties[].reason` rationale fields.

---

## The two questions the author most needs to answer

**1. Is the generic-topic gate about the room, or about the vocabulary?**
Every defect in P0-1, P1-3 and P1-4 flows from modelling genericity as a room statistic. As a room
statistic it is non-monotonic (a fifth guest who shares the thesis deletes the match), room-size
inverted (the forbidden pair surfaces at 3 people), roster-dependent in a way that breaks R-021's
asymmetry guarantee, and — decisively — it does not fire on the one case that was actually measured,
because 5 of 10 is exactly half. As a vocabulary property (`venture-capital-craft` is simply not a
discriminating tag, established once by AUD-EDGES) all four problems vanish and the rule gets
simpler. Which did you mean? The answer changes R-025, `scoring-model.md` §3b, and re-baselines
G-008, G-025 and G-026 together.

**2. What is the actual boundary for a family-derived fact, and at which layer is it enforced?**
R-038 is the load-bearing half of K-4's defence of the widest sourcing policy in the spec, and right
now it has no definition ("family or intimates" is never defined), no schema field that could carry
it, no fixture, and one `happy`-path fixture that requires rendering exactly such a fact. Meanwhile
the same spec protects the *operator's* account structurally, by making write operations
non-existent in the interface. Should the member's family get the same structural treatment
(`derived_from_edges[]`, rejected in `select_renderable_facts`), or is the intended boundary
narrower — only *named living people* as fact subjects, with family *organisations* and inherited
context allowed through? Until this is decided, an implementer will guess, and the guess is the
thing that gets the product written about.
