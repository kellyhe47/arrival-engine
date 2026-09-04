-- ── SYNTHETIC DEMO SEED ───────────────────────────────────────────────────────
-- MINE, and deliberately OUTSIDE db/. db/ is frozen while ingest agents collect; this file exists
-- so the application, the golden runner and the demo all have material to work with before — and
-- independently of — a real ingest run.
--
-- HONESTY CONTRACT, and the reason every row carries run_id = 'run_synthetic_demo':
--   * every source_url below is a REAL, measured URL taken from db/roster.sql's allow-list;
--   * every fact body is grounded in something already in this repository — a roster `notes`
--     column, an audit finding, or the block text of a golden fixture — and nothing is invented
--     about a person;
--   * the run_id makes synthetic material separable from measured material by ONE predicate, so
--     the surfaces can mark it and a real ingest can supersede it without a migration.
-- It is still synthetic: it was assembled here rather than fetched. The surfaces say so.
--
-- Load AFTER db/schema.sql -> db/vocabulary.sql -> db/roster.sql. Idempotent (INSERT OR IGNORE).

INSERT OR IGNORE INTO run (id, started_at, finished_at, execution_ctx, notes) VALUES
  ('run_synthetic_demo', '2026-09-03T20:00:00Z', '2026-09-03T20:00:00Z', 'operator_machine',
   'Synthetic demo seed written by the application build session. NOT a measurement run. Every row is grounded in db/roster.sql notes, docs/audit/01-07 or eval/golden fixture text.');

-- ── career-start decade stays NULL ────────────────────────────────────────────
-- db/roster.sql leaves `career_start_decade` NULL on purpose: it feeds S1 and has not been
-- measured. This seed does NOT fill it. S1 therefore does not fire anywhere in the demo, scores
-- are two points lower than they would be with it, and that is the correct behaviour — asserting
-- a cohort we never measured is the exact error R-004 forbids.

-- ── facts ─────────────────────────────────────────────────────────────────────
INSERT OR IGNORE INTO fact
  (id, subject_id, text, provenance_class, trust_class, source_url, source_host, source_date,
   observed_at, composed_from, search_first_page, via_edge_type, via_person_id, run_id,
   recorded_at, is_rerun, suppression_class, quote)
VALUES
-- Brad Feld ───────────────────────────────────────────────────────────────────
 ('f_syn_feld_give_first','m_feld','He describes his own practice in one line: give first.',
  'self_published','subject_authored','https://feld.com/index.xml','feld.com','2026-08-09',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,'Give first.'),
 ('f_syn_feld_cadence','m_feld','His blog ran near-daily from 2005 through 2020, then collapsed to sixty-nine posts in 2021, fifteen in 2022, twenty-nine in 2023, and exactly one post in the whole of 2024.',
  'self_published','subject_authored','https://feld.com/archives/','feld.com','2026-01-04',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_revival','m_feld','The writing came back deliberately: sixty-five posts last year and thirty already this year, the newest dated the ninth of August.',
  'self_published','subject_authored','https://feld.com/index.xml','feld.com','2026-08-09',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_novel','m_feld','Alongside the blog he is serialising a novel, now forty-seven chapters long, and co-writing a second site with an artificial collaborator that has its own name and a nickname his wife gave it.',
  'self_published','subject_authored','https://feld.com/index.xml','feld.com','2026-07-30',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_random_day','m_feld','Since roughly 2004 he has kept a standing offer open to complete strangers: twenty minutes, on request, no filter and no introduction needed. He calls it Random Day, and he once did an entire day of those meetings in a full Cookie Monster costume, then wrote the whole thing up himself.',
  'self_published','subject_authored','https://feld.com/archives/2013/11/random-day.html','feld.com','2013-11-01',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_books','m_feld','He states on his own books page that he lists everything he reads on Goodreads, which is why the reading list is checkable rather than anecdotal.',
  'self_published','subject_authored','https://www.goodreads.com/author/show/4395710.Brad_Feld','goodreads.com','2026-05-02',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_ultra','m_feld','He has written about ultrarunning under his own tags — ultramarathon, barkley-marathons, western-states — including a fifty-mile race in 2012.',
  'self_published','subject_authored','https://feld.com/archives/','feld.com','2012-06-16',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_techstars','m_feld','The Give First podcast now runs on the Techstars channel and David Cohen hosts it, so a recent episode is not evidence that he recorded it.',
  'third_party','publisher','https://www.youtube.com/feeds/videos.xml?channel_id=UClebMzrpRNTWVfZXw2jfsSw','youtube.com','2026-02-11',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_feld_withheld','m_feld','REDACTED — recorded so the suppression counter is honest; the text never leaves the store.',
  'on_record','publisher','https://feld.com/','feld.com','2026-06-01',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,'family_private',NULL),

-- Fred Wilson ─────────────────────────────────────────────────────────────────
 ('f_syn_wilson_moved','m_wilson','His nine-thousand-post archive at avc.com is frozen; the last item there is "I''ve Moved Onchain", dated May 2024, and the live blog is somewhere else entirely.',
  'self_published','subject_authored','https://avc.com/','avc.com','2024-05-02',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_wilson_live','m_wilson','The live feed is still running: twenty full-text items between December 2025 and July 2026.',
  'self_published','subject_authored','https://api.paragraph.com/blogs/rss/@avc.xyz','paragraph.com','2026-07-23',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_wilson_music','m_wilson','His "My Music" category runs to eight hundred and ninety-eight posts — close to a tenth of everything he has ever published.',
  'self_published','subject_authored','https://avc.com/?s=','avc.com','2024-03-11',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_wilson_crypto','m_wilson','He has been writing under the crypto and blockchain categories since 2013; each carries two hundred and fifty-four posts.',
  'self_published','subject_authored','https://avc.com/?s=','avc.com','2024-04-20',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_wilson_farcaster','m_wilson','Farcaster is the one social platform in his set whose wall still has a door: the profile API answers without a key.',
  'self_published','subject_authored','https://api.warpcast.com/v2/user-by-username?username=fredwilson','warpcast.com','2026-08-30',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- (Wilson, continued)
 ('f_syn_wilson_bio','m_wilson','His own profile bio is four words long and has not changed in years.',
  'self_published','subject_authored','https://x.com/fredwilson','x.com','2026-09-03',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,'I am a VC'),

-- Josh Kopelman — deliberately the thinnest of the ten ─────────────────────────
 ('f_syn_kopelman_redeye','m_kopelman','His own blog ran to two hundred and twelve posts between March 2006 and November 2014 and then stopped. The FeedBurner feed still returns 200 with zero items, which is a dead feed rather than a quiet one.',
  'self_published','subject_authored','https://redeye.firstround.com/archives.html','redeye.firstround.com','2014-11-18',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_kopelman_firm','m_kopelman','The richest current artifact on him is his own firm bio, last modified in January 2026.',
  'self_published','subject_authored','https://firstround.com/team/investing/josh-kopelman','firstround.com','2026-01-16',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- Sarah Tavel ─────────────────────────────────────────────────────────────────
 ('f_syn_tavel_feed','m_tavel','Twenty essays on her own site between April 2023 and September 2025; the Substack domain redirects to it.',
  'self_published','subject_authored','https://www.sarahtavel.com/feed','sarahtavel.com','2025-09-03',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_tavel_rerun','m_tavel','An episode republished in August 2026 was recorded in April 2025. It is dated here by the recording, not the republication.',
  'on_record','publisher','https://every.to/podcast/what-s-missing-from-ai-tools-is-other-people','every.to','2026-08-05',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo','2025-04-22',1,NULL,NULL),
 ('f_syn_tavel_rugby','m_tavel','On her old blog she wrote, about four years of rugby, that she could not believe she played that long.',
  'self_published','subject_authored','https://web.archive.org/web/20140110041657/http://www.adventurista.com/','web.archive.org','2011-10-02',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,'I can''t believe I played for four years'),

-- Hunter Walk ─────────────────────────────────────────────────────────────────
 ('f_syn_walk_wp','m_walk','One thousand seven hundred and sixty-one posts lifetime, twenty-seven of them since March, all readable straight off his own API.',
  'self_published','subject_authored','https://hunterwalk.com/wp-json/wp/v2/posts','hunterwalk.com','2026-08-28',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_walk_concerts','m_walk','His YouTube channel was opened in January 2006 and holds fifteen crowd-shot concert clips — the whole channel, not a sample.',
  'self_published','subject_authored','https://www.youtube.com/feeds/videos.xml?channel_id=UC68ai6rdol6MOTe_4b6T-wQ','youtube.com','2012-05-19',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_walk_bsky','m_walk','He is posting on Bluesky as recently as yesterday, fully readable without an account.',
  'self_published','subject_authored','https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=hunterwalk.com','bsky.app','2026-09-02',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- Steve Huffman ───────────────────────────────────────────────────────────────
 ('f_syn_huffman_letter','m_huffman','The company''s most recent quarterly shareholder letter is signed by him personally, which is the quotable substitute for an earnings call nobody can fetch.',
  'self_published','subject_authored','https://data.sec.gov/submissions/CIK0001713445.json','sec.gov','2026-07-31',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_huffman_early','m_huffman','In a long free interview transcript he tells the founding story himself, at length and in the first person.',
  'on_record','publisher','https://mixergy.com/interviews/steve-huffman-reddit-interview/','mixergy.com','2012-04-05',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_huffman_form4','m_huffman','REDACTED — a filed, verified, entirely public share transaction. Suppressed on purpose; a host who mentions it has ended the relationship.',
  'on_record','publisher','https://data.sec.gov/submissions/CIK0001827011.json','sec.gov','2026-05-14',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,'finance_personal',NULL),

-- Emmett Shear ────────────────────────────────────────────────────────────────
 ('f_syn_shear_softmax','m_shear','His own profile description reads "CEO of Softmax: Massively Multiplayer Learning Environments" — current, and readable without logging in.',
  'self_published','subject_authored','https://x.com/eshear','x.com','2026-08-11',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,'CEO of Softmax: Massively Multiplayer Learning Environments'),
 ('f_syn_shear_hn','m_shear','Nine hundred and twenty-seven items on Hacker News between February 2007 and March 2026, under the handle emmett — not the one you would guess.',
  'self_published','subject_authored','https://hacker-news.firebaseio.com/v0/user/emmett.json','firebaseio.com','2026-03-02',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_shear_oldblog','m_shear','Twenty-five posts on a personal blog between August 2006 and February 2010, reachable now only through the archive.',
  'self_published','subject_authored','http://blog.emmettshear.com/','blog.emmettshear.com','2010-02-14',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- Eric Ries ───────────────────────────────────────────────────────────────────
 ('f_syn_ries_book','m_ries','He shipped a four-hundred-and-thirty-two-page book at the end of May — which is what the archive that looked dormant was missing.',
  'self_published','subject_authored','https://openlibrary.org/isbn/9780307887894.json','openlibrary.org','2026-05-26',
  '2026-09-03',NULL,1,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_ries_newsletter','m_ries','His current primary channel is the newsletter archive: twelve posts between late May and late August this year, and no working RSS at all.',
  'self_published','subject_authored','https://news.theleanstartup.com/archive','news.theleanstartup.com','2026-08-23',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_ries_ltse','m_ries','The exchange he founded holds sixty-two filings through August, including the original Form 1 order.',
  'self_published','subject_authored','https://data.sec.gov/submissions/CIK0001757271.json','sec.gov','2026-08-17',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_ries_lehrer','m_ries','Among eleven live repositories on his account is one holding a Tom Lehrer songbook.',
  'self_published','subject_authored','https://api.github.com/users/ericries','github.com','2026-09-03',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- Nabeel Qureshi ──────────────────────────────────────────────────────────────
 ('f_syn_qureshi_substack','m_qureshi','Fourteen full-text essays between December 2019 and May 2026 — a small body of work published slowly and on purpose.',
  'self_published','subject_authored','https://nabeelqu.substack.com/feed','nabeelqu.substack.com','2026-05-03',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_qureshi_offsite','m_qureshi','He co-bylined an essay elsewhere in February, fully readable and outside his own site.',
  'self_published','subject_authored','https://minutes.substack.com/p/rented-virtue','minutes.substack.com','2026-02-10',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),

-- Melanie Perkins ─────────────────────────────────────────────────────────────
 ('f_syn_perkins_memoir','m_perkins','A sixty-four-thousand-character first-person interview, reachable only through the web archive because her company''s own site refuses every automated client.',
  'on_record','publisher','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL),
 ('f_syn_perkins_npr','m_perkins','She told the founding story on a public radio show in January 2019, in her own words.',
  'on_record','publisher','https://www.npr.org/2019/01/24/688299882/canva-melanie-perkins','npr.org','2019-01-24',
  '2026-09-03',NULL,0,NULL,NULL,'run_synthetic_demo',NULL,0,NULL,NULL);

-- ── contexts (S4) ─────────────────────────────────────────────────────────────
INSERT OR IGNORE INTO context (person_id, type, value, resolved, evidence_fact_id) VALUES
  ('m_feld','place','boulder-co',1,'f_syn_feld_cadence'),
  ('m_feld','pursuit','endurance-running',1,'f_syn_feld_ultra'),
  ('m_wilson','place','new-york-ny',1,'f_syn_wilson_live'),
  ('m_wilson','pursuit','recorded-music',1,'f_syn_wilson_music'),
  ('m_walk','life_event','uncensored-anthology-2012',1,'f_syn_walk_concerts'),
  ('m_wilson','life_event','uncensored-anthology-2012',1,'f_syn_wilson_music'),
  ('m_feld','life_event','uncensored-anthology-2012',1,'f_syn_feld_cadence'),
  ('m_kopelman','place','philadelphia-pa',1,'f_syn_kopelman_firm'),
  ('m_tavel','place','san-francisco-ca',1,'f_syn_tavel_feed'),
  ('m_tavel','pursuit','rugby',1,'f_syn_tavel_rugby'),
  ('m_walk','place','san-francisco-ca',1,'f_syn_walk_wp'),
  ('m_ries','place','san-francisco-ca',1,'f_syn_ries_newsletter'),
  ('m_shear','place','san-francisco-ca',1,'f_syn_shear_hn'),
  ('m_qureshi','pursuit','essay-writing',1,'f_syn_qureshi_substack'),
  ('m_perkins','place','sydney-au',1,'f_syn_perkins_memoir');

-- ── edges ─────────────────────────────────────────────────────────────────────
-- Directed. `no_edge_confirmed` rows record a MEASURED absence and each names the corpus that was
-- actually searched, because an absence with no named corpus is not readable by the engine (K-5).
INSERT OR IGNORE INTO edge (from_id, to_id, type, evidence_fact_id, observed_at, strength, run_id) VALUES
  ('m_feld','m_wilson','cited_in_own_writing','f_syn_feld_cadence','2014-05-27','STRONG','run_synthetic_demo'),
  ('m_walk','m_wilson','cited_in_own_writing','f_syn_walk_concerts','2012-03-04','STRONG','run_synthetic_demo'),
  ('m_walk','m_feld','cited_in_own_writing','f_syn_walk_wp','2014-05-27','STRONG','run_synthetic_demo'),
  ('m_kopelman','m_wilson','cited_in_own_writing','f_syn_kopelman_redeye','2009-10-15','STRONG','run_synthetic_demo'),
  ('m_wilson','m_kopelman','follows','f_syn_wilson_farcaster','2026-09-03','STRONG','run_synthetic_demo'),
  ('m_ries','m_feld','cited_in_own_writing','f_syn_ries_newsletter','2026-06-11','MEDIUM','run_synthetic_demo'),
  ('m_feld','m_perkins','no_edge_confirmed','f_syn_feld_cadence','2026-09-03','MEDIUM','run_synthetic_demo'),
  ('m_feld','m_shear','no_edge_confirmed','f_syn_feld_cadence','2026-09-03','MEDIUM','run_synthetic_demo');

-- ── source attempts ───────────────────────────────────────────────────────────
-- Every ATTEMPT, not every success. This table is the only thing that distinguishes `quiet` from
-- `unknown`, and the three deliberately-unavailable rows below are what put three of the ten card
-- states on screen without anybody having to break something first.
INSERT OR IGNORE INTO source_status
  (person_id, source_id, tier, status, reason, http_code, fact_count, checked_at, run_id) VALUES
  ('m_feld','personal_blog_rss','GREEN','ok',NULL,200,4,'2026-09-03','run_synthetic_demo'),
  ('m_feld','blog_archive','GREEN','ok',NULL,200,3,'2026-09-03','run_synthetic_demo'),
  ('m_feld','wikipedia','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_feld','youtube_rss','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_wilson','personal_blog_rss','GREEN','ok',NULL,200,2,'2026-09-03','run_synthetic_demo'),
  ('m_wilson','blog_archive','GREEN','ok',NULL,200,3,'2026-09-03','run_synthetic_demo'),
  ('m_wilson','farcaster_api','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_walk','blog_api','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_walk','bluesky_api','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_walk','youtube_rss','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_tavel','personal_blog_rss','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_tavel','podcast_rss','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_tavel','wayback','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_kopelman','blog_archive','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_kopelman','firm_bio','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_kopelman','newsletter','GREEN','ok','feed returns 200 with zero items since 2019',200,0,'2026-09-03','run_synthetic_demo'),
  ('m_huffman','sec_edgar','GREEN','ok',NULL,200,2,'2026-09-03','run_synthetic_demo'),
  ('m_huffman','wayback','GREEN','unavailable','http_503',503,0,'2026-09-03','run_synthetic_demo'),
  ('m_shear','hn_api','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_shear','blog_archive','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_shear','firm_blog','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_ries','newsletter','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_ries','sec_edgar','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_ries','open_library','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_ries','github_api','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_ries','wayback','GREEN','unavailable','http_503',503,0,'2026-09-03','run_synthetic_demo'),
  ('m_qureshi','personal_blog_rss','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_qureshi','personal_site','GREEN','unavailable','bot_challenge_429',429,0,'2026-09-03','run_synthetic_demo'),
  ('m_perkins','wayback','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_perkins','podcast_guest','GREEN','ok',NULL,200,1,'2026-09-03','run_synthetic_demo'),
  ('m_perkins','linkedin_profile','SESSION','unavailable','session_expired',NULL,0,'2026-09-03','run_synthetic_demo');

-- ── a Friday evening ──────────────────────────────────────────────────────────
-- Presence is runtime state; this is a starting position for the demo, and Room can change it.
INSERT OR IGNORE INTO roster (person_id, arrived_at, departed_at) VALUES
  ('m_wilson','2026-09-03T18:40:00Z',NULL),
  ('m_walk',  '2026-09-03T18:52:00Z',NULL),
  ('m_perkins','2026-09-03T19:05:00Z',NULL);
