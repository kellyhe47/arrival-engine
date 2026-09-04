# Fixture notes — corrections made, and `given` gaps filled

The rule this file exists to keep visible: **never edit an expectation to make code pass.** Every
entry below names the authority the fixture contradicted, and every correction was applied to the
spec and the fixture together, per `docs/IMPLEMENTATION-PROMPT.md` §2.

Nothing here was discovered by an implementation failing. Both entries were found by reading the
fixtures against `db/roster.sql` before any product code existed, and both are recorded whether or
not they affect a test result.

---

## 1. G-022 asserted a score that `db/roster.sql` forbids  *(corrected; defect P0-10)*

**What it said.** `22-full-digest-happy-path.json` expected `score(m_feld -> m_wilson) = 11` on
`S1 S2 S5 S7 S8`, and its Room block cited `S8` as one of the reasons.

**Why that cannot be right.** S8 fires only when B's prominence tier is *strictly above* A's.
`db/roster.sql` measures both men at tier 4 — Wilson 640,845 followers, Feld 388,685 — under the
one measured rule in `db/vocabulary.sql`. There is no gradient between them, so S8 cannot fire in
either direction. **G-001 was re-baselined for exactly this reason on 2026-09-03** and says so in
its own `why`: *"Wilson and Feld are both prominence tier 4 under the measured rule … so S8 no
longer fires."* G-022 is the same pair and was not re-baselined.

**Why it survived.** G-022 passed `present_members` as bare ids (`["m_wilson", "m_perkins"]`) rather
than as attribute records. `eval/verify_fixtures.py` re-derives ranked-match arithmetic only when
those entries are objects, so it skipped this fixture's scoring entirely. The checker could not see
the contradiction, and neither could anything else.

**The correction, both halves together.**
1. The member attribute records are now supplied inline, taken **verbatim** from G-001 (Feld,
   Wilson) and G-005 (Perkins) — the audited baselines — so the fixture is self-describing like
   every other `rank_room` / `generate_digest` case, and `verify_fixtures.py` now re-derives it.
2. The expectation is `10` on `S1 S2 S5 S7`, and `S8` is removed from the Room block's
   `cited_signal_ids` — forced by the same correction, because a reason may name only signals that
   actually fired (R-037 / G-020).

Block text is untouched, so the derived `word_count` is still 253. `verify_fixtures.py` went from
178 to 180 checks: the two extra are this fixture's arithmetic, now visible.

**Consequence for the implementation:** none. The engine computed 10 before the fixture was
touched, which is how the discrepancy was confirmed rather than assumed.

---

## 2. G-027 does not say where its seven facts come from  *(gap filled, fixture unchanged)*

`27-expired-session-yields-partial-profile.json` expects `facts_ingested: 7` from
`personal_blog_rss` for `m_perkins`, and asserts `external_calls: []`. Its `given` states the fetch
plan and the session failure, but never the size of the blog corpus that produces the seven.

The fixture is **not** edited. Instead the runner supplies the implied input as a recorded corpus,
`eval/recorded/m_perkins__personal_blog_rss.json`, holding seven dated items. `RecordedAdapter`
reads it, so the ingest run is offline, reproducible, and genuinely free of external calls — which
is what the fixture asserts and what the socket tripwire in `eval/golden_runner.py` enforces.

Recording a corpus is the smallest thing that makes the case executable; inventing an
`expected_facts` field in `given` would have been editing the contract.

---

## Not corrected, and why

**G-037 remains synthetic and remains labelled synthetic.** Its shared context and its
`m_kopelman -> m_ries` link are fixture-supplied, not audit-backed; the fixture says so at length.
An exhaustive search found no equal-score, differing-LARGE-count tie anywhere in the real graph, so
tie-break tier 1 cannot be grounded in real data today. Leaving it synthetic and labelled is
correct; re-ground it if ingest ever produces a real one.
