# THE ARRIVAL ENGINE — PRD

**Implementation contract:** this PRD defines required product behaviour. The companion documents
below own the named domain details; golden fixtures are executable acceptance examples for the
behaviours they explicitly cover. For the same behaviour, precedence is: an explicit §10 defect or
exception → a covering golden fixture → the named domain authority → this PRD's summary. A fixture
does not override an unrelated numbered requirement.

### Implementation sources and references

| file | authority over | read it before |
|---|---|---|
| `eval/golden/*.json` | executable acceptance examples for the behaviours they cover | implementing or changing covered behaviour |
| `docs/scoring-model.md` | the scoring oracle: signals, buckets, gates, threshold, ties | scoring, ranking, Room |
| **`docs/ingest-spec.md`** | **the fetch contract: who may be collected, from where, how identity is confirmed, what a run must write** | **any scraper, adapter or ingest prompt** |
| **`docs/ingest-prompts/`** | **ten ready-to-hand-off collection prompts, one per member, plus `00-COMMON.md` (rules, auth protocol, write contract)** | **running the first ingest** |
| **`db/roster.sql`** | **the canonical cast — the ten, their allow-listed sources, the measured deny-list, supplied-vs-current labels** | **any ingest or resolution work** |
| `db/schema.sql` | storage, and the gates enforced as views (`v_renderable_fact`, `v_recency_state`, `v_collectable_source`) | any persistence work |
| `db/vocabulary.sql` | controlled vocabulary; the measured `discriminating` flag | scoring, topic work |
| `docs/knowledge-graph.md` | node and edge types, which signal each feeds | edge and traversal work |
| `docs/wireframes.html` + `docs/ui-states.md` | every screen state | any surface work |
| `docs/audit/01–07` | measured evidence, not normative product behaviour | checking the evidence behind a number or claim |
| `docs/decisions/DECISIONS.md` | settled decision history, not a second requirements document | changing or challenging an established policy |
| `docs/spec-review-01.md` | historical adversarial review, not a source of truth; only defects retained in §10 remain active | investigating the origin of an active defect |
| `docs/architecture.excalidraw` | non-normative pipeline overview; current contracts above win | orientation only |

---

## 1. Thesis

**R-001** A webhook fires with a name and one or two identifying details. A host has
~90 seconds between the door and the handshake. No facial recognition, no CV — arrival is solved.
The endpoint accepts events only from its configured arrival system over an authenticated,
integrity-checked and replay-protected channel; malformed or unknown identities are rejected before
profile or Room data is read.

**R-002** The failure mode is not incompleteness, it is creepiness. *"A member who feels
SEEN renews and brings friends. A member who feels DOSSIERED quits and tells people why."*

**R-003** The shippable test, from a working maître d': **would the member be pleased
to read this card over the host's shoulder?** (AUD-LINE-14.)

**R-004** **The engine must never assert what it merely failed to observe.** Every
defect the audit found was a variant of this: the `@spez` collision, the operator's graph leaking
into member profiles, the wrong Fred Wilson in a tagged post, "Ries is dormant" the month he
shipped a book. Every gate below exists to enforce it.

## 2. Sourcing

**R-005** Sources are tiered by **measured** access. Audit 04 tested logged-out; audit 07
tested a logged-in session. The per-source fetch contract — user-agent, keys, rate limits, the
measured retrieval traps, and what every run must write — is `docs/ingest-spec.md`; it is normative
for ingest and this table is its summary. Credentials remain operator-local, enter through an
approved secret store or environment injection, and are never written to the repo, prompts, SQLite
file, source URLs, reports, logs or deployed profile cache.

| Tier | Sources | Runs |
|---|---|---|
| **GREEN** | blog RSS full-text, HN Algolia, SEC EDGAR, Wikipedia, Wayback, YouTube transcripts, podcast RSS, Open Library | anywhere, incl. deployed |
| **METERED** | X API | anywhere, costs money |
| **SESSION** | LinkedIn, X, Instagram (measured working); Facebook, TikTok (UNVERIFIED) | ingest only, **never deployed** |

**R-006** Build the relational layer for inner-circle, tagged-associate, and follow-graph evidence.
Audit 07 confirmed that authenticated LinkedIn returns full post bodies and tagged people, X's
follow list is available through the accessibility tree, and Instagram captions yield places and
pursuits. *(DEC-1, DEC-6)*

**R-007** **Read-only, structurally.** No write operation exists in the adapter
interface, so posting, liking or following is unreachable by bug, retry or injected instruction.
*(DEC-6; B-018, consolidated in G-029)*

**R-008** No captcha or bot-detection evasion, at any tier. Human pace.

**R-009** Personalized strings are stripped at the adapter boundary against a
**whitelist**. "Followed by Sam Altman", "3rd degree", "5 others you know" are facts about the
*operator*. The whitelist is enumerated per platform in `ingest-spec.md` §6.3 — MAY-extract and
MUST-NOT-extract, both lists closed. *(DEC-7; G-029)*

**R-010** **Source precedence on contradiction:** the member's own words > their organisation's >
the follow graph > press. A lower-precedence source never overrides a higher one. This evidence
ordering is independent of the GREEN / METERED / SESSION access tiers in R-005.

**R-011** An unavailable source reports unavailability and returns empty — never
backfilled from a snippet or a model. A session expiring mid-ingest yields a profile **marked
partial**. *(B-010/B-017, G-027)*

## 3. Identity and staleness

**R-012** Resolution requires **corroboration**; a handle match is not identity.
`spez` on Reddit is Huffman; `@spez` on X is a stranger with 103 followers. *(G-016)*
Corroboration kinds, their strengths and the acceptance rule (**≥1 STRONG, or ≥2 WEAK from
different sources; never `handle_matches` alone**) are seeded in `corroboration_kind` and stated in
`ingest-spec.md` §3.3.

**R-013** Count candidates only after applying R-012 corroboration. Zero corroborated candidates →
`not_found`. Exactly one living corroborated candidate → `resolved`. Two or more corroborated
candidates → **`ambiguous`: show the chooser, emit no brief.** Any otherwise-resolvable candidate
marked **deceased** also yields `ambiguous` and no brief — "Nabeel Qureshi" resolves to the writer
and to an apologist who died in 2017. Briefing on a dead man is the worst available failure.

**R-014** **The supplied label is a hint to verify, never a fact to echo.** The brief's
own roster is stale for several of the ten: Shear runs **Softmax**, not Twitch. A host who opens
with *"so, Twitch…"* has damaged the relationship before the handshake. Supplied and measured labels
for all ten are in `member_label` (`db/roster.sql`); Shear is the one row flagged `stale`. Keying on
"Twitch" also loses his strongest edge — the YC S2005 tie is Kiko↔Reddit, not Twitch↔Reddit.

**R-015** The brief emits `label_correction {supplied, current, stale}`. When stale,
the card shows it explicitly — *"the door said Twitch; it's Softmax now"* — because the host may
have already read the door.

## 4. Scoring

Oracle: `scoring-model.md`. Directional: `score(A→B)` ≠ `score(B→A)`.

**R-016** Weights bucket to exactly three values — SMALL 1, MID 2, LARGE 3. A signal
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

**R-017** S2 and S3 are mutually exclusive, so the ceiling is **16**.

**R-018** **S8 cannot create a match.** The surfacing threshold is evaluated on the
score **excluding S8**; S8 affects display and ranking only. Prominence breaks ties, never makes
them. Without this the engine sends everyone to the most famous person present — *selection*, the
Fleming failure, not service.

**R-019** **Genericity is a property of the vocabulary, not the room.** A topic is
excluded from S3/S6/S7 when `holder_count / base_size ≥ 0.40`, measured once over the member base
and stored in `topic.discriminating`. `venture-capital-craft` is held by 5 of 10 and is excluded.
The prior room-statistic version was non-monotonic, room-size-inverted, and failed on its own
justifying case. The mechanism is in `db/vocabulary.sql`.

**R-020** **Introduction floor = 6**, and at least one of S3/S5/S7 must have fired.
Demographics alone is not a reason to interrupt someone. Below the floor **nobody is named** — not
as primary, not as backup.

**R-021** Ties break by LARGE-signal count, then evidence recency, then id. *(G-017)*

**R-022** **Brokering mode** uses the S8-excluded surfacing scores from R-018, in precedence order:
`mutual` when both directions meet the floor → `broker` when exactly one direction meets the floor
and the absolute score gap is ≥6 → `light_touch` otherwise. It changes what the host physically
does — mutual means introduce and step away; broker means stay and carry the reason across.

**R-023** Every fired signal carries a one-line `evidence` string naming why it fired.
That is what makes the number arguable rather than oracular.

## 5. Disclosure

**R-024** Any public source may contribute a deep-cut candidate, but public availability is not
permission to render. A fact is eligible only when its source is shown and it passes the trust,
suppression and narrator rules below. The provenance chip is mandatory, but never sufficient on
its own. *(DEC-4)*

**R-025** **A fact with no source cannot render.** An **inferred** fact must name what it
was composed from. Enforced in the store by `v_renderable_fact`, not by care.
*(B-007/B-008, consolidated in G-034)*

**R-026** **`trust_class` is independent of provenance:** `subject_authored` /
`publisher` / `third_party_open`. Instagram's tagged tab is written by **other people** — its first
item names the wrong Fred Wilson (the conceptual artist). `third_party_open` content is never
attributed without corroboration, never rendered, and never concatenated into a model prompt as
fact. It is a traversal hint only. *(AUD-07-7 — an injection surface, measured)*

**R-027** Family facts are governed by a **compose-time narrator judgement, not a structural gate.**
Family *organisations* and inherited context may render. Fixtures can assert the recorded
judgement and output shape, but cannot prove social suitability. This leaves an accepted residual
risk: in the Target and Meyer cases, the person harmed was not the subject. *(DEC-9; AUD-LINE-6)*

**R-028** **The suppression counter.** The card shows withheld facts as **class and
count only** — *"2 withheld: finance, family"* — never content. It proves restraint without
leaking, and it is the visible answer to *"what did you choose to leave out."*

**R-029** The worked example: **Huffman's SEC Form 4 share sales are public, filed and
verified — and suppressed.** A host who mentions them has ended the relationship.

**R-030** The compose-time narrator may only **rephrase retrieved facts, never add facts.** A
hallucinated fact read aloud to a founder is unrecoverable in the room.

**R-031** **Image analysis is in scope; face recognition is not.** The brief's
exclusion is scoped to arrival detection. In: scene, object, activity, venue, text-in-image. Out
permanently: face recognition, matching, clustering, or inference from a face. Only
subject-published images; screenshot the render, never store a signed CDN URL; no image is stored,
only the derived observation; an image-derived fact must corroborate a textual one to render.
Demonstrated value: the blog said "music", the photo said *vinyl and vintage receivers*. *(DEC-8)*

**R-032** **Do Not Brief.** A member may opt out of recognition. Their card renders
name and role only — no dossier, no matches, no score computed either way — and they are removed
from *other* members' rooms, because a one-way opt-out is not an opt-out. Honoured at scoring time.
For this deliverable, an operator records a verified request in `member_flags`; member self-service
is out of scope. Deletion is a real purge (`ON DELETE CASCADE`), not a hidden flag that reinstates.
The purge workflow also removes generated cards and replaces any deployed snapshot containing the
member before reporting completion.

## 6. The card

**R-033** A full card is **250–350 words**; outside the band is a hard gate failure. The declassified
PDB of 3 Sep 1968 is 5 items / ~265 words / ~87s aloud; Brysbaert (2019, 190 studies) puts adult
silent reading at 175–300 wpm and the slow end binds, because the host is standing and watching a
door. Do Not Brief, `not_found`, gate-withheld and other non-card responses are degraded states and
are exempt from the band; they are never padded. A thin profile attempts a full card without
fabrication and falls back to its withheld greeting when the available evidence cannot support one.

**R-034** A full card has **five ordered bare-noun blocks**, no summary, no transitions:
`Who` (name + one borrowed attributed line, plus `person.name_respelling` when present; the narrator
never invents a pronunciation) · `Now` · `Room` · `Notice` (the deep cut) · `Say`.

**R-035** The card **ends on a sayable line, not a fact** — SBAR's Recommendation slot.
*(B-006, G-022)*

**R-036** **Reason first, score small.** *(DEC-2)*

**R-037** The reason names **only signals that actually fired**. *(G-020)*

**R-038** **One primary introduction, one backup. Everyone else collapses.** Candidates
below the floor appear only as `not_named` with a reason.

**R-039** The intro is a **name-drop, never an instruction** — *"Eric Ries is here; his
new book is about exactly the incentive problem you've been working on"*, not *"go talk to Eric."*
Members are not routed.

**R-040** **Recency has three states, not two:** `active` · `quiet` (every source
reached, genuinely nothing) · `unknown` (a source was unreachable). **Only `quiet` may state
silence.** One unreached source downgrades to `unknown` — absence of evidence from a source you
could not read is not evidence of absence. Ries looked dormant and had shipped a book that month;
staleness was a retrieval artifact. Tavel's Aug-2026 podcast is a **rerun** of an Apr-2025 recording
and must be dated by recording. *(B-009/B-021, G-014/G-033)*

**R-041** A **thin profile emits fewer facts**, sets `non_obvious_fact_id: null`, and
fabricates nothing. Kopelman is the thinnest of the ten.

**R-042** The card is a **staff-intended instrument** and is never linked from a member-facing
surface. For this no-login deliverable, an unguessable URL and `noindex` mitigate discovery but do
not guarantee access control; this is the accepted P0-5 risk in §10. The Battery's charter already
forbids members using presence features to watch each other.

## 7. Surfaces

`wireframes.html` · `ui-states.md`.

**R-043** Mobile-first. This demo has no login; its unguessable URL and `noindex` are discovery
mitigations, not access control. One primary surface (the card), plus **Why-this-score** (one tap)
and **Room**.

**R-044** **Room is the current-presence list**, ordered by `arrived_at`, with each member's name and
arrival time plus simulate-arrival and mark-departed controls. Physical position is not tracked in
this deliverable.

**R-045** Across the product, every applicable state must have a defined surface: ready ·
no-strong-match · cold trail · **unknown coverage** · empty room · ingesting · withheld · ambiguous
· not-found · thin profile. `docs/ui-states.md` assigns each state to its surfaces and defines its
trigger, content, actions and exit.

**R-046** **Why-this-score** shows fired signals with weights, signals that did *not*
fire and why, excluded generic topics, and the reverse-direction score.

**R-047** **Retry never relaxes a gate.** The obvious implementation is
re-render-until-pass, which converts a hard gate into a retry loop.

## 8. Architecture and storage

**R-048** **Ingest** (offline, authenticated, slow) → SQLite with provenance on every
row. **Arrival** (online, fast) reads the frozen file and makes no source-adapter calls. The injected
narrator is its only permitted external dependency; if unavailable, the card degrades to a
deterministic withheld greeting. The SQLite file is a sensitive server-side artifact: it is absent
from version control and public static assets, opened read-only by the runtime, and readable only by
the runtime identity. Runtime logs contain identifiers and statuses, never fact text or credentials.

**R-049** **Graph shape, relational store.** No operation traverses more than one hop;
inner-circle expansion is an ingest-time walk that writes facts back onto the member. The SQLite
file *is* the cache DEC-3 requires — the ingest/serve split becomes a file copy.

**R-050** **Deterministic:** resolution, scoring, buckets, ranking, floor, provenance and trust
gates, suppression class, and opt-out. **Probabilistic:** fact extraction at ingest and prose at
compose, including the DEC-9 judgement about whether an otherwise eligible family fact is suitable.
No model output changes identity, score, ranking, a structural render gate, suppression class or
opt-out. Retrieved text is untrusted data, never instructions; the narrator has no tools or network
authority and receives only render-eligible structured facts. The narrator is an injected seam at
both points at temperature 0. Goldens assert decisions and output structure, not exact prose.

**R-051** Facts are **append-only** (supersede, never UPDATE) and every row names its
`run_id`, so a re-scrape is diffable and *"what did the card say on Friday, and why"* is answerable.

## 9. Demo and deliverables

**R-052** Ship: a live URL, the repo, and one paragraph on what to build next with a
month and real member data.

**R-053** **Ten cached + one live re-run.** The on-stage run exercises **GREEN
adapters only**, so it cannot fail on a dead session. SESSION adapters are **absent from the runtime
registry**; G-027 pins the deployed registry to non-SESSION adapters while also covering the
operator-side partial-profile failure. *(DEC-3; B-010)*

**R-054** The repo records **hours spent** against a visible cut line — RUBRIC-1 scores
*"in how many hours"* and needs a number.

## 10. Risks and open defects

These are the tracked implementation defects inherited from the historical review. Resolved findings
remain in `docs/spec-review-01.md` and `docs/decisions/DECISIONS.md`. Three defects remain:

| id | defect | fix |
|---|---|---|
| P0-5 | "never member-visible" has no enforcement: no auth + public URL + ten real named people | unguessable URL + `noindex`; accepted risk, stated |
| P0-7 | `word_count` is handed to fixtures, not derived (circular) | fixtures supply block text; the runner counts |
| P0-9 | **G-017 carries `m_shear` as `founder`; the canonical cast says `chief-executive`** (measured: `x.com/eshear` og:description, "CEO of Softmax"). Correcting it kills S1 and drops him 6→4, destroying the tie the fixture exists to test | re-ground after the first ingest run, against the real edges in AUD-06 (E13b Walk/Ries co-curated *Uncensored* 2012; E10b Walk→Kopelman). A search over all ten members × all pairs found **no** equal-score tie in the real attribute space, because `context` and `edge` are not seeded yet. Also depends on `board-games` (K-8) |

| # | risk | standing |
|---|---|---|
| K-1 | SESSION adapters breach platform ToS; enforcement is account-level on the **operator's** account | raised, accepted (DEC-6) |
| K-2 | Facebook / TikTok yields UNVERIFIED | measure before claiming |
| K-3 | Session data is not reproducible by Arena Hall from another account | mitigated by DEC-7; residual |
| K-4 | Provenance is structural (R-025); **the family half is a prompt instruction, not a mechanism** | accepted by decision (DEC-9) |
| K-5 | AUD-EDGES incomplete — Kopelman's retrievable first-person archive ends in 2014; feld.com's Pagefind index is unqueryable | never assert `no_edge_confirmed` where the corpus was not searched |
| K-6 | **None of the ten are in Texas.** The brief's "same city" is false as written | harmless for scoring; noted so it is not mistaken for a modelling assumption |
| K-8 | `board-games` is a G-017 placeholder with **no audit backing**, so `db/roster.sql` assigns it to nobody | source it or delete it and re-baseline G-017 |
| K-9 | **Prominence mixes platforms.** Perkins reaches tier 4 on a LinkedIn figure (370,639) while the other nine are ranked on X; her X is 56,591, which alone is tier 3 | tiers are computed once at ingest and frozen into the file, so this is sound at runtime — but a LinkedIn follower is not the same unit as an X follower, and the ranking is only as even as the platforms actually measured |
| K-10 | **Huffman has no measurable prominence on any GREEN source.** `x.com/spez` is a stranger, `@stevehuffman` has 38 followers, `@shuffman` has 4; Reddit is closed to logged-out reads | tier is NULL, so S8 is silent in both directions for him — correct, not a gap to paper over. Obtainable from SESSION LinkedIn `/in/shuffman`, the same source that produced Perkins' figure |

## 11. Implementation contract

**R-055** **The cast is closed and it is a table.** The ten are seeded in
`db/roster.sql`; `person.is_member = 1` is the complete membership. There is no discovery step that
adds an eleventh member. People reached by traversal enter as `is_member = 0`, exist only so their
edges are traversable, and are never scored and never surfaced.

**R-056** **Collection is allow-listed, and refusal is by table.** An adapter may fetch
a `(person, source)` pair only if `person_identity` holds a row for it, and must refuse any URL,
handle or domain matching `person_identity_negative`; every seeded row records a fetch that reached
the wrong person. Matching is by value across all ten, because the failure being prevented is
cross-attribution. **A 200 is not identity confirmation:** `eshear.com` returns 200 on every path it
is asked for, `wikipedia.org/wiki/Nabeel_Qureshi` is a man who died in 2017, and
`youtube.com/feeds/videos.xml?user=canva` returns valid XML from an unrelated channel.

**R-057** **The inner-circle walk is exactly one hop**, and is an ingest-time walk that
writes facts back onto the member. There is no hop 2. Unbounded, a follow-graph walk from Wilson's
1,345 follows collects strangers indefinitely — a privacy failure before it is a compute one.
Per-member crawl budget, stop conditions and the deep-cut-is-search rule: `ingest-spec.md` §9.

**R-058** **Every attempt is recorded, not every success.** `source_status` takes a row
per `(person, source, run)` — `ok` / `unavailable` / `skipped`, with `http_code` and `fact_count`.
It is the only thing that distinguishes `quiet` from `unknown` (R-040). A 200 with zero items is not
silence: `feeds.feedburner.com/redeyevc` is a live feed with no items since 2019.

## 12. Index

Thesis R-001–004 · Sourcing R-005–011 · Identity R-012–015 · Scoring R-016–023 ·
Disclosure R-024–032 · Card R-033–042 · Surfaces R-043–047 · Architecture R-048–051 ·
Demo R-052–054 · **Implementation R-055–058 (§11)**. Risks are K-1–K-10, not R-numbered.
