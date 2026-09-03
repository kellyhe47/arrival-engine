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
