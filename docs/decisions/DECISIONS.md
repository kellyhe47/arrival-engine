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

## DEC-6 — Session-assisted ingestion, READ-ONLY (user's call, 2026-09-03)
User pushed back on the RED verdicts: the audit measured LOGGED-OUT access, which is a different
question from what a logged-in session can see. Correct objection. User authorises using their own
logged-in accounts, driven through Claude in Chrome.

**Hard constraint, stated by the user and binding on the design:**
> "You can use my account but you ARE NOT ALLOWED TO MAKE ANY WRITE changes
>  aka no posts, no messages, no likes"

Enforced structurally, not by care:
  - Session-assisted adapters expose READ operations only. There is no write path in the adapter
    interface, so a write cannot be reached by a bug, a retry, or a prompt.
  - No follows, connection requests, DMs, likes, reactions, comments, or profile edits. Ever.
  - Navigation and reading at human pace. No captcha or bot-detection evasion is designed or built.

**Architectural consequence — this is the important one.**
A session-assisted adapter CANNOT run on the deployed live URL the brief requires
("a live URL we can click"). It only runs on the operator's machine with their browser.
So the adapter taxonomy becomes three tiers, and ingestion is firmly separated from serving:
  - GREEN        — runs anywhere, including in the deployed app. Free, keyless, measured 200.
  - METERED      — runs anywhere, costs money per call (X API).
  - SESSION      — runs ONLY at ingestion time, on the operator's machine, read-only.
                   Output is written to the profile cache; the deployed app serves the cache.
This is compatible with DEC-3 (ten cached + one live re-run): the on-stage live re-run exercises
GREEN adapters only, so it cannot fail on a dead session in front of the room.

**Risks the user was told once and accepted:**
  - Meta ToS 3.2(3) covers automated collection "regardless of whether ... logged-in";
    LinkedIn User Agreement "Don'ts" cl.2 bans automated profile scraping. Enforcement is
    account-level and lands on the USER's personal account.
  - A session can expire mid-ingest. That is a designed failure mode, not an error (see B-017).

**Status: PARTIALLY MEASURED, 2026-09-03 — see docs/audit/07-session-measured.md.**
  - LinkedIn  SESSION-GREEN. Full post bodies, dates, engagement, tagged people, reposts.
              Overturned the "Perkins has no 2026 first-person output" finding: she posted 1d ago.
  - X profile SESSION-GREEN. Bio, counts, join date, birthday.
  - X following list SESSION-GREEN via the accessibility tree (NOT text extraction). Free, replacing
              a ~$13.45/pull metered call. Virtualized: scroll required, so it is a batch job.
  - Instagram UNVERIFIED — session not logged in at test time. Retest.
  - Facebook, TikTok UNVERIFIED — not tested.
Dating apps remain out: no access path at any login state, and special-category data.

## DEC-7 — Personalized strings are stripped at the adapter boundary (forced by AUD-07-4)
The logged-in view is personalised: "Followed by Alexandr Wang and Sam Altman", "Followed by
Upasana, Imshan and 5 others you know", "3rd" degree. Those are facts about THE OPERATOR, not the
member. They are not reproducible by Arena Hall, they make coverage depend on who the operator
knows, and they leak the operator's contacts into a member profile.
Rule: session adapters extract against a WHITELIST of member-owned fields. Personalized strings are
dropped at the boundary and never enter a fact record. Whitelist, never blacklist.

## DEC-8 — Image analysis IS in scope; face recognition is not (2026-09-03)
User: "For the social media scraping, we absolutely must analyze the pictures themselves."

**The brief's exclusion, quoted in full:**
> "No facial recognition, no computer vision. Assume arrival detection is solved: a webhook fires
>  with a name. In our view that is the easy half, and it is not the half we are testing."

**The call, and the reasoning to give on Friday.** The exclusion is scoped to ARRIVAL DETECTION —
its stated rationale is that identifying who walked in is "the easy half". Reading a photograph a
member published themselves, to learn that he collects vinyl, is not arrival detection. The brief
also instructs: "where the scope is ambiguous, make a call, and tell us on Friday why you made it."

  IN SCOPE : scene, object, activity, venue and text-in-image understanding.
  OUT, PERMANENTLY : face recognition, face matching, face clustering, identifying any person by
                     their face, or inferring age/gender/ethnicity/emotion from a face.
                     This is refused regardless of framing. It is the one capability the brief
                     names outright, and it is the line the product cannot cross.

**Consequent constraints (all measured, see audit 07):**
1. Only images published by the SUBJECT are analysed. Tagged-tab images are third_party_open
   (R-026) and are not analysed for facts about the member.
2. Screenshot the rendered post. Never fetch or store signed CDN URLs (AUD-07-11).
3. Vision output is DATA, never instruction (AUD-07-12). Text-in-image is an injection surface.
4. No image is stored. Only the derived structured observation is kept, with the post permalink as
   provenance. This keeps the fact store free of member photographs entirely.
5. Images containing identifiable people yield ONLY non-person content (setting, objects, activity).
   People present in a photo are not enumerated, counted, described or identified.
6. Children, homes' interiors, medical settings and anything in a domestic-private setting yield no
   facts at all. Nearest to AUD-LINE-6: facts about family are a different class of object.
7. An image-derived fact never renders on the card ALONE. It must corroborate a fact from a second,
   textual source — which is the demonstrated value anyway (AUD-07-10: "music" -> "vinyl").
   This single rule is what keeps image analysis on the hospitality side of the line.

## DEC-9 — No structural family-fact rule; judgement at write time (user's call, 2026-09-03)
Spec-review P0-3 found R-038 ("family facts never render") had no definition, no schema field, no
fixture, and one former happy-path provenance fixture that MANDATED rendering a family-derived fact
("His family foundation paid to digitise the 1901-1906 Jewish Encyclopedia").

I offered four boundaries, recommending the structural one (`derived_from_edges[]` rejected in
`select_renderable_facts`, the same treatment that protects the operator's account from writes).
**User chose: no structural rule, judgement at write time.**

What this means, stated plainly so no later reader thinks P0-3 was missed:
  - R-038 is REWRITTEN as a narrator-prompt instruction (the leak test), not a gate.
  - Family-derived facts about ORGANISATIONS and inherited context MAY render. The former Kopelman
    Foundation example remains legitimate output, but its fixture was removed when provenance
    cases were consolidated into G-034; it asserted no separate family-fact rule.
  - There is NO fixture that can fail when a family fact reaches a card, because by decision there
    is no rule to violate.
  - K-4 in the PRD risk table must say this honestly: the family half of the RUBRIC-4 defence is a
    prompt instruction, not a mechanism. The reviewer's objection stands on the record and was
    answered by decision, not by fix.
  - Residual risk carried: AUD-LINE-6 (Target, Meyer) is the evidence that this is where harm lands,
    and the harm lands on someone who is not the member. If a card ever does this, the leak test in
    the prompt is the only thing that was standing in the way.

## DEC-10 — Pending queue resolved (2026-09-03)
All six queued changes and the eight P0s from the (since-retired) spec review were decided in one pass.

ACCEPTED and now in the PRD:
  P-1 phonetic respelling in Who        -> R-034
  P-3 do-not-brief + real deletion      -> R-032, schema member_flags + ON DELETE CASCADE, G-035
                                          (the do-not-brief half was withdrawn by DEC-15;
                                           the deletion half stands)
  P-4 quiet vs unknown recency          -> R-040, schema source_status + v_recency_state, G-033
  P-5 trust_class / injection surface   -> R-026, schema fact.trust_class + v_renderable_fact, G-034
  P-6 Instagram captions feed S4        -> R-005/R-031, schema context.resolved
  P0-1 genericity                       -> R-019, vocabulary property, G-025 rebased
  P0-2 S8 cannot create matches         -> R-018, surfacing evaluated excluding S8
  P0-4 runtime registry                 -> R-053, structural absence; B-010 consolidated in G-027
  P0-6 controlled vocabulary            -> db/vocabulary.sql (slug collision seed-stage-* fixed)

DROPPED:
  P-2 merge NPR/announce-card audit material — audit hygiene, shapes no requirement. The one
      finding worth keeping (the pronouncer) was already lifted into R-034.

STILL OPEN, and they are all fixture defects rather than spec defects:
  P0-5 no enforcement for "never member-visible" — mitigated by unguessable URL + noindex,
       accepted and stated as K-1..K-6 risk. There is no auth to add; the brief excludes it.
  P0-7 word_count handed to fixtures instead of derived.
  P0-8 contradictory member attributes across fixtures; the cast must be derived from
       db/vocabulary.sql. Applying the stated prominence rule moves Ries 3 -> 4.

## DEC-11 — Adopted from the comparison implementation
Reviewed /Users/kellyhe/Documents/gauntlet/arena-hall-arrival-engine/docs/PRD.md. Adopted:
  - Stale supplied labels (their R-017/019) -> our R-014/R-015 + B-020/G-031. Their strongest idea
    and we had nothing on it. The brief's own roster says "Emmett Shear — Twitch"; he runs Softmax.
  - Suppression counter, class and count only (their R-033) -> our R-028 + B-024/G-022. Makes restraint
    provable without leaking, and is the visible answer to RUBRIC-3.
  - Huffman's SEC Form 4 sales as the named worked example of what is left out -> R-029.
  - Brokering mode: mutual / broker / light_touch (their R-025) -> R-022. Tells the host what to DO,
    not just whom to name.
  - Deceased homonym never auto-resolved (their R-015) -> R-013.
  - Source precedence on contradiction (their R-012) -> R-010.
  - Primary + one backup, everyone else collapses (their R-036) -> R-038.
  - Name-drop never an instruction (their R-041) -> R-039.
  - Thin profile emits fewer facts, fabricates nothing (their R-038) -> R-041.
  - Positional room view (their R-044) -> R-044.
  - None of the ten are in Texas; the brief's "same city" is false as written -> K-6.
NOT adopted: their 0/1/3 buckets and max 48 (ours is 1/2/3, ceiling 16, already fixture-pinned);
their floor of 6 coincides with ours; their fact-class ban list is superseded by DEC-9, which the
user decided the other way.

## DEC-12 — Family-sourced facts render without corroboration (user's call, 2026-09-03)

**Trigger.** `knowledge-graph.md` described `family_or_partner` as "inner-circle traversal ONLY —
never scored, never on a card". The user asked whether we are nonetheless using that relationship
data to inform our view of the person. **We are**, and the wording hid it: the traversal exists
precisely so a partner's public writing can be harvested for facts about the member, and those facts
scored and rendered like any other. Wilson is the worked case — his own blog went quiet in May 2024
while `gothamgal.com` posts near-daily, so his partner's site is one of the better recency sources
on him, and `01-m_wilson.md` already directs an agent to it.

**Options put to the user.** (a) keep the misleading wording; (b) require a family-sourced fact to
corroborate a subject-sourced one before rendering, mirroring the image rule in DEC-8 / R-031;
(c) render on its own merits, with labelling.

**Decision: (c), with the wording fixed.** The user's reasoning: corroboration "gives it more
credibility" but should not be a gate — *"if member A's wife is doing something, most likely he is
also participating in the activity."* A shared household is real evidence of shared activity, and a
corroboration gate would discard the freshest available signal on the members whose own output has
gone quiet.

**What this settles.**
1. The **edge** never scores and is never named on a card. Unchanged, and the only two restrictions.
2. Facts reached by traversing the edge **render on their own merits.** No corroboration gate.
   Corroboration raises confidence and is preferred where available; its absence is not a bar.
3. **Attribution stays hard.** A source showing the *partner* did something is not observation that
   the *member* did it. That step is an inference and uses machinery that already exists:
   `provenance_class = 'inferred'` with `composed_from` naming its inputs, and an `inferred` fact
   that cannot name its inputs cannot render (R-025). "They were in Venice" when the post says *we*
   is observation; "he was in Venice" from a post that says only *I* is an inference and must
   declare itself. This is the one place the co-participation intuition must not be applied
   silently — it is exactly the "assert what you merely failed to observe" failure (R-004).
4. **Labelled, not hidden.** `fact.via_edge_type` and `fact.via_person_id` record the traversal, so
   the class is countable by the suppression counter, visible in Why-this-score, and reversible by
   policy later without a re-ingest.

**Residual risk, accepted and stated.** The non-member partner never opted in and has no way to opt
out of being traversed. Since DEC-15 that is true of members too, so this is no longer a gap
peculiar to non-members — it is the condition the whole product operates under. Their writing is public either way;
the reason we read it is the relationship. Logged as K-11.

## DEC-13 — Stack: Python 3.12 + FastAPI + stdlib sqlite3 + server-rendered Jinja2 (2026-09-03)

No stack had ever been chosen; no language, framework or deployment target appeared in any
document. Decided, and the reasoning given in one paragraph so it can be overruled on evidence
rather than taste.

**Python 3.12, FastAPI + Uvicorn, stdlib `sqlite3` (no ORM), Jinja2 server-rendered HTML with no
build step, self-hosted webfonts, one container.** SQLite is already the store (DEC-3 / R-049) and
the serving path is read-only point lookups, so an ORM would add a mapping layer over queries that
are already the clearest statement of the gate they enforce — several of those gates *are* views
(`v_renderable_fact`, `v_present`, `v_recency_state`, `v_collectable_source`, `v_assertable_absence`,
`v_traversable_person`) and must be queried, not re-implemented, so raw SQL is the feature.
`eval/verify_fixtures.py` is already Python, so one language covers the spec checker, the golden
runner and the application, and the golden runner can import the real implementation rather than
shelling out to it. Server-rendered HTML with no bundler removes an entire class of deployment
failure for a demo that must survive being opened on a phone at a door, and it keeps the runtime's
`external_calls` genuinely empty — every fixture asserts `external_calls: []`, and a CDN font or a
client-side data fetch would make that assertion a lie. The deployed app opens the SQLite file
read-only, so the ingest/serve split (DEC-3, R-053) is a file copy rather than architecture.

Consequences accepted: no client-side interactivity beyond a `<details>` disclosure and plain form
posts; Python's startup cost is irrelevant for a long-lived container; and the narrator seam is an
injected object rather than a service call, so the default deployment is a deterministic template
narrator and the model narrator is an unused, documented seam (R-050).

## DEC-14 — The live Say line is model-written from one selected fact (user's call, 2026-09-03)

**Trigger.** The deterministic template produced stage directions—“Tell them… then leave it there
and let them decide whether to walk over”—rather than words a host could naturally say. The Room
explanation was useful and should remain deterministic; the final delivery was not.

**Decision.** Scoring still selects the match and `arena.reason.say_context` selects the strongest
fired fact. The live narrator sends only that fact, the arriving member's name, and the matched
person's name to the model. The prompt asks for one warm line the host can say verbatim, treats the
fact as context rather than text to recite, and explicitly rejects stage directions and routing.
The model writes no other block and changes no decision. Responses are structured, tool-free, and
not stored; missing credentials or model failure takes the existing withheld-card path.

This supersedes only DEC-13's final consequence that the deployed narrator is deterministic. The
stack, server-rendered surface, read-only store, and deterministic test narrator remain unchanged.

## DEC-14 — The surfaces answer at the root; the unguessable path is withdrawn (user's call, 2026-09-04)

**Trigger.** `http://localhost:8111/` returned 404 and the operator asked for the app to be served
there. Told that the unguessable path is the only discovery mitigation R-059 has, the operator
reaffirmed: *"Make this update and remove that requirement."*

**Decision.** Root serves the Room. The unguessable-path clause is struck from R-059, and P0-5 is
**reopened** rather than quietly left marked closed — the risk did not go away, it got larger, and
the honest thing is for the table to say so.

**What is actually given up, stated once and plainly.** The path was never access control; it was
the requirement that somebody know a string before they could look. Without it, anyone who can
reach the host reaches the Room, and from the Room every member's card is one tap away. On a laptop
that is nothing. On a public URL carrying ten real, named people it is the whole of the exposure,
and no other line in this repository reduces it.

**What is kept, because it is still worth keeping and is now the entire mitigation.**
  - `X-Robots-Tag: noindex, nofollow, noarchive` and a `robots.txt` disallow — the cards stay out
    of search results, which is where a member would most plausibly stumble into one.
  - `Referrer-Policy: no-referrer`.
  - **No member name in any URL or page title.** Card URLs carry an opaque token derived from the
    member id, so a name cannot leak through a referrer header, a proxy log or a browser-history
    entry. This one is independent of the path and is unaffected by the decision.

**How it is built.** The same handlers are registered twice — under `/` and under `/<path>` — so a
bookmark of either keeps working and nothing is a redirect. `arena.config.public_root()` reads
`ARENA_PUBLIC_ROOT`; setting it to `0` restores the old posture. That is offered as a **deployment
option, not as a mitigation the spec claims** — R-059 no longer promises it, and a README that
described it as protection would be doing the papering-over this decision exists to avoid.

**Recommendation on the record, not acted on.** If this is ever put on a public host, the answer is
not to bring the path back. It is a session behind the door — the one thing the brief's no-auth
constraint rules out for the demo and the first thing to build after it.


## DEC-15 — The Do Not Brief opt-out is withdrawn, flag and all (user's call, 2026-09-04)

**Trigger.** The operator, on seeing a card that read *"This member has opted out of recognition"*:
*"There shouldn't be any way, absolutely no way, that a member is opting out of this service. The
members don't know about the service."*

**Decision.** R-032's opt-out half is struck. `member_flags.do_not_brief` is removed from the
scratch schema, from `v_present`, from `rank_room`, from `card_state`, from the Room list and the
member picker, and the Do Not Brief card is deleted. Golden fixture 35 and red-first G-035 are
retired with the behaviour they defended. Every member is briefed, always.

**Why the flag had to go rather than default to 0.** The opt-out was never reachable. Members are
not told this service exists — no notice, no consent surface, no self-service, and the PRD said so
in its own words ("member self-service is out of scope"). Nothing could ever have set the column,
and in the one build where an operator did set it by hand, the card told the host a member had
made a choice that no member had been given the opportunity to make. A privacy control that cannot
be exercised is not a privacy control; it is a claim, and leaving it in the schema defaulted to 0
would have kept the claim readable to anyone auditing this repo.

**What is deliberately KEPT, and why it is not the same thing.**
  - **R-032's purge.** `DELETE FROM person` still cascades through facts, edges, contexts, roster
    and cards. Erasure on request is a legal obligation that does not require the subject to have
    known about the system in advance — it is the opposite case. It stays.
  - **`member_flags.do_not_traverse`.** The operator restraining the INGEST walk across any person
    row, including the non-members reached by `family_or_partner` traversal. K-11 already says
    nobody can request it and that it is operator-set; it is the operator exercising restraint on
    a third party's behalf, not a member setting a preference. It stays, and `member_flags` stays
    with it.

**Also in this pass, at the same request.** The synthetic seed no longer pre-populates the roster.
The app starts with **nobody in the room** — a state the product already had to handle honestly
("first one here, not an error"), and the state a real evening actually starts in. Presence is
filled by the arrival webhook or Room's simulate-arrival control. The serving store was rebuilt
from the existing measured `db/*.db` files; no ingest adapter was re-run.

**Cost.** The repository can no longer point at a mechanism and say a member may decline. That was
the honest reading of the ask: the mechanism did not work, and saying so out loud is better than
shipping a control that only looks like one. The exposure this leaves is the one DEC-14 already
reopened under P0-5, and it is not reduced here.
