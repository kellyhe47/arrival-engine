# Manual QA — Arrival Engine

```yaml
sha: 538c1dd
branch: codex/ingest-m-feld
tree: dirty      # this report describes the uncommitted 2026-09-04 design re-baseline
launched: .venv/bin/python -m uvicorn arena.web:app --port 8111 (via .claude/launch.json);
          withheld flow on :8112 with an invalid narrator key
```

**Spec:** `docs/PRD.md` (2026-09-04 re-baseline; §§4/6/7 authoritative).
**Designs:** `designs/prototype/handback/render/` (12 frames) + `handback/static/arena.css`.
**Evidence:** Browser-pane visual walks (mobile 390×844, the design's form factor) plus rendered
HTML snapshots in `.qa/screens/` — no local screenshot tooling was available, so the snapshot
trail is HTML; visual layout was verified live in the pane for Room, first-arrival card, ready
card and the reference screen.

## Flows walked

| # | Flow | Requirements | Trail | Result |
|---|---|---|---|---|
| F1 | Empty room → fire webhook → first-arrival card | R-044, R-034/035, R-060 | 01, 02 + pane | PASS |
| F2 | 8 arrivals → Room order → seating 2–6 → 9th arrival merge rule | R-044, R-062, R-065 | 03–05 + pane | PASS (3+3+2, 6+2; 9@4 → 4+5) |
| F3 | Ready card: bullets, door check, Who's-here coverage, Say rail, collapsed rest (match · ledger · recent · personal + suppression counter), word band, outcome tag+text and text-only | R-034–041, R-028, R-060 | 06 + pane | PASS (255–263 words; both outcome rows landed append-only, `Logged against this introduction` confirms) |
| F4 | Card → Why (intent line, fired/not-fired incl. S9, generics with shares, reverse, brokering: mutual) → How-the-score-works (all 8 design sections) | R-046, R-022–022c, R-043 | 07, 08 + pane | PASS |
| F5 | Degraded: no-strong-match (Perkins 3 · needs 6, nobody named), unknown coverage (Reached 19 of 20, `instagram_session · session_expired`) | R-038, R-040 | 09, 10 | PASS |
| F6 | Identity: single resolve (16 sources + corroboration line), ambiguous "me" → 2 candidates, no default, own Say line; not-found | R-013, R-063 | 11–14 | PASS |
| F7 | Live re-run: coverage count, SESSION `absent from registry`, per-adapter rows, partial outcome | R-064, R-058, R-053 | 15 | PASS |
| F8 | Depart removes from Present (7 present); noindex/referrer headers; robots disallow | R-044, R-059 | inline | PASS |
| F9 | Unsigned webhook rejected (503 `webhook_not_configured`, no data read) | R-001 | inline | PASS |
| F10 | Withheld (narrator broken on :8112): Who + gate table (Observed/Allowed) + "retry re-runs render only" + greeting Say + outcome capture; no brief sections | R-048, R-061, R-047 | 16 | PASS |

## Findings

**QA-1 (P2, verbiage).** F3, ready card, Who's-here bullet: *"both were part of uncensored
anthology 2012"* — a de-hyphenated context slug in card prose, lowercase mid-sentence. Repro:
open `/card/<feld token>` with Wilson present. Expected: R-034/R-030 prose reads as a human
sentence (design frame `ready.html` uses editorial phrasing). Observed: slug residue. Cause is
data-side (no display label on `life_event` context values); flagging, not diagnosing.
Screenshot: `.qa/screens/06-card-ready-feld.html`.

**QA-2 (P2, verbiage).** F3, Who-they-are third bullet: *"The door said Foundry Group /
Techstars, Boulder; the measured read is Foundry, General Partner."* Correct and honest, but
flatter than the design's *"Foundry is right, the Techstars half is older than it reads."* The
deterministic narrator cannot write the nuance; acceptable, noted for a future model-composed
door line. Screenshot: `.qa/screens/06-card-ready-feld.html`.

**QA-3 (note, coverage).** The **cold-trail** state (R-040 `quiet`, design frame
`cold-trail.html`) is untriggerable with the current store: every member has at least one
unreachable source, so recency is always `unknown`. The state is covered by goldens/unit tests,
not by this walk. Not a defect; a data-coverage gap worth one line in the demo script.

**QA-4 (note).** Design frame `why.html` omits the Intent section and S9 row that its own
`scoring.html` mandates; the app follows `scoring.html` (and PRD R-046) and renders both. Treated
as design-internal drift, resolved in the PRD's favour.

## Requirements no flow covered

None of the UI requirements. Backend-only requirements (R-032 purge, ingest contract §2/§11) are
out of scope for this skill.

## Escalations

- Signed-webhook happy path (F9) needs the shared secret provisioned; only the rejection path
  was drivable.
- Pane-hidden clicks time out in this environment; interactions were driven through the pages'
  own forms via in-page JS (same requests, same handlers).
