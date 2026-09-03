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
      1, 1, 10, 'Tavel — Adventurista: "I can''t believe I played for four years"'),
  ('board-games',           'personal',     'Board and strategy games',
      1, 1, 10, 'placeholder used by G-017; NOT audit-backed — must be sourced or removed');

-- Slug collisions found mechanically across the fixture set. P0-6.
INSERT INTO topic_alias (alias, canonical) VALUES
  ('seed-stage-investing', 'seed-stage-financing'),   -- used 5x vs 1x; audit 06 §5 uses -financing
  ('ultrarunning',         'endurance-running');      -- used 3x; audit uses endurance-running

-- ── prominence_tier: the derivation, so it is measured rather than asserted ────
-- P0-6 flagged this as having zero audit backing. It is derived from ONE citable quantity:
--   tier 4 : >= 250,000 followers on any single platform, OR a Wikipedia article exists
--   tier 3 : 25,000 - 249,999
--   tier 2 : 1,000 - 24,999
--   tier 1 : < 1,000
-- Measured values on record (audit 01/03/07):
--   Wilson  X 640,800 followers            -> 4
--   Perkins LinkedIn 370,639 followers     -> 4
--   Ries    X 301,419 followers            -> 4   ** fixtures currently say 3 — see note **
--   Shear   Wikipedia article exists       -> 4
--   Tavel, Walk: NO Wikipedia article (both measured 404) -> tier from follower count, unmeasured
--   Qureshi: no large following measured    -> 2
--
-- NOTE, and it is a real one: applying this rule moves Ries from 3 to 4, which changes whether S8
-- fires in G-006 and G-017. That is P0-8 (contradictory member attributes) surfacing again. The
-- canonical cast must be DERIVED from this table, not hand-written into fixtures. Do not paper over
-- it by editing the expectations.
