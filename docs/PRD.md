# THE ARRIVAL ENGINE — PRD

**Acceptance contract:** `eval/golden/*.json`. Prose carries the *why*; fixtures carry the *what*.
Where they disagree, fixtures win — except the four fixtures named defective in §10.

`[source]` brief / rubric / measured audit · `[decided]` user's call (`docs/decisions/DECISIONS.md`)
· `[proposal]` mine. Review the `[proposal]` lines.

Companions: `scoring-model.md` (oracle) · `knowledge-graph.md` + `db/schema.sql` (storage) ·
`wireframes.html` + `ui-states.md` (surfaces) · `architecture.excalidraw` · `audit/01–07` (ground
truth, every claim URL-backed) · `spec-review-01.md` (adversarial review).

---

## 1. Thesis

**R-001** `[source]` A webhook fires with a name and one or two identifying details. A host has
~90 seconds between the door and the handshake. No facial recognition, no CV — arrival is solved.

**R-002** `[source]` The failure mode is not incompleteness, it is creepiness. *"A member who feels
SEEN renews and brings friends. A member who feels DOSSIERED quits and tells people why."*

**R-003** `[proposal]` The shippable test, from a working maître d': **would the member be pleased
to read this card over the host's shoulder?** (AUD-LINE-14.)

**R-004** `[proposal]` **The engine must never assert what it merely failed to observe.** Every
defect the audit found was a variant of this: the `@spez` collision, the operator's graph leaking
into member profiles, the wrong Fred Wilson in a tagged post, "Ries is dormant" the month he
shipped a book. Every gate below exists to enforce it.

## 2. Sourcing

**R-005** `[source]` Sources are tiered by **measured** access. Audit 04 tested logged-out; audit 07
tested a logged-in session.

| Tier | Sources | Runs |
|---|---|---|
| **GREEN** | blog RSS full-text, HN Algolia, SEC EDGAR, Wikipedia, Wayback, YouTube transcripts, podcast RSS, Open Library | anywhere, incl. deployed |
| **METERED** | X API | anywhere, costs money |
| **SESSION** | LinkedIn, X, Instagram (measured working); Facebook, TikTok (UNVERIFIED) | ingest only, **never deployed** |

**R-006** `[decided, DEC-1/6]` The relational layer — inner circle, tagged associates, follow-graph —
is built. My RED verdicts were measured logged-out; the user correctly objected. Audit 07 confirmed:
LinkedIn returns full post bodies and tagged people; X's follow list comes free via the
accessibility tree; Instagram captions yield places and pursuits.

**R-007** `[decided, DEC-6]` **Read-only, structurally.** No write operation exists in the adapter
interface, so posting, liking or following is unreachable by bug, retry or injected instruction.
*(G-028)*

**R-008** `[proposal]` No captcha or bot-detection evasion, at any tier. Human pace.

**R-009** `[decided, DEC-7]` Personalized strings are stripped at the adapter boundary against a
**whitelist**. "Followed by Sam Altman", "3rd degree", "5 others you know" are facts about the
*operator*. *(G-029)*

**R-010** `[proposal]` **Source precedence on contradiction:** the member's own words > their
organisation's > the follow graph > press. A lower tier never overrides a higher one. *(from the
comparison PRD, R-012)*

**R-011** `[source]` An unavailable source reports unavailability and returns empty — never
backfilled from a snippet or a model. A session expiring mid-ingest yields a profile **marked
partial**. *(G-015, G-027)*

## 3. Identity and staleness

**R-012** `[source]` Resolution requires **corroboration**; a handle match is not identity.
`spez` on Reddit is Huffman; `@spez` on X is a stranger with 103 followers. *(G-016)*

**R-013** `[proposal]` More than one candidate → **`ambiguous`: show the chooser, emit no brief.**
Zero → `not_found`. A candidate marked **deceased is never auto-resolved** — "Nabeel Qureshi"
resolves to the writer and to an apologist who died in 2017. Briefing on a dead man is the worst
available failure.

**R-014** `[source]` **The supplied label is a hint to verify, never a fact to echo.** The brief's
own roster is stale for several of the ten: Shear runs **Softmax**, not Twitch. A host who opens
with *"so, Twitch…"* has damaged the relationship before the handshake.

**R-015** `[proposal]` The brief emits `label_correction {supplied, current, stale}`. When stale,
the card shows it explicitly — *"the door said Twitch; it's Softmax now"* — because the host may
have already read the door.

## 4. Scoring

Oracle: `scoring-model.md`. Directional: `score(A→B)` ≠ `score(B→A)`.

**R-016** `[decided]` Weights bucket to exactly three values — SMALL 1, MID 2, LARGE 3. A signal
fires at full weight or not at all.

| id | signal | w | directed |
|---|---|---|---|
| S1 | peer tier + cohort | 2 | |
| S2 | same-industry | 2 | |
| S3 | cross-industry + shared professional topic | 3 | |
| S4 | life-context overlap (place, institution, event, pursuit) | 3 | |
| S5 | directed link — follows / cites / co-mentions | 3 | **✓** |
| S6 | shared personal interest | 1 | |
| S7 | shared professional thesis | 3 | |
| S8 | status gradient | 1 | **✓** |

**R-017** `[proposal]` S2 and S3 are mutually exclusive, so the ceiling is **16**.

**R-018** `[proposal]` **S8 cannot create a match.** The surfacing threshold is evaluated on the
score **excluding S8**; S8 affects display and ranking only. Prominence breaks ties, never makes
them. Without this the engine sends everyone to the most famous person present — *selection*, the
Fleming failure, not service. *(fixes P0-2)*

**R-019** `[proposal]` **Genericity is a property of the vocabulary, not the room.** A topic is
excluded from S3/S6/S7 when `holder_count / base_size ≥ 0.40`, measured once over the member base
and stored in `topic.discriminating`. `venture-capital-craft` is held by 5 of 10 and is excluded.
The prior room-statistic version was non-monotonic, room-size-inverted, and failed on its own
justifying case. *(fixes P0-1; mechanism in `db/vocabulary.sql`)*

**R-020** `[proposal]` **Introduction floor = 6**, and at least one of S3/S5/S7 must have fired.
Demographics alone is not a reason to interrupt someone. Below the floor **nobody is named** — not
as primary, not as backup.

**R-021** `[proposal]` Ties break by LARGE-signal count, then evidence recency, then id. *(G-017)*

**R-022** `[proposal]` **Brokering mode**, in precedence order: `mutual` (both ≥ floor) →
`broker` (gap ≥ 6) → `light_touch`. It changes what the host physically does — mutual means
introduce and step away; broker means stay and carry the reason across.

**R-023** `[proposal]` Every fired signal carries a one-line `evidence` string naming why it fired.
That is what makes the number arguable rather than oracular.

## 5. Disclosure

**R-024** `[decided, DEC-4]` Deep cut: **anything public, with the source shown.** The provenance
chip is not decoration — it is the mechanism that makes the widest policy defensible.

**R-025** `[source]` **A fact with no source cannot render.** An **inferred** fact must name what it
was composed from. Enforced in the store by `v_renderable_fact`, not by care. *(G-011, G-012)*

**R-026** `[proposal]` **`trust_class` is independent of provenance:** `subject_authored` /
`publisher` / `third_party_open`. Instagram's tagged tab is written by **other people** — its first
item names the wrong Fred Wilson (the conceptual artist). `third_party_open` content is never
attributed without corroboration, never rendered, and never concatenated into a model prompt as
fact. It is a traversal hint only. *(AUD-07-7 — an injection surface, measured)*

**R-027** `[decided, DEC-9]` Family facts are governed by a **write-time judgement in the narrator
prompt, not a gate.** Family *organisations* and inherited context may render. Spec-review P0-3
argued for a structural rule; I recommended it, the user chose write-time judgement. **No fixture
can fail when a family fact reaches a card, because there is no rule to violate.** Residual risk
accepted (AUD-LINE-6: in Target and Meyer the person harmed was not the subject).

**R-028** `[proposal]` **The suppression counter.** The card shows withheld facts as **class and
count only** — *"2 withheld: finance, family"* — never content. It proves restraint without
leaking, and it is the visible answer to *"what did you choose to leave out."*

**R-029** `[source]` The worked example: **Huffman's SEC Form 4 share sales are public, filed and
verified — and suppressed.** A host who mentions them has ended the relationship.

**R-030** `[proposal]` The model may only **rephrase retrieved text, never add facts.** A
hallucinated fact read aloud to a founder is unrecoverable in the room.

**R-031** `[decided, DEC-8]` **Image analysis is in scope; face recognition is not.** The brief's
exclusion is scoped to arrival detection. In: scene, object, activity, venue, text-in-image. Out
permanently: face recognition, matching, clustering, or inference from a face. Only
subject-published images; screenshot the render, never store a signed CDN URL; no image is stored,
only the derived observation; an image-derived fact must corroborate a textual one to render.
Demonstrated value: the blog said "music", the photo said *vinyl and vintage receivers*.

**R-032** `[proposal]` **Do Not Brief.** A member may opt out of recognition. Their card renders
name and role only — no dossier, no matches, no score computed either way — and they are removed
from *other* members' rooms, because a one-way opt-out is not an opt-out. Honoured at scoring time.
Deletion is a real purge (`ON DELETE CASCADE`), not a hidden flag that reinstates.
*(Oracle OPERA's Incognito mode is the only comparable that ships this; AUD-LINE-19.)*

## 6. The card

**R-033** `[source]` **250–350 words.** The declassified PDB of 3 Sep 1968 is 5 items / ~265 words /
~87s aloud; Brysbaert (2019, 190 studies) puts adult silent reading at 175–300 wpm and the slow end
binds, because the host is standing and watching a door. Outside the band is a hard gate failure.

**R-034** `[source]` **Five ordered bare-noun blocks**, no summary, no transitions:
`Who` (name + one borrowed attributed line, plus a phonetic respelling when the name is not obvious
— NPR convention, `[EL-suh]`) · `Now` · `Room` · `Notice` (the deep cut) · `Say`.

**R-035** `[source]` The card **ends on a sayable line, not a fact** — SBAR's Recommendation slot.
*(G-009)*

**R-036** `[decided, DEC-2]` **Reason first, score small.** No product ships both a score and its
reasoning; relationship CRMs hide the reasoning, event matchmakers hide the score.

**R-037** `[source]` The reason names **only signals that actually fired**. *(G-020)*

**R-038** `[proposal]` **One primary introduction, one backup. Everyone else collapses.** Candidates
below the floor appear only as `not_named` with a reason.

**R-039** `[proposal]` The intro is a **name-drop, never an instruction** — *"Eric Ries is here; his
new book is about exactly the incentive problem you've been working on"*, not *"go talk to Eric."*
Members are not routed.

**R-040** `[source]` **Recency has three states, not two:** `active` · `quiet` (every source
reached, genuinely nothing) · `unknown` (a source was unreachable). **Only `quiet` may state
silence.** One unreached source downgrades to `unknown` — absence of evidence from a source you
could not read is not evidence of absence. Ries looked dormant and had shipped a book that month;
staleness was a retrieval artifact. Tavel's Aug-2026 podcast is a **rerun** of an Apr-2025 recording
and must be dated by recording. *(G-013, G-014)*

**R-041** `[proposal]` A **thin profile emits fewer facts**, sets `non_obvious_fact_id: null`, and
fabricates nothing. Kopelman is the thinnest of the ten.

**R-042** `[proposal]` The card is a **staff instrument**, never member-visible. The Battery's
charter already forbids members using presence features to watch each other.

## 7. Surfaces

`wireframes.html` · `ui-states.md`.

**R-043** `[decided]` Mobile-first, no login. One primary surface (the card), plus **Why-this-score**
(one tap) and **Room**.

**R-044** `[proposal]` **Room is positional, not a list** — a host needs to know where the named
person actually is in order to point.

**R-045** `[source]` States every surface must define: ready · no-strong-match · cold trail ·
**unknown coverage** · empty room · ingesting · withheld · ambiguous · not-found · thin profile.

**R-046** `[proposal]` **Why-this-score** shows fired signals with weights, signals that did *not*
fire and why, excluded generic topics, and the reverse-direction score.

**R-047** `[proposal]` **Retry never relaxes a gate.** The obvious implementation is
re-render-until-pass, which converts a hard gate into a retry loop.

## 8. Architecture and storage

**R-048** `[decided]` **Ingest** (offline, authenticated, slow) → SQLite with provenance on every
row. **Arrival** (online, fast) reads the frozen file: `external_calls: []`.

**R-049** `[proposal]` **Graph shape, relational store.** No operation traverses more than one hop;
inner-circle expansion is an ingest-time walk that writes facts back onto the member. The SQLite
file *is* the cache DEC-3 requires — the ingest/serve split becomes a file copy.

**R-050** `[proposal]` **Deterministic:** resolution, scoring, buckets, ranking, floor, disclosure.
**Probabilistic:** fact extraction at ingest, prose at compose. The boundary is enforced by the
fixtures — no golden test asserts model prose, and no model output changes a score. The narrator is
an injected seam at both points; temperature 0.

**R-051** `[proposal]` Facts are **append-only** (supersede, never UPDATE) and every row names its
`run_id`, so a re-scrape is diffable and *"what did the card say on Friday, and why"* is answerable.

## 9. Demo and deliverables

**R-052** `[source]` Ship: a live URL, the repo, and one paragraph on what to build next with a
month and real member data.

**R-053** `[decided, DEC-3]` **Ten cached + one live re-run.** The on-stage run exercises **GREEN
adapters only**, so it cannot fail on a dead session. SESSION adapters are **absent from the runtime
registry**; G-015 is defence-in-depth, not the mechanism. *(fixes P0-4)*

**R-054** `[proposal]` The repo records **hours spent** against a visible cut line — RUBRIC-1 scores
*"in how many hours"* and needs a number.

## 10. Risks and open defects

`spec-review-01.md` holds the full review (8 P0 / 15 P1 / 11 P2). **P0-1, P0-2, P0-3, P0-4 and P0-6
are resolved above.** Three remain, all fixture defects:

| id | defect | fix |
|---|---|---|
| P0-5 | "never member-visible" has no enforcement: no auth + public URL + ten real named people | unguessable URL + `noindex`; accepted risk, stated |
| P0-7 | `word_count` is handed to fixtures, not derived (circular) | fixtures supply block text; the runner counts |
| P0-8 | fixtures assign contradictory attributes to one member id (`m_ries` 3 vs 4) | derive the cast from `db/vocabulary.sql`; do not edit expectations |

| # | risk | standing |
|---|---|---|
| K-1 | SESSION adapters breach platform ToS; enforcement is account-level on the **operator's** account | raised, accepted (DEC-6) |
| K-2 | Facebook / TikTok yields UNVERIFIED | measure before claiming |
| K-3 | Session data is not reproducible by Arena Hall from another account | mitigated by DEC-7; residual |
| K-4 | Provenance is structural (R-025); **the family half is a prompt instruction, not a mechanism** | accepted by decision (DEC-9) |
| K-5 | AUD-EDGES incomplete — Kopelman has no retrievable first-person archive; feld.com's search index is unqueryable | never assert `no_edge_confirmed` where the corpus was not searched |
| K-6 | **None of the ten are in Texas.** The brief's "same city" is false as written | harmless for scoring; noted so it is not mistaken for a modelling assumption |

## 11. Index

Thesis R-001–004 · Sourcing R-005–011 · Identity R-012–015 · Scoring R-016–023 ·
Disclosure R-024–032 · Card R-033–042 · Surfaces R-043–047 · Architecture R-048–051 ·
Demo R-052–054 · Risks R-055 n/a.
