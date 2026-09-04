# Build run — THE ARRIVAL ENGINE

Resumable from disk. Re-derive state by reading this file plus `make validate-spec test-golden`.

Working dir: `/Users/kellyhe/Documents/gauntlet/arena-hall`
Brief: `docs/IMPLEMENTATION-PROMPT.md`. Contract: `eval/golden/*.json` > `docs/PRD.md` > everything else.

## Hard boundary
`db/` is FROZEN and read-only for this build. Live ingest agents are writing there.
- Never open a file under `db/` for writing. Read-only URI only: `sqlite3.connect("file:...?mode=ro", uri=True)`.
- Schema changes are PROPOSED in `docs/schema-requests.md`, never applied to `db/`.
- The serving store is built OUTSIDE `db/` at `var/arena.serve.db` (gitignored) by `scripts/build_store.py`.

## Scope
The whole application: golden runner, vendored spec validator, narrator seam, deterministic core,
three surfaces (Card / Why-this-score / Room), deployment. Not ingest collection.

## Board
- [x] T0  Read the contract: fixtures, PRD, scoring model, schema, roster, vocabulary, ui-states, decisions
- [x] T1  Stack decision recorded as DEC-13
- [x] T2  Scratch/serving store builder (`scripts/build_store.py`) + synthetic seed (`seed/synthetic.sql`)
- [x] T3  Golden runner (`eval/golden_runner.py`) — dispatches on `when.operation`, deep-compares
          result / state_changes / emitted_events / external_calls
- [x] T4  Vendor `validate_golden.py` into `scripts/`; wire `make validate-spec` + `make test-golden`
- [x] T5  Narrator seam + fixture-backed fake (`arena/narrator.py`) — temperature 0, no decisions
- [x] T6  Deterministic core: identity -> label -> scoring -> ranking -> fact selection -> gates
- [x] T7  Surfaces: Card, Why-this-score, Room (server-rendered, Arena Hall design system)
- [x] T8  Deployment: container, noindex/robots, unguessable path
- [x] T9  Red-first evidence: every fixture observed failing for its intended reason
- [x] T10 README (incl. the P0-5 residual, stated plainly) + hours ledger + "what next"

## Criteria (definition of done)
1. All 60 PRD requirements met.
2. `git status` shows no modification under `db/` attributable to this build.
3. `make validate-spec` and `make test-golden` green from a clean clone; both in CI.
4. Every fixture observed red for its intended reason before green (`docs/red-first.md`).
5. App runs against an empty store and a populated one; degrades honestly in between.

## Commands
    make install        # uv venv + deps
    make store          # build var/arena.serve.db from db/*.sql + seed/synthetic.sql (read-only on db/)
    make validate-spec  # scripts/validate_golden.py + eval/verify_fixtures.py
    make test-golden    # eval/golden_runner.py against the real implementation
    make test           # both, plus unit tests
    make run            # uvicorn on :8000
    make red            # re-run the red-first harness (mutation evidence)

## Resume procedure
1. `cat docs/RUN.md` (this board), then `make validate-spec test-golden`. Failures name the ticket.
2. Never trust a completion summary over the tree. `git status`, `ls`, run the checks.
3. If `var/arena.serve.db` is missing or stale, `make store` rebuilds it. It is disposable.
4. If `db/` shows a modification you did not make, it is an ingest agent's. Leave it.

## Fixture corrections
`docs/fixture-notes.md` — one entry per fixture defect fixed or `given` gap filled. Nothing is
edited to make code pass; every entry names the authority the fixture contradicted.
