PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO run (id, started_at, execution_ctx, notes) VALUES
  ('run_ingest_kopelman_20260903','2026-09-04T01:08:46Z','operator_machine',
   'Content ingest for m_kopelman. Per-person store; source attempts and completion summary are finalized in m_kopelman-02-edges-contexts-backfill.sql.');

-- One-hop people only. These rows are merge-safe because other member ingests may reach them too.
INSERT OR IGNORE INTO person
  (id,is_member,display_name,name_respelling,seniority_tier,career_start_decade,
   prominence_tier,prominence_basis,created_run) VALUES
  ('p_robert_hayes',0,'Robert Hayes',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_william_trenchard',0,'William Trenchard',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_phineas_barnes',0,'Phineas Barnes',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_brett_berson',0,'Brett Berson',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_christopher_fralic',0,'Christopher Fralic',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_hayley_barna',0,'Hayley Barna',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_todd_jackson',0,'Todd Jackson',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_chukwuemeka_asonye',0,'Chukwuemeka Asonye',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_cristina_cordova',0,'Cristina Cordova',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_elizabeth_wessel',0,'Elizabeth Wessel',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_meg_whitman',0,'Meg Whitman',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903'),
  ('p_howard_morgan',0,'Howard Morgan',NULL,NULL,NULL,NULL,NULL,'run_ingest_kopelman_20260903');

-- New allow-list rows. Existing roster rows for Redeye, First Round, Wikipedia, X, and LinkedIn
-- are left untouched; the current LinkedIn measurement is appended under a distinct source id.
INSERT OR IGNORE INTO person_identity
  (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
  ('m_kopelman','blog_feed','https://feeds.feedburner.com/redeyevc','redeyevc','feed','GREEN',
   '["linked_from_own_canonical"]',200,'2026-09-03',
   'Valid RSS channel and metadata, but zero item elements. This is an unknown activity window, not evidence of quiet.'),
  ('m_kopelman','linkedin_session_current','https://www.linkedin.com/in/jkopelman','jkopelman','canonical','SESSION',
   '["linked_from_own_canonical","named_in_sec_filing"]',200,'2026-09-03',
   'Read-only operator session succeeded. The firm bio and 2026 Form ADV independently bind this exact slug to Kopelman.'),
  ('m_kopelman','podcast_annie','https://annieduke.substack.com/p/imagine-if-with-josh-kopelman',NULL,'archive','GREEN',
   '["subject_self_identifies"]',200,'2026-09-03',
   'Full public transcript dated 2024-12-12; Kopelman speaks in first person and identifies @joshk.'),
  ('m_kopelman','sec_form_d_vi','https://www.sec.gov/Archives/edgar/data/1682482/000168248216000002/primary_doc.xml',NULL,'api','GREEN',
   '["named_in_sec_filing"]',200,'2026-09-03','Fund VI D/A filed 2016-09-09.'),
  ('m_kopelman','sec_form_d_vii','https://www.sec.gov/Archives/edgar/data/1755714/000175571418000001/primary_doc.xml',NULL,'api','GREEN',
   '["named_in_sec_filing"]',200,'2026-09-03','Fund VII Form D filed 2018-10-18.'),
  ('m_kopelman','sec_form_d_ix','https://www.sec.gov/Archives/edgar/data/1926484/000192648422000001/primary_doc.xml',NULL,'api','GREEN',
   '["named_in_sec_filing"]',200,'2026-09-03','Fund IX Form D filed 2022-05-11.'),
  ('m_kopelman','sec_form_d_x','https://www.sec.gov/Archives/edgar/data/2086435/000208643525000001/primary_doc.xml',NULL,'api','GREEN',
   '["named_in_sec_filing"]',200,'2026-09-03','Fund X Form D filed 2025-09-17.'),
  ('m_kopelman','sec_adv_pdf','https://reports.adviserinfo.sec.gov/reports/ADV/160848/PDF/160848.pdf',NULL,'api','GREEN',
   '["named_in_sec_filing"]',200,'2026-09-03',
   'Annual amendment filed 2026-03-31; binds Joshua Marc Kopelman to jkopelman and @joshk.'),
  ('m_kopelman','kopelman_foundation','https://redeye.firstround.com/about-josh.html',NULL,'archive','GREEN',
   '["subject_self_identifies"]',200,'2026-09-03','Restored first-person biography on Kopelman''s own Redeye site.'),
  ('m_kopelman','uncensored','https://leanpub.com/uncensored','joshk','archive','GREEN',
   '["subject_self_identifies"]',200,'2026-09-03','Contributor biography binds Josh Kopelman to @joshk.'),
  ('m_kopelman','internet_archive','https://web.archive.org/web/20240520181107id_/https://redeye.firstround.com/2013/10/2904-days-ago.html',NULL,'archive','GREEN',
   '["linked_from_own_canonical"]',200,'2026-09-03','Byte-preserving capture of an allow-listed Redeye post.');

INSERT INTO fact
  (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,
   observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

  ('f_kopelman_001','m_kopelman',
   'First Round''s current team biography identifies Josh Kopelman as a Partner focused on the first 24 months of a company''s life; the page was last modified 2026-01-16.',
   'on_record','publisher','https://www.firstround.com/team/investing/josh-kopelman','firstround.com','2026-01-16',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_002','m_kopelman',
   'His official biography says he co-founded Infonautics in 1992 while in college, co-founded Half.com in 1999, stayed at eBay for three years after its 2000 acquisition, founded TurnTide in late 2003 and sold it within six months, then co-founded First Round in 2004.',
   'on_record','publisher','https://www.firstround.com/team/investing/josh-kopelman','firstround.com','2026-01-16',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_003','m_kopelman',
   'His official biography lists one second-place ribbon in the 2011 Nantucket Watermelon Eating competition and adds, in his voice, "I was robbed."',
   'on_record','subject_authored','https://www.firstround.com/team/investing/josh-kopelman','firstround.com','2026-01-16',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_004','m_kopelman',
   'The complete Redeye archive index lists 212 posts: 57 in 2006, 31 in 2007, 45 in 2008, 18 in 2009, 18 in 2010, 9 in 2011, 20 in 2012, 9 in 2013, and 5 in 2014. The corpus runs from 2006-03-08 through 2014-11-12; the sidebar still advertises 11,901 RSS subscribers.',
   'self_published','subject_authored','https://redeye.firstround.com/archives.html','redeye.firstround.com','2014-11-12',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_005','m_kopelman',
   'Writing about bridge loans versus preferred equity, Kopelman says First Round had made more than 20 seed-stage investments, strives to be the first money into a company, and generally prefers preferred equity; the post names Brad Feld while debating seed financing mechanics.',
   'self_published','subject_authored','https://redeye.firstround.com/2006/04/bridge_loans_vs_1.html','redeye.firstround.com','2006-04-09',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_006','m_kopelman',
   'In "Company Math vs. VC Math," Kopelman cites Fred Wilson approvingly and explains how ownership, investment size, and fund-return arithmetic can push venture investors toward outcomes that do not match founders'' company-level math.',
   'self_published','subject_authored','https://redeye.firstround.com/2009/10/company-math-vs-vc-math.html','redeye.firstround.com','2009-10-15',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_007','m_kopelman',
   'Kopelman says Half.com interns installed urinal screens in Penn Station, airports, hotels, and restaurants carrying the line "Don''t Piss Away All Your Money - Shop at Half.com"; he also says he had to explain to Meg Whitman what a urinal screen was.',
   'self_published','subject_authored','https://redeye.firstround.com/2006/03/get_your_fouls.html','redeye.firstround.com','2006-03-27',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_008','m_kopelman',
   'On the day Aggregate Knowledge announced its $119 million sale to Neustar, Kopelman published his 2005-11-17 cold email to Paul Martino, including: "if we were meeting in person, I would slide a check across the table right now." The email describes Kopelman and Howard Morgan as partners in a seed-stage fund.',
   'self_published','subject_authored','https://redeye.firstround.com/2013/10/2904-days-ago.html','redeye.firstround.com','2013-10-30',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_009','m_kopelman',
   'Kopelman thanked Eric Ries as an outside speaker at First Round''s 2010 CEO Summit.',
   'self_published','subject_authored','https://redeye.firstround.com/2010/01/sharing-and-exchanging.html','redeye.firstround.com','2010-01-28',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_010','m_kopelman',
   'Kopelman says he appeared on the 2009 Nantucket Conference panel "The Changing VC Industry" with Brad Feld, Jo Tango, and Paul Ciriello, moderated by Dan Primack.',
   'self_published','subject_authored','https://redeye.firstround.com/2009/03/nantucket-conference.html','redeye.firstround.com','2009-03-29',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_011','m_kopelman',
   'Kopelman''s restored first-person biography says that he and his wife created the Kopelman Foundation in 2001 to make start-up grants to social entrepreneurs.',
   'self_published','subject_authored','https://redeye.firstround.com/about-josh.html','redeye.firstround.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_012','m_kopelman',
   'The live Jewish Encyclopedia site says it contains the complete, unedited contents of the 12-volume encyclopedia originally published from 1901 to 1906, and its current homepage credits "Funded by The Kopelman Foundation."',
   'on_record','publisher','https://www.jewishencyclopedia.com/','jewishencyclopedia.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_013','m_kopelman',
   'The Jewish Encyclopedia terms, updated 2002-08-01, say the online service is owned and controlled by the Kopelman Foundation.',
   'on_record','publisher','https://www.jewishencyclopedia.com/terms_of_use','jewishencyclopedia.com','2002-08-01',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_014','m_kopelman',
   'Google Books catalogs JewishEncyclopedia.com as a 2002 digital reproduction and identifies the Kopelman Foundation as contributor and publisher.',
   'third_party','publisher','https://books.google.com/books/about/JewishEncyclopedia_com.html?id=H9wxzgEACAAJ','books.google.com','2002',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_015','m_kopelman',
   'The Kopelman Foundation that Josh and his wife created funded and controlled the 2002 online digitization/full-text reproduction of the 1901-1906 Jewish Encyclopedia, and the live project still credits the foundation in 2026. This does not claim that Kopelman personally performed the digitization.',
   'inferred','publisher','https://www.jewishencyclopedia.com/terms_of_use','jewishencyclopedia.com','2026-09-03',
   '2026-09-04T01:08:46Z','["f_kopelman_011","f_kopelman_012","f_kopelman_013","f_kopelman_014"]',0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_016','m_kopelman',
   'The Philadelphia Inquirer reports that Kopelman joined its board in 2015, became chair in 2016, led the board for eight years, stepped down at his term limit in 2024, and was elected to a three-year term as chair emeritus.',
   'third_party','publisher','https://www.inquirer.com/business/philadelphia-inquirer-board-lisa-kabnick-josh-kopelman-20240605.html','inquirer.com','2024-06-05',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_017','m_kopelman',
   'First Round Capital VI''s amended Form D, filed 2016-09-09, designates Josh Kopelman, Robert Hayes, William Trenchard, Phineas Barnes, Brett Berson, and Christopher Fralic as Executive Officers. Kopelman signs as Managing Member of the Ultimate GP of the GP.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1682482/000168248216000002/primary_doc.xml','sec.gov','2016-09-09',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_018','m_kopelman',
   'First Round Capital VII''s Form D, filed 2018-10-18, designates Josh Kopelman, Robert Hayes, William Trenchard, Phineas Barnes, Brett Berson, Christopher Fralic, and Hayley Barna as Executive Officers.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1755714/000175571418000001/primary_doc.xml','sec.gov','2018-10-18',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_019','m_kopelman',
   'First Round Capital IX''s Form D, filed 2022-05-11, designates Josh Kopelman, William Trenchard, Robert Hayes, Brett Berson, Christopher Fralic, Hayley Barna, Todd Jackson, Cristina Cordova, and a reversed-field "Asonye Chukwuemeka" entry as Executive Officers; Fund X resolves that person as Chukwuemeka Asonye.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1926484/000192648422000001/primary_doc.xml','sec.gov','2022-05-11',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_020','m_kopelman',
   'First Round Capital X''s Form D, filed 2025-09-17, designates Joshua Kopelman, William Trenchard, Brett Berson, Chukwuemeka Asonye, Hayley Barna, Todd Jackson, and Elizabeth Wessel as Executive Officers.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/2086435/000208643525000001/primary_doc.xml','sec.gov','2025-09-17',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_021','m_kopelman',
   'The Form ADV annual amendment filed 2026-03-31 names Joshua Marc Kopelman, CRD 6047358, as a limited partner and 75%+ control person of FR Capital Holdings, LP and managing member/control person of FR Capital Holdings LLC. It independently lists linkedin.com/in/jkopelman and x.com/joshk.',
   'on_record','publisher','https://reports.adviserinfo.sec.gov/reports/ADV/160848/PDF/160848.pdf','reports.adviserinfo.sec.gov','2026-03-31',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_022','m_kopelman',
   'Kopelman contributed "Founders and Heat Seeking Missiles" to the 2012 anthology Uncensored; his contributor bio reads "Josh Kopelman @joshk / VC. Father. Geek." Hunter Walk and Eric Ries authored the collection, which also includes contributors Fred Wilson and Brad Feld.',
   'third_party','publisher','https://leanpub.com/uncensored','leanpub.com','2012',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_023','m_kopelman',
   'Hunter Walk names Kopelman and First Round Capital as the people who largely drove the institutionalization of seed financing as a venture-capital practice.',
   'third_party','publisher','https://hunterwalk.com/2019/12/16/the-five-most-influential-vcs-of-the-2010s/','hunterwalk.com','2019-12-16',
   '2026-09-04T01:08:46Z',NULL,0,'cited_in_own_writing','m_walk','run_ingest_kopelman_20260903'),

  ('f_kopelman_024','m_kopelman',
   'A full-text search of all 212 Redeye posts found no mention of Sarah Tavel. This measured absence is limited to that complete, dated corpus and does not generalize to sources that were not searched.',
   'inferred','publisher','https://redeye.firstround.com/archives.html','redeye.firstround.com','2014-11-12',
   '2026-09-04T01:08:46Z','["f_kopelman_004"]',0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_025','m_kopelman',
   'For the paired-edge audit, Sarah Tavel''s current public feed contributed 20 posts to the searched corpus.',
   'third_party','publisher','https://www.sarahtavel.com/feed','sarahtavel.com','2025-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_026','m_kopelman',
   'For the paired-edge audit, the Adventurista archive contributed 113 Sarah Tavel posts to the searched corpus.',
   'third_party','publisher','https://web.archive.org/web/20140110041657/http://www.adventurista.com/','web.archive.org','2014-01-10',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_027','m_kopelman',
   'A full-text search of all 133 Sarah Tavel posts--20 current-feed posts plus 113 Adventurista archive posts--found no mention of Josh Kopelman. This measured absence is limited to those named corpora.',
   'inferred','publisher','https://www.sarahtavel.com/feed','sarahtavel.com','2025-09-03',
   '2026-09-04T01:08:46Z','["f_kopelman_025","f_kopelman_026"]',0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_028','m_kopelman',
   'The public X profile API identifies @joshk as Josh Kopelman and measured 150,180 followers on 2026-09-03, placing him in prominence tier 3 under the roster rule.',
   'on_record','publisher','https://api.fxtwitter.com/joshk','api.fxtwitter.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_029','m_kopelman',
   'The current @joshk X profile describes him as a father, husband, venture capitalist, INTJ, dad-joke lover, First Round partner, entrepreneur, and Philadelphia resident; the session view showed 6,460 posts and about 150.1K followers.',
   'self_published','subject_authored','https://x.com/joshk','x.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_030','m_kopelman',
   'On 2026-08-27, Kopelman congratulated David Tisch on a $1B-plus outcome and joked that he remembered cringing at Tisch''s cursing on the Bloomberg Techstars reality show.',
   'self_published','subject_authored','https://x.com/joshk/status/2092955278291456475','x.com','2026-08-27',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_031','m_kopelman',
   'On 2026-08-23, Kopelman wrote: "Series A, 2021: $150M post. Series AI, 2026: $1B post. Maybe the ''I'' stands for inflation."',
   'self_published','subject_authored','https://x.com/joshk/status/2091610680801562927','x.com','2026-08-23',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_032','m_kopelman',
   'A read-only X session confirmed that Fred Wilson follows @joshk. Two separate passes over @joshk''s following list did not find the reverse follow; this establishes only the positive Wilson-to-Kopelman follows edge and does not erase their independent citation relationships.',
   'on_record','publisher','https://x.com/fredwilson/following','x.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_033','m_kopelman',
   'The canonical LinkedIn profile /in/jkopelman identifies Kopelman as a First Round Capital partner in Philadelphia, lists the Wharton School, and showed 29,242 followers in the read-only session.',
   'self_published','subject_authored','https://www.linkedin.com/in/jkopelman','linkedin.com','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_034','m_kopelman',
   'The Josh Kopelman Wikipedia raw wikitext is 15,628 bytes and begins his career with the 1992 co-founding of Infonautics, independently placing his career start in the 1990s.',
   'third_party','third_party_open','https://en.wikipedia.org/w/index.php?title=Josh_Kopelman&action=raw','en.wikipedia.org','2026-09-03',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903'),

  ('f_kopelman_035','m_kopelman',
   'In Annie Duke''s published 2024-12-12 interview transcript, Kopelman says he started his first company in 1991. That differs by one year from the official biography and Wikipedia''s 1992 founding date but leaves the career-start decade unambiguously in the 1990s.',
   'on_record','subject_authored','https://annieduke.substack.com/p/imagine-if-with-josh-kopelman','annieduke.substack.com','2024-12-12',
   '2026-09-04T01:08:46Z',NULL,0,NULL,NULL,'run_ingest_kopelman_20260903');

COMMIT;
