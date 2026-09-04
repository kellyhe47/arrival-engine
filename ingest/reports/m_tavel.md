# m_tavel — Sarah Tavel

Store: `db/arena.m_tavel.db` (per-person, to avoid colliding with the other nine ingest agents).
`db/arena.db` is left as the untouched roster seed. Rebuild recipe and merge notes:
`ingest/sql/m_tavel-00-README.md`.

```
Status:     partial (1 blocker)
Sources:    16 attempts — 13 ok, 2 unavailable, 1 skipped
Written:    51 facts (51 renderable), 28 edges (6 assertable absences), 14 contexts
Recency:    unknown — but she is ACTIVE, and the prompt's "stale" premise is OVERTURNED. Her blog
            has been silent for twelve months (newest Substack post 2025-09-03, exactly a year
            before this run) and Medium since 2024-04-02 — but she posted on X on 2026-08-31,
            THREE DAYS before this run, and reposted portfolio founders on LinkedIn one week
            before it. v_recency_state reads `unknown` only because three source attempts did not
            return `ok`. Do NOT downgrade this to `quiet`, and do not call her dormant.
Deep cuts:  The "-ista" is a feminist joke and she says so outright: "Because I initially started
            my blog with the intention of blogging from the perspective of a female, junior
            professional (hence the 'ista' in Adventurista)." Her two biggest tags were
            "La Feminista (12)" and "La Environmentalista (5)".
            https://web.archive.org/web/20091103004637/http://www.adventurista.com/2009/09/my-ista-take-on-larry-chengs-vc-blog.html
            A six-year callback inside her own blog. Dec 2006, on landing a junior VC job:
            "(Whoo hoo! Corporate Jet!)". Mar 2012, hiring her replacement: "I regret to inform
            you that Bessemer does not have a corporate jet."
            https://web.archive.org/web/20120316012453/http://www.adventurista.com/2012/03/hiring-associate-at-bessemer.html
            Her own About Me, c.2011: "While in college I became a Kant fanatic and, despite my
            parents' best wishes, majored in Philosophy... Before Bessemer, I founded and ran a
            general contracting business (don't ask), sold a lot of local ads... I was also
            captain of Harvard's varsity women's rugby team, so watch out. I still know how to
            tackle." Blog tagline underneath: "don't mess with me".
            https://web.archive.org/web/20110321005110/http://www.adventurista.com/2011/03/big-thank-you-to-cornerstone-ondemand.html
            SHE IS NO LONGER A GENERAL PARTNER. 2025-04-29: "After eight years at Benchmark, I'm
            shifting to a Venture Partner role." https://www.sarahtavel.com/p/my-new-role-at-benchmark
            Her mother, in her own words: "@susavel. Immigrated to the US from Argentina in 1973
            with a suitcase, $200, and one share of IBM stock... Raised five kids." (X, 2021-05-09)
            — and on the podcast, "I remember going to Argentina and having somebody on a
            motorcycle come to exchange money."
            Keeps a written pre-mortem on every company she diligences, crediting Annie Duke's
            *Thinking in Bets*, and names her own miss in the same breath: "I passed on a company
            because the valuation was too high... this company Mercado."
            Why the blog is quiet, from her, 2026-08-30: "The secret fear they keeps making my
            blog post draft list longer and longer. 🤣"
New denies: none. No NEW collision measured. Eight new ALLOW rows instead, one of them written
            `role='negative_probe'` — TikTok, below.
```

## Not established

- **That `tiktok.com/@sarahtavel` is her.** It renders logged out and it is exactly the nothing the
  prompt said: 716 followers, **one video, ever**, 107 views. But the only corroboration available
  is `handle_matches` + `display_name_matches`, **both WEAK and both from the same platform** —
  precisely the pair R-012 forbids, and precisely the `@spez` shape. The bio is "💫💯"; there is no
  backlink. Recorded as `negative_probe` so `v_collectable_source` excludes it. **No fact was
  written from it, and it is not on the deny-list either** — unresolved is not proven-wrong.
- **Anything behind her Instagram.** The session works and the profile reads; the account is
  **private**, which answers the prompt's open question ("Public vs private cannot be determined")
  — it is private, measured. 119 posts, 623 followers. No caption, location tag or post date is
  obtainable, so Instagram contributes **zero** S4 context.
- **The roster's "113 archived posts" for Adventurista.** Measured is **104** distinct post URLs
  (103 from a CDX sweep, 1 recovered by hand), 2006-12-03 → 2015-10-07. 113 is not reproducible
  from the CDX index and is not restated as measured. Likewise the roster's **14 EDGAR filings**:
  measured is **17**, all Forms 3/4/5, and there are **no Form Ds** despite the prompt saying so.
- **Her lifetime Medium corpus.** The feed is a **ten-item window**, not a total — the HTML profile
  403s, so no archive count is obtainable. "10 items" is what the feed shows, not what she wrote.
- **Her follow graph.** The 1,435-entry X following list was **not walked** — it is virtualized and
  the spec calls it a slow batch job, not a request-time read. So `follows` was written in **no**
  direction, and no `no_edge_confirmed` was written against it either (R-011). What *was* searched
  is her own post corpus, and that is what the six absences rest on.
- **Whether Wilson, Walk or Kopelman reciprocate.** Every edge here is directed **out of** her. The
  reverse direction is another agent's corpus.
- **`name_respelling`. Left NULL, and it is the one the prompt asked for.** "Tavel" is genuinely
  not obvious. The Every.to episode has audio and video, but only the **transcript** was read, and
  a transcript cannot source a pronunciation. Guessing this column is forbidden, so it stays NULL
  until someone listens to the recording.
- **`blogging-practice` and AI-and-work have no vocabulary slug**, so neither could be tagged. This
  is a real gap: blogging is arguably her single best-evidenced personal topic — it is the subject
  of her first post, of the "-ista" explanation, of all four Fred Wilson citations and of her
  newest X post — and AI-and-work is the only thing she has written about since 2023.

## What changed under the prompt

- **The label is drifting and `member_label` was deliberately NOT rewritten.** Roster says
  "Benchmark, Partner", basis = her Substack bio, which still reads "Partner @benchmark" — as does
  her X bio and her LinkedIn headline. But her own 2025-04-29 post says she moved to **Venture
  Partner**, and Benchmark's model, which she herself describes as "no more than six general
  partners", makes that a real distinction, not a synonym. Recorded as `f_tavel_001`. The row is
  left alone because every source the row cites still says "Partner"; the operator should decide.
- **The prompt's "@cklemke resolves to Christine Lemke — verify before creating an edge" is now
  verified twice over, from her own words on two platforms.** `api.fxtwitter.com/cklemke` gives
  `name: "Christine Lemke"` (STRONG, `api_name_field_matches`), her X bio says "Ball and chain for
  @cklemke and 🧒🏽👧🏻👶🏻", and her Instagram bio says "Co-founder with @cklemke of @marcotavel".
  Written as `family_or_partner`, strength MEDIUM. The MEDIUM is honest: "ball and chain" and
  "co-founder of [a child's account]" are idioms, and the reading is an interpretation of them.
- **Adventurista names Fred Wilson four times — confirmed, and all four are about BLOGGING**, which
  is exactly the shape the prompt predicted: "hers is about him". "Fred Wilson is our Marc Benioff"
  (2009-11-23); "on how Fred Wilson continues to lead the VC blogging show" (2009-09-09); "I don't
  know how Fred Wilson does it" (2010-06-29); and a whole post answering his (2010-07-20).
- **The clean zero across all 104 posts is confirmed** for Kopelman, Huffman, Shear, Ries, Qureshi
  and Perkins, and for the strings "Twitch" and "Lean Startup". But **Kopelman is NOT a zero
  overall** — X shows two replies to `@joshk` ("wow that was pretty good", 2016-08-21; "great way
  of putting it", 2019-01-11), so no absence was written against him.
- **Hunter Walk is much stronger than one Adventurista mention.** Seven years of X replies, in a
  register she uses with nobody else in the set: "Not too much of a break please. I depend on his
  social validation of my tweets. Happy birthday Hunter!" (2020-09-18).

## Notes an implementer needs

- **The Wayback warning was heeded and the number is in the store.** CDX returned 806 rows; 103
  distinct post URLs survived filtering; **103/103 fetches succeeded and the failure count (0) was
  recorded**, at concurrency 1 with a 1.5 s pace and four retries with backoff. `source_status`
  carries the count. Had any failed, the six `no_edge_confirmed` rows would not have been written.
- **`f_tavel_051` is the corpus-naming fact the six absences point at**, and `v_assertable_absence`
  returns exactly those six. K-5's error class is structurally excluded, not avoided by care.
- **The Substack archive API gives a real total where the RSS gives a window.**
  `/api/v1/archive?sort=new&limit=50&offset=0` returns **23** and `offset=50` returns `[]`, so 23
  is her lifetime output there — 0.74 posts/month, eight of them in Jan–Sep 2025. The 20-item RSS
  feed would have looked like the same thing and been a coincidence.
- **LinkedIn was the single richest artifact for her, and it is the ONLY source for two things**:
  `career_start_decade` (The Kerdan Group, Jun 2005 — no Wikipedia article exists, confirmed 404)
  and the rugby captaincy in a form the roster's topic can cite. The slug was **not guessed**: its
  Websites block links `sarahtavel.com`, already confirmed hers, and its experience list reproduces
  the Bessemer → Pinterest → Greylock → Benchmark sequence her own Substack bio states and the SEC
  independently binds.
- **Personalization was stripped at the boundary, not filtered later.** Discarded and never stored:
  every `· 3rd`, "More profiles for you", "Explore Premium profiles", "Pages for you", "N other
  connections work here", X's "Followed by …" line and Who-to-follow rail, Instagram's "Suggested
  for you" rail, and the operator's own search history, which LinkedIn renders inside the profile's
  own accessibility tree.
- **Rugby is corroborated across twenty years by two independently written sources** — her 2011
  blog blurb and her 2026 LinkedIn education entry — which is why `f_tavel_050` exists as an
  `inferred` fact with both in `composed_from` rather than as a bare assertion.
- **`context` for Argentina is `resolved=0` on purpose.** She has never said she lives in or is
  from Argentina; her mother emigrated from it and she has family there. A `resolved=0` context
  never matches for S4, which is the correct behaviour — the alternative manufactures a shared
  "place" between her and anyone who has been to Buenos Aires.
- **§7.8 has a gap for her.** Her only current professional topic is AI-and-work and the vocabulary
  has no slug for it, so her three tagged topics are all things she wrote about before 2016 or
  played in college. Do not fix this by widening an existing AI tag — that is the exact
  Huffman/Shear/Tavel merge the audit forbids.
- **benchmark.com was fetched once, at 2,297 bytes, and not probed again.** Name, two addresses
  (140 New Montgomery SF; 2965 Woodside Road, Woodside CA), one link to @benchmark. `/people` 404s.
- **Prominence untouched.** fxtwitter now reads 52,899 against the roster's 52,896 — drift of
  three, not a new measurement, not written.
- One hop only. 17 non-members written, all `is_member=0`. Nothing traversed further. No
  `third_party_open` row exists for her — no tagged tab was fetched, and her Instagram is private
  anyway.

## Blockers

- `facebook_session` — no operator session on this machine, and the URL tried was a guessed vanity
  slug that establishes nothing either way. See `ingest/BLOCKERS.md`.
- Not blockers, but recorded there so nobody re-files them: `instagram_session` is `ok` and the
  grid is closed **by her privacy setting**; `tiktok_public` is `unavailable` for an **identity**
  reason, not an access one.
