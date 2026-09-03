# Scoring model — normative spec

This is the oracle the golden fixtures assert against. Prose here is normative, not explanatory.

## 1. Direction

`score(A -> B)` reads "how much A should want to meet B". A is the ARRIVING member; B is a member
already present. The engine computes `score(A -> B)` for every present B. It is **not symmetric**:
`score(A -> B) != score(B -> A)` whenever a directed signal fires. [DEC-user, brief §"not a
one-to-one scoring algorithm"]

## 2. Signals and buckets

Weights are bucketed into exactly three values. No nuance, no tuning knobs, no learned weights.
  SMALL = 1   MID = 2   LARGE = 3
A signal either FIRES at its full bucket weight or contributes 0. There are no partial firings.

| id  | signal                          | weight | directed | fires when |
|-----|---------------------------------|--------|----------|-----------|
| S1  | peer tier + cohort              | MID 2  | no  | A and B hold the SAME seniority tier AND the SAME career-start decade. Both conditions required. |
| S2  | same-industry adjacency         | MID 2  | no  | A and B have >=1 industry tag in common |
| S3  | cross-industry complementarity  | LARGE 3| no  | A and B are in different industries AND share >=1 PROFESSIONAL topic — the pairing a silo could not produce |
| S4  | life-context overlap            | LARGE 3| no  | A and B share >=1 non-professional context: a place, an institution, a life event, a pursuit |
| S5  | directed declared link          | LARGE 3| YES | A follows B, or A has publicly named/cited/praised B in A's own words |
| S6  | shared personal interest        | SMALL 1| no  | A and B share >=1 personal-interest topic |
| S7  | shared professional thesis      | LARGE 3| no  | A and B share >=1 professional topic each has returned to repeatedly. Fires independently of industry, so S3 and S7 may both fire. |
| S8  | status gradient                 | SMALL 1| YES | B's prominence tier is strictly above A's |

S2 and S3 are mutually exclusive (see 3a), so the ceiling takes the larger of the two:
Max attainable = S1 2 + S3 3 + S4 3 + S5 3 + S6 1 + S7 3 + S8 1 = **16**. Score is an integer in [0, 16].

## 3. The status-gradient rule (the taste constraint)

**S8 fires only if at least one of S2, S3, S5, S7 has already fired.**

Rationale: prominence may break a tie; it may never create a match. Without this gate the engine
degenerates into "introduce everyone to the most famous person in the room", which is
*selection*, not *service* — the documented failure mode in AUD-LINE principle 16 (Fleming /
Vice). It is also the answer to the VP-vs-CEO question: the VP's pull toward the CEO is real and
is modelled (S8), but it cannot outrank an actual conversational substrate.

S8 is capped at SMALL precisely so it cannot dominate. One prominence point never beats one
shared thesis (3).

## 3a. Signal independence

Signals are evaluated independently and may co-fire. Two consequences worth stating because they
are the arithmetic most likely to be got wrong:
  - S2 (same industry) and S3 (cross-industry) are mutually exclusive by construction.
  - S3 and S7 both fire for a cross-industry pair sharing a professional topic. That is intended:
    the pairing is both complementary AND substantive, and the brief weights that case highest.
  - S6 (personal) never satisfies S3, whose shared-topic test reads professional topics only.

## 3b. Generic-topic exclusion (AUD-EDGES-GENERIC)

The edge audit measured that `venture-capital-craft` is held by **five of the ten**. A topic that
half the room shares carries no information: it would fire S7 for Kopelman/Tavel (who have no
discoverable edge at all) exactly as hard as for Wilson/Feld (296 mutual citations).

Rule: **a topic is excluded from S3, S6 and S7 if the room holds at least 4 people (including the
arriving member) AND strictly more than 50% of them hold that topic.** Excluded topics are reported
so the exclusion is visible rather than silent.

The minimum room size is load-bearing, not a detail. Genericity is a statistical claim, and in a
room of two any shared topic is held by 100% of the room. Without the floor the gate deletes every
match in a quiet room — which is precisely when the host most needs one. At 4 people, "more than
half" means at least 3 holders, which is a real cluster rather than a coincidence.

This preserves the three-bucket design — a signal still fires at its full weight or not at all.
The gate is on which topics *count*, never on how much a signal is *worth*.

## 4. Ranking and ties

Present members are ranked by `score(A -> B)` descending. Ties break by, in order:
  1. count of LARGE signals fired (more wins)
  2. recency of the most recent evidence backing any fired signal (newer wins)
  3. member id, ascending (deterministic, arbitrary, documented as arbitrary)

## 5. Threshold for surfacing

A match is surfaced on the card only if `score >= 6` AND at least one of S3, S5, S7 fired.
Below that the "Room" block reports honestly that there is no strong match right now.

Rationale: a host who name-drops on a weak match burns credibility that a strong match later
needs. Forcing a recommendation is the failure the brief's TASTE criterion punishes. A card that
says "nobody obvious tonight" is a *feature*.

## 6. Reasoning exposure

Every surfaced match renders:
  - a REASON sentence, generated from the fired signals, naming the shared substrate in plain words
  - the SCORE, small and de-emphasised [DEC-2]
  - a PROVENANCE chip per fact used in the reason: source + date [DEC-4]

The reason sentence must name only signals that actually fired. A reason that cites a signal
which did not fire is a hard failure.

## 7. Fact provenance classes

Every fact carries `provenance_class`, assigned at ingestion:
  - `self_published`  — subject published it under their own name
  - `on_record`       — subject said it, journalist-mediated
  - `third_party`     — someone else published it about the subject
  - `inferred`        — the engine derived it by composing >=2 facts

Per DEC-4 all four classes MAY render, provided the card shows the source.
Per AUD-LINE principle 5, `inferred` facts must additionally name the facts they were composed
from, because composition is where the creepiness lives. An `inferred` fact that cannot name its
inputs cannot render.

## 8. Word budget

The rendered card body is 250-350 words. [AUD-FORMAT: PDB 1968 = 265 words / ~87s aloud;
Brysbaert 2019 = 175-300 wpm silent, slow end binding because the host is standing and watching
a door.] Outside the band is a hard gate failure, not a warning.

## 9. Card blocks — exactly five, in this order

  1. `Who`     — name + one line, borrowed and attributed
  2. `Now`     — what they are actually doing lately, or an honest statement that the trail is cold
  3. `Room`    — top matches, reason first, score small; or an honest no-match
  4. `Notice`  — the deep cut, with provenance
  5. `Say`     — the sayable line. Second person, present tense. This is the SBAR Recommendation
                 slot: the card ends on an action, never on a fact.

Bare-noun labels, no headlines, no summary paragraph, no transitions. [AUD-FORMAT]
