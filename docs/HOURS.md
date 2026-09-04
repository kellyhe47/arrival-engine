# Hours ledger

RUBRIC-1 scores *"in how many hours"*, and DEC-0 requires an explicit **first N hours** line the
demo can be narrated against. This is that line, kept as the work happened rather than reconstructed
afterwards.

**Measurement basis, stated so the number can be read honestly.** This was one continuous
agent-driven build session on **2026-09-03**, not a stopwatch-timed human sprint. The order below is
exact — it is the order the files were written and the checks went green. The durations are
wall-clock estimates for that session, and they are the weaker half of this table; the ordering and
the cut line are the part worth trusting.

---

## THE CUT LINE — everything above it is the first 6 hours

| # | h | work | evidence on disk |
|---|---|---|---|
| 1 | 0.9 | Read the whole contract before writing anything: 18 fixtures, the 24-behaviour manifest, PRD's 60 requirements, the scoring oracle, the schema and its six gate views, roster, vocabulary, ui-states, DECISIONS, ingest-spec, knowledge-graph | — |
| 2 | 0.1 | Stack decision, recorded as **DEC-13** with its rationale | `docs/decisions/DECISIONS.md` |
| 3 | 0.2 | Durable run state on disk **before** any long work: board, scope, criteria, commands, resume procedure | `docs/RUN.md` |
| 4 | 0.5 | Scratch/serving store builder — reads `db/` read-only, refuses to write inside it, applies the pending schema requests to the scratch file only | `scripts/build_store.py` |
| 5 | 1.4 | The deterministic core, dependency-ordered: scoring → ranking and the three tie-break tiers → identity → labels → the render gate (queried from `v_renderable_fact`, not re-implemented) → recency → reason | `arena/*.py` |
| 6 | 0.4 | The narrator seam and the fixture-backed fake, **before** any card work, so card work was never blocked on a model | `arena/narrator.py` |
| 7 | 0.7 | `test-golden`: dispatch on `when.operation`, projection-deep-compare on all four observation surfaces, socket tripwire behind `external_calls` | `eval/golden_runner.py` |
| 8 | 0.3 | Vendored `validate_golden.py` into `scripts/`; wired `validate-spec` and `test-golden` as separate commands, both in CI | `scripts/`, `Makefile`, `.github/workflows/ci.yml` |
| 9 | 0.6 | Card assembly, gates, digest, the DEC-5 gate/grade rollup | `arena/card.py` |
| 10 | 0.5 | The synthetic demo seed — outside `db/`, every row tagged `run_synthetic_demo`, every URL measured, every body grounded in this repository | `seed/synthetic.sql` |
| 11 | 0.4 | **G-022 corrected**: found by reading the fixtures against `db/roster.sql` before the implementation existed, confirmed when the engine computed 10 against an expectation of 11. Spec and fixture fixed together | `docs/fixture-notes.md`, PRD §10 P0-10 |
| 12 | 0.5 | **`make red`** — the mutation harness. 18/18 fixtures proven load-bearing | `eval/red_first.py` |
| **6.5** | | **first green run of both commands, from a clean clone** | |

---

## After the cut line

| # | h | work | evidence on disk |
|---|---|---|---|
| 13 | 1.1 | Three surfaces: Card with all ten states, Why-this-score, Room with simulate-arrival and mark-departed | `arena/web.py`, `arena/templates/` |
| 14 | 0.6 | The Arena Hall design system — tokens read off the live site, zero border-radius, hairlines, the two typefaces and the one deliberate deviation | `arena/static/arena.css` |
| 15 | 0.5 | 38 unit tests for the structural properties no behaviour fixture can see: no write path in any adapter, SESSION absent from the deployed registry, `db/` opened read-only, the runtime writing only `roster` and `card`, the purge cascade | `tests/test_engine.py` |
| 16 | 0.4 | **Two invariant violations caught on real ingest output and fixed**: a nested quotation attributed to the wrong member, and a guessed pronoun. Both produced schema or code changes, not comments | `docs/schema-requests.md` |
| 17 | 0.3 | The `ON DELETE` defect: `DELETE FROM person` does not purge, contrary to the schema's own comment. Found by a test, written up, applied to the scratch store only | `docs/schema-requests.md` |
| 18 | 0.4 | Adapters, tiers, the ingest run, the recorded corpus | `arena/adapters/`, `arena/ingest.py` |
| 19 | 0.5 | Container, CI, README including the P0-5 residual in plain words | `Dockerfile`, `.github/workflows/`, `README.md` |
| **~10.3** | | **total** | |

---

## What the first six hours buys, and what it does not

**Does:** both acceptance commands green from a clean clone, every fixture proven load-bearing by
mutation, the whole deterministic core, and a store that can be rebuilt from `db/` without ever
writing to it.

**Does not:** a single pixel. Everything a person can look at is after the cut line. That ordering
was deliberate — the fixtures are the contract and the surfaces are downstream of them — but it is
worth saying out loud, because a demo narrated against "six hours" and shown a card is being told
about two different things.
