# `m_qureshi` · Nabeel Qureshi

Writer and researcher. Prominence 3 (X 37,922). Seniority individual. Read `00-COMMON.md` first.

## Disambiguation — read before anything else
**"Nabeel Qureshi" is a heavily-collided name, and one collision is a dead man.**
- `en.wikipedia.org/wiki/Nabeel_Qureshi` returns 200 and is **a different person** — the Christian
  apologist, **1983–2017**. **Our subject has no English Wikipedia article.**
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
| `https://www.newstatesman.com/science-tech/2026/05/art-against-the-machine` | 2026-05-23, **partial — 3 paragraphs then a wall** |
| the `INTERVIEWS` table on `nabeelqu.co`, incl. `dialectic.fm/nabeel-qureshi` (2026-06-29) | **a ~120k-char public transcript** — the best voice source in the project |

Linked but never fetched, so UNVERIFIED: the WIRED "Waluigi Effect" piece, and the Mercatus SSRN paper.

## Never fetch
- `en.wikipedia.org/wiki/Nabeel_Qureshi` — the deceased apologist
- `instagram.com/nabeelqu/` — a different person. **No Instagram account for our subject was found**
- `github.com/nabeelqu` — also 200, but a **nameless empty account**. Real handle is `nqureshi`
- TikTok `@nabeelqu` — 2 followers, no bio, dead handle · LinkedIn `/in/nabeelqu` hard signup wall
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
`career_start_decade` — no Wikipedia; LinkedIn (hard-walled) or his "More About Me" section.
Respelling **needed** — source it from the interview audio or leave NULL. Never guess a pronunciation.
Surface the headless-browser requirement if you can't render.
