-- Controlled vocabulary (closes most of P0-6).
-- Every slug below is one actually used in eval/golden/*.json, extracted mechanically, not invented.
-- `discriminating` is measured, not asserted — see the rule below.

-- ── Seniority ─────────────────────────────────────────────────────────────────
INSERT INTO seniority_tier (slug, rank, label) VALUES
  ('individual',      1, 'Individual contributor / independent'),
  ('principal',       2, 'Partner, principal, or equivalent'),
  ('founder',         3, 'Founder'),
  ('chief-executive', 4, 'Chief executive');
-- S1 requires the SAME tier, not an adjacent one. `rank` exists for display order only; it is
-- deliberately NOT used as a distance, because "one tier apart" is not a measured relationship.

-- ── Industries ────────────────────────────────────────────────────────────────
INSERT INTO industry (slug, label) VALUES
  ('venture-capital',   'Venture capital'),
  ('capital-markets',   'Capital markets / exchanges'),
  ('consumer-internet', 'Consumer internet'),
  ('ai-research',       'AI research'),
  ('design-software',   'Design software'),
  ('writing-research',  'Writing and independent research');

-- ── Topics ────────────────────────────────────────────────────────────────────
-- THE DISCRIMINATING RULE (P0-1):
--   discriminating = 0  WHEN  holder_count / base_size >= 0.40
-- Measured ONCE over the member base at ingest, stored here, room-independent.
-- Rationale: a tag held by two-fifths of the membership carries no information about a specific
-- pairing. The previous design made this a room statistic; that version was non-monotonic
-- (a fifth guest sharing your thesis deleted the match), room-size-inverted, and — decisively —
-- failed on the only case ever measured, because 5 of 10 is exactly 50% and the predicate was >50%.
-- base_size is stored so the flag can be recomputed and audited rather than trusted.
--
-- Holder counts below are from docs/audit/06-edges.md §5 "Computable topic overlaps",
-- measured across the ten stand-ins (base_size = 10).

-- `board-games` was removed 2026-09-03 (K-8): a placeholder with no audit backing and no holder in
-- db/roster.sql. G-017 was re-grounded on real edges and no longer needs it.
INSERT INTO topic (slug, kind, label, discriminating, holder_count, base_size, basis) VALUES
  ('venture-capital-craft', 'professional', 'The craft of venture investing',
      0, 5, 10, 'AUD-EDGES 06 §5: Wilson, Feld, Kopelman, Tavel, Walk — "the least discriminating tag in the set"'),
  ('startup-communities',   'professional', 'Building startup communities',
      1, 2, 10, 'AUD-EDGES 06 §5: Feld, Ries'),
  ('tech-policy-immigration','professional','Tech policy and immigration',
      1, 2, 10, 'AUD-EDGES 06 §5: Feld, Ries (Startup Visa Movement)'),
  ('seed-stage-financing',  'professional', 'Seed-stage financing mechanics',
      1, 2, 10, 'AUD-EDGES 06 §5: Kopelman, Walk'),
  ('reading-and-books',     'professional', 'Reading and books',
      1, 2, 10, 'AUD-EDGES 06 §5: Feld, Qureshi'),
  ('ai-alignment',          'professional', 'AI alignment',
      1, 1, 10, 'AUD-EDGES 06 §5: Shear only. Explicitly NOT merged with Huffman/Tavel AI tags.'),
  ('content-moderation',    'professional', 'Content moderation and platform governance',
      1, 1, 10, 'Huffman. Audit 06 §5 warns: do not collapse the three AI-adjacent tags.'),
  ('long-term-governance',  'professional', 'Long-term corporate governance',
      1, 1, 10, 'Ries / LTSE — SEC Form 1 order 34-85828, EDGAR CIK 0001757271'),
  ('crypto-protocols',      'professional', 'Crypto protocols and web3',
      1, 1, 10, 'Wilson — avc.com categories crypto=254, blockchain=254'),
  ('marketplace-dynamics',  'professional', 'Marketplace and network dynamics',
      1, 1, 10, 'Tavel'),
  ('product-led-growth',    'professional', 'Product-led growth',
      1, 1, 10, 'Perkins'),
  ('essay-craft',           'professional', 'Essay writing as a craft',
      1, 1, 10, 'Qureshi — nabeelqu.substack.com, 14 posts full text'),
  ('music-collecting',      'personal',     'Recorded music and collecting',
      1, 1, 10, 'Wilson — avc.com category "My Music" = 898 posts (~10% of lifetime output); corroborated visually, AUD-07-10'),
  ('endurance-running',     'personal',     'Endurance and ultra running',
      1, 1, 10, 'Feld — tags ultramarathon, barkley-marathons, western-states; 50-mile race 2012'),
  ('live-music',            'personal',     'Live music and concerts',
      1, 1, 10, 'Walk — own YouTube channel opened 2006-01-03, 15 crowd-shot concert clips'),
  ('rugby',                 'personal',     'Rugby',
      1, 1, 10, 'Tavel — Adventurista: "I can''t believe I played for four years"');

-- Slug collisions found mechanically across the fixture set. P0-6.
INSERT INTO topic_alias (alias, canonical) VALUES
  ('seed-stage-investing', 'seed-stage-financing'),   -- used 5x vs 1x; audit 06 §5 uses -financing
  ('ultrarunning',         'endurance-running');      -- used 3x; audit uses endurance-running

-- ── prominence_tier: the derivation, so it is measured rather than asserted ────
-- P0-6 flagged this as having zero audit backing. REVISED 2026-09-03 (K-7): the original rule read
--   "tier 4: >= 250,000 followers on any single platform, OR a Wikipedia article exists"
-- The `OR Wikipedia` clause was withdrawn. It stapled a boolean onto a follower ladder and the
-- boolean swallowed the top band: it put 7 of 10 in tier 4, four of them with NO follower figure
-- measured at all, so S8 could not fire between any pair of them. It was also WRONG in both
-- directions once the counts were measured — Kopelman and Shear were sitting at 4 on an
-- encyclopedia article with ~150k and ~123k followers, while Walk sat at 2 on a Bluesky floor of
-- 5,371 when his X account has 246,611. Wikipedia is a biography source, not a rung on a ladder.
--
-- THE RULE. One scale, one quantity: the HIGHEST MEASURED single-platform follower count.
--   tier 4 : >= 250,000
--   tier 3 : 25,000 - 249,999
--   tier 2 : 1,000 - 24,999
--   tier 1 : < 1,000
--   NULL   : never measured. S8 cannot fire in either direction. Absence is not tier 1.
--
-- The measuring instrument is free, keyless and unauthenticated: `api.fxtwitter.com/<handle>`
-- returns name, follower/following counts, bio and website (AUD-04 Tier B1 narrow exception).
-- It is the ONLY sanctioned use of an X mirror — counts and profile fields, never content.
--
-- Measured 2026-09-03, every figure re-pulled in one pass so they are mutually comparable:
--   Wilson    X  640,845  -> 4
--   Feld      X  388,685  -> 4
--   Perkins   LI 370,639  -> 4   (X is 56,591; see the cross-platform caveat below)
--   Ries      X  301,423  -> 4
--   Walk      X  246,611  -> 3   ** was 2 on a Bluesky floor. 45x wrong. **
--   Kopelman  X  150,180  -> 3   ** was 4 on the Wikipedia clause **
--   Shear     X  123,007  -> 3   ** was 4 on the Wikipedia clause **
--   Tavel     X   52,896  -> 3
--   Qureshi   X   37,922  -> 3
--   Huffman   ---------- -> NULL. He has NO usable X account: x.com/spez is a stranger (G-016),
--             @stevehuffman has 38 followers and @shuffman has 4 (AUD-02 §3.3). Reddit is closed
--             to logged-out reads. His figure is obtainable from SESSION LinkedIn (/in/shuffman),
--             the same source that produced Perkins' 370,639. Until then: unmeasured, S8 silent.
--
-- CAVEAT, recorded rather than hidden (K-9): "highest measured single-platform" mixes platforms.
-- Perkins reaches tier 4 on a LinkedIn figure while everyone else is ranked on X, so her tier rests
-- on a SESSION source the deployed runtime cannot reach. Tiers are computed once at ingest and
-- frozen into the file, so this is sound at runtime — but a follower on LinkedIn is not the same
-- unit as a follower on X, and the ranking is only as even as the platforms actually measured.
