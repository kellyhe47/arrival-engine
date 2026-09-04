# m_huffman — Steve Huffman

Store: `db/arena.m_huffman.db` (isolated per-person store; `db/arena.db` was not written).
Replay instructions: `ingest/sql/m_huffman-00-README.md`.

```text
Status:      partial — one material auth blocker
Sources:     20 attempts — 17 ok, 2 unavailable, 1 deliberately skipped
Written:     31 facts — 30 renderable, 1 withheld: finance
             12 directed edges — 4 positive, 8 assertable measured absences
             7 contexts, 3 one-hop non-members, 1 new deny-list collision
Recency:     unknown — live Reddit could not be read; this is not a quiet profile
Prominence:  tier 2 — LinkedIn 8,128 followers, measured 2026-09-03
```

## What changed

- **The supplied LinkedIn slug is wrong.** A logged-in read and the archived copy both resolve
  `/in/shuffman/` to Sarah Huffman at Healthvana. It is now a deny-list row. YC's official Reddit
  founder record links Steve Huffman to `/in/shuffman56/`; the live profile matched Reddit, San
  Francisco, and the University of Virginia. Its Activity page showed 8,128 followers. Operator
  identity, connection degree, “followed by” text, and recommendation rails were discarded.
- **Prominence is no longer NULL.** This is a first measurement, not follower-count drift:
  8,128 falls in the stored 1,000–24,999 band, so `prominence_tier=2`. S8 may now use Huffman's
  tier, subject to the scoring model's substrate gate and the existing cross-platform caveat.
- **The SEC is the primary current channel.** The Q2 2026 shareholder letter is signed by Huffman
  and supplies quotable first-person product direction. Corporate moderation metrics remain
  attributed to Reddit, not rewritten as personal observation. The SEC-filed release also
  designates u/spez as a Regulation FD disclosure channel.
- **Career start is backfilled to the 2000s.** Wikipedia records the 2005 UVA graduation, YC entry,
  and Reddit launch; the SEC prospectus independently records his Reddit and Hipmunk history.
  `name_respelling` remains NULL because no pronunciation source was reviewed.
- **`content-moderation` now has evidence.** The current SEC letter describes AI plus
  community-led moderation; the 2010 Mixergy transcript supplies historical first-person context.

## Relationships and measured absences

- Huffman and Emmett Shear share the **Y Combinator Summer 2005** cohort: Reddit and Kiko are both
  official S05 companies. The stored edge is `shared_org`, STRONG, directed out of Huffman's
  sidecar only. It does not assert direct interaction. Justin.tv/Twitch is not the batch bridge.
- The citation asymmetry is preserved. Across all **67 HN comments by `spez`**, the strings
  `emmett`, `shear`, and `kiko` occur zero times. No `cited_in_own_writing` edge was created.
- Alexis Ohanian is linked as Reddit co-founder; Michael Seibel as a Reddit director since 2020;
  Adam Goldstein as Hipmunk co-founder. All three are one-hop non-members. Goldstein's Softmax
  board role is recorded only as bridge context—no second hop was traversed.
- Eight `no_edge_confirmed` rows cover Wilson, Feld, Kopelman, Tavel, Walk, Ries, Qureshi, and
  Perkins. Every row points to a fact that names the searched corpus: Huffman's full 67-comment HN
  set plus Reddit's 424B4. Feld's supplied 5,551-post body corpus and Tavel's supplied 113-post
  Adventurista audit are named on their reciprocal rows. The separate Tavel ingest reproduced 104
  distinct archived URLs, so this run records 113 as supplied audit scope, not as a new count.

## Deep cuts

- The SEC formally names u/spez as a Regulation FD channel.
- In archived Reddit comments, Huffman lays out a specific Twizzlers → Red Vines → Good & Plenty
  licorice hierarchy, says Weird Al Yankovic was his first concert, and describes his Cavapoo as an
  eight-year-old puppy. The source is a 2022 Wayback snapshot, never live Reddit.

## Suppression and limits

- One verified SEC Form 4 fact is stored with `suppression_class='finance'`. Its content is excluded
  from `v_renderable_fact`; only **“1 withheld: finance”** may reach a card. The scratch-only schema
  overlay and the pending schema request record this as a structural rule.
- Live Reddit remains auth-blocked, so no claim is made about Huffman's current posting cadence or
  complete lifetime corpus. Investor relations was deliberately not retried under the per-person
  protocol; equivalent SEC archive documents were available.
- No direct Huffman–Shear interaction, Huffman-authored Shear citation, or name pronunciation was
  established.

