-- Brad Feld ingest overlay (m_feld-01).
-- Apply to a freshly seeded arena database or a combined database that does not
-- yet contain run_ingest_feld_20260903 / f_feld_* rows.

PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;
BEGIN IMMEDIATE;

-- The checked-in schema defines this view, but some already-seeded database
-- snapshots predate it. Keep the sidecar query-compatible without touching the
-- shared seed.
CREATE VIEW IF NOT EXISTS v_assertable_absence AS
  SELECT * FROM edge
   WHERE type = 'no_edge_confirmed' AND evidence_fact_id IS NOT NULL;

INSERT INTO run (id, started_at, finished_at, execution_ctx, notes)
VALUES (
  'run_ingest_feld_20260903',
  '2026-09-03T23:35:00Z',
  '2026-09-04T01:18:00Z',
  'operator_machine',
  'Content ingest for m_feld. 18 sources reached; 34 facts, 13 outgoing edges, and 2 contexts. Feld data is stored in a per-person sidecar to avoid concurrent-writer collisions.'
);

UPDATE person
   SET career_start_decade = '1980s'
 WHERE id = 'm_feld';

INSERT OR IGNORE INTO person
  (id, is_member, display_name, name_respelling, seniority_tier,
   career_start_decade, prominence_tier, prominence_basis, created_run)
VALUES
  ('p_amy_batchelor', 0, 'Amy Batchelor', NULL, NULL, NULL, NULL, NULL, 'run_ingest_feld_20260903'),
  ('p_jason_mendelson', 0, 'Jason Mendelson', NULL, NULL, NULL, NULL, NULL, 'run_ingest_feld_20260903'),
  ('p_david_cohen', 0, 'David Cohen', NULL, NULL, NULL, NULL, NULL, 'run_ingest_feld_20260903');

INSERT INTO person_identity
  (person_id, source_id, url, handle, role, tier, corroboration,
   http_status, measured_at, notes)
VALUES
  ('m_feld','books','https://feld.com/books/',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Nine books listed; links Goodreads as the record of everything he reads.'),
  ('m_feld','films','https://feld.com/films/',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03','Twelve documentaries listed.'),
  ('m_feld','tags','https://feld.com/tags/',NULL,'archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','Canonical tag index.'),
  ('m_feld','zero_knowledge','https://zeroknowledge.ink/',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Serialized novel; 47 chapters visible; newsletter only.'),
  ('m_feld','adventures_in_claude','https://adventuresinclaude.ai/',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Separately bylined posts by Brad Feld and his AI collaborator.'),
  ('m_feld','firm_bio','https://foundry.vc/team',NULL,'firm','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Foundry team page lists Brad Feld as General Partner.'),
  ('m_feld','anchor_point','https://anchorpointfoundation.org/',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Foundation founded by Brad Feld and Amy Batchelor.'),
  ('m_feld','linkedin_session','https://www.linkedin.com/in/bfeld/','bfeld','canonical','SESSION','["linked_from_own_canonical"]',200,'2026-09-03','Authenticated browser render: Partner at Foundry; Boulder; 341,009 followers.'),
  ('m_feld','sec_form_d','https://www.sec.gov/Archives/edgar/data/1910041/000110465922033260/primary_doc.xml',NULL,'canonical','GREEN','["named_in_sec_filing"]',200,'2026-09-03','Foundry 2022, L.P. Form D names Brad Feld as director and manager of the general partner.'),
  ('m_feld','sec_iapd_probe','https://adviserinfo.sec.gov/firm/summary/159541',NULL,'firm','GREEN','["display_name_matches"]',200,'2026-09-03','IAPD identifies Foundry Group, LLC (SEC 801-107412) as active in Boulder; it does not name Feld.'),
  ('m_feld','techstars_about_probe','https://www.techstars.com/about',NULL,'firm','GREEN','["display_name_matches"]',200,'2026-09-03','Official timeline names David Cohen and Brad Feld among Techstars founders.')
ON CONFLICT(person_id, source_id, url) DO UPDATE SET
  handle=excluded.handle,
  role=excluded.role,
  tier=excluded.tier,
  corroboration=excluded.corroboration,
  http_status=excluded.http_status,
  measured_at=excluded.measured_at,
  notes=excluded.notes;

UPDATE person_identity
   SET notes = 'name="Brad Feld", 388,694 followers, following 1, 39,098 posts',
       http_status = 200,
       measured_at = '2026-09-03'
 WHERE person_id = 'm_feld'
   AND source_id = 'x_profile'
   AND url = 'https://api.fxtwitter.com/bfeld';

INSERT INTO fact
  (id, subject_id, text, provenance_class, trust_class, source_url,
   source_host, source_date, observed_at, composed_from, search_first_page,
   via_edge_type, via_person_id, run_id)
VALUES
  ('f_feld_001','m_feld',
   'Foundry lists Brad Feld as a General Partner on its 2026 team page.',
   'on_record','publisher','https://foundry.vc/team','foundry.vc','2026-09-03','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_002','m_feld',
   'A Foundry 2022, L.P. Form D filed March 14, 2022 names Brad Feld as a director and clarifies his relationship as “A Manager of the General Partner.”',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1910041/000110465922033260/primary_doc.xml','sec.gov','2022-03-14','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_003','m_feld',
   'Feld says he started his first company in 1987 and required every employee to read Zen and the Art of Motorcycle Maintenance.',
   'self_published','subject_authored','https://feld.com/archives/2026/03/quality/','feld.com','2026-03-24','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_004','m_feld',
   'The latest item in Feld Thoughts'' 20-item full-text feed was “The Argument Against AI Writing Is At Least 2,400 Years Old,” published August 9, 2026.',
   'self_published','subject_authored','https://feld.com/index.xml','feld.com','2026-08-09','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_005','m_feld',
   'Feld''s X profile identifies him as a Foundry VC in Boulder who invests in software and Internet companies, runs marathons, and loves to read; the profile API showed 388,694 followers and one following account.',
   'self_published','subject_authored','https://api.fxtwitter.com/bfeld','api.fxtwitter.com','2026-09-03','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_006','m_feld',
   'Feld posted a Zero Knowledge Chapter 24.1 update on X on September 3, 2026, confirming current activity beyond the August 9 blog-feed endpoint.',
   'self_published','subject_authored','https://x.com/bfeld/status/2095363656636887365','x.com','2026-09-03','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_007','m_feld',
   'His LinkedIn profile rendered as “Partner at Foundry” in Boulder with 341,009 followers, described him as an early-stage entrepreneur and investor since 1987, and showed his September 3 Zero Knowledge Chapter 24.1 post as latest activity.',
   'self_published','subject_authored','https://www.linkedin.com/in/bfeld/','linkedin.com','2026-09-03','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_009','m_feld',
   'The Feld Thoughts archive contains 5,551 unique post links from 2004 through August 2026: 220, 536, 672, 544, 507, 335, 365, 307, 282, 266, 223, 185, 210, 187, 159, 170, 174, 69, 15, 29, 1, 65, and 30 posts by year respectively.',
   'on_record','publisher','https://feld.com/archives/','feld.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_010','m_feld',
   'Feld published near-daily from 2005 through 2020, fell to 69 posts in 2021, 15 in 2022, 29 in 2023, and one in 2024, then deliberately revived the blog with 65 posts in 2025 and 30 through August 2026; continuity across that gap should not be assumed.',
   'inferred','publisher','https://feld.com/archives/','feld.com','2026-09-03','2026-09-03T23:35:00Z','["f_feld_009"]',0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_011','m_feld',
   'Feld lists nine books published since 2010; Venture Deals is co-authored with Jason Mendelson and reached a fourth edition in 2019.',
   'self_published','subject_authored','https://feld.com/books/','feld.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_012','m_feld',
   'Feld''s films page lists twelve documentaries he and Amy Batchelor funded, including The River in 2026.',
   'self_published','subject_authored','https://feld.com/films/','feld.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_013','m_feld',
   'Zero Knowledge is a serialized novel written by Brad Feld with Phin Argofy; 47 chapters were live and the site''s blog was current through August 30, 2026.',
   'self_published','subject_authored','https://zeroknowledge.ink/','zeroknowledge.ink','2026-08-30','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_014','m_feld',
   'Adventures in Claude contains separately attributed posts by Brad Feld and by Phin Argofy; author bylines must be respected rather than assigning the whole site to Feld.',
   'self_published','subject_authored','https://adventuresinclaude.ai/','adventuresinclaude.ai','2026-08-16','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_015','m_feld',
   'The Anchor Point Foundation says Brad Feld and Amy Batchelor founded it to support arts and culture, education, entrepreneurship, the environment, health and human services, progressive public policy, and women and girls.',
   'on_record','publisher','https://anchorpointfoundation.org/','anchorpointfoundation.org','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_016','m_feld',
   'Techstars'' current Give First feed attributes Episode 109 to host David Cohen, not Brad Feld; whether Feld formally stopped hosting was not established, so no current episode is attributed to him.',
   'on_record','publisher','https://www.youtube.com/feeds/videos.xml?channel_id=UClebMzrpRNTWVfZXw2jfsSw','youtube.com','2026-08-25','2026-09-03T23:35:00Z',NULL,1,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_017','m_feld',
   'Feld''s tag index contains long-running veins for startup communities, Startup Visa, Venture Deals, venture capital, ultramarathon, ultrarunning, Barkley Marathons, and Western States.',
   'self_published','subject_authored','https://feld.com/tags/','feld.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_018','m_feld',
   'On venture-capital craft, Feld recommends continuous board engagement and a concise board package that focuses discussion on substantive issues rather than status reporting.',
   'self_published','subject_authored','https://feld.com/archives/2013/01/the-best-approach-to-a-board-package/','feld.com','2013-01-16','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_019','m_feld',
   'Feld published Eric Ries'' foreword to The Startup Community Way and described Ries as a longtime friend and colleague whose Lean Startup work shaped entrepreneurial communities.',
   'self_published','subject_authored','https://feld.com/archives/2020/07/eric-ries-foreword-to-the-startup-community-way/','feld.com','2020-07-28','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_020','m_feld',
   'Feld and Eric Ries worked publicly on startup-immigration policy; Feld''s 2016 International Entrepreneur Rule post says they discussed the Startup Visa initiative with the White House and Homeland Security.',
   'self_published','subject_authored','https://feld.com/archives/2016/08/startup-visa-international-entrepreneurs-rule-form-941/','feld.com','2016-08-29','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_021','m_feld',
   'Feld writes, “I love books. I love to read,” and describes reading and writing about entrepreneurship books as a recurring practice.',
   'self_published','subject_authored','https://feld.com/archives/2011/11/books-on-entrepreneurship/','feld.com','2011-11-25','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_022','m_feld',
   'Feld completed the American River 50 Mile Endurance Run in 2012 in 11:57:37 and documented the effort across five blog posts.',
   'self_published','subject_authored','https://feld.com/archives/2012/04/american-river-50-mile-endurance-run/','feld.com','2012-04-09','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_023','m_feld',
   'Feld''s Random Day practice lets anyone request a 20-minute meeting; by 2013 he had done it for almost a decade and once held twelve meetings at a coffee shop mostly dressed as Cookie Monster.',
   'self_published','subject_authored','https://feld.com/archives/2013/11/the-return-of-random-day/','feld.com','2013-11-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_024','m_feld',
   'Random Day remained active in May 2025, when Feld offered nine 15-minute slots at The Composition Shop.',
   'self_published','subject_authored','https://feld.com/archives/2025/05/random-day-on-5-28-at-the-composition-shop/','feld.com','2025-05-13','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_025','m_feld',
   'Phin Argofy is Feld''s AI collaborator, not a person; Feld says Phin chose both its name and the pronoun “it.”',
   'self_published','subject_authored','https://feld.com/archives/2026/06/writing-a-novel-with-phin-argofy/','feld.com','2026-06-13','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_026','m_feld',
   'Amy calls Lumen “Clod.” Feld identifies Lumen as the Claude Code instance that chose its own name and posted at Adventures in Claude; the source does not say Lumen and Phin are the same collaborator.',
   'self_published','subject_authored','https://feld.com/archives/2026/03/i-built-a-plugin-because-anthropic-wont-stop-shipping/','feld.com','2026-03-29','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_027','m_feld',
   'Jason Mendelson is Feld''s co-author on Venture Deals.',
   'self_published','subject_authored','https://feld.com/books/','feld.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_028','m_feld',
   'Techstars'' official timeline says the company was incorporated in 2006 with founders David Cohen, David Brown, Brad Feld, and Jared Polis.',
   'on_record','publisher','https://www.techstars.com/about','techstars.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_029','m_feld',
   'Feld''s LinkedIn profile says he runs the Anchor Point Foundation with his wife, Amy Batchelor.',
   'self_published','subject_authored','https://www.linkedin.com/in/bfeld/','linkedin.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_cites_wilson','m_feld',
   'Feld says he met Fred Wilson in 1997, calls him a “smart dude,” and describes overlapping investments and boards; the prior corpus audit found Wilson citations across roughly 296 Feld posts.',
   'self_published','subject_authored','https://feld.com/archives/2005/02/fred-wilson-announces-the-launch-of-union-square-ventures/','feld.com','2005-02-10','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_031','m_feld',
   'Feld hosted an April 29, 2026 virtual fireside chat with Eric Ries about Incorruptible, building durable organizations, and the ideas behind Lean Startup.',
   'self_published','subject_authored','https://feld.com/archives/2026/04/give-first-build-right-with-eric-ries/','feld.com','2026-04-20','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_032','m_feld',
   'Feld wrote that he and his Foundry partners were investors in Hunter Walk''s Homebrew, establishing a direct LP relationship.',
   'self_published','subject_authored','https://feld.com/archives/2014/05/spending-day-another-vc-firm/','feld.com','2014-05-27','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_033','m_feld',
   'A prior audit of all 5,551 Feld Thoughts post bodies found zero occurrences of Sarah Tavel, Steve Huffman, Emmett Shear, Nabeel Qureshi, or Melanie Perkins. This is not a complete current exclusion: feld.com now serves a Pagefind WASM index that could not be queried headlessly.',
   'inferred','publisher','https://feld.com/archives/','feld.com','2026-09-03','2026-09-03T23:35:00Z','["f_feld_009"]',0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_034','m_feld',
   'Feld''s Goodreads author page is the broad public reading record he links when he says he lists everything he reads there, rather than only an author bibliography.',
   'on_record','publisher','https://www.goodreads.com/author/show/4395710.Brad_Feld','goodreads.com','2026-09-03','2026-09-03T23:35:00Z',NULL,0,NULL,NULL,'run_ingest_feld_20260903'),
  ('f_feld_035','m_feld',
   'The SEC adviser registry identifies Foundry Group, LLC as an active Boulder adviser (firm 159541; SEC 801-107412), but the entry does not name Feld and therefore corroborates only the firm attached to his current Foundry role.',
   'inferred','publisher','https://adviserinfo.sec.gov/firm/summary/159541','adviserinfo.sec.gov','2026-09-03','2026-09-03T23:35:00Z','["f_feld_001","f_feld_007"]',0,NULL,NULL,'run_ingest_feld_20260903');

UPDATE person_topic SET evidence_fact_id='f_feld_018'
 WHERE person_id='m_feld' AND topic_slug='venture-capital-craft';
UPDATE person_topic SET evidence_fact_id='f_feld_019'
 WHERE person_id='m_feld' AND topic_slug='startup-communities';
UPDATE person_topic SET evidence_fact_id='f_feld_020'
 WHERE person_id='m_feld' AND topic_slug='tech-policy-immigration';
UPDATE person_topic SET evidence_fact_id='f_feld_021'
 WHERE person_id='m_feld' AND topic_slug='reading-and-books';
UPDATE person_topic SET evidence_fact_id='f_feld_022'
 WHERE person_id='m_feld' AND topic_slug='endurance-running';

INSERT INTO context (person_id, type, value, resolved, evidence_fact_id) VALUES
  ('m_feld','place','boulder-co',1,'f_feld_005'),
  ('m_feld','pursuit','endurance-running',1,'f_feld_022');

INSERT INTO edge
  (from_id, to_id, type, evidence_fact_id, observed_at, strength, run_id)
VALUES
  ('m_feld','m_wilson','cited_in_own_writing','f_feld_cites_wilson','2026-09-03','STRONG','run_ingest_feld_20260903'),
  ('m_feld','m_ries','cited_in_own_writing','f_feld_019','2026-09-03','STRONG','run_ingest_feld_20260903'),
  ('m_feld','m_ries','co_appearance','f_feld_031','2026-04-29','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_ries','shared_org','f_feld_020','2026-09-03','STRONG','run_ingest_feld_20260903'),
  ('m_feld','m_walk','co_investment','f_feld_032','2014-05-27','STRONG','run_ingest_feld_20260903'),
  ('m_feld','p_amy_batchelor','family_or_partner','f_feld_029','2026-09-03','STRONG','run_ingest_feld_20260903'),
  ('m_feld','p_jason_mendelson','cited_in_own_writing','f_feld_027','2026-09-03','STRONG','run_ingest_feld_20260903'),
  ('m_feld','p_david_cohen','shared_org','f_feld_028','2026-09-03','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_tavel','no_edge_confirmed','f_feld_033','2026-09-03','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_huffman','no_edge_confirmed','f_feld_033','2026-09-03','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_shear','no_edge_confirmed','f_feld_033','2026-09-03','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_qureshi','no_edge_confirmed','f_feld_033','2026-09-03','MEDIUM','run_ingest_feld_20260903'),
  ('m_feld','m_perkins','no_edge_confirmed','f_feld_033','2026-09-03','MEDIUM','run_ingest_feld_20260903');

INSERT INTO source_status
  (person_id, source_id, tier, status, reason, http_code, fact_count, checked_at, run_id)
VALUES
  ('m_feld','blog_rss','GREEN','ok','20-item full-text feed reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','blog_archive','GREEN','ok','2.5 MB archive index reached; 5,551 unique posts enumerated and targeted pages checked.',200,16,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','books','GREEN','ok','Books page reached.',200,2,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','films','GREEN','ok','Films page reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','tags','GREEN','ok','Tag index reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','zero_knowledge','GREEN','ok','Serialized novel reached; 47 chapters visible.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','adventures_in_claude','GREEN','ok','Site reached and author bylines separated.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','firm_bio','GREEN','ok','Foundry team page reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','anchor_point','GREEN','ok','Foundation site reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','goodreads','GREEN','ok','Canonical author page reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','youtube_rss','GREEN','ok','Techstars feed reached; current Give First host attribution checked.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','wikipedia','GREEN','ok','Raw wikitext reached for career cross-check; not used as a render fact.',200,0,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','x_profile','GREEN','ok','Profile API reached.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','x_session','SESSION','ok','Authenticated browser render reached; newest post timestamp verified.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','linkedin_session','SESSION','ok','Authenticated browser render reached; profile and latest activity checked.',200,2,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','sec_form_d','GREEN','ok','Official 2022 Form D reached and Feld named.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','sec_iapd_probe','GREEN','ok','Official adviser record reached; firm found, Feld not named.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903'),
  ('m_feld','techstars_about_probe','GREEN','ok','Official timeline reached; co-founder relationship confirmed.',200,1,'2026-09-03T23:35:00Z','run_ingest_feld_20260903');

INSERT INTO fact_fts(fact_fts) VALUES('rebuild');
COMMIT;
