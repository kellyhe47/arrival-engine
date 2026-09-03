# Arena Hall — Arrival Engine · Inception run plan

Working dir: /Users/kellyhe/Documents/gauntlet/arena-hall
Process: product-inception skill. Checkpoints at Phase 2 (audit), Phase 6 (fixtures+wireframes), Phase 9 (review).

## State board
- [x] P1 Understand brief  -> docs/audit/00-AUDIT-BRIEF.md, ids RUBRIC-1..4, AMB-1..5
- [x] P2 Audit ground truth -> docs/audit/01..05 landed; 06-edges dispatched
- [x] P3 Align -> docs/decisions/DECISIONS.md (DEC-0..DEC-5)
- [x] P4 Golden fixtures -> 26 fixtures / 16 behaviors; both checks green (190 arithmetic checks)
- [~] P5 Grill open decisions (deferred to after P6 checkpoint; offered to user)
- [x] P6 Architecture (docs/architecture.excalidraw, 21/21 edges recoverable) + docs/wireframes.html + docs/ui-states.md
- [ ] P7 PRD                 -> docs/PRD.md
- [ ] P8 Design handoff prompt (optional)
- [ ] P9 spec-review loop    -> eval/verify_claims.py
- [ ] P10 Handoff prompt     -> docs/HANDOFF.md
- [ ] P11 Compound

## Audit agents dispatched (P2)
1. people: Wilson / Feld / Kopelman        -> docs/audit/01-*.md
2. people: Tavel / Walk / Huffman          -> docs/audit/02-*.md
3. people: Shear / Ries / Qureshi / Perkins-> docs/audit/03-*.md
4. source retrievability (GREEN/RED stack) -> docs/audit/04-*.md
5. comparables + seen-vs-dossiered line    -> docs/audit/05-*.md

## Resume procedure
Re-derive state from disk, not from notifications. `ls docs/audit/` shows which audits landed.
If an audit file is missing or thin, re-dispatch that one agent with the same prompt.
Do not proceed past P2 checkpoint until all 5 files exist and have been read.

## Standing constraints (from the brief)
- No facial recognition / CV. Arrival is a webhook carrying a name.
- No auth, no accounts, no infra theatre.
- Working beats pretty.
- Scored on: speed(hours), data judgment(creative sourcing), signal-over-noise(what was LEFT OUT), taste(seen not dossiered).

## P2 findings that reshape the spec (2026-09-03)
- AUD-RED: LinkedIn(999) / Instagram(JS shell) / Facebook(400) / TikTok(captcha+academic-only)
  / X timelines+following(metered, mirrors dead) / dating apps(GDPR Art.9) are ALL unusable.
  The user's proposed stack is ~90% RED. The GREEN stack is open-web: full-text blog RSS,
  HN Algolia, SEC EDGAR, Wikipedia, YouTube transcripts, podcast RSS, Open Library search-inside.
- AUD-STALE: several of the ten have thin/absent Mar-Sep 2026 first-person output
  (Kopelman: none; Tavel: 12 months dead; Perkins: journalist-mediated only; Wilson: decelerating).
  "What they've been up to lately" cannot assume freshness.
- AUD-FORMAT: real 90-second briefs are 250-350 words / 4-5 bare-noun labelled items /
  2-3 sentences each / ends on a sayable line, not a fact. (PDB 1968 = 265 words, ~87s aloud.)
- AUD-LINE: the shippable taste test is the trade's own leak test —
  "would the member be pleased to read this card over the host's shoulder?"
- AUD-GAP: nobody ships score AND reasoning together. Relationship CRMs expose scores and hide
  reasoning; event matchmakers show reasoning and hide scores. The brief asks for both.
