# `m_kopelman` · Josh Kopelman

First Round Capital, Philadelphia — label current. Prominence 3 (X 150,180, `@joshk`).
Seniority principal. Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_kopelman.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_kopelman-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_kopelman_<date>`, `f_kopelman_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/jkopelman`.** Canonical slug, `linked_from_own_canonical` from his own First Round bio (STRONG). Measured 2026-09-03: First Round Capital partner, Philadelphia, the Wharton School, ~29,000 followers. `/in/joshkopelman` is NOT canonical — do not substitute it. His LinkedIn is one of the few live surfaces he has, given the blog died in 2014; it is worth reading in full rather than skimming the top card.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph. **Kopelman is the reverse half of the Wilson asymmetry:** Wilson->Kopelman `follows` is now CONFIRMED (measured 2026-09-04, position 20 of Wilson's list). Whether Kopelman follows Wilson back is YOURS to measure — walk his whole list, and if you do not reach the end, say so rather than writing `no_edge_confirmed`.

**Thinnest footprint of the ten.** His blog died in 2014 and his firm's huge content operation
carries none of his byline. A thin profile that says it is thin is correct output. Fabricate nothing.

## Fetch
| url | what |
|---|---|
| `https://redeye.firstround.com/archives.html` | **212 posts, Mar 2006 – Nov 2014.** Index lists all 212 |
| `https://firstround.com/team/investing/josh-kopelman` | **richest single artifact.** lastmod 2026-01-16 |
| `https://en.wikipedia.org/w/index.php?title=Josh_Kopelman&action=raw` | 15,628 B — best structured bio he has; settles `career_start_decade` |
| `https://api.fxtwitter.com/joshk` · `https://x.com/joshk` | name="Josh Kopelman", 150,180 followers |
| `https://www.linkedin.com/in/jkopelman` | SESSION. **Canonical slug is `jkopelman`**, per his own firm bio |
| `colossus.com/episode/kopelman-the-past-present-and-future-of-seed-investing/` · `thetwentyminutevc.com/joshkopelman` · `annieduke.substack.com/p/imagine-if-with-josh-kopelman` (2024-12-12) | all 200; transcripts UNVERIFIED |

**Open lead:** First Round Form D / ADV on EDGAR. Related persons across funds VI/VII/IX/X are
Kopelman plus Hayes, Trenchard, Barnes, Berson, Fralic, Barna, Jackson, Asonye, Cordova, Wessel —
**none of the other nine.**

## Never fetch
- `github.com/joshk` — a different developer
- `joshk.substack.com` — **Josh Katzman.** Sole post titled "Test"
- `linkedin.com/in/joshkopelman` — not canonical; use `jkopelman`
- `permanentrecord.firstround.com` — **dead host, curl exit 28.** A timeout is not a 404

## The trap
**`feeds.feedburner.com/redeyevc` returns 200** with a valid channel, `lastBuildDate` 2019-05-21, and
**zero items** — while the sidebar still advertises "11901 Subscribers via RSS". "Feed OK, 0 items"
is **`unknown`, not `quiet`**. Record `fact_count` separately from `status`.

## Inner circle (one hop)
First Round partners (above). Meg Whitman, from the Half.com/eBay era. His 2015–2024 chairmanship of
*The Philadelphia Inquirer*. The Kopelman Foundation.

## Edges
- **Wilson → Kopelman `follows` confirmed; reverse NOT found** in two passes. Preserve it.
- **Walk names him as the person who institutionalised seed-stage financing** (Walk's side).
- Contributor to *Uncensored* (2012); his bio there reads *"Josh Kopelman @joshk / VC. Father. Geek"*.
- **Measured absence: Kopelman ↔ Tavel have no edge in any corpus searched** — all 212 of his posts
  and all 133 of hers. They share only the non-discriminating `venture-capital-craft`. The engine
  must be able to say "you have never mentioned each other."
- He has no retrievable first-person archive beyond the dead blog — **never write
  `no_edge_confirmed` against a corpus you couldn't search.**

## Topics needing evidence
`venture-capital-craft` (non-discriminating), `seed-stage-financing` (`seed-stage-investing` is an
alias — canonicalise).

## Deep cut
Matters more here than for anyone else, because he is thin. Mine the 212 archived posts, the firm
bio, Open Library `search/inside`, the Internet Archive. Known veins: a **second-place
watermelon-eating ribbon** on his official firm bio that he is bitter about; branded **urinal
screens in Penn Station** for Half.com; the **Kopelman Foundation digitised the 1901–06 Jewish
Encyclopedia** and it is still credited 24 years on; he published the **verbatim 2005 cold email**
(*"I would slide a check across the table right now"*) on the day that company sold for $119M.

## Backfill / auth
`career_start_decade` — **priority**; fixtures disagree (1980s vs 1990s) and the wikitext settles it.
Respelling: plausibly needed, source it or leave NULL.
LinkedIn is the only wall. If blocked, note that his thinness is a **true finding about him**, not a
collection failure — report the difference.
