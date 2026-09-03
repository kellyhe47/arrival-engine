# Decisions log

## DEC-0 — Time budget
"Ignore time constraints." Spec for correctness, not hours.
NOTE: RUBRIC-1 still scores "in how many hours", so the PRD must carry an explicit
"first N hours" cut line the demo can be narrated against.

## DEC-1 — Relational layer stays in scope, as specced (user's call, 2026-09-03)
The audit (AUD-RED, docs/audit/04) measured LinkedIn 999, Instagram JS-shell, Facebook 400,
TikTok captcha-walled, X timelines metered + mirrors dead. I recommended cutting the
inner-circle / family / follow-graph layer on both retrievability and RUBRIC-4 taste grounds.
**User reaffirmed: keep it as specced.** That is the decision; the PRD builds it.

How it is honoured without pretending the bytes exist:
1. The relational layer is a first-class specced component with TYPED ADAPTERS, one per source.
2. Every adapter carries its MEASURED status from docs/audit/04 and a named lawful acquisition
   path. Adapters measured RED are specced and ship DISABLED-BY-DEFAULT with an empty result,
   not faked. No adapter is specified to defeat a captcha or bot-detection wall.
3. The X follow-graph IS buildable (metered API, ~$13.45/full pull for a 1,345-following account)
   and is specced for real, because "member A already follows member B" was weighted Large.
4. Dating profiles: no access path exists at any price, so there is nothing to build an adapter
   against. Recorded, not silently dropped.
5. **Wide collection, narrow disclosure.** The user's own brief says "hospitality and not
   surveillance". So collection breadth is the user's call (this decision), and the DIGEST is
   independently gated by a disclosure rule (see DEC-TBD on the leak test). These are two
   different stages and the second is not a veto on the first.

## DEC-2 — Score UI: reason first, score small
The "why" is the headline; the number sits beside it, small and de-emphasised. Host reads a
sentence, never arithmetic. Sourced to AUD-FORMAT (PDB: bare-noun label + prose) and the White
House palm card (name + one borrowed line with its source attached).
Satisfies BRIEF "with a score and the reasoning exposed" without turning the host into a scorer.

## DEC-3 — Demo scope: ten cached + one live re-run
All ten profiles pre-built and cached; the demo never depends on a network call to render.
ONE live ingestion run must be triggerable on stage to prove the pipeline is real.
Implication: ingestion and serving are separate stages with a durable cache between them.

## DEC-4 — Deep-cut gate: anything public, with source shown
User's call. Widest option. Any verifiable public fact qualifies PROVIDED the card carries its
source. I flagged AUD-LINE principles 3 (Clearview: "it was public" is the weakest defence) and
5 (composition is the danger); user chose breadth.
Mitigation carried into the spec, because it is what the chosen option itself requires:
  - EVERY fact rendered on the card carries a visible provenance chip (source + date).
  - Provenance is a REQUIRED field on a fact, not an optional annotation. A fact that cannot
    name its source cannot render. This is the palm-card pattern (a borrowed superlative with
    its source attached) and it is the mechanism that makes DEC-4 defensible on Friday.

## DEC-5 — Test rollup: gate on structure, grade on content
HARD PASS/FAIL gates (any failure fails the digest):
  - word count within band
  - all required blocks present
  - every rendered fact carries provenance
  - no fact drawn from a disallowed-provenance class
  - correct top-ranked match
GRADED (partial credit, reported as a score + failure list):
  - deep cut found and non-obvious
  - reasoning cites a real, resolvable source
  - talk-track reads as sayable
Every scoring fixture's observation envelope must therefore emit BOTH a gate verdict and a
graded component. Settled before fixtures are written, per the fixture contract.
