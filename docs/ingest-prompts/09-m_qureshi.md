# `m_qureshi` · Nabeel Qureshi

Writer and researcher. Prominence 3 (X 37,922). Seniority individual. Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_qureshi.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_qureshi-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_qureshi_<date>`, `f_qureshi_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/nabeelqu`. It is HIS, and it was wrongly filed under "Never fetch".** A slug IS attested: **`nabeelqu.co` lists it in his own contact block** (`LinkedIn: nabeelqu`), which is `linked_from_own_canonical` (STRONG). The archived profile of 2026-01-23 matches his own site on three independent fields — **Mercatus Center at George Mason University**, **University of Oxford**, **New York City metropolitan area** — and his site says he was "a Visiting Scholar in AI at the Mercatus Center". Live top card, 2026-09-03: **"Founder/CEO at Stealth"**, 2,615 followers. ⚠️ **This is NOT one of his name collisions.** The deceased apologist is a different person and now sits at the disambiguated title **`Nabeel_Qureshi_(writer)`** — a trap sharpened by the fact that this project's own label for our subject is "writer and researcher". See the disambiguation section below.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

## Disambiguation — read before anything else
**"Nabeel Qureshi" is a heavily-collided name, and one collision is a dead man.**
- `en.wikipedia.org/wiki/Nabeel_Qureshi` **and now `en.wikipedia.org/wiki/Nabeel_Qureshi_(writer)`**
  are **a different person** — the Christian apologist, **1983–2017**, `occupation = Christian
  evangelist`, categories `1983 births` / `2017 deaths`. **Our subject has no English Wikipedia
  article.** ⚠️ The disambiguator Wikipedia chose is **`(writer)`**, and this project's own label for
  our subject is *"writer and researcher"* — the wrong person's URL now contains the right person's
  job title. This has already misled one reviewer. Our subject is **alive** (GitHub push 2026-09-03).
- There is also a **Pakistani film director** of the same name.
- `instagram.com/nabeelqu` is **"Nabeel qurban Ali"** — a third person.

Any name-based lookup pulls the wrong person. A deceased candidate is **never auto-resolved**.

## Fetch
| url | what |
|---|---|
| `https://nabeelqu.substack.com/feed` | **start here. 14 items with full bodies**, 2019 → 2026-05-03. Strictly better than his own feed |
| `https://nabeelqu.co/` | richest single artifact — essays, projects, interviews. See the trap below |
| `https://nabeelqu.co/rss` | valid RSS but **title-only, no bodies**. Inferior |
| `https://api.github.com/users/nqureshi` | ⚠️ handle is **`nqureshi`**. 25 repos, **11 commits in Sept 2026** |
| `https://api.fxtwitter.com/nabeelqu` · `https://x.com/nabeelqu` | name="Nabeel S. Qureshi", 37,922 followers. **Header renders logged out**; timeline flaky |
| `https://minutes.substack.com/p/rented-virtue` | with Will Manidis, 2026-02-10, **fully readable, no paywall** |
| `https://www.linkedin.com/in/nabeelqu` | SESSION; Wayback `20260123092938` is the GREEN fallback. Slug attested from his own contact block on `nabeelqu.co`. Live headline **"Founder/CEO at Stealth"**, 2,615 followers |
| `https://www.newstatesman.com/science-tech/2026/05/art-against-the-machine` | 2026-05-23, **partial — 3 paragraphs then a wall** |
| the `INTERVIEWS` table on `nabeelqu.co`, incl. `dialectic.fm/nabeel-qureshi` (2026-06-29) | **a ~120k-char public transcript** — the best voice source in the project |

Linked but never fetched, so UNVERIFIED: the WIRED "Waluigi Effect" piece, and the Mercatus SSRN paper.

## Never fetch
- `en.wikipedia.org/wiki/Nabeel_Qureshi` **and `…/Nabeel_Qureshi_(writer)`** — the deceased apologist.
  He was moved to the `(writer)` title after the audit, so a denial keyed on the bare URL misses him
- `instagram.com/nabeelqu/` — a different person. **No Instagram account for our subject was found**
- `github.com/nabeelqu` — also 200, but a **nameless empty account**. Real handle is `nqureshi`
- TikTok `@nabeelqu` — 2 followers, no bio, dead handle
- ⚠️ **`linkedin.com/in/nabeelqu` was listed here in error and has been moved to Fetch — it is HIS.**
- **No authored book.** A negative finding. **His current startup is stealth — do not name it**

## The trap — a challenge, not an auth wall
`nabeelqu.co` sits behind a **Vercel bot challenge**: every curl and WebFetch returns **429** with
`x-vercel-mitigated: challenge`. The usual fallback also failed — Wayback CDX returned **503**.
It is trivially readable by a human and non-trivially by a naive scraper. **Route it through a real
headless browser**, which solves the challenge legitimately. Don't bypass the checkpoint any other
way. If you can't render, the Substack feed carries more content anyway.

## Inner circle (one hop)
**Will Manidis** — co-bylined "Rented Virtue" on his Substack *Minutes*. The Dialectic host. Mercatus.

## Edges
- **Qureshi ↔ Feld share `reading-and-books` with ZERO documented contact.** The clearest case in the
  audit: deep, repeatedly-documented shared interest, no contact at all. **This is exactly the pair
  the engine should introduce** — and it must say so honestly rather than implying a connection.
  Record the absence with the corpora named.
- **Measured absences:** Tavel's 113 posts — zero. Feld's 5,551 — zero. Open Library — zero. He is
  absent from the *Uncensored* TOC.

## Topics needing evidence
`essay-craft`, `reading-and-books`.

## Deep cut
Known vein: a **chess endgame kata trainer he vibe-coded**, closing a loop he opened in a 2020 essay —
the repo is on `nqureshi`. The 120k-char transcript is the best raw material for a sayable line.

## Recency — he is very live
X 2026-08-31 · essay 2026-05-02 · New Statesman 2026-05-23 · Dialectic 2026-06-29 · GitHub Sept 2026.
If you conclude otherwise you hit the Vercel challenge and mistook it for silence — that's `unknown`.

## Backfill / auth
`career_start_decade` — **settled: 2000s**, from LinkedIn (Oxford 2007–2010) — it is not hard-walled.
Respelling **needed** — source it from the interview audio or leave NULL. Never guess a pronunciation.
Surface the headless-browser requirement if you can't render.
