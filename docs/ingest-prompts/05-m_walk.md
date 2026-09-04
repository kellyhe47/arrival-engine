# `m_walk` · Hunter Walk

Homebrew, San Francisco — label current. Prominence 3 (X 246,611). Seniority principal.
Read `00-COMMON.md` first.

**Ten of these are running in parallel right now.** Write to **`db/arena.m_walk.db`**, never to `db/arena.db`, and keep your writes as replayable SQL in `ingest/sql/m_walk-NN-*.sql` — the operator merges the ten files at the end. Namespace your ids (`run_ingest_walk_<date>`, `f_walk_NNN`), `INSERT OR IGNORE` any one-hop non-member, and **append** to `ingest/BLOCKERS.md` rather than overwriting it. See the parallel-run section of `00-COMMON.md`.

**LinkedIn — CONFIRMED `linkedin.com/in/hunterwalk`.** A slug IS attested: **`hunterwalk.com` carries a "More of Me?" block** linking his LinkedIn, **Instagram (`instagram.com/hunterwalk`)**, Bluesky and **Threads (`threads.net/@hunterwalk`)** — all `linked_from_own_canonical` (STRONG). That block is also why the "Threads unverified" note below is obsolete. Measured 2026-09-03: headline "Funding Startups via Homebrew and new VCs via Screendoor LP"; Experience gives **Linden Lab from Jan 2001** and **Google Nov 2003 – Feb 2013**, which settles `career_start_decade`. ⚠️ **His LinkedIn shows 882,825 followers — 3.6x his X figure.** Under the stored ladder that is tier 4, not the seeded 3. **Do not re-baseline the row yourself** (00-COMMON forbids it); report the drift and leave it. A public post of his names **"my wife Caroline Barlerin"** — the `@cbarlerin` in his X bio, now confirmed.

**Walk the WHOLE following list, not the first page.** Record how many of the claimed total you actually reached. Real wheel events only (programmatic scrolling does not page the list), reload to clear a stalled virtualizer, and scope selectors to the primary column so the "Who to follow" rail never leaks into the graph.

## Fetch
| url | what |
|---|---|
| `https://hunterwalk.com/wp-json/wp/v2/posts` | **use this, not the RSS.** Header `x-wp-total: 1761` lifetime; `?after=2026-03-01` → 27. Fully open |
| same, `?search=Five+Questions+With` | **103 posts.** His interview series is *text on his own blog* — the whole series is the transcript. Rich edge corpus |
| `https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=hunterwalk.com` | **fully readable, no auth.** Latest 2026-09-02 |
| `https://api.github.com/users/hunterwalk` | **identity confirmed** by the name field. 0 repos — a claimed handle, not a code presence |
| `https://www.youtube.com/feeds/videos.xml?channel_id=UC68ai6rdol6MOTe_4b6T-wQ` | confirmed his. 15 crowd-shot concert clips 2012–2024 — the `live-music` evidence |
| `https://api.fxtwitter.com/hunterwalk` | 246,611 followers, **1 tweet**, website `hunterwalk.com`, bio `🚀@homebrew 💰@screendoorvc 👨‍👩‍👧@cbarlerin 🐶@daisyfleets` |
| `https://www.linkedin.com/in/hunterwalk/` | SESSION. **882,825 followers — 3.6x his X count.** Experience settles `career_start_decade`: Linden Lab Jan 2001, Google Nov 2003–Feb 2013 |
| `https://www.instagram.com/hunterwalk/` · `https://www.threads.net/@hunterwalk` | both linked from his own "More of Me?" block — `linked_from_own_canonical`, so identity is STRONG even though the platforms are walled |
| `https://www.homebrew.co/blog` | **separate corpus**, firm news. **Byline not exposed — UNVERIFIED whether he writes it.** Don't attribute |

## Never fetch / dead ends
`homebrew.co/feed` 404 · `hunterwalk.com/archives` 404 (use the REST API) · `wp-sitemap.xml` 404 ·
`hunterwalk.substack.com` exists but **archive count 0** · `medium.com/@hunterwalk` 403 ·
TikTok `@hunterwalk` has **3 followers** · **no Wikipedia article** ·
`news.ycombinator.com/user?id=hunterwalk` **429 twice, body "Sorry."** — rate-limited, *not* absent

## His X identity — the weakest accepted in the set
246,611 followers, **one tweet**, and the display name is an **emoji**, so there is no name field to
match. Accepted on three WEAK signals from different sources: `website` = his confirmed domain; bio
names `@homebrew`; display name is the **identical string** as his verified Bluesky. That clears the
≥2-WEAK bar, barely. **`hunterwalk.com` carries no link to X** — checked, and that's why it isn't
STRONG. A SESSION read would upgrade it. Evidence it is *not* him is a deny-list row and a finding.

## Inner circle (one hop)
From his own bio: `@homebrew`, `@screendoorvc`, **`@cbarlerin`** (`family_or_partner` — DEC-12:
facts reached through them render, tagged `via_edge_type`), `@daisyfleets` (a dog — not a `person` row). **Satya Patel**, named by Feld as his Homebrew
co-founder. The **103 "Five Questions With…" interviewees** are a large open edge corpus.

## Edges — he is the best-connected of the ten
- **Walk ↔ Ries, STRONG:** they **co-curated *Uncensored*** (Leanpub, Jan–Feb 2012). His words:
  *"In January Eric Ries and I curated an ebook called Uncensored…"*
  ⚠️ **Ries's own 392 posts never mention it** — documented from Walk's side plus Leanpub only.
- ***Uncensored* puts five of the ten in one artifact:** Kopelman, Wilson, Feld, Ries, Walk.
  **Absent: Tavel, Huffman, Shear, Perkins, Qureshi.**
- **Walk → Wilson** and **Walk → Feld** from that same sentence. **Walk ↔ Feld:** Foundry is an LP in
  Homebrew. **Walk → Kopelman:** he names him as institutionalising seed-stage financing.
- Tavel's *Adventurista* names him (her side).

## Topics needing evidence
`venture-capital-craft` (non-discriminating), `seed-stage-financing` (canonicalise the alias),
`live-music` (the YouTube clips). Also measured: `startup-boards`, `tech-policy-elections`.

## Deep cut
Known veins: in therapy since 2011, blogged the ten-year anniversary; the **"failure tiger"**, a
private metaphor reused for 7+ years; coffee and paper notebooks (the `☕️` in his display name is
the same fact twice); **his first concert was Madonna in 1985 and the Beastie Boys opened and got
booed.**

## Backfill / auth
`career_start_decade` — **settled: 1990s–2000s boundary, take it from LinkedIn** (Linden Lab Jan 2001, Google Nov 2003). Respelling NULL.
**`prominence_basis` is now 246,611** — the old Bluesky floor of 5,371 was 45× low; don't regress it.
Almost everything of his is keyless and open. He should be your most complete profile; if he isn't,
say what went wrong.
