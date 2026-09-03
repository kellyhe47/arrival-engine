# Handoff — THE ARRIVAL ENGINE

You are implementing a staff-facing arrival brief for a private members club. A webhook fires with a
name; within ninety seconds a host reads a card telling them who arrived, who present they should
meet and why, and one thing they can say out loud. You do not need the original brief — the PRD has
absorbed it.

## 1. Sources of truth, in precedence order
1. **`eval/golden/*.json`** — 30 fixtures, 19 behaviors. The acceptance contract.
2. **`docs/PRD.md`** — 52 numbered requirements. §11 lists **8 open P0 defects**.
3. **`docs/scoring-model.md`** — the normative scoring oracle.
4. **`docs/wireframes.html` + `docs/ui-states.md`** — every screen state.

On conflict, fixtures win over prose. **Except where §11 says a fixture is itself defective** —
P0-1, P0-2, P0-7 and P0-8 are known-bad fixtures. Fix the spec and the fixture together, and record
the change as a spec change with its provenance. Never edit an expectation to make code pass.

Already settled, do not relitigate: DEC-1..DEC-9 in `docs/decisions/DECISIONS.md`.

## 2. Do this first, before any feature work
The eight P0s in PRD §11. Two are load-bearing and have agreed fixes:
- **P0-1** genericity becomes a vocabulary property, not a room statistic. Re-baseline G-008, G-025,
  G-026 together.
- **P0-2** evaluate the surfacing threshold on the score **excluding S8**, so prominence cannot
  create a match.
Then the six queued changes in `scratchpad/PENDING-PRD-CHANGES.md`. **P-5 (tagged content is an
injection surface) is the most urgent correctness fix in the whole set.**

## 3. Two commands, never conflated
```
validate-spec   # schema + traceability + arithmetic. Exists and passes today:
                #   python3 eval/verify_fixtures.py
                #   python3 ~/.claude/skills/product-inception/scripts/validate_golden.py eval/golden
test-golden     # DOES NOT EXIST YET. You build it. It must drive the real implementation,
                # capture the four observation surfaces, and deep-compare to expect.exact.
```
Every fixture must first be observed **failing for its intended reason**, then pass.
Vendor `validate_golden.py` into the repo — today it lives in a skill directory outside it.

## 4. The invariant that must never be compromised
**The engine must never assert something it merely failed to observe.**
Every defect the audit found in this spec was a variant of that one error: the `@spez` handle
collision, the operator's own social graph leaking into member profiles, tagged posts naming the
wrong Fred Wilson, and "Eric Ries is dormant" when he had shipped a book that month.
Checkable yourself: for any claim on a card, can you name the source that was actually read, and
distinguish "we looked and there was nothing" from "we could not look"? If not, it must not render.

## 5. Dependency facts for ticket ordering
- The **narrator is an injected seam**. It writes prose and makes no decisions. Temperature 0. No
  fixture asserts model prose. Build the seam with a fixture-backed fake before any card work.
- **`test-golden` is consumed by everything and does not exist.** Build it first.
- **SESSION adapters** (LinkedIn, X, Instagram — all measured working; Facebook/TikTok unverified)
  run **only** on the operator's machine, read-only, and must be absent from the deployed runtime.
  The deployed app serves the profile cache. This split is not optional; see P0-4.
- **Controlled vocabulary does not exist** (P0-6). Scoring depends on it. Build it early.
- **Canonical cast does not exist** (P0-8). Fixtures currently contradict each other.

## 6. Definition of done
- All 52 requirements met; all 8 P0s closed; the 6 queued changes accepted or explicitly rejected
  with a reason.
- `validate-spec` green from a clean checkout.
- `test-golden` green from a clean checkout, driving the real implementation.
- Full golden suite in CI.
- Deliverables: a live clickable URL, the repo, and one paragraph on what to build next with a month
  and real member data.
- The run is resumable from disk: ticket board, scope, criteria, commands and resume procedure as
  files, before the first sub-agent is dispatched.
