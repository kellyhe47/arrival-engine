# `m_feld` · Brad Feld

Foundry, General Partner (door said "Foundry Group / Techstars, Boulder"). Prominence 4 (X 388,685).
Seniority principal. Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_feld.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_feld-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_feld_<date>`, `f_feld_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/bfeld`.** A slug IS attested: **`feld.com` links it directly from his own footer**, which is `linked_from_own_canonical` (STRONG). Measured 2026-09-03: "Partner at Foundry", Boulder, **341,009 followers** — below his X 388,685, so it does not move his tier. The profile also states he runs the **Anchor Point Foundation with his wife Amy Batchelor**. Note `bfeld` is his X handle too, but on GitHub it is a different person (Björn Feld, deny-listed) — the slug is correct on LinkedIn and X, and wrong on GitHub. Do not generalise either way.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

**The Techstars half of the label is weak:** *Give First* is now hosted by **David Cohen, not Feld**.
Don't attribute its episodes to him.

## Fetch
| url | what |
|---|---|
| `https://feld.com/index.xml` | 20 full-text items; `/feed/` 302s here |
| `https://feld.com/archives/` | **2.5 MB — the whole 22-year index on one page.** 5,551 posts |
| `https://feld.com/books/` · `/films/` · `/tags/` | 9 books, 12 documentaries, tag index |
| `https://zeroknowledge.ink/` | serialized novel, 47 chapters, newsletter only |
| `https://adventuresinclaude.ai/` | posts by him and by "Phin Argofy", his AI collaborator |
| `https://foundry.vc/team` | confirms General Partner, 2026 |
| `https://anchorpointfoundation.org/` | co-run with Amy Batchelor |
| `https://www.goodreads.com/author/show/4395710.Brad_Feld` | he says he lists **everything he reads** here |
| `https://www.youtube.com/feeds/videos.xml?channel_id=UClebMzrpRNTWVfZXw2jfsSw` | Techstars channel |
| `https://en.wikipedia.org/w/index.php?title=Brad_Feld&action=raw` | thin, carries a citation-needed |
| `https://api.fxtwitter.com/bfeld` · `https://x.com/bfeld` | counts; SESSION |
| `https://www.linkedin.com/in/bfeld/` | SESSION. Linked from his own `feld.com` footer. "Partner at Foundry", Boulder, **341,009 followers** (below his X count, so it does not move his tier); names the Anchor Point Foundation with Amy Batchelor |

**Open lead:** Foundry Group Form D / ADV on EDGAR were never probed. UNVERIFIED, not absent.

## Never fetch
- `github.com/bfeld` — **Björn Feld.** No verified Brad Feld GitHub account exists.

## Inner circle (one hop)
Amy Batchelor, his wife — Anchor Point, co-author of *Startup Life* (`family_or_partner`; facts reached
through her render, tagged `via_edge_type` — DEC-12). Jason Mendelson (*Venture Deals*). David Cohen (Techstars). "Phin Argofy" is an AI, not a
person — a fact about him, not a `person` row.

## Edges
- **Feld ↔ Wilson: ~296 mutual citations.** **Feld ↔ Ries:** startup-communities, immigration policy,
  elections, plus a **2026 fireside chat** — one of only two verified co-recordings in the whole set.
- **Feld ↔ Walk:** Foundry is an LP in Homebrew, in Feld's own words (2014-05-27).
- **Measured absence:** all 5,551 posts contain **zero** occurrences of Tavel, Huffman, Shear,
  Qureshi, Perkins. ⚠️ Caveat that must go in the evidence string: feld.com now serves a Pagefind
  WASM index that could not be queried headlessly, so this is not a *complete* exclusion.
- **Feld ↔ Qureshi share `reading-and-books` with zero documented contact** — the best pure-topic
  pairing in the set, and the case the engine should introduce *honestly*.

## Topics needing evidence
`venture-capital-craft` (non-discriminating), `startup-communities`, `tech-policy-immigration`,
`reading-and-books`, `endurance-running` (tags ultramarathon / barkley-marathons / western-states).
`ultrarunning` is an alias — canonicalise.

## Deep cut
Rich and easy. Known veins: "Random Day" — meeting strangers for 20 minutes on request since ~2004,
once in a Cookie Monster costume; a 50-mile ultramarathon in 2012 blogged across five posts; in 1987
he made every employee of his first company read *Zen and the Art of Motorcycle Maintenance*; his AI
collaborator has a name and a pronoun and his wife calls it "Clod".

## Also store: the shape of his output
2005–2020 near-daily, then **2021: 69 · 2022: 15 · 2023: 29 · 2024: 1**, then a deliberate revival
(2025: 65 · 2026: 30 through Aug). A host must not assume continuity across that gap.

## Backfill / auth
`career_start_decade` from Wikipedia, cross-check "his first company, 1987". Respelling NULL.
Everything of his is open; a LinkedIn/X failure costs only the follow-graph.
