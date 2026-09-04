PRAGMA foreign_keys = ON;
BEGIN;

-- One-hop people are deliberately non-members. INSERT OR IGNORE makes this layer safe when
-- another parallel ingest has already introduced the same person id.
INSERT OR IGNORE INTO person
  (id,is_member,display_name,name_respelling,seniority_tier,career_start_decade,prominence_tier,prominence_basis,created_run)
VALUES
  ('p_satya_patel',0,'Satya Patel',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_caroline_barlerin',0,'Caroline Barlerin',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_dan_teran',0,'Dan Teran',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_brad_hargreaves',0,'Brad Hargreaves',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_austin_johnsen',0,'Austin Johnsen',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jason_del_rey',0,'Jason Del Rey',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_tom_preston_werner',0,'Tom Preston-Werner',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alex_heath',0,'Alex Heath',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alex_konrad',0,'Alex Konrad',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_joe_hyrkin',0,'Joe Hyrkin',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_molly_mielke',0,'Molly Mielke',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alex_levin',0,'Alex Levin',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_nilam_ganenthiran',0,'Nilam Ganenthiran',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_ben_braverman',0,'Ben Braverman',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_sandro_roco',0,'Sandro Roco',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_javier_soltero',0,'Javier Soltero',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_max_greenwald',0,'Max Greenwald',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_pat_kinsel',0,'Pat Kinsel',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_melanie_naranjo',0,'Melanie Naranjo',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_michael_mignano',0,'Michael Mignano',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_chris_neumann',0,'Chris Neumann',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_avni_patel_thompson',0,'Avni Patel Thompson',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_sar_haribhakti',0,'Sar Haribhakti',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_ashley_mayer',0,'Ashley Mayer',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jarrod_dicker',0,'Jarrod Dicker',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_andrew_bosworth',0,'Andrew Bosworth',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alex_taub',0,'Alex Taub',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_lenny_rachitsky',0,'Lenny Rachitsky',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_kia_kokalitcheva',0,'Kia Kokalitcheva',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_katie_carroll',0,'Katie Carroll',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jeff_berman',0,'Jeff Berman',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_adam_davidson',0,'Adam Davidson',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_rebecca_hanover',0,'Rebecca Hanover',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jason_shellen',0,'Jason Shellen',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_taylor_lorenz',0,'Taylor Lorenz',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_brian_morrissey',0,'Brian Morrissey',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_web_smith',0,'Web Smith',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_amber_discko',0,'Amber Discko',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_christy_turlington_burns',0,'Christy Turlington Burns',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_susan_lyne',0,'Susan Lyne',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_renee_diresta',0,'Renee DiResta',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_heather_hartnett',0,'Heather Hartnett',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_nick_quah',0,'Nick Quah',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alyssa_bereznak',0,'Alyssa Bereznak',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_casey_newton',0,'Casey Newton',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_derek_nelson',0,'Derek Nelson',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_tommy_vietor',0,'Tommy Vietor',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jennifer_pahlka',0,'Jennifer Pahlka',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_brett_hagler',0,'Brett Hagler',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_amy_chang',0,'Amy Chang',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_virginia_heffernan',0,'Virginia Heffernan',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_scott_harrison',0,'Scott Harrison',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_anneke_jong',0,'Anneke Jong',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_bianca_st_louis',0,'Bianca St. Louis',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_charles_best',0,'Charles Best',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_kyle_russell',0,'Kyle Russell',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_emily_lafave_olson',0,'Emily LaFave Olson',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_julia_boorstin',0,'Julia Boorstin',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_elle_luna',0,'Elle Luna',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_laura_weidman_powers',0,'Laura Weidman Powers',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_vanessa_pappas',0,'Vanessa Pappas',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_jessi_hempel',0,'Jessi Hempel',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alec_ross',0,'Alec Ross',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_adam_grant',0,'Adam Grant',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_kimberly_newell_green',0,'Kimberly Newell Green',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_sasha_lubomirsky',0,'Sasha Lubomirsky',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_ted_rheingold',0,'Ted Rheingold',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_shiva_rajaraman',0,'Shiva Rajaraman',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903'),
  ('p_alexia_tsotsis',0,'Alexia Tsotsis',NULL,NULL,NULL,NULL,NULL,'run_ingest_walk_20260903');

-- Arena-member and inner-circle relationships.
INSERT OR IGNORE INTO edge
  (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id)
VALUES
  ('m_walk','m_ries','co_appearance','f_walk_019','2012-02-23','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_wilson','co_appearance','f_walk_019','2012-02-23','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_feld','co_appearance','f_walk_019','2012-02-23','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_kopelman','co_appearance','f_walk_019','2012-02-23','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_wilson','cited_in_own_writing','f_walk_020','2012-03-04','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_feld','cited_in_own_writing','f_walk_020','2012-03-04','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_feld','co_investment','f_walk_021','2014-05-27','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_kopelman','cited_in_own_writing','f_walk_024','2019-12-16','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_tavel','cited_in_own_writing','f_walk_031','2025-03-18','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_satya_patel','shared_org','f_walk_022','2013-07-17','STRONG','run_ingest_walk_20260903'),
  ('m_walk','p_caroline_barlerin','family_or_partner','f_walk_007','2025-10-13','STRONG','run_ingest_walk_20260903'),
  ('m_walk','m_huffman','no_edge_confirmed','f_walk_032','2026-09-03','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','m_shear','no_edge_confirmed','f_walk_033','2026-09-03','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','m_perkins','no_edge_confirmed','f_walk_034','2026-09-03','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','m_qureshi','no_edge_confirmed','f_walk_035','2026-09-03','MEDIUM','run_ingest_walk_20260903');

-- Each edge below is backed by a clearly titled “Five Questions With…” post. Grouped evidence
-- facts keep the corpus compact while retaining the complete one-hop interview graph.
INSERT OR IGNORE INTO edge
  (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id)
VALUES
  ('m_walk','p_dan_teran','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_brad_hargreaves','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_austin_johnsen','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jason_del_rey','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_tom_preston_werner','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alex_heath','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alex_konrad','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_joe_hyrkin','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_molly_mielke','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alex_levin','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_nilam_ganenthiran','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_ben_braverman','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_sandro_roco','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_javier_soltero','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_max_greenwald','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_pat_kinsel','co_appearance','f_walk_036','2026-04-01','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_melanie_naranjo','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_michael_mignano','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_chris_neumann','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_avni_patel_thompson','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_sar_haribhakti','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_ashley_mayer','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jarrod_dicker','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_andrew_bosworth','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alex_taub','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_lenny_rachitsky','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_kia_kokalitcheva','co_appearance','f_walk_037','2023-08-31','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_katie_carroll','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jeff_berman','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_adam_davidson','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_rebecca_hanover','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jason_shellen','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_taylor_lorenz','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_brian_morrissey','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_web_smith','co_appearance','f_walk_038','2019-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_amber_discko','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_christy_turlington_burns','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_susan_lyne','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_renee_diresta','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_heather_hartnett','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_nick_quah','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alyssa_bereznak','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_casey_newton','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_derek_nelson','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_tommy_vietor','co_appearance','f_walk_039','2017-08-19','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jennifer_pahlka','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_brett_hagler','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_amy_chang','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_virginia_heffernan','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_scott_harrison','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_anneke_jong','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_bianca_st_louis','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_charles_best','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_kyle_russell','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_emily_lafave_olson','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_julia_boorstin','co_appearance','f_walk_040','2016-12-21','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_elle_luna','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_laura_weidman_powers','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_vanessa_pappas','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_jessi_hempel','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alec_ross','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_adam_grant','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_kimberly_newell_green','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_sasha_lubomirsky','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_ted_rheingold','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_shiva_rajaraman','co_appearance','f_walk_041','2016-02-24','MEDIUM','run_ingest_walk_20260903'),
  ('m_walk','p_alexia_tsotsis','co_appearance','f_walk_042','2016-02-24','MEDIUM','run_ingest_walk_20260903');

INSERT OR IGNORE INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
  ('m_walk','place','San Francisco, California',1,'f_walk_003'),
  ('m_walk','institution','Homebrew',1,'f_walk_001'),
  ('m_walk','institution','Screendoor',1,'f_walk_001'),
  ('m_walk','institution','Google',1,'f_walk_005'),
  ('m_walk','institution','YouTube',1,'f_walk_005'),
  ('m_walk','institution','Linden Lab',1,'f_walk_005'),
  ('m_walk','pursuit','live music and concerts',1,'f_walk_018'),
  ('m_walk','pursuit','coffee and paper notebooks',1,'f_walk_029'),
  ('m_walk','life_event','in therapy since 2011',1,'f_walk_027');

UPDATE person_topic SET evidence_fact_id='f_walk_023'
 WHERE person_id='m_walk' AND topic_slug='venture-capital-craft';
UPDATE person_topic SET evidence_fact_id='f_walk_024'
 WHERE person_id='m_walk' AND topic_slug='seed-stage-financing';
UPDATE person_topic SET evidence_fact_id='f_walk_018'
 WHERE person_id='m_walk' AND topic_slug='live-music';

-- These measured sources extend the roster allow-list. The two one-hop sources are explicitly
-- marked as not belonging to Walk; they were fetched only for dated relationship corroboration.
INSERT OR IGNORE INTO person_identity
  (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes)
VALUES
  ('m_walk','linkedin_cdx','https://web.archive.org/cdx/search/cdx?url=linkedin.com/in/hunterwalk&output=json&filter=statuscode:200&filter=mimetype:text/html&collapse=digest',
   'hunterwalk','archive','GREEN','["linked_from_own_canonical","bio_backlink_to_canonical","display_name_matches"]',200,'2026-09-03',
   'Archive index for the exact LinkedIn slug first attested by hunterwalk.com/about; returned 18 deduplicated captures from 2007 through 2025.'),
  ('m_walk','blog_member_search','https://hunterwalk.com/wp-json/wp/v2/posts?search=',
   'hunterwalk','api','GREEN','["subject_self_identifies"]',200,'2026-09-03',
   'Parameterized full-archive search on Walk’s allow-listed WordPress REST corpus; used for named arena-member queries.'),
  ('m_walk','feld_blog_lp','https://feld.com/archives/2014/05/spending-day-another-vc-firm/',
   NULL,'archive','GREEN','["display_name_matches","bio_backlink_to_canonical"]',200,'2026-09-03',
   'NOT his. Brad Feld’s first-person post names Hunter Walk and Homebrew and links the same Homebrew relationship independently described on Walk’s confirmed site; collected only as relationship evidence.'),
  ('m_walk','inner_circle_cbarlerin_x','https://api.fxtwitter.com/cbarlerin',
   'cbarlerin','api','GREEN','["linked_from_own_canonical","display_name_matches"]',200,'2026-09-03',
   'NOT his. The @cbarlerin handle is linked from Walk’s confirmed X bio after a family emoji; used only to corroborate the full name Caroline Barlerin. No partner-source fact was collected.');

INSERT INTO source_status
  (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id)
VALUES
  ('m_walk','canonical_about','GREEN','ok',
   'First-party biography reached; it directly attests the LinkedIn /in/hunterwalk slug before any LinkedIn collection.',200,2,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','linkedin_session','SESSION','ok',
   'Logged-out fetch first returned HTTP 999. The attested profile then loaded read-only in the signed-in operator Chrome session; only public profile, experience, follower, and activity fields were kept, with personalization and write affordances discarded.',200,5,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','linkedin_wayback','GREEN','ok',
   'Wayback availability resolved the attested slug to the 2025-08-06 snapshot, and the archived profile HTML was readable.',200,1,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','linkedin_cdx','GREEN','ok',
   'CDX returned 18 deduplicated captures from 2007 through 2025 for the attested LinkedIn slug.',200,0,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','blog_api','GREEN','ok',
   'WordPress REST was fully readable: 1,761 lifetime posts, 27 after 2026-03-01, plus targeted first-person posts and relationship evidence.',200,14,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','blog_member_search','GREEN','ok',
   'Targeted full-archive WordPress searches found Tavel citations and measured zero-result blog-corpus searches for Huffman, Shear, Perkins, and Qureshi.',200,4,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','blog_five_questions','GREEN','ok',
   'Both WordPress REST result pages were read: 103 search hits total, 85 within the 2016 cutoff. Sixty-six distinct in-budget interview subjects came from those hits; one additional 2016 interview was fetched directly while resolving the corpus.',200,7,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','bluesky_api','GREEN','ok',
   'Public profile and author-feed endpoints reached; feed rows were filtered to posts authored by the hunterwalk.com DID so reposted content was not misattributed.',200,2,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','github_api','GREEN','ok',
   'GitHub API name and canonical-domain fields confirmed the handle; zero public repositories is stored as a claimed handle, not code presence.',200,1,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','youtube_rss','GREEN','ok',
   'Confirmed Hunter Walk channel feed reached; all 15 entries and the 2006 channel creation date were read.',200,2,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','x_profile','GREEN','ok',
   'Sanctioned profile-measurement endpoint reached. Current count was 246,607, four below the seed; no prominence re-baseline was applied. Identity remains accepted on the three documented weak cross-source signals.',200,2,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','homebrew_blog','GREEN','ok',
   'All eight firm-blog pages were reachable through current August 2026 news. Article bylines are not exposed, so zero article text was attributed to Walk.',200,0,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','leanpub_uncensored','GREEN','ok',
   'Publisher metadata reached; it names Walk and Ries as authors and enumerates Wilson, Feld, and Kopelman among contributors.',200,1,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','feld_blog_lp','GREEN','ok',
   'Feld first-person post reached and states that he and his Foundry partners were investors in Homebrew.',200,1,'2026-09-04T01:50:00Z','run_ingest_walk_20260903'),
  ('m_walk','inner_circle_cbarlerin_x','GREEN','ok',
   'Profile measurement corroborated the full name Caroline Barlerin. No partner-source fact was collected; the relationship itself comes from Walk’s direct LinkedIn post.',200,0,'2026-09-04T01:50:00Z','run_ingest_walk_20260903');

-- External-content FTS tables require an explicit rebuild after direct fact insertion.
INSERT INTO fact_fts(fact_fts) VALUES('rebuild');

UPDATE run
   SET finished_at='2026-09-04T01:52:00Z',
       notes='Complete Hunter Walk sidecar ingest. 15 sources reached, 0 unavailable; no auth blockers. 42 renderable facts, 82 outgoing edges, 9 contexts. LinkedIn succeeded through the signed-in operator Chrome session after a logged-out HTTP 999, and Wayback also succeeded. Current X count was 246,607 versus seeded 246,611, while LinkedIn showed 882,825; prominence was deliberately not re-baselined. Homebrew firm-news bylines remain unverified, so none of that article text was attributed.'
 WHERE id='run_ingest_walk_20260903';

COMMIT;
