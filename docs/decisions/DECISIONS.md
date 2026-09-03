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
All six queued changes and the eight spec-review P0s were decided in one pass.

ACCEPTED and now in the PRD:
  P-1 phonetic respelling in Who        -> R-034
  P-3 do-not-brief + real deletion      -> R-032, schema member_flags + ON DELETE CASCADE, G-035
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
