# Handoff — THE ARRIVAL ENGINE

You are implementing a staff-facing arrival brief for a private members club. A webhook fires with a
name; within ninety seconds a host reads a card telling them who arrived, who present they should
meet and why, and one thing they can say out loud. You do not need the original brief — the PRD has
absorbed it.

## 1. Sources of truth, in precedence order
1. **`eval/golden/*.json`** — 31 fixtures, 24 behaviours. The acceptance contract.
2. **`docs/PRD.md`** — 58 numbered requirements. §10 lists the open defects; §11 is the
   implementation contract; §12 indexes both. The full companion-document map is at the top of it.
3. **`docs/scoring-model.md`** — the scoring oracle. Corrected 2026-09-03 to match PRD R-018/R-019;
   its old §3b room-statistic genericity rule is withdrawn.
4. **`docs/ingest-spec.md` + `db/roster.sql`** — the fetch contract and the canonical cast. Anything
   that collects data works from these two, not from the audit prose.
5. **`docs/wireframes.html` + `docs/ui-states.md`** — every screen state.

On conflict, fixtures win over prose — **except where PRD §10 says a fixture is itself defective**.
Fix the spec and the fixture together, and record the change as a spec change with its provenance.
**Never edit an expectation to make code pass.**

Already settled, do not relitigate: DEC-1..DEC-9 in `docs/decisions/DECISIONS.md`.

## 2. What is already closed, and what is not

**Closed since the last handoff.** P0-1 (genericity is a vocabulary property — `db/vocabulary.sql`),
P0-2 (S8 excluded from the surfacing threshold), P0-3 (DEC-9), P0-4 (SESSION adapters absent from the
runtime registry), P0-6 (controlled vocabulary exists), **P0-8 (canonical cast exists —
`db/roster.sql`)**, and the identity half of P1-11 (`corroboration_kind`).

**Still open, and do these first.**

| id | defect | fix |
|---|---|---|
| P0-5 | "never member-visible" has no enforcement: no auth + public URL + ten real named people | unguessable URL + `noindex`; accepted risk, stated |
| P0-7 | `word_count` is handed to fixtures, not derived (circular) | fixtures supply block text; the runner counts |
| P0-9 | G-017 carries `m_shear` as `founder`; the table says `chief-executive` (measured). Correcting it destroys the tie the fixture tests | re-ground after the first ingest run against AUD-06's real edges; no equal-score tie exists in the real attribute space until `context` and `edge` are seeded |
| — | `board-games` is a G-017 placeholder with no audit backing and no holder in the roster | source it or delete it and re-baseline G-017 |

## 3. Two commands, never conflated
```
validate-spec   # schema + traceability + arithmetic. Exists and passes today:
                #   python3 eval/verify_fixtures.py            (162 checks, green)
                #   python3 ~/.claude/skills/product-inception/scripts/validate_golden.py eval/golden
test-golden     # DOES NOT EXIST YET. You build it. It must drive the real implementation,
                # capture the four observation surfaces, and deep-compare to expect.exact.
```
Every fixture must first be observed **failing for its intended reason**, then pass.
Vendor `validate_golden.py` into the repo — today it lives in a skill directory outside it, so half
the acceptance contract is not reproducible from a clone.

## 4. The invariant that must never be compromised
**The engine must never assert something it merely failed to observe.**
Every defect the audit found in this spec was a variant of that one error: the `@spez` handle
collision, the operator's own social graph leaking into member profiles, tagged posts naming the
wrong Fred Wilson, and "Eric Ries is dormant" when he had shipped a book that month.
Checkable yourself: for any claim on a card, can you name the source that was actually read, and
distinguish "we looked and there was nothing" from "we could not look"? If not, it must not render.

Its ingest-side twin, which is now equally mechanised: **never collect from a source you have not
confirmed is the subject.** `db/roster.sql` is the allow-list and the deny-list; `ingest-spec.md`
is the contract. A 200 is not identity confirmation.

## 5. Dependency facts for ticket ordering
- **`test-golden` is consumed by everything and does not exist.** Build it first.
- The **narrator is an injected seam**. It writes prose and makes no decisions. Temperature 0. No
  fixture asserts model prose. Build the seam with a fixture-backed fake before any card work.
- **Storage loads in one order:** `db/schema.sql` → `db/vocabulary.sql` → `db/roster.sql`.
  Verified: loads clean under SQLite with `foreign_keys = ON`; 10 people, 55 allow-listed sources,
  19 deny-list rows, 24 topic assignments.
- **SESSION adapters** (LinkedIn, X, Instagram — all measured working; Facebook/TikTok unverified)
  run **only** on the operator's machine, read-only, and must be absent from the deployed runtime.
  The deployed app serves the profile cache. This split is not optional; see P0-4.
- **Two roster columns are deliberately NULL** and block one signal each until an ingest run fills
  them: `career_start_decade` (S1 cannot fire for anyone) and `name_respelling` (R-034's phonetic
  line). `m_huffman.prominence_tier` is also NULL — no GREEN source carries a follower count for
  him. `ingest-spec.md` §8.4 names the source for each.
- **`career_start_decade` is the highest-value next measurement.** It blocks S1 entirely, and
  fixtures already disagree about it (`m_kopelman` appears as both `1980s` and `1990s`). Wikipedia
  wikitext settles it for the seven with articles; SESSION LinkedIn for Tavel, Walk, Qureshi.
- **Prominence was re-measured 2026-09-03** and four tiers moved. `db/vocabulary.sql` carries the
  rule, the withdrawn clause, and every figure with its platform.
- `person_topic.evidence_fact_id` is NULL across the board until the first content run. A topic with
  no evidence fact produces a reason sentence the host cannot defend.

## 6. Definition of done
- All 58 requirements met; the open defects in §2 closed.
- `validate-spec` green from a clean checkout, with `validate_golden.py` vendored.
- `test-golden` green from a clean checkout, driving the real implementation.
- Full golden suite in CI.
- Deliverables: a live clickable URL, the repo, and one paragraph on what to build next with a month
  and real member data.
- The run is resumable from disk: ticket board, scope, criteria, commands and resume procedure as
  files, before the first sub-agent is dispatched.
