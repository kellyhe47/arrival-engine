# Scoring model — normative spec

This is the oracle the golden fixtures assert against. Prose here is normative, not explanatory.
**Re-baselined 2026-09-04** against the clickable prototype (`Arrival-Engine-Prototype.html`) and
PRD §4; the previous eight-signal model is retired.

Precedence: `eval/golden/*.json` > `docs/PRD.md` > this file. Where this file and the PRD have
disagreed, the PRD was right and this file has been corrected.
Inputs come from `db/roster.sql` (the cast, including each member's measured `intent`) and
`db/vocabulary.sql` (the controlled vocabulary); neither is a fixture-time invention.

## 1. Direction

`score(A -> B)` reads "how much A should want to meet B". A is the ARRIVING member; B is a member
already present. The engine computes `score(A -> B)` for every present B. It is **not symmetric**:
`score(A -> B) != score(B -> A)` whenever a directed signal (S7, S8, S9) fires.

## 2. Signals and buckets

Weights are bucketed into exactly three values. No nuance, no tuning knobs, no learned weights.
  SMALL = 1   MID = 2   LARGE = 3
A signal either FIRES at its full bucket weight or contributes 0. There are no partial firings.

| id  | signal                       | weight | directed | fires when |
|-----|------------------------------|--------|----------|-----------|
| S1  | same industry                | MID 2  | no  | A and B have >=1 industry tag in common. Establishes context; can never carry a match (see §5) |
| S2  | seniority + cohort           | MID 2  | no  | A and B hold the SAME seniority tier AND the SAME career-start decade. Both required |
| S3  | shared context               | LARGE 3| no  | A and B share >=1 measured, RESOLVED context of type place, institution or life_event (a programme such as YC S2005 is a life_event). Never an assumed geography, never "both at the club tonight" |
| S4  | organisation history         | SMALL 1| no  | A and B share >=1 resolved context of type organisation — they overlapped inside the same org |
| S5  | shared professional topic    | LARGE 3| no  | A and B share >=1 PROFESSIONAL topic after generic exclusion (§4) and alias folding |
| S6  | shared personal topic        | MID 2  | no  | A and B share >=1 personal topic. `topics_personal` and pursuit-type contexts both count, so the storage shape does not decide the score |
| S7  | declared link                | LARGE 3| YES | A follows B, or A has publicly cited / named / reposted B in A's own words |
| S8  | status gradient              | SMALL 1| YES | B's prominence tier is strictly above A's (NULL on either side never fires). Tie-break and display only |
| S9  | intent complement            | LARGE 3| YES | the pair's intent class is `complement` — B has done what A is trying to do (§3). Display only; never in the floor |

**Ceiling = S1+S2+S3+S4+S5+S6+S7 = 16.** S8 is outside the ceiling. S9 is outside both the
ceiling and the floor; it is added to the DISPLAYED score only when the class is complement.

## 3. Intent and the intent classes

Every member carries one intent for the evening, measured from evidence
(`person.intent` / `person.intent_basis`), never assumed:

  I1 deploying capital · I2 raising or being backed · I3 building an institution ·
  I4 publishing a body of work · I5 learning a domain · I6 giving access · I7 stepping back ·
  I8 being social — attendance without an agenda, a FINDING, never a residual ·
  I0 unknown — coverage incomplete. NULL reads as I0, and I0 is NEVER read as I8.

**The evidence bar (R-022b):** an intent needs at least two corroborating items, each with a
source and a date, inside a rolling 180-day window, or it is I0; intent decays out of the window
rather than being carried forward. I8 needs its own evidence like any other value. **A member may
hold two intents** (`person.intent` / `person.intent_secondary`); a third is treated as none.
With two intents per side, I0 and I8 are whole-member states checked first; the class is then the
best available combination, in the order complement > guarded > parallel > neutral.

**What intent must never do (R-022c):** never rendered as a need; never inferred from a role or
title; never inferred from silence; never carried across a suppression; never used as a residual;
never shown to the member's face.

Each pair takes an **intent class** for `score(A -> B)`, in precedence order:

  1. `unknown`    — I0 on either side. Ranked on score alone.
  2. `open`       — I8 on either side. Ranked on score alone.
  3. `complement` — B's intent completes A's, per the closed map:
                       A raising (I2)  ← B deploying (I1) or giving access (I6)
                       A learning (I5) ← B published body of work (I4) or giving access (I6)
                       A building (I3) ← B built one and stepped back (I7)
                    S9 fires. A complement the map does not name is not a complement.
  4. `guarded`    — an ask (I2 or I5) on one side pointed at someone stepping back (I7) on the
                    other. Ranked LAST, and the card names the asymmetry. Never suppressed.
  5. `parallel`   — same intent on both sides. Two people deploying capital are parallel,
                    not complementary. S9 does not fire.
  6. `neutral`    — anything else. Score alone.

## 3a. The status-gradient rule (the taste constraint)

**S8 fires only if at least one of S3, S5, S6, S7 has already fired**, and, independently,
**the floor in §5 is evaluated on the score EXCLUDING S8.** Two rules, both required: the first
stops prominence contributing at all without substrate; the second stops it carrying a borderline
pair over the line. S8 affects display and ranking only.

Rationale: prominence may break a tie; it may never create a match. Without this gate the engine
degenerates into "introduce everyone to the most famous person in the room" — *selection*, not
*service* (AUD-LINE 16, Fleming / Vice). S8 is capped at SMALL precisely so it cannot dominate.

## 4. Generic-topic exclusion

Genericity is a property of the **vocabulary**, not of the room.

Rule: **a topic is excluded from S5 and S6 when `holder_count / base_size >= 0.40`**, measured
once over the member base at ingest and stored in `topic.discriminating`. The test is `>=`:
a topic held by exactly 4 of 10 sits at the threshold and is excluded. Room-independent.
Excluded topics are reported with their holder shares on Why-this-score, never silently dropped.
Mechanism: `db/vocabulary.sql`. Measured: `venture-capital-craft` is held by 5 of 10 — excluded.

Related trap: **do not merge adjacent topics.** Tavel writes about AI-and-work, Shear about
AI-alignment, Huffman about content moderation — three people, three tags, no shared tag.
Collapsing them into one `AI` bucket manufactures a fake affinity.

## 5. The floor, and the order of operations

A match is surfaced only if **`sum(fired S1..S7) >= 6`** (S8 and S9 both excluded) **AND at least
one of S3, S5, S6, S7 fired**. S1/S2/S4 are demographics, and demographics alone is not a reason
to interrupt someone. Below the floor **nobody is named** — not as primary, not as backup. The
card reports the miss with the number ("Top score, no candidate named · 5 · needs 6").

The full pipeline (PRD R-022a, verbatim):

  1. Score every pair in the room, both directions, S1–S8.
  2. Drop everything below the floor.
  3. Class every survivor. I8 on either side means open.
  4. Rank: complement, then parallel, then open / neutral / unknown on score, guarded last.
  5. Add S9 to the displayed score where the class is complement. The floor excludes it.
  6. Write the reason from the intent, not the overlap.

## 6. Ranking and ties

Surfaced matches rank by intent class (step 4), then by displayed score descending. Ties inside a
class break by, in order:

  1. count of LARGE signals fired (more wins)
  2. recency of the most recent evidence backing any fired signal (newer wins)
  3. member id, ascending (deterministic, arbitrary, documented as arbitrary)

Tier 2: each fired signal carries the date of the fact backing it
(`signal_evidence[member_id][signal_id]`, ids S3/S5/S6/S7), and a match's recency is the LATEST
such date across its fired signals. **S8 is excluded from that maximum** — its date is a
prominence measurement, not a dated event between two people; including it makes every match tie
at today's date and silently collapses tier 2 into tier 3. Where neither side has a dated signal,
tier 2 is skipped and tier 3 decides.

Below-floor matches trail in plain score order; they are listed on Why-this-score for honesty and
are never named on a card.

## 7. Reasoning exposure

Every surfaced match renders:
  - a REASON sentence written from the INTENT first (the S9 clause leads when the class is
    complement), then the fired signals, naming the shared substrate in plain words
  - the SCORE, small and de-emphasised
  - a PROVENANCE chip per fact used in the reason: source + date

The chip's source is the `source_url`'s hostname **with a leading `www.` removed, and nothing
else stripped**. A real subdomain is never stripped: `blog.emmettshear.com` is not
`emmettshear.com`, which is a GoDaddy parking page and a different site entirely.

The reason sentence must name only signals that actually fired. A reason that cites a signal
which did not fire is a hard failure. Why-this-score additionally shows every signal that did
NOT fire with a one-line reason, the excluded generic topics with holder shares, and the
reverse-direction score with its own fired rows.

## 8. Fact provenance classes

Every fact carries `provenance_class`, assigned at ingestion:
  - `self_published`  — subject published it under their own name
  - `on_record`       — subject said it, journalist-mediated
  - `third_party`     — someone else published it about the subject
  - `inferred`        — the engine derived it by composing >=2 facts

All four classes MAY render, provided the card shows the source. `inferred` facts must
additionally name the facts they were composed from. An `inferred` fact that cannot name its
inputs cannot render.

## 9. Word budget

The rendered card body is 250–350 words, measured over the whole brief — the reading layer and
the collapsed rest together. Outside the band is a hard gate failure, not a warning.

## 10. Card blocks

Five content blocks. The COMPOSITION order — the gate contract, what fixtures assert — is
unchanged: `Who` · `Now` · `Room` · `Notice` · `Say`. The RENDER arranges them in two layers
(PRD R-034):

  reading layer   `Who`  (Who they are) — name + one line, borrowed and attributed
                  `Room` (Who's here)   — the one named match, reason first, score small; or an
                                          honest miss
                  `Say`  (Say this)     — the sayable line. Spoken to somebody, present tense.
                                          The reading layer ENDS here; a pinned Say rail repeats
                                          the condensed line until the real block is on screen
  collapsed       `Now`    (Recent activity) — or an honest cold trail / coverage gap
                  `Notice` (Personal detail) — the deep cut, with provenance

The collapsed layer also renders `The match` (candidate + score, score linking to Why-this-score)
and `Sources` (deduplicated provenance hosts), both derived, not narrated. Bare-noun labels, no
headlines, no summary paragraph, no transitions.

The card ends with the R-060 outcome capture: a free-text observation and five outcome tags
(`Never introduced` · `Brief hello` · `Talked a while` · `Together all night` · `Swapped
details`), stored append-only against the introduction. A log needs the observation or a tag —
either alone is worth keeping. Logging is optional and blocks nothing.
