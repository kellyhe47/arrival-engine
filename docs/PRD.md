# THE ARRIVAL ENGINE — PRD

**Status:** build-ready. **Date:** 2026-09-03.
**Acceptance contract:** `eval/golden/*.json` (30 fixtures, 19 behaviors). Prose here carries the
*why*; the fixtures and wireframes carry the *what*. Where they disagree, the fixtures win.

**Tagging.** `[source]` = from the brief, its rubric, or a measured audit finding.
`[decided]` = the user's call, logged in `docs/decisions/DECISIONS.md`. `[proposal]` = mine, pending.
Review the `[proposal]` lines.

**Companion artifacts**
| File | What it is |
|---|---|
| `docs/audit/01`–`07` | Ground truth, ~7,700 lines, every claim URL-backed with HTTP status |
| `docs/decisions/DECISIONS.md` | DEC-0 … DEC-7 |
| `docs/scoring-model.md` | Normative scoring spec — the fixture oracle |
| `docs/knowledge-graph.md` | Node, edge and source-tier schema |
| `docs/architecture.excalidraw` | 20 nodes / 23 edges, machine-recoverable |
| `docs/wireframes.html`, `docs/ui-states.md` | Every screen state, not just the happy path |
| `eval/golden-manifest.json`, `eval/golden/*.json`, `eval/verify_fixtures.py` | The contract + its checker |

---

## 1. Problem

R-001 `[source]` Arena Hall's members are founders and investors. Today, knowing who walked in and
who they should meet lives in one person's head, supported by software the CEO writes from a
terminal after midnight. The engine removes that constraint.

R-002 `[source]` A webhook fires with a name and one or two identifying details. Arrival detection
is assumed solved; no facial recognition, no computer vision, ever.

R-003 `[source]` The output is read by a host in **about ninety seconds** while the member walks in.

R-004 `[source]` The product dies on the wrong side of one line: a member who feels **seen** renews
and brings friends; a member who feels **dossiered** quits and tells people why.

---

## 2. Scope

**In:** ingestion across open and session-assisted sources; a per-member knowledge graph; asymmetric
pairwise scoring against everyone present; a staff-facing digest; one mobile-first surface.

**Out** `[source]`: facial recognition or any CV; login, accounts, roles; member-facing views;
polish for its own sake. **Out** `[decided]`: dating-app data — no access path exists at any login
state and it implies GDPR Art. 9 special-category data.

R-005 `[decided]` **Working beats pretty.** Ship a rough thing that runs.

R-006 `[proposal]` The repo records **hours spent** against a visible cut line, because RUBRIC-1
scores *"what did you get working, and in how many hours — both numbers matter."* Even with time
constraints lifted (DEC-0), the demo needs an hours number to answer that question.

---

## 3. Data sourcing

R-007 `[source]` Sources are tiered by **measured** access, never by assumption. Audit 04 tested
logged-out access; audit 07 tested a logged-in session. Both are recorded with HTTP status.

| Tier | Sources | Runs where |
|---|---|---|
| **GREEN** | blog RSS full-text (`avc.com`, `feld.com`, `hunterwalk.com`, `nabeelqu.substack.com`), HN Algolia, SEC EDGAR, Wikipedia, Wayback CDX, YouTube transcripts, podcast RSS, Open Library `search/inside` | anywhere, **including the deployed URL** |
| **METERED** | X API | anywhere; costs money |
| **SESSION** | **LinkedIn, X, Instagram, Facebook, TikTok** — operator's logged-in browser, read-only | **ingestion only, never the deployed URL** |

R-008 `[decided, DEC-1/DEC-6]` The relational layer — inner circle, tagged associates, follow-graph
— **is in scope and is built**. My audit's RED verdicts were measured logged-out; the user correctly
objected that this is the wrong measurement, and audit 07 confirmed it.

R-009 `[source, AUD-07]` **Measured session yields.** LinkedIn returns full post bodies, dates,
engagement, tagged people (`cc: …`) and reposts — and overturned a prior finding: Perkins posted
**1 day** before the audit, where the logged-out sweep found no 2026 first-person output at all.
X returns bio, counts, join date, birthday; the **following list is retrievable via the accessibility
tree** (not text extraction), replacing a ~$13.45/pull metered call with $0. Instagram, Facebook and
TikTok are **UNVERIFIED** — not logged in at test time. The PRD does not assume they work.

R-010 `[decided, DEC-6]` **Read-only, structurally.** Session adapters declare read operations only.
No post, message, like, follow, comment, reaction or connection request exists in the interface, so
it cannot be reached by a bug, a retry, or an instruction injected into a page. *(G-028)*

R-011 `[proposal]` No captcha or bot-detection evasion is designed or built, at any tier. Navigation
runs at human pace. TikTok's page carries 25 captcha references; that is a wall, not a challenge.

R-012 `[decided, DEC-7]` **Personalized strings are stripped at the adapter boundary.** A logged-in
page renders facts about *the operator* — `Followed by Alexandr Wang and Sam Altman`, `3rd`,
`5 others you know`. These are not reproducible by Arena Hall, they make coverage depend on who the
operator knows, and they leak the operator's contacts into a member's profile. Extraction runs
against a **whitelist** of member-owned fields; unknown fields are dropped. *(G-029, G-030)*

R-013 `[source]` Identity resolution requires **corroboration**. A handle match alone is not
identity: `spez` on Reddit is Steve Huffman; `@spez` on X is an unrelated account with 103 followers
and no posts. Emmett Shear is `emmett` on HN, not `eshear`. *(G-016)*

R-014 `[source]` An unavailable source **reports unavailability and returns empty**. It is never
backfilled from a search snippet or a language model. *(G-015, G-027)*

R-015 `[proposal]` A session expiring mid-ingest yields a **partial profile, marked partial**.
Collected facts are kept; the gap is visible. *(G-027)*

---

## 4. Knowledge graph

R-016 `[decided]` One graph per member, merged into one store. Full schema: `docs/knowledge-graph.md`.

R-017 `[source]` Every fact carries `provenance_class` ∈ {`self_published`, `on_record`,
`third_party`, `inferred`}, a `source_url` and a `source_date`, assigned at ingestion.

R-018 `[proposal]` Non-member people (co-founders, spouses, tagged colleagues) exist as graph nodes
so their edges are traversable, but are **never scored and never surfaced**. This is what makes wide
collection compatible with a narrow card.

R-019 `[source, AUD-EDGES]` Confirmed absences are stored as `no_edge_confirmed`. Feld's 5,551 posts
contain **zero** occurrences of Tavel, Huffman, Shear, Qureshi or Perkins. Recording the absence
stops the engine dressing topical similarity up as a relationship.

R-020 `[source]` Topics use a **controlled vocabulary** shared across people, so overlaps are
computable rather than string-matched.

---

## 5. Scoring

Normative spec: `docs/scoring-model.md`. Fixtures G-001 … G-008, G-017, G-023, G-025, G-026.

R-021 `[decided]` `score(A → B)` reads "how much A should want to meet B" and is **asymmetric**.
Asymmetry arises only from directed evidence (S5) and the status gradient (S8). With neither, both
directions are identical. *(G-001, G-002)*

R-022 `[decided]` Weights are bucketed into exactly three values — SMALL 1, MID 2, LARGE 3. A signal
fires at full weight or not at all. No partial firings, no learned weights, no tuning.

| id | signal | weight | directed |
|---|---|---|---|
| S1 | peer tier + cohort (same tier AND same career decade) | 2 | no |
| S2 | same-industry adjacency | 2 | no |
| S3 | cross-industry complementarity (different industries + shared professional topic) | 3 | no |
| S4 | life-context overlap (place, institution, life event, pursuit) | 3 | no |
| S5 | directed declared link (A follows / cites / co-mentions B) | 3 | **yes** |
| S6 | shared personal interest | 1 | no |
| S7 | shared professional thesis | 3 | no |
| S8 | status gradient (B more prominent than A) | 1 | **yes** |

R-023 `[proposal]` S2 and S3 are **mutually exclusive**, so the ceiling is **16**, not 18.
*(caught by `eval/verify_fixtures.py`, not by reading — G-023)*

R-024 `[proposal]` **S8 cannot fire unless a substrate signal (S2/S3/S5/S7) has already fired**, and
it is capped at SMALL. Prominence breaks ties; it never creates a match. Without this the engine
introduces everyone to the most famous person present — which is *selection*, the documented Fleming
failure mode, not *service*. It is also the answer to the VP-versus-CEO question: the aspirational
pull is real and modelled, but one prominence point never beats one shared thesis. *(G-003–G-005)*

R-025 `[proposal]` **Generic-topic exclusion.** A topic is excluded from S3, S6 and S7 when the room
holds ≥4 people and >50% of them hold it. AUD-EDGES measured `venture-capital-craft` on five of the
ten; without this, Kopelman↔Tavel (no discoverable edge) scores as strongly as Wilson↔Feld (296
mutual citations). The min-room floor is load-bearing: in a room of two, any shared topic is held by
100% of the room, and without the floor the gate deletes every match in a quiet room. *(G-025, G-026)*

R-026 `[proposal]` **Surfacing threshold.** A match is surfaced only at `score ≥ 6` **and** with at
least one of S3/S5/S7 fired. Demographics alone — same city, same tier, same decade — is not a
reason to interrupt someone. A card that says "nobody obvious tonight" is a feature: a weak
name-drop burns credibility a strong one later needs. *(G-006–G-008)*

R-027 `[proposal]` Ties break by LARGE-signal count, then evidence recency, then member id. The
ordering is deterministic and the arbitrary final tiebreak is documented as arbitrary. *(G-017)*

---

## 6. The digest

R-028 `[source, AUD-FORMAT]` **250–350 words.** The declassified President's Daily Brief of
3 Sep 1968 is 5 items / ~265 words / ~87 seconds read aloud. Brysbaert (2019, 190 studies, 18,573
participants) puts adult silent non-fiction reading at 175–300 wpm; the slow end binds, because the
host is standing, walking and watching a door. Outside the band is a **hard gate failure**. *(G-010)*

R-029 `[source]` **Exactly five ordered bare-noun blocks**, no summary paragraph, no transitions:

| # | Block | Contains |
|---|---|---|
| 1 | **Who** | Name + one borrowed, attributed line (the White House palm-card unit) |
| 2 | **Now** | What they are actually doing — or an honest statement that the trail is cold |
| 3 | **Room** | Top matches: reason first, score small |
| 4 | **Notice** | The deep cut, with provenance |
| 5 | **Say** | The line the host can say out loud |

R-030 `[source, AUD-FORMAT-SBAR]` The card **ends on a sayable line, not a fact**. In clinical SBAR
the Recommendation slot is mandatory; a brief that ends on information is an unfinished handoff.
*(G-009)*

R-031 `[decided, DEC-2]` **Reason first, score small.** The "why" is the headline; the number sits
beside it, de-emphasised, out of 16. No product on the market ships both a score and its reasoning —
relationship CRMs expose scores and deliberately hide reasoning; event matchmakers show reasoning
and never expose a score. The brief asks for both, which is unoccupied territory.

R-032 `[source]` The reason sentence **names only signals that actually fired**. A reason citing a
connection the engine did not find is worse than no reason, because the host says it out loud to the
member. *(G-020)*

R-033 `[decided, DEC-4]` **Deep cut: anything public, with the source shown.** Any verifiable public
fact qualifies provided the card carries its provenance. I flagged AUD-LINE-3 ("it was public" is
the weakest defence — every Clearview image was public) and AUD-LINE-5 (composition is the danger);
the user chose breadth. The provenance chip is therefore not decoration — it is the mechanism that
makes the widest policy defensible, and it is the palm-card pattern: a borrowed line with its source
attached. *(G-024)*

R-034 `[source]` **A fact with no source cannot render.** Provenance is a required field, not display
metadata. *(G-011)*

R-035 `[source, AUD-LINE-5]` An **inferred** fact must name the facts it was composed from, or it
cannot render. Two Uber timestamps are boring; joined, they are a one-night stand. The creepiness
lives in the join. *(G-012)*

R-036 `[source, AUD-STALE]` **Staleness is stated, never disguised.** Kopelman has no first-person
content since 2014-11-12; Tavel's newest owned post is 12 months old; her Aug 2026 podcast is a
**rerun of an Apr 2025 recording** and must be dated by recording, not publication. *(G-013, G-014)*

R-037 `[proposal]` The card is a **staff instrument** and is never member-visible. The Battery's
charter already forbids members using presence features to surveil each other; the moment this
becomes member-visible it violates a rule members have been given.

R-038 `[proposal]` Facts about family or intimates may **inform a match** via graph traversal but
never appear as a sentence on the card. In both Target and Meyer, the person harmed was not the
subject of record.

---

## 7. Surfaces and states

Wireframes: `docs/wireframes.html`. Full state table, navigation and actions: `docs/ui-states.md`.

R-039 `[decided]` One primary surface: the **card**, mobile-first. Plus **Why-this-score** (one tap)
and **Room** (demo control standing in for the webhook).

R-040 `[source]` Every state is designed, not just the happy path: ready, no-strong-match, cold
trail, empty room, ingesting, withheld, ambiguous name, unknown name. *(G-013, G-019)*

R-041 `[proposal]` **Why-this-score** shows fired signals with weights, signals that did *not* fire
and why, excluded generic topics with their share of the room, and the reverse-direction score.
This is the whole answer to "expose the reasoning", one tap away and never on the card.

R-042 `[proposal]` The **ingesting** screen names unavailable adapters and their reasons rather than
hiding them. On stage this screen is half the argument for RUBRIC-2.

R-043 `[proposal]` **Retry never relaxes a gate.** The obvious implementation of a retry button is
re-render-until-pass, which converts a hard gate into a retry loop.

R-044 `[proposal]` On ambiguity the **host picks**; the engine never guesses an identity.

---

## 8. Evaluation

R-045 `[decided, DEC-5]` **Gate on structure, grade on content.** Hard pass/fail: word count, blocks
present and ordered, all facts sourced, inferred facts name inputs, correct top match, sayable
close. Graded with partial credit: deep cut found and non-obvious, reason cites a resolvable source,
talk track reads as sayable. A gate failure outranks any content grade — a card scoring 4/4 on
content still fails if it carries one unsourced fact. *(G-021)*

R-046 `[source]` Two distinct commands: `validate-spec` (schema, arithmetic, traceability — runs
today) and `test-golden` (drives the real implementation against the fixtures — needs the runner).
They must never be conflated.

R-047 `[proposal]` Digest generation is **idempotent**: same name, same roster, same cache, same
card. Narrator temperature 0. The demo re-runs an arrival on stage; a card that varies between runs
is a sample, not a decision. *(G-018)*

R-048 `[proposal]` The narrator is an **injected seam**. The model writes prose; it never makes a
decision. Everything in the matching path is deterministic. No fixture asserts model prose.

---

## 9. Demo and deliverables

R-049 `[source]` Ship: **a live URL**, **the repo**, and **one paragraph** on what to build next
with a month and Arena Hall's real data.

R-050 `[decided, DEC-3]` **Ten cached + one live re-run.** All ten profiles pre-built and cached so
rendering never depends on a network call. One live ingestion run is triggerable on stage to prove
the pipeline is real.

R-051 `[proposal]` The on-stage live run exercises **GREEN adapters only**, so it cannot fail on a
dead session in front of the room. Session-assisted ingestion happens beforehand, locally.

R-052 `[proposal]` The deployed app **serves the cache**. Session adapters are absent from the
runtime registry entirely — sharing one registry between the ingestion job and the web app is how
the live URL ends up trying to open a browser it does not have. *(G-015)*

---

## 10. Risks

| # | Risk | Standing |
|---|---|---|
| K-1 | Session adapters violate platform ToS; enforcement is **account-level on the operator's own account**. Meta §3.2(3) covers logged-in collection; LinkedIn "Don'ts" cl.2 bans it; *hiQ* lost on breach of contract and ate a permanent injunction. | Raised, user accepted (DEC-6) |
| K-2 | Instagram, Facebook, TikTok session yields are **UNVERIFIED**. | Must be measured before they are claimed |
| K-3 | Session data is **not reproducible** by Arena Hall — they cannot re-derive it from a different account. | Mitigated by DEC-7 stripping; residual |
| K-4 | RUBRIC-4 pressure. DEC-4 takes the widest sourcing policy; the defence rests entirely on visible provenance and on family facts never rendering. | Mitigated by R-033/R-034/R-038 |
| K-5 | The live re-run fails on stage. | Mitigated by R-050/R-051 |
| K-6 | AUD-EDGES is **incomplete** — Kopelman has no retrievable first-person archive, Tavel's 2006–15 blog was not enumerated, firm-level co-investment could not be scraped. | Named as a corpus gap; `no_edge_confirmed` must not be asserted where the corpus was never searched |

---

## 11. Requirement index

Data R-007…R-015 · Graph R-016…R-020 · Scoring R-021…R-027 · Digest R-028…R-038 ·
Surfaces R-039…R-044 · Evaluation R-045…R-048 · Demo R-049…R-052 · Problem R-001…R-006.

**Fixture coverage:** every behavior in `eval/golden-manifest.json` (19) is covered by at least one
of the 30 fixtures; both `validate_golden.py` and `verify_fixtures.py` pass (197 arithmetic checks).
