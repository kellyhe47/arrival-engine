# THE ARRIVAL ENGINE — PRD

**Implementation contract:** this PRD defines required product behaviour. The companion documents
below own the named domain details; golden fixtures are executable acceptance examples for the
behaviours they explicitly cover. For the same behaviour, precedence is: an explicit §10 defect or
exception → a covering golden fixture → the named domain authority → this PRD's summary. A fixture
does not override an unrelated numbered requirement.

> **Re-baseline (2026-09-04).** The clickable prototype `Arrival-Engine-Prototype.html` (repo root)
> supersedes the previous §4 scoring model and the §6/§7 card and surface behaviour. It changes
> requirements, not just design: a new signal set with S9 and an intent taxonomy, a restructured
> card with outcome logging, table seating on Room, and a How-the-score-works reference screen.
> `docs/scoring-model.md`, `docs/wireframes.html`, `docs/ui-states.md`, `db/vocabulary.sql`'s signal
> references and the golden fixtures have **not** yet been re-synced; until they are, §§4, 6 and 7
> of this PRD are the authority for the behaviours they state, the precedence table notwithstanding.

### Implementation sources and references

| file | authority over | read it before |
|---|---|---|
| `eval/golden/*.json` | executable acceptance examples for the behaviours they cover | implementing or changing covered behaviour |
| **`Arrival-Engine-Prototype.html`** | **the clickable prototype this PRD was re-baselined against (2026-09-04)** | **any surface, card or scoring work** |
| `docs/scoring-model.md` | the scoring oracle: signals, buckets, gates, threshold, ties — **stale, pending re-sync to §4** | scoring, ranking, Room |
| **`docs/ingest-spec.md`** | **the fetch contract: who may be collected, from where, how identity is confirmed, what a run must write** | **any scraper, adapter or ingest prompt** |
| **`docs/IMPLEMENTATION-PROMPT.md`** | **the ordered build brief: stack decision, build order, defects to close, definition of done** | **building the application** |
| **`docs/ingest-prompts/`** | **ten ready-to-hand-off collection prompts, one per member, plus `00-COMMON.md` (rules, auth protocol, write contract)** | **running the first ingest** |
| **`db/roster.sql`** | **the canonical cast — the ten, their allow-listed sources, the measured deny-list, supplied-vs-current labels** | **any ingest or resolution work** |
| `db/schema.sql` | storage, and the gates enforced as views (`v_renderable_fact`, `v_recency_state`, `v_collectable_source`) | any persistence work |
| `db/vocabulary.sql` | controlled vocabulary; the measured `discriminating` flag | scoring, topic work |
| `docs/knowledge-graph.md` | node and edge types, which signal each feeds | edge and traversal work |
| `docs/wireframes.html` + `docs/ui-states.md` | every screen state | any surface work |
| `docs/audit/01–07` | measured evidence, not normative product behaviour | checking the evidence behind a number or claim |
| `docs/decisions/DECISIONS.md` | settled decision history, not a second requirements document | changing or challenging an established policy |
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
| **SESSION** | LinkedIn, X, Instagram (measured working); Facebook, TikTok (attempted, still UNVERIFIED) | ingest only, **never deployed** |

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

Oracle: `scoring-model.md` — **stale**; re-baselined 2026-09-04 against the prototype, and this
section is normative until that file is re-synced. Directional: `score(A→B)` ≠ `score(B→A)`.

**R-016** Weights bucket to exactly three values — SMALL 1, MID 2, LARGE 3. A signal
fires at full weight or not at all. The signal set is the prototype's:

| id | signal | w | directed |
|---|---|---|---|
| S1 | same industry, bucketed — establishes context, does not carry a match | 2 | |
| S2 | comparable seniority + career start in the same decade | 2 | |
| S3 | shared context — a place, institution or programme, measured | 3 | |
| S4 | overlapping organisation history | 1 | |
| S5 | shared professional topic held by both, generics excluded | 3 | |
| S6 | shared personal topic | 2 | |
| S7 | declared link — A cites, follows or has written about B | 3 | **✓** |
| S8 | status gradient | 1 | **✓** |
| S9 | intent complement — B has done what A is trying to do | 3 | **✓** |

> **Note on place.** Arena Hall is **in Austin, Texas** — measured from `arenahall.com`, whose own
> page title reads "Arena Hall — Austin, Texas" and whose hero is captioned "A private membership
> community in Austin, Texas." **None of the ten stand-ins are**; they are spread across New York,
> Boulder, Philadelphia, San Francisco and Sydney. So the venue's city is real and the *members'*
> shared-city assumption is not. S3 matches on **measured** shared place, institution or programme,
> never on an assumed geography — and never on "they are both at the club tonight", which is
> true of everyone in the room and therefore carries no information. *(was K-6)*

**R-017** The ceiling is **16** — the sum of S1–S7. S8 is outside the ceiling: it is tie-break and
display only (R-018). S9 is outside both the ceiling and the floor: it is added to the *displayed*
score only where the pair's intent class is complement (R-022a step 5). The old S2/S3
mutual-exclusion rule is retired with the old signal set.

**R-018** **S8 cannot create a match.** S8 fires only when B's prominence tier is strictly above
A's. The surfacing threshold is evaluated on the score **excluding S8**; S8 affects display and
ranking only. Prominence breaks ties, never makes them. Without this the engine sends everyone to
the most famous person present — *selection*, the Fleming failure, not service.

**R-019** **Genericity is a property of the vocabulary, not the room.** A topic is
excluded from the topic signals S5/S6 when `holder_count / base_size ≥ 0.40`, measured once over
the member base and stored in `topic.discriminating`. `venture-capital-craft` is held by 5 of 10
and is excluded. The test is ≥: a topic held by exactly 4 of 10 sits at the threshold and is
excluded. (The prototype's `artificial-intelligence` row illustrates that boundary; no such tag
exists in the stored vocabulary — three people hold three adjacent AI tags, deliberately unmerged.) Excluded topics are reported with their holder shares, not silently
dropped (they render on Why-this-score, R-046). The prior room-statistic version was
non-monotonic, room-size-inverted, and failed on its own justifying case. The mechanism is in
`db/vocabulary.sql`.

**R-020** **Introduction floor = 6**, evaluated on S1–S7 (S8 and S9 both excluded), and at least
one of S3/S5/S6/S7 must have fired — a shared context, topic, personal interest or declared link.
S1/S2/S4 are demographics, and demographics alone is not a reason to interrupt someone: the
measured miss is a 5 built on industry, seniority and org history with *"nothing personal, nothing
declared and nothing cited underneath it."* Below the floor **nobody is named** — not as primary,
not as backup.

**R-021** Ties break by LARGE-signal count, then evidence recency, then id. *(G-017)*

**R-022** **Intent.** Every member carries one intent for the evening, measured from evidence,
never assumed:

`I1` deploying capital · `I2` raising or being backed · `I3` building an institution ·
`I4` publishing a body of work · `I5` learning a domain · `I6` giving access ·
`I7` stepping back · `I8` being social — attendance without an agenda, **a finding, never a
residual** · `I0` unknown — coverage incomplete, **never read as I8**.

Every above-floor pair then takes an **intent class**, which drives ranking and the written
reason: **complement** (B has done what A is trying to do; S9 fires) · **parallel** (same pursuit;
S9 does not fire — two people deploying capital are parallel, not complementary) · **open** (either
side is I8; ranked on score alone) · **neutral** (no intent relation; score alone) · **unknown**
(either side is I0; score alone) · **guarded** (an intent asymmetry the host should know about;
ranked last, and the card names the asymmetry — **never suppressed**).

**R-022a** **Order of operations**, verbatim from the prototype's reference screen:

1. Score every pair in the room, both directions, S1–S8.
2. Drop everything below the floor (R-020).
3. Class every survivor. I8 on either side means open.
4. Rank: complement, then parallel, then open / neutral / unknown on score, guarded last.
5. Add S9 to the displayed score where the class is complement. The floor excludes it.
6. Write the reason from the intent, not the overlap.

The former `mutual` / `broker` / `light_touch` brokering machinery is retired. What the host
physically does is carried in card prose instead: `Who's here` states mutuality or its absence in
words backed by edges — *"Wilson cites him in public; no reverse edge was found across two
passes"*, *"Neither needs introducing to the other, so the host can leave them to it."*

**R-023** Every fired signal carries a one-line `evidence` string naming why it fired — and every
signal that did *not* fire carries a one-line reason why not, rendered on Why-this-score. That is
what makes the number arguable rather than oracular.

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

**R-027a** `[decided, DEC-12]` A fact reached by **traversing a `family_or_partner` edge renders on
its own merits — no corroboration gate.** Corroboration by a subject-sourced fact raises confidence
and is preferred, but its absence is not a bar: a shared household is real evidence of shared
activity, and a gate would discard the freshest signal on the members whose own output has gone
quiet. Two things stay restricted, and only two: **the edge never scores, and is never named on a
card.** One hard line remains — a source showing the *partner* did something is not observation that
the *member* did it, so that step is `provenance_class='inferred'` and must name `composed_from`
(R-025). Every traversed fact carries `via_edge_type` / `via_person_id`, so the class is countable
by the suppression counter, visible in Why-this-score, and reversible by policy without a re-ingest.

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

**R-032** **Deletion is a real purge.** `DELETE FROM person` cascades (`ON DELETE CASCADE`) —
facts, edges, contexts, roster rows and generated cards go with it. It is not a hidden flag that
reinstates, which is explicitly the opposite of OpenTable, where a suppressed profile comes back
with its notes intact. The purge workflow also replaces any deployed snapshot containing the member
before reporting completion.

**There is no opt-out, and there is deliberately no flag for one.** *(DEC-15)* Members are never
told this service exists. They are not asked, not notified, and given no surface on which to
express a preference about it — so nothing could have populated a "do not brief" column, and a card
explaining that a member *"has opted out of recognition"* described something that had never
happened. A dormant privacy control is worse than none, because it reads to a reviewer as a control
that exists. Removed from the schema, the scoring path and the card. Erasure on request is the
obligation that survives, and it is R-032 above.

## 6. The card

**R-033** A full card is **250–350 words**; outside the band is a hard gate failure. The declassified
PDB of 3 Sep 1968 is 5 items / ~265 words / ~87s aloud; Brysbaert (2019, 190 studies) puts adult
silent reading at 175–300 wpm and the slow end binds, because the host is standing and watching a
door. `not_found`, gate-withheld and other non-card responses are degraded states and
are exempt from the band; they are never padded. A thin profile attempts a full card without
fabrication and falls back to its withheld greeting when the available evidence cannot support one.

**R-034** A full card renders in **two layers**, bare-noun labels, no summary, no transitions.
The reading layer is three ordered blocks: `Who they are` (name + one borrowed attributed line,
plus `person.name_respelling` when present — the narrator never invents a pronunciation; the R-015
label correction renders here: *"The door said Foundry Group, Techstars, Boulder — Foundry is
right, the Techstars half is older than it reads"*) · `Who's here` (the match, then the rest of
the room answered in one or two short sentences — other above-floor pairings counted but never
named, everyone else in aggregate with the honest zero called out; never a roll call) ·
`Say this`. The rest of the brief collapses behind a single
control, in order: `The match` (one candidate and the score, the score itself a one-tap link to
Why-this-score) · `Sources` · `Recent activity` · `Personal detail` (the deep cut). The R-033 word
band is measured over the whole brief.

**R-035** The reading layer **ends on a sayable line, not a fact** — SBAR's Recommendation slot.
While the `Say this` block is less than ~40% visible in the scroll viewport, a one-line **Say
rail** pins the condensed line to the bottom edge of the card; it retires when the real block is on
screen rather than becoming permanent chrome over the primary action. *(B-006, G-022)*

**R-036** **Reason first, score small.** *(DEC-2)*

**R-037** The reason names **only signals that actually fired**. *(G-020)*

**R-038** **Exactly one candidate is named.** `The match` names one member and one score; there is
no ranked backup slot. Other present members appear in `Who's here` prose only when something true
is measured about them — *"Melanie Perkins is also present; nothing is measured between them."*
Below the floor nobody is named and the match block reports the miss honestly with the number —
*"Top score, no candidate named · 5 · needs 6."*

**R-039** The intro is a **name-drop, never an instruction** — *"Eric Ries is here; his
new book is about exactly the incentive problem you've been working on"*, not *"go talk to Eric."*
Members are not routed.

**R-040** **Recency has three states, not two:** `active` · `quiet` (every source
reached, genuinely nothing) · `unknown` (a source was unreachable). **Only `quiet` may state
silence.** One unreached source downgrades to `unknown` — absence of evidence from a source you
could not read is not evidence of absence. Ries looked dormant and had shipped a book that month;
staleness was a retrieval artifact. Tavel's Aug-2026 podcast is a **rerun** of an Apr-2025 recording
and must be dated by recording. *(B-009/B-021, G-014/G-033)* When coverage is `unknown`, `Recent
activity` carries a coverage block: **"Reached N of M sources"**, the unread source with its
failure code (*"wayback · http_503"*), and the sentence that no claim is made about silence in
either direction.

**R-041** A **thin profile emits fewer facts**, sets `non_obvious_fact_id: null`, and
fabricates nothing. Kopelman is the thinnest of the ten.

**R-042** The card is a **staff-intended instrument** and is never linked from a member-facing
surface. For this no-login deliverable there is no access control and, since DEC-14, no path
obscurity either; `noindex` and the robots disallow keep it out of search results and nothing keeps
anyone out. This is the accepted P0-5 risk in §10. The Battery's charter already
forbids members using presence features to watch each other.

**R-060** `[new, prototype 2026-09-04]` **The card closes the loop.** Every card ends with an
outcome capture: a free-text observation field (*"what did you observe about the interaction?"*)
and five outcome chips — `Never introduced` · `Brief hello` · `Talked a while` · `Together all
night` · `Swapped details` — with a single log action. The outcome is stored append-only against
that introduction (pair, direction, run), because the only proof the introduction worked is what
happened next. Logging is optional and never blocks any other behaviour.

**R-061** `[new, prototype 2026-09-04]` **A degraded state is an answer, not a shortened happy
path.** The withheld card emits exactly: `Who they are` as a single line, the failure notice
(*"a hard gate failed, so the brief is withheld — this degrades to a greeting, never to a
guess"*), a **gate table** listing each failed gate with observed and allowed values (*"Word count
in band · 372 · 250–350"*, *"Reason cites fired only · S8 · S1, S2, S5"*), the note that retry
re-runs render only, and the `Say` greeting. Nothing else of the BRIEF renders — no Sources with
em-dashes, no Personal detail whose content is that there is no content. A section that says
nothing IS padding, the exact failure this state exists to avoid. The one exception is R-060's
outcome capture, which still closes the card (as it does in the prototype): it grades the
greeting, not the brief.

## 7. Surfaces

`wireframes.html` · `ui-states.md`.

**R-043** Mobile-first. This demo has no login and, since DEC-14, no unguessable path; `noindex`
and the robots disallow are search-visibility controls, not access control. One primary surface
(the card), plus **Why-this-score** (one tap from any rendered score), **Room**, and
**How-the-score-works** — a staff reference screen reachable from Room's footer and from
Why-this-score, carrying the signal table, the intent taxonomy, the intent classes and the order
of operations (R-016/R-022/R-022a) verbatim.

**R-044** **Room is the current-presence list**, ordered by `arrived_at`, each row a member's name
(tap → their card) and arrival time, plus simulate-arrival and mark-departed controls. Physical
position is not tracked in this deliverable. An **empty room is a correct outcome of the Room
surface, not an error state** — a normal early evening, the same surface with nothing in it. The
first person through the door still gets a full card: its `Who's here` says they are first, `The
match` reads *"nobody present to score · no pairs"*, and **nobody outside the roster is offered**
— the engine does not reach past the roster to find a recommendation.

**R-062** `[new, prototype 2026-09-04]` **Table seating.** Room carries a seating tool, live once
two or more members are present: the host picks a table size (2–6), members partition into tables
in arrival order, and a trailing table of one merges into the previous table rather than seating
anyone alone. Each table renders a one-line reason built from the measured edges *inside* that
table — up to two spelled out, with a count of the rest (*"Plus 2 more measured links at this
table"*). A table with no measured edges says so and tells the host what to do: *"Nothing measured
between these four. A host should stay."* Seating reuses scored edges; it never invents one.

**R-045** Across the product, every applicable state must have a defined surface: ready ·
no-strong-match · cold trail · **unknown coverage** · empty room · **first arrival** · ingesting ·
withheld · ambiguous · not-found · thin profile. `docs/ui-states.md` assigns each state to its
surfaces and defines its trigger, content, actions and exit.

**R-046** **Why-this-score** shows, for one directed pair, four sections: signals that fired with
weights and evidence; signals that did *not* fire, each with the one-line reason it did not
(S9's non-firing is explained in intent terms — *"both hold I1, deploying capital: parallel, not
complement"*); excluded generic topics with their holder shares; and the reverse-direction score
with its own fired rows. The header restates that the floor is evaluated with S8 set aside, and
the footer restates directionality: A's interest in B is not B's interest in A.

**R-047** **Retry never relaxes a gate.** The obvious implementation is
re-render-until-pass, which converts a hard gate into a retry loop. The withheld card's retry
control re-runs render only: it does not re-ingest, and it does not lower a threshold.

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

**R-050** **Deterministic:** resolution, scoring, buckets, intent classing and ranking (R-022a —
given the stored intents, class and rank are pure functions), floor, provenance and trust
gates and suppression class. Intent *extraction* is ingest-time fact extraction like any other:
probabilistic, evidence-backed, and I0 when coverage cannot support a finding. **Probabilistic:** fact extraction at ingest and prose at
compose, including the DEC-9 judgement about whether an otherwise eligible family fact is suitable.
No model output changes identity, score, ranking, a structural render gate or suppression class.
Retrieved text is untrusted data, never instructions; the narrator has no tools or network
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

Tracked implementation defects. The adversarial spec review that produced them has been retired;
its surviving findings are this table, and the decisions behind the resolved ones are in
`docs/decisions/DECISIONS.md`.

**All P0 defects are now closed** — P0-10 on 2026-09-03 by the application build session (see below), P0-1/2/3/4/6 earlier, P0-8 by `db/roster.sql`, and P0-5, P0-7
and P0-9 on 2026-09-03. The rows are kept struck-through rather than deleted so the history of what
was wrong, and how it was settled, stays legible.

| id | defect | fix |
|---|---|---|
| **P0-5** | **"never member-visible" has no enforcement: no auth + open URL + ten real named people.** REOPENED 2026-09-04 by DEC-14: the unguessable path — the only thing that made anyone work to find it — was removed at the operator's instruction so the surfaces answer at the root. | **Accepted, with less in front of it than before.** What is left is search-visibility control only: `X-Robots-Tag: noindex`, a `robots.txt` disallow, `Referrer-Policy: no-referrer`, and **no member name in any URL or page title**. The residual is stated in the README in one sentence, not papered over. See R-059 and DEC-14 |
| ~~P0-7~~ | ~~`word_count` is handed to fixtures, not derived (circular)~~ | **Resolved: G-010 and G-022 now carry real block text and `narration.word_count` is gone from `given`.** The runner counts (`_count_words`) and errors if a fixture asserts a count it cannot derive. Verified by tampering: changing the asserted count fails the check |
| **P0-10** | **G-022 asserted `score(m_feld -> m_wilson) = 11` including S8, and cited S8 in its Room block. S8 requires B's prominence tier strictly above A's; `db/roster.sql` measures both at tier 4 (640,845 and 388,685 followers), so it cannot fire. G-001 was re-baselined for exactly this on 2026-09-03; G-022 was the stale twin, and it survived because it passed `present_members` as bare ids, which `verify_fixtures.py` cannot re-derive** | **Resolved 2026-09-03: spec and fixture fixed together.** The member attribute records are now supplied inline, taken verbatim from G-001 and G-005, so the checker re-derives this case like every other; the expectation is **10** on S1/S2/S5/S7 and S8 is removed from `cited_signal_ids` (forced by R-037 — a reason may name only signals that fired). Block text is untouched, so the derived `word_count` is still 253. Full write-up: `docs/fixture-notes.md` |
| ~~P0-9~~ | ~~G-017 carries `m_shear` as `founder`; the canonical cast says `chief-executive`** (measured: `x.com/eshear` og:description, "CEO of Softmax"). Correcting it kills S1 and drops him 6→4, destroying the tie the fixture exists to test ~~ | **Resolved: G-017 re-grounded on the one real tie in the audited graph** — Walk scores 9 to both Wilson and Feld on identical signals, so tier 1 cannot separate them and it falls through to evidence recency (Feld 2014-05-27 beats Wilson 2012-03-04). Tiers 2 and 3 had **zero** coverage before. `m_shear` is gone from the fixture, so the contradiction is gone. **G-037** was added for tier 1 and is labelled synthetic, because an exhaustive search found no differing-LARGE-count tie anywhere in the real graph |

| # | risk | standing |
|---|---|---|
| K-1 | SESSION adapters breach platform ToS; enforcement is account-level on the **operator's** account | raised, accepted (DEC-6) |
| K-2 | Facebook / TikTok yields UNVERIFIED | **Decided: attempt them through the operator's logged-in session**, same read-only posture as LinkedIn, X and Instagram (DEC-6). They stay UNVERIFIED until a session actually measures them — the claim is still earned, not assumed. **R-008 is unchanged: no captcha or bot-detection evasion**, so TikTok's 25 captcha references remain a hard stop, recorded as `unavailable` with a blocker rather than worked around |
| K-3 | Session data is not reproducible by Arena Hall from another account | mitigated by DEC-7; residual |
| K-4 | Provenance is structural (R-025); **the family half is a prompt instruction, not a mechanism** | accepted by decision (DEC-9) |
| K-5 | AUD-EDGES incomplete — Kopelman's retrievable first-person archive ends in 2014; feld.com's Pagefind index is unqueryable | **now a constraint, not a caution:** `v_assertable_absence` requires every `no_edge_confirmed` row to carry an `evidence_fact_id` naming the corpus actually searched. An absence with no named corpus is not readable by the engine |
| K-9 *(accepted)* | **Prominence mixes platforms.** Perkins reaches tier 4 on a LinkedIn figure (370,639) while the other nine are ranked on X; her X is 56,591, which alone is tier 3 | **Decided: accept, and record the platform alongside every figure.** Tiers are computed once at ingest and frozen into the file, so this is sound at runtime. The residual — that a LinkedIn follower is not the same unit as an X follower — is stated rather than engineered away |
| K-11 | A non-member partner reached by `family_or_partner` traversal **never opted in and has nobody to ask** — and since DEC-15 no member has a way to opt out either, so this is the general condition rather than a gap peculiar to non-members | **partially mechanised:** `member_flags.do_not_traverse` now exists and applies to any `person` row, member or not, and `v_traversable_person` excludes them. Residual: nobody can *request* the flag, so it is operator-set. Accepted (DEC-12) |
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

**R-059** `[decided, DEC-14 — supersedes the unguessable-path clause]` **Staff-only is asserted,
not enforced, and the spec says so in the plainest words available.** The brief forbids auth and
accounts, so there is no access control, and **as of DEC-14 there is no path obscurity either**:
the surfaces answer at the root of whatever host serves them. Anyone who reaches the host reaches
the Room.

What remains is narrower and is still required: `X-Robots-Tag: noindex, nofollow, noarchive`, a
`robots.txt` disallow, `Referrer-Policy: no-referrer`, and **no member name in any URL or page
title**, so a name cannot leak through a referrer header or a browser-history entry. Those keep the
cards out of search results and keep names out of logs. They do not keep anyone out.

The README must state the residual in one sentence a non-engineer can read: *this is a staff
instrument on an open URL carrying ten real, named people.* An implementation MAY offer path
obscurity as a deployment option (`ARENA_PUBLIC_ROOT=0`), but it is an option, not a mitigation
this spec claims. *(P0-5 stays accepted, and is now accepted with less in front of it)*

## 12. Index

Thesis R-001–004 · Sourcing R-005–011 · Identity R-012–015 · Scoring R-016–023 (incl. R-022a) ·
Disclosure R-024–032 (incl. R-027a) · Card R-033–042 + R-060–061 · Surfaces R-043–047 + R-062 ·
Architecture R-048–051 · Demo R-052–054 · **Implementation R-055–059 (§11)**. Risks are K-1–K-11,
not R-numbered. R-060–062 were added by the 2026-09-04 prototype re-baseline.
