-- THE ARRIVAL ENGINE — canonical cast. Closes P0-8.
--
-- This file is the ANSWER to "which ten people, and how do we know a page is one of them".
-- Every row is traceable to docs/audit/01-07; nothing here was inferred from a search snippet.
-- The fetch contract that consumes it is docs/ingest-spec.md.
--
-- Load order:  db/schema.sql  ->  db/vocabulary.sql  ->  db/roster.sql
--
-- WHAT IS DELIBERATELY NULL. Three person columns are unmeasured and must stay NULL until an
-- ingest run fills them from a named source. They are not oversights; asserting them would be the
-- exact error R-004 forbids:
--   career_start_decade  — feeds S1. Retrievable from Wikipedia wikitext for the 7 with articles;
--                          SESSION LinkedIn for Tavel, Walk, Qureshi. S1 cannot fire until then.
--   name_respelling      — R-034 wants NPR-convention respelling. A pronunciation must be SOURCED
--                          (the subject saying their own name on a fetched recording), never guessed.
--                          Candidates needing one: Tavel, Qureshi, Kopelman.
-- (m_walk.prominence_tier was in this list and is now MEASURED — see his row.)
--   person.prominence_tier for m_huffman — no measurable follower count exists on any GREEN source.

INSERT INTO run (id, started_at, finished_at, execution_ctx, notes) VALUES
  ('run_audit_20260903', '2026-09-03T00:00:00Z', '2026-09-03T23:59:59Z', 'operator_machine',
   'Measurement run behind docs/audit/01-07. Roster seed; not a content-ingest run.');

-- ── The ten ───────────────────────────────────────────────────────────────────
-- prominence_tier is DERIVED by the rule in db/vocabulary.sql, not hand-written (P0-8):
--   highest MEASURED single-platform follower count.
--   4: >=250,000   3: 25,000-249,999   2: 1,000-24,999   1: <1,000   NULL: never measured
-- RESOLVED 2026-09-03 (was K-7): the "OR a Wikipedia article exists" clause is WITHDRAWN. The rule
-- is now one scale — the highest MEASURED single-platform follower count — and every figure below
-- was re-pulled in a single pass so they are mutually comparable. Four tiers moved: Kopelman 4->3,
-- Shear 4->3, Walk 2->3, Huffman 4->NULL. Feld, Wilson, Ries and Perkins held. The result is
-- 4 at tier 4, 5 at tier 3, 1 unmeasured — S8 discriminates again.

INSERT INTO person
  (id, is_member, display_name, name_respelling, seniority_tier, career_start_decade,
   prominence_tier, prominence_basis, created_run) VALUES

  ('m_wilson', 1, 'Fred Wilson', NULL, 'principal', NULL, 4,
   'X 640,845 followers (api.fxtwitter.com, measured 2026-09-03, api_name_field_matches: name="Fred Wilson"). Highest measured single-platform figure',
   'run_audit_20260903'),

  ('m_feld', 1, 'Brad Feld', NULL, 'principal', NULL, 4,
   'X 388,685 followers (api.fxtwitter.com, measured 2026-09-03, name="Brad Feld"). WAS tier 4 on the withdrawn Wikipedia clause with no follower figure at all; now measured, and it holds',
   'run_audit_20260903'),

  ('m_kopelman', 1, 'Josh Kopelman', NULL, 'principal', NULL, 3,
   'X 150,180 followers, @joshk (api.fxtwitter.com, measured 2026-09-03, name="Josh Kopelman"). CORRECTED from 4: he sat at 4 on the withdrawn Wikipedia clause. 150,180 is the 25k-249,999 band',
   'run_audit_20260903'),

  ('m_tavel', 1, 'Sarah Tavel', NULL, 'principal', NULL, 3,
   'X 52,896 followers (api.fxtwitter.com, measured 2026-09-03, name="Sarah Tavel"); re-pull matched AUD-02 exactly',
   'run_audit_20260903'),

  ('m_walk', 1, 'Hunter Walk', NULL, 'principal', NULL, 3,
   'X 246,611 followers, @hunterwalk (api.fxtwitter.com, measured 2026-09-03). CORRECTED from 2: the old figure was a Bluesky floor of 5,371 and was 45x low. Identity on three WEAK signals from different sources — website field = hunterwalk.com, bio names @homebrew, display name is the identical emoji string as his verified Bluesky profile. No name field to match (his X display name is an emoji), so this is the weakest accepted identity in the set; a SESSION read would upgrade it',
   'run_audit_20260903'),

  ('m_huffman', 1, 'Steve Huffman', NULL, 'chief-executive', NULL, NULL,
   'UNMEASURED. He has no usable X account: x.com/spez is an unrelated stranger (G-016), @stevehuffman has 38 followers, @shuffman has 4 (AUD-02 §3.3, all three re-confirmed 2026-09-03). Reddit is closed to logged-out reads. He WAS tier 4 on the withdrawn Wikipedia clause. NULL means S8 cannot fire in either direction for him — that is correct, not a gap to paper over. Obtainable from SESSION LinkedIn /in/shuffman, the same source that produced Perkins'' figure',
   'run_audit_20260903'),

  ('m_shear', 1, 'Emmett Shear', NULL, 'chief-executive', NULL, 3,
   'X 123,007 followers, @eshear (api.fxtwitter.com, measured 2026-09-03, name="Emmett Shear"). CORRECTED from 4: he sat at 4 on the withdrawn Wikipedia clause',
   'run_audit_20260903'),

  ('m_ries', 1, 'Eric Ries', NULL, 'founder', NULL, 4,
   'X 301,423 followers (api.fxtwitter.com, measured 2026-09-03, name="Eric Ries"); AUD-03 read 301,419 the same day, so counts drift and measured_at matters. Tier 4 either way. Fixtures G-006/G-017 carry 3 — re-baseline them against this table, never the reverse (P0-8)',
   'run_audit_20260903'),

  ('m_qureshi', 1, 'Nabeel Qureshi', NULL, 'individual', NULL, 3,
   'X 37,922 followers, @nabeelqu (api.fxtwitter.com, measured 2026-09-03, name="Nabeel S. Qureshi"). AUD-03 read 37.9K. CORRECTS db/vocabulary.sql''s earlier "no large following measured -> 2"',
   'run_audit_20260903'),

  ('m_perkins', 1, 'Melanie Perkins', NULL, 'chief-executive', NULL, 4,
   'LinkedIn 370,639 followers (AUD-07, SESSION, logged-in linkedin.com/in/melanieperkins). Her X @MelanieCanva is 56,591 (api.fxtwitter.com, measured 2026-09-03, name="Melanie Perkins"), which alone is tier 3. She reaches 4 on a LinkedIn figure while the other nine are ranked on X — see the cross-platform caveat K-9 in db/vocabulary.sql',
   'run_audit_20260903');

-- Seniority is the CURRENT OPERATING ROLE, one value, measured. Founder-CEOs resolve to
-- chief-executive: Huffman, Shear and Perkins each founded their company AND run it today, and
-- S1 tests tier EQUALITY, so a person cannot hold two.

-- ── R-014 / R-015 — the door's label vs the measured one ──────────────────────
-- The brief's own roster is stale for Shear. A host who opens with "so, Twitch..." has damaged the
-- relationship before the handshake. `supplied_label` is verbatim from THE TEN as handed over.
INSERT INTO member_label (person_id, supplied_label, current_label, stale, basis, measured_at) VALUES
  ('m_wilson','Union Square Ventures, New York','Union Square Ventures, New York',0,
   'usv.com/people/fred-wilson/ 200; SEC IAPD firm_source_id 162375, 817 Broadway 14th Floor, New York NY 10003, scope ACTIVE (AUD-01 §1.2)','2026-09-03'),
  ('m_feld','Foundry Group / Techstars, Boulder','Foundry, General Partner',0,
   'foundry.vc/team 200 lists Feld as General Partner as of 2026 (AUD-01 §2.1). Techstars: the Give First podcast is now hosted by David Cohen, not Feld (AUD-01 §2.2) — the Techstars half of the supplied label is weaker than it reads','2026-09-03'),
  ('m_kopelman','First Round Capital, Philadelphia','First Round Capital',0,
   'firstround.com/team/investing/josh-kopelman 200, sitemap lastmod 2026-01-16 (AUD-01 §3.1)','2026-09-03'),
  ('m_tavel','Benchmark, San Francisco','Benchmark, Partner',0,
   'Substack profile API bio verbatim: "Blogging since 2006. Partner @benchmark. formerly: product @pinterest. vc @greylockvc, @bessemervp." (AUD-02 §1.1)','2026-09-03'),
  ('m_walk','Homebrew, San Francisco','Homebrew',0,
   'hunterwalk.com 200; homebrew.co/blog 200, latest 2026-08-19 (AUD-02 §2.1)','2026-09-03'),
  ('m_huffman','Reddit','Reddit, Inc. — CEO',0,
   'data.sec.gov/submissions/CIK0001713445.json 200, 478 filings, NYSE:RDDT; Q2 2026 shareholder letter signed by him personally (AUD-02 §3.1)','2026-09-03'),
  ('m_shear','Twitch','Softmax — CEO',1,
   'STALE. x.com/eshear og:description, current: "CEO of Softmax: Massively Multiplayer Learning Environments". He left Twitch; softmax.com/blog carries his byline (AUD-03 §1.2, §2). Also note AUD-06 E-NEW: an implementation keying on "Twitch" MISSES his strongest edge, because the YC S2005 tie is Kiko<->Reddit, not Twitch<->Reddit','2026-09-03'),
  ('m_ries','The Lean Startup / LTSE','LTSE; author, Incorruptible (2026-05-26)',0,
   'data.sec.gov/submissions/CIK0001757271.json 200, 62 filings through 2026-08-17; Incorruptible ISBN 9798893311860, Authors Equity, 2026-05-26 (AUD-03 §1.5). The label is current but INCOMPLETE — the book is the live fact (R-040: he looked dormant and had shipped a book that month)','2026-09-03'),
  ('m_qureshi','writer and researcher','writer and researcher',0,
   'nabeelqu.co 200 in browser; nabeelqu.substack.com/feed 200, 14 full-text items to 2026-05-03 (AUD-03). Current startup is stealth — UNVERIFIED, do not name it','2026-09-03'),
  ('m_perkins','Canva, Sydney','Canva — Co-founder and CEO',0,
   'x.com/MelanieCanva profile card verbatim: "Co-founder and CEO of @Canva ... Sydney, Australia" (AUD-03 §1.3)','2026-09-03');

-- ── What corroboration means (R-012; closes P1-11) ────────────────────────────
INSERT INTO corroboration_kind (slug, strength, label, basis) VALUES
  ('named_in_sec_filing','STRONG','Named as a person in an SEC filing',
   'data.sec.gov/submissions/CIK0001827011.json = "Huffman Steve Ladd". Note CIK 0001690226 "Huffman Steve" is a DIFFERENT person — a filing binds a handle to a legal person only when the CIK does (AUD-02 §3.1)'),
  ('api_name_field_matches','STRONG','A platform API returns the subject''s real name',
   'api.github.com/users/hunterwalk -> "name": "Hunter Walk", "blog": "www.hunterwalk.com" (AUD-02 §2.1)'),
  ('linked_from_own_canonical','STRONG','The account is linked from a page already confirmed as the subject''s',
   'linkedin.com/in/jkopelman is canonical because his own firm bio links it (AUD-01 §3.1)'),
  ('subject_self_identifies','STRONG','The subject names themselves in first-person content on the account',
   'Shear, HN item 47219766: "Hi, I''m Emmett. You may know me as the founder of Twitch (YC S05)" (AUD-03 §2a)'),
  ('bio_backlink_to_canonical','WEAK','The account bio links the subject''s confirmed domain',
   'instagram.com/fredwilson bio "I am a vc", link avc.com (AUD-07). Forgeable; a parody account can carry the same link'),
  ('display_name_matches','WEAK','Display name matches',
   'Weakest signal in the set. "Nabeel Qureshi" matches at least three distinct people (AUD-03 disambiguation)'),
  ('handle_matches','WEAK','Handle string matches one confirmed elsewhere',
   'THE trap. reddit.com/user/spez is Huffman; x.com/spez is a stranger with 103 followers (G-016). Never sufficient alone, and never sufficient WITH display_name_matches on the same platform');

-- ── The allow-list: where each member may be collected from ───────────────────
-- Not exhaustive of the audits — these are the sources with a measured 200 and a corroboration
-- path. Anything not listed here requires a new measurement before an adapter touches it.
INSERT INTO person_identity (person_id, source_id, url, handle, role, tier, corroboration, http_status, measured_at, notes) VALUES
  -- Fred Wilson
  ('m_wilson','blog_rss','https://api.paragraph.com/blogs/rss/@avc.xyz','avc.xyz','feed','GREEN','["linked_from_own_canonical","subject_self_identifies"]',200,'2026-09-03','THE live blog. 20 items with full content:encoded, 2025-12-18 -> 2026-07-23'),
  ('m_wilson','blog_archive','https://avc.com/','avc','archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','9,046 posts 2003-2024, FROZEN. Newest feed item is "I''ve Moved Onchain", 2024-05-02. Scraping this and calling it current is reading a corpse'),
  ('m_wilson','blog_search','https://avc.com/?s=','avc','api','GREEN','["subject_self_identifies"]',200,'2026-09-03','On-site search over the archive. Best deep-cut mining tool for him'),
  ('m_wilson','wikipedia','https://en.wikipedia.org/wiki/Fred_Wilson_(financier)',NULL,'canonical','GREEN','["display_name_matches","linked_from_own_canonical"]',200,'2026-09-03','DISAMBIGUATED TITLE IS LOAD-BEARING — see person_identity_negative'),
  ('m_wilson','farcaster','https://api.warpcast.com/v2/user-by-username?username=fredwilson','fredwilson','api','GREEN','["bio_backlink_to_canonical"]',200,'2026-09-03','The one social platform whose wall has a door'),
  ('m_wilson','sec_iapd','https://api.adviserinfo.sec.gov/search/firm?query=union%20square%20ventures',NULL,'api','GREEN','["named_in_sec_filing"]',200,'2026-09-03','firm_source_id 162375, SEC# 802-75126'),
  ('m_wilson','x_session','https://x.com/fredwilson','fredwilson','canonical','SESSION','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03','Bio "I am a VC", 1,345 following. Following list via a11y tree ONLY (AUD-07-5)'),
  ('m_wilson','instagram_session','https://www.instagram.com/fredwilson/','fredwilson','canonical','SESSION','["bio_backlink_to_canonical"]',200,'2026-09-03','414 posts. Captions carry S4 contexts. /tagged/ tab is OFF LIMITS as fact — see ingest-spec §6'),

  -- Brad Feld
  ('m_feld','blog_rss','https://feld.com/index.xml','feld.com','feed','GREEN','["subject_self_identifies"]',200,'2026-09-03','feld.com/feed/ 302s here. 20 full-text items. 5,551 posts 2004-2026'),
  ('m_feld','blog_archive','https://feld.com/archives/',NULL,'archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','2.5 MB, the entire 22-year index on one page. Note the 2021-2024 collapse (1 post in 2024)'),
  ('m_feld','wikipedia','https://en.wikipedia.org/wiki/Brad_Feld',NULL,'canonical','GREEN','["display_name_matches"]',200,'2026-09-03',NULL),
  ('m_feld','goodreads','https://www.goodreads.com/author/show/4395710.Brad_Feld',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','He states on feld.com/books/ that he lists everything he reads here'),
  ('m_feld','youtube_rss','https://www.youtube.com/feeds/videos.xml?channel_id=UClebMzrpRNTWVfZXw2jfsSw',NULL,'feed','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Techstars channel, Give First podcast. HOST IS NOW DAVID COHEN, not Feld — do not attribute episodes to him'),
  ('m_feld','x_session','https://x.com/bfeld','bfeld','canonical','SESSION','["linked_from_own_canonical"]',200,'2026-09-03','Linked from feld.com footer'),

  -- Josh Kopelman
  ('m_kopelman','blog_archive','https://redeye.firstround.com/archives.html','redeyevc','archive','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','212 posts, Mar 2006 - Nov 2014. DEAD. feeds.feedburner.com/redeyevc returns 200 with ZERO items and lastBuildDate 2019-05-21 — an empty feed is not silence, it is a dead feed'),
  ('m_kopelman','firm_bio','https://firstround.com/team/investing/josh-kopelman',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Richest single Kopelman artifact. lastmod 2026-01-16'),
  ('m_kopelman','wikipedia','https://en.wikipedia.org/wiki/Josh_Kopelman',NULL,'canonical','GREEN','["display_name_matches"]',200,'2026-09-03','15,628 B wikitext — the best structured biography available for him'),
  ('m_kopelman','linkedin_session','https://www.linkedin.com/in/jkopelman','jkopelman','canonical','SESSION','["linked_from_own_canonical"]',999,'2026-09-03','CANONICAL slug is jkopelman, linked from his own firm bio. /in/joshkopelman is a different, weaker surface — do not use it'),
  ('m_kopelman','x_session','https://x.com/joshk','joshk','canonical','SESSION','["display_name_matches"]',200,'2026-09-03','Title renders "Josh Kopelman (@joshk) / X". Fred Wilson follows him (AUD-31); the reverse was not found in two DOM passes — directed-link asymmetry is B-001 / G-001'),

  -- Sarah Tavel
  ('m_tavel','blog_rss','https://www.sarahtavel.com/feed','sarahtavel','feed','GREEN','["subject_self_identifies"]',200,'2026-09-03','20 items 2023-04-24 -> 2025-09-03. sarahtavel.substack.com 301s to this custom domain'),
  ('m_tavel','substack_api','https://www.sarahtavel.com/api/v1/publication/users/ranked?public=true',NULL,'api','GREEN','["subject_self_identifies"]',200,'2026-09-03','Bio verbatim, profile created 2023-01-04'),
  ('m_tavel','blog_archive','https://web.archive.org/web/20140110041657/http://www.adventurista.com/','adventurista','archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','113 archived posts 2006-2015. Names Wilson and Walk and NOBODY ELSE. See ingest-spec §7 on counting Wayback failures'),
  ('m_tavel','x_profile','https://api.fxtwitter.com/sarahtavel','sarahtavel','api','GREEN','["bio_backlink_to_canonical"]',200,'2026-09-03','Counts and bio only, free. 52,896 followers'),
  ('m_tavel','podcast_guest','https://every.to/podcast/what-s-missing-from-ai-tools-is-other-people',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Public transcript, published 2025-04-30'),

  -- Hunter Walk
  ('m_walk','blog_api','https://hunterwalk.com/wp-json/wp/v2/posts','hunterwalk','api','GREEN','["subject_self_identifies"]',200,'2026-09-03','x-wp-total 1761 lifetime, 27 since 2026-03-01. Fully open. Use this, NOT the 10-item RSS window, and NOT /archives (404)'),
  ('m_walk','bluesky_api','https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=hunterwalk.com','hunterwalk.com','api','GREEN','["bio_backlink_to_canonical"]',200,'2026-09-03','Fully readable, no auth. Most recent post 2026-09-02'),
  ('m_walk','github_api','https://api.github.com/users/hunterwalk','hunterwalk','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','Identity CONFIRMED by the name field. 0 repos — a claimed handle, not a code presence'),
  ('m_walk','youtube_rss','https://www.youtube.com/feeds/videos.xml?channel_id=UC68ai6rdol6MOTe_4b6T-wQ','HunterWalk','feed','GREEN','["api_name_field_matches"]',200,'2026-09-03','15 videos 2012-2024, channel opened 2006-01-03. Crowd-shot concert clips — the live-music topic'),

  -- Steve Huffman
  ('m_huffman','sec_person','https://data.sec.gov/submissions/CIK0001827011.json','spez','api','GREEN','["named_in_sec_filing"]',200,'2026-09-03','"Huffman Steve Ladd", 88 filings from 2020-10-01. His RICHEST open source. CIK 0001690226 is a different Steve Huffman'),
  ('m_huffman','sec_company','https://data.sec.gov/submissions/CIK0001713445.json',NULL,'api','GREEN','["named_in_sec_filing"]',200,'2026-09-03','Reddit, Inc., 478 filings. Q2 2026 shareholder letter is signed by him personally — the quotable substitute for the un-fetchable earnings call'),
  ('m_huffman','wikipedia','https://en.wikipedia.org/wiki/Steve_Huffman',NULL,'canonical','GREEN','["display_name_matches"]',200,'2026-09-03',NULL),
  ('m_huffman','reddit_archive','http://web.archive.org/cdx/search/cdx?url=old.reddit.com/user/spez/comments/','spez','archive','GREEN','["named_in_sec_filing","subject_self_identifies"]',200,'2026-09-03','Reddit itself is fully closed to logged-out reads in Sept 2026. Wayback is the only path to u/spez'),
  ('m_huffman','interview','https://mixergy.com/interviews/steve-huffman-reddit-interview/',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Full free transcript, ~60 KB'),

  -- Emmett Shear
  ('m_shear','hn_api','https://hacker-news.firebaseio.com/v0/user/emmett.json','emmett','api','GREEN','["subject_self_identifies"]',200,'2026-09-03','927 items 2007-02-19 -> 2026-03-02, karma 4,858. HANDLE IS `emmett`, NOT `eshear` — /user/eshear.json is 1 submission, karma 14'),
  ('m_shear','firm_blog','https://softmax.com/blog',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','6 posts. Only TWO carry his byline and both are co-credited to Claude Sonnet 3.7. No RSS exists — sitemap.xml is the only machine-readable index'),
  ('m_shear','blog_archive','http://blog.emmettshear.com/','emmettshear','archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','Wayback ONLY. 25 posts Aug 2006 - Feb 2010. Note it is the SUBDOMAIN; the apex is not his'),
  ('m_shear','github_api','https://api.github.com/users/eshear','eshear','api','GREEN','["subject_self_identifies"]',200,'2026-09-03','9 repos, joined 2009-02-04. github.com/emmettshear is 404'),
  ('m_shear','wikipedia','https://en.wikipedia.org/wiki/Emmett_Shear',NULL,'canonical','GREEN','["display_name_matches"]',200,'2026-09-03',NULL),
  ('m_shear','x_session','https://x.com/eshear','eshear','canonical','SESSION','["subject_self_identifies"]',200,'2026-09-03','og:description "CEO of Softmax: Massively Multiplayer Learning Environments" is current and readable logged-out'),

  -- Eric Ries
  ('m_ries','blog_archive','https://www.startuplessonslearned.com/sitemap.xml','startuplessonslearned','archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','392 posts 2008-08-02 -> 2026-05-17'),
  ('m_ries','newsletter','https://news.theleanstartup.com/archive',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','CURRENT primary channel. 12 posts 2026-05-26 -> 2026-08-23. NO working RSS — scrape the archive page'),
  ('m_ries','sec_ltse','https://data.sec.gov/submissions/CIK0001757271.json',NULL,'api','GREEN','["named_in_sec_filing"]',200,'2026-09-03','62 filings through 2026-08-17. Form 1 order 34-85828. The richest verifiable vein for him'),
  ('m_ries','podcast_rss','https://anchor.fm/s/f51132a8/podcast/rss',NULL,'feed','GREEN','["subject_self_identifies"]',200,'2026-09-03','The Eric Ries Show, 44 episodes 2024-05-05 -> 2026-01-08'),
  ('m_ries','youtube_rss','https://www.youtube.com/@TheEricRiesShow',NULL,'feed','GREEN','["subject_self_identifies"]',200,'2026-09-03','Live to 2026-09-03'),
  ('m_ries','github_api','https://api.github.com/users/ericries','ericries','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','11 repos, active 2026-09-03. Includes the Tom Lehrer songbook repo'),
  ('m_ries','books','https://openlibrary.org/isbn/9780307887894.json',NULL,'api','GREEN','["display_name_matches"]',200,'2026-09-03','Incorruptible 9798893311860, Authors Equity, 2026-05-26, 432pp — the live fact R-040 turns on'),

  -- Nabeel Qureshi
  ('m_qureshi','substack_rss','https://nabeelqu.substack.com/feed','nabeelqu','feed','GREEN','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03','14 FULL-TEXT items 2019-12-15 -> 2026-05-03. STRICTLY BETTER than his own site feed, which is title-only'),
  ('m_qureshi','personal_site','https://nabeelqu.co/','nabeelqu','canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','429 to curl AND WebFetch (Vercel bot challenge, x-vercel-mitigated: challenge). Readable ONLY in a real headless browser. Wayback was 503 at audit time — no fallback'),
  ('m_qureshi','github_api','https://api.github.com/users/nqureshi','nqureshi','api','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','HANDLE IS `nqureshi`. github.com/nabeelqu also 200s and is a nameless empty account — not him'),
  ('m_qureshi','x_profile','https://x.com/nabeelqu','nabeelqu','canonical','GREEN','["bio_backlink_to_canonical"]',200,'2026-09-03','Header renders logged-out: 9,112 posts, 37.9K followers, link nabeelqu.co. Timeline rendering is flaky'),
  ('m_qureshi','offsite','https://minutes.substack.com/p/rented-virtue',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Co-bylined with Will Manidis, 2026-02-10, fully readable, no paywall'),

  -- Prominence measurement endpoint. Free, keyless, unauthenticated. COUNTS AND PROFILE FIELDS
  -- ONLY — never content (AUD-04 Tier B1 narrow exception). All measured 2026-09-03.
  ('m_wilson','x_profile','https://api.fxtwitter.com/fredwilson','fredwilson','api','GREEN','["api_name_field_matches","bio_backlink_to_canonical"]',200,'2026-09-03','name="Fred Wilson", 640,845 followers'),
  ('m_feld','x_profile','https://api.fxtwitter.com/bfeld','bfeld','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','name="Brad Feld", 388,685 followers, following 1'),
  ('m_kopelman','x_profile','https://api.fxtwitter.com/joshk','joshk','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','name="Josh Kopelman", 150,180 followers, joined 2006-05-24. Upgrades his X identity from display_name_matches (WEAK) to STRONG'),
  ('m_walk','x_profile','https://api.fxtwitter.com/hunterwalk','hunterwalk','api','GREEN','["bio_backlink_to_canonical","display_name_matches","handle_matches"]',200,'2026-09-03','246,611 followers, 1 tweet. website=hunterwalk.com, bio names @homebrew, display name is the identical emoji string as his verified Bluesky. NO name field to match — three WEAK signals from different sources, the weakest accepted identity in the set'),
  ('m_shear','x_profile','https://api.fxtwitter.com/eshear','eshear','api','GREEN','["api_name_field_matches","subject_self_identifies"]',200,'2026-09-03','name="Emmett Shear", 123,007 followers'),
  ('m_ries','x_profile','https://api.fxtwitter.com/ericries','ericries','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','name="Eric Ries", 301,423 followers'),
  ('m_perkins','x_profile','https://api.fxtwitter.com/MelanieCanva','MelanieCanva','api','GREEN','["api_name_field_matches"]',200,'2026-09-03','name="Melanie Perkins", 56,591 followers. Her tier comes from LinkedIn, not this'),

  -- Melanie Perkins
  ('m_perkins','newsroom_archive','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/',NULL,'archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','~64,000-char first-person memoir. canva.com is 403 to EVERY automated client; Wayback via curl is the only path (WebFetch refuses web.archive.org)'),
  ('m_perkins','x_profile','https://x.com/MelanieCanva','MelanieCanva','canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Profile card is server-rendered. 1,314 posts, 56.5K followers, joined June 2011. Handle is CAPITALISED MelanieCanva'),
  ('m_perkins','linkedin_session','https://www.linkedin.com/in/melanieperkins/','melanieperkins','canonical','SESSION','["subject_self_identifies"]',200,'2026-09-03','SESSION-GREEN and her single best recency source — full post bodies, most recent 1d at audit time. Overturns AUD-03''s "no fetchable first-person publication"'),
  ('m_perkins','podcast_guest','https://www.npr.org/2019/01/24/688299882/canva-melanie-perkins',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','How I Built This. Status confirmed by curl only; transcript presence UNVERIFIED');

-- ── The deny-list. Every row was MEASURED reaching the wrong person. ──────────
-- This is the table that answers "are we targeting the right people". An adapter about to fetch a
-- matching value must REFUSE. Nothing here is a heuristic; each row is a fetch that happened.
INSERT INTO person_identity_negative (person_id, value, kind, belongs_to, basis, measured_at) VALUES
  ('m_huffman','https://x.com/spez','url','an unrelated account, 103 followers, no posts',
   'G-016 / AUD-HANDLE-COLLISION. `spez` on Reddit is Huffman; @spez on X is a stranger. THE canonical example of why handle equality is not identity',' 2026-09-03'),
  ('m_qureshi','https://en.wikipedia.org/wiki/Nabeel_Qureshi','wikipedia_title','Nabeel Qureshi the Christian apologist and author, 1983-2017',
   'AUD-03 disambiguation warning. HTTP 200, wrong person, and DECEASED. R-013: a candidate marked deceased is never auto-resolved. There is also a Pakistani film director of the same name. Our subject has NO English Wikipedia article',' 2026-09-03'),
  ('m_qureshi','https://www.instagram.com/nabeelqu/','url','"Nabeel qurban Ali" — a different person',
   'AUD-03 §4',' 2026-09-03'),
  ('m_qureshi','https://github.com/nabeelqu','url','a nameless, empty GitHub account',
   'AUD-03 §1. The real handle is nqureshi. UNVERIFIED whose this is — refuse regardless',' 2026-09-03'),
  ('m_shear','https://www.youtube.com/@eshear','url','"eshwar mr Kannada gamer"',
   'AUD-03 §1.5, page <title> read directly. No YouTube channel he owns was found',' 2026-09-03'),
  ('m_shear','eshear.com','domain','a GoDaddy domain-for-sale parking page',
   'AUD-03 §1.5. THE WORST TRAP IN THE SET: parking wildcards every path, so /feed, /rss.xml, /atom.xml, /blog, /posts and /robots.txt ALL return 200 with the same 114-byte stub. A 200 is not identity confirmation',' 2026-09-03'),
  ('m_shear','emmettshear.com','domain','NXDOMAIN now; an Indonesian SEO spam blog c. 2019-2021',
   'AUD-03 §1.5. His actual blog lived on the SUBDOMAIN blog.emmettshear.com',' 2026-09-03'),
  ('m_shear','https://www.humanx.co/speaker/emmett-shear','url',NULL,
   'AUD-03 §1.5. 404. A search result asserted this page exists; it does not. Search results are not sources',' 2026-09-03'),
  ('m_feld','https://github.com/bfeld','url','Björn Feld',
   'AUD-01 §2.1, page title read directly. No verified Brad Feld GitHub account exists',' 2026-09-03'),
  ('m_kopelman','https://github.com/joshk','url','a different developer',
   'AUD-01 §3.1. No Kopelman GitHub identity found',' 2026-09-03'),
  ('m_kopelman','https://joshk.substack.com/','url','Josh Katzman',
   'AUD-01 §3.1. Page reads "Josh''s Newsletter ... By Josh Katzman", sole post titled "Test"',' 2026-09-03'),
  ('m_wilson','https://en.wikipedia.org/wiki/Fred_Wilson','wikipedia_title','ambiguous — Fred Wilson the conceptual artist among others',
   'The disambiguated title Fred_Wilson_(financier) is the only correct one. AUD-07-7 measured the artist appearing IN the VC''s Instagram tagged tab',' 2026-09-03'),
  ('m_wilson','https://www.youtube.com/@fredwilson','url',NULL,
   'AUD-01 §1.2. Channel UCHHUu9VCZ3lyfOBnmSOWHvw exists but channelMetadataRenderer description and keywords are both empty. Cannot attribute. UNVERIFIED means refuse',' 2026-09-03'),
  ('m_wilson','https://github.com/fredwilson','url',NULL,
   'AUD-01 §1.2. 0 repos, 0 gists, 1 follower, no bio, no website. An empty shell — not usable as evidence',' 2026-09-03'),
  ('m_wilson','https://avc.mirror.xyz/','url',NULL,
   'AUD-01 §1.2. His 2021-2023 posts. HTTP 403, unreadable. Listed so an implementer stops trying',' 2026-09-03'),
  ('m_perkins','https://www.youtube.com/feeds/videos.xml?user=canva','url','an unrelated Hong Kong personal channel',
   'AUD-03 §4. Silently resolves to the wrong channel — no error, just wrong data',' 2026-09-03'),
  ('m_perkins','melanieperkins.com.au','domain','a GoDaddy parking page, listed for sale',
   'AUD-03 §1.2. melanieperkins.com does not resolve. She has NO personal site',' 2026-09-03'),
  ('m_ries','http://ericries.com/','url',NULL,
   'AUD-03 §1.1. curl exit 000, DNS/connect failure. Not his live property',' 2026-09-03'),
  ('m_huffman','https://api.fxtwitter.com/stevehuffman','url','a Steve Huffman with 38 followers, 4 tweets, joined 2009',
   'AUD-02 §3.3, re-confirmed 2026-09-03. One of THREE X handles that look like him and are not him',' 2026-09-03'),
  ('m_huffman','https://api.fxtwitter.com/shuffman','url','an account named "shuffman", 4 followers, 17 tweets',
   'AUD-02 §3.3, re-confirmed 2026-09-03. His LinkedIn slug is shuffman; his X is not',' 2026-09-03'),
  (NULL,'https://www.instagram.com/fredwilson/tagged/','url','third parties — anyone on the platform',
   'AUD-07-7. Not a wrong-person URL: an INJECTION SURFACE. Its first item names Fred Wilson the conceptual artist inside the VC''s own profile. Contents are written by strangers. trust_class third_party_open, traversal hint only, never a fact, never in a prompt',' 2026-09-03');

-- ── Added 2026-09-04 after an independent re-verification of all ten LinkedIn slugs ───────────
-- Both rows are collisions that the ORIGINAL prompts actively pointed an agent at. Additive only:
-- person_identity_negative's PK is (value, kind), and neither value existed before.
INSERT INTO person_identity_negative (person_id, value, kind, belongs_to, basis, measured_at) VALUES
  ('m_huffman','https://www.linkedin.com/in/shuffman','url','Sarah Huffman — a different person',
   'The slug docs/ingest-prompts/06-m_huffman.md attested as his, and roster.sql itself asserted ("His LinkedIn slug is shuffman"). Wayback holds three captures: 2008 renders "LinkedIn: Sarah Huffman", 2021 and 2024 are HTTP 999 walls. NO capture has ever shown Steve Huffman. His real profile is /in/shuffman56, corroborated by a 2016 capture listing "Co-founder, Reddit, June 2005 - October 2009" and Y Combinator 2005-2006. This row is the second measured instance of the R-004 error inside this project''s own seed data',' 2026-09-04'),
  ('m_qureshi','https://en.wikipedia.org/wiki/Nabeel_Qureshi_(writer)','wikipedia_title','Nabeel Qureshi the Christian apologist and author, 1983-2017 — the SAME deceased person already denied at the bare title',
   'Wikipedia moved the apologist to this disambiguated title after the audit, so the existing denial keyed on /wiki/Nabeel_Qureshi no longer catches him. Confirmed from wikitext: occupation "Christian evangelist", death_date 2017-09-16, categories "1983 births" / "2017 deaths". DANGEROUS BECAUSE the disambiguator is "(writer)" while member_label.current_label for m_qureshi is "writer and researcher" — the wrong person''s URL contains the right person''s job title, and it has already misled a human reviewer. Our subject is alive (GitHub push 2026-09-03) and has NO English Wikipedia article',' 2026-09-04');

-- ── Industries (S2 / S3) ──────────────────────────────────────────────────────
-- Assigned from the CURRENT measured role in member_label, against db/vocabulary.sql.
INSERT INTO person_industry (person_id, industry_slug) VALUES
  ('m_wilson','venture-capital'), ('m_feld','venture-capital'), ('m_kopelman','venture-capital'),
  ('m_tavel','venture-capital'),  ('m_walk','venture-capital'),
  ('m_huffman','consumer-internet'),
  ('m_shear','ai-research'),          -- Softmax, NOT Twitch. Keying on Twitch loses the S2005 edge
  ('m_ries','capital-markets'),       -- LTSE; SEC Form 1 order 34-85828
  ('m_qureshi','writing-research'),
  ('m_perkins','design-software');

-- ── Topics (S3 / S6 / S7) ─────────────────────────────────────────────────────
-- Every assignment is transcribed from the `basis` column of db/vocabulary.sql, which is itself
-- transcribed from docs/audit/06-edges.md §5. The holder_counts in vocabulary.sql are the
-- denominators of these exact rows — if you add one, recompute `discriminating`.
-- `board-games` was REMOVED from the vocabulary on 2026-09-03 (K-8): a placeholder with no audit
-- backing and no holder here. G-017 was re-grounded on real edges and no longer needs it.
INSERT INTO person_topic (person_id, topic_slug, evidence_fact_id) VALUES
  ('m_wilson','venture-capital-craft',NULL),   ('m_feld','venture-capital-craft',NULL),
  ('m_kopelman','venture-capital-craft',NULL), ('m_tavel','venture-capital-craft',NULL),
  ('m_walk','venture-capital-craft',NULL),
  ('m_feld','startup-communities',NULL),       ('m_ries','startup-communities',NULL),
  ('m_feld','tech-policy-immigration',NULL),   ('m_ries','tech-policy-immigration',NULL),
  ('m_kopelman','seed-stage-financing',NULL),  ('m_walk','seed-stage-financing',NULL),
  ('m_feld','reading-and-books',NULL),         ('m_qureshi','reading-and-books',NULL),
  ('m_shear','ai-alignment',NULL),
  ('m_huffman','content-moderation',NULL),
  ('m_ries','long-term-governance',NULL),
  ('m_wilson','crypto-protocols',NULL),
  ('m_tavel','marketplace-dynamics',NULL),
  ('m_perkins','product-led-growth',NULL),
  ('m_qureshi','essay-craft',NULL),
  ('m_wilson','music-collecting',NULL),
  ('m_feld','endurance-running',NULL),
  ('m_walk','live-music',NULL),
  ('m_tavel','rugby',NULL);

-- evidence_fact_id is NULL because no content-ingest run has happened yet. The first ingest run
-- MUST backfill it: R-025 says a fact with no source cannot render, and a topic with no evidence
-- fact produces a reason sentence the host cannot defend.

-- ── PRD R-022 (2026-09-04 re-baseline) — the measured intent for the evening ─────────────────
-- One value per member, read from the same evidence the labels were measured from. NULL is the
-- honest default and the engine reads it as I0 — unknown, never "being social". These drive the
-- intent classes (complement / parallel / open / neutral / unknown / guarded) and S9.
UPDATE person SET intent = 'I1', intent_basis =
  'usv.com/people/fred-wilson: active GP at an operating fund; SEC IAPD scope ACTIVE (AUD-01 §1.2)'
  WHERE id = 'm_wilson';
UPDATE person SET intent = 'I1', intent_basis =
  'foundry.vc/team lists him General Partner as of 2026 (AUD-01 §2.1); writing about active deals'
  WHERE id = 'm_feld';
UPDATE person SET intent = 'I1', intent_basis =
  'firstround.com: listed partner at an operating seed fund (AUD-01)'
  WHERE id = 'm_kopelman';
UPDATE person SET intent = 'I1', intent_basis =
  'benchmark.com: listed GP at an operating fund (AUD-01)'
  WHERE id = 'm_tavel';
UPDATE person SET intent = 'I1', intent_basis =
  'homebrew.co: listed partner; hunterwalk.com bio names Homebrew as current (AUD-01)'
  WHERE id = 'm_walk';
UPDATE person SET intent = 'I3', intent_basis =
  'reddit.com leadership page: CEO of the company he co-founded and returned to run (AUD-01)'
  WHERE id = 'm_huffman';
UPDATE person SET intent = 'I3', intent_basis =
  'x.com/eshear og:description "CEO of Softmax" — building a new company, measured 2026-09-03'
  WHERE id = 'm_shear';
UPDATE person SET intent = 'I3', intent_basis =
  'canva.com/about: co-founder and CEO of the company she is still scaling (AUD-01)'
  WHERE id = 'm_perkins';
UPDATE person SET intent = 'I4', intent_basis =
  'member_label basis: "LTSE; author, Incorruptible (2026-05-26)" — a book shipped this year'
  WHERE id = 'm_ries';
UPDATE person SET intent = 'I5', intent_basis =
  'nabeelqu.co: the recurring subject of his essays is how to learn and understand a domain, stated in his own words as his current project'
  WHERE id = 'm_qureshi';
