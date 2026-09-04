PRAGMA foreign_keys = ON;
BEGIN;

-- Directed relationship evidence. INSERT OR IGNORE keeps this replayable when another member's
-- ingest has already written the same shared edge.
INSERT OR IGNORE INTO edge
  (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
  ('m_kopelman','m_wilson','cited_in_own_writing','f_kopelman_006','2009-10-15','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_feld','cited_in_own_writing','f_kopelman_005','2006-04-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_feld','co_appearance','f_kopelman_010','2009-03-29','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_ries','co_appearance','f_kopelman_009','2010-01-28','MEDIUM','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_meg_whitman','co_mention','f_kopelman_007','2006-03-27','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_howard_morgan','co_investment','f_kopelman_008','2013-10-30','STRONG','run_ingest_kopelman_20260903'),
  ('m_walk','m_kopelman','cited_in_own_writing','f_kopelman_023','2019-12-16','STRONG','run_ingest_kopelman_20260903'),
  ('m_wilson','m_kopelman','follows','f_kopelman_032','2026-09-03','STRONG','run_ingest_kopelman_20260903'),

  ('m_kopelman','m_walk','shared_org','f_kopelman_022','2012','MEDIUM','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_ries','shared_org','f_kopelman_022','2012','MEDIUM','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_wilson','shared_org','f_kopelman_022','2012','MEDIUM','run_ingest_kopelman_20260903'),
  ('m_kopelman','m_feld','shared_org','f_kopelman_022','2012','MEDIUM','run_ingest_kopelman_20260903'),

  ('m_kopelman','m_tavel','no_edge_confirmed','f_kopelman_024','2026-09-03','STRONG','run_ingest_kopelman_20260903'),

  ('m_kopelman','p_robert_hayes','shared_org','f_kopelman_017','2016-09-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_william_trenchard','shared_org','f_kopelman_017','2016-09-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_phineas_barnes','shared_org','f_kopelman_017','2016-09-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_brett_berson','shared_org','f_kopelman_017','2016-09-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_christopher_fralic','shared_org','f_kopelman_017','2016-09-09','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_hayley_barna','shared_org','f_kopelman_018','2018-10-18','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_todd_jackson','shared_org','f_kopelman_019','2022-05-11','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_chukwuemeka_asonye','shared_org','f_kopelman_020','2025-09-17','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_cristina_cordova','shared_org','f_kopelman_019','2022-05-11','STRONG','run_ingest_kopelman_20260903'),
  ('m_kopelman','p_elizabeth_wessel','shared_org','f_kopelman_020','2025-09-17','STRONG','run_ingest_kopelman_20260903');

INSERT OR IGNORE INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
  ('m_kopelman','place','Philadelphia, Pennsylvania',1,'f_kopelman_033'),
  ('m_kopelman','institution','First Round Capital',1,'f_kopelman_001'),
  ('m_kopelman','institution','The Wharton School, University of Pennsylvania',1,'f_kopelman_033'),
  ('m_kopelman','institution','Infonautics Corporation',1,'f_kopelman_002'),
  ('m_kopelman','institution','Half.com',1,'f_kopelman_002'),
  ('m_kopelman','institution','eBay',1,'f_kopelman_002'),
  ('m_kopelman','institution','TurnTide',1,'f_kopelman_002'),
  ('m_kopelman','institution','The Philadelphia Inquirer',1,'f_kopelman_016'),
  ('m_kopelman','institution','Kopelman Foundation',1,'f_kopelman_011'),
  ('m_kopelman','institution','Jewish Encyclopedia',1,'f_kopelman_015'),
  ('m_kopelman','pursuit','seed-stage venture investing',1,'f_kopelman_005'),
  ('m_kopelman','life_event','second place, 2011 Nantucket Watermelon Eating competition',1,'f_kopelman_003');

-- S1 and topic provenance. The official 1992 career date and the raw wikitext agree on the decade;
-- the 2024 interview says 1991, which does not change the decade.
UPDATE person SET career_start_decade='1990s'
 WHERE id='m_kopelman';

UPDATE person_topic SET evidence_fact_id='f_kopelman_006'
 WHERE person_id='m_kopelman' AND topic_slug='venture-capital-craft';
UPDATE person_topic SET evidence_fact_id='f_kopelman_005'
 WHERE person_id='m_kopelman' AND topic_slug='seed-stage-financing';

INSERT INTO source_status
  (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
  ('m_kopelman','blog_archive','GREEN','ok',
   'Complete 212-post archive index reached and fully searched for the specified member-edge names; targeted posts fetched directly.',200,8,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','blog_feed','GREEN','ok',
   'Valid channel; lastBuildDate Tue, 21 May 2019 23:04:36 +0000; zero item elements. Fact count is zero and source-level recency is UNKNOWN, not quiet.',200,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','firm_bio','GREEN','ok',
   'Current team biography reached; sitemap lastmod 2026-01-16T20:07:39Z.',200,3,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','wikipedia','GREEN','ok',
   'Raw wikitext reached, 15,628 bytes; stored as third_party_open and not renderable.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','x_profile','GREEN','ok',
   'API name matched Josh Kopelman; 150,180 followers measured.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','x_session','SESSION','ok',
   'Read-only signed-in profile and current timeline reached. Following graph checked twice; personalization strings discarded.',200,4,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','linkedin_session_current','SESSION','ok',
   'Canonical /in/jkopelman profile reached in read-only session; headline, location, company, education, and follower count extracted; personalization discarded.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','podcast_colossus','GREEN','ok',
   'Episode page reached. No transcript claim imported from this page.',200,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','podcast_20vc','GREEN','ok',
   'Episode page and show notes reached. No transcript claim imported from this page.',200,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','podcast_annie','GREEN','ok',
   'Full public 2024-12-12 transcript reached; one first-person career fact imported.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','sec_form_d_vi','GREEN','ok',
   'Fund VI D/A primary XML reached; filed 2016-09-09.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','sec_form_d_vii','GREEN','ok',
   'Fund VII primary XML reached; filed 2018-10-18, signed 2018-10-17.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','sec_form_d_ix','GREEN','ok',
   'Fund IX primary XML reached; reversed Asonye/Chukwuemeka fields preserved in fact text and resolved by Fund X.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','sec_form_d_x','GREEN','ok',
   'Fund X primary XML reached; filed 2025-09-17.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','sec_adv_pdf','GREEN','ok',
   'Current Form ADV PDF reached; annual amendment filed 2026-03-31.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','inquirer_board','GREEN','ok',
   'Publisher article reached; distinguishes board service beginning 2015 from chairmanship 2016-2024.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','kopelman_foundation','GREEN','ok',
   'Restored first-person About Josh page reached.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','jewish_encyclopedia','GREEN','ok',
   'Live homepage and Terms of Use reached; current funding credit and 2002 control statement imported.',200,2,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','google_books','GREEN','ok',
   'Catalog record for the 2002 digital reproduction reached.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','uncensored','GREEN','ok',
   'Leanpub anthology page and contributor biography reached.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','walk_blog','GREEN','ok',
   'Hunter Walk post reached; direct citation imported through one hop.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','tavel_current_feed','GREEN','ok',
   'All 20 current-feed posts included in the paired full-text absence measurement.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','tavel_archive','GREEN','ok',
   'All 113 Adventurista posts included in the paired full-text absence measurement.',200,1,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','openlibrary_inside','GREEN','unavailable',
   'Both HTTPS and HTTP low-volume search/inside requests failed to connect (curl code 7 / HTTP 000). No zero-result or absence claim was made.',NULL,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','internet_archive','GREEN','ok',
   'Byte-preserving captures of the Redeye index and cold-email post reached and corroborated the live pages.',200,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903'),
  ('m_kopelman','internet_archive_retry','GREEN','unavailable',
   'A later CDX request returned an Internet Archive Temporarily Offline page. Successful direct captures are recorded separately; no absence claim uses this retry.',NULL,0,'2026-09-04T01:08:46Z','run_ingest_kopelman_20260903');

UPDATE run
   SET finished_at='2026-09-04T01:15:32Z',
       notes='Content ingest, m_kopelman. 24 sources ok, 2 unavailable; no auth blockers. 35 facts, 23 edges, 12 contexts. X and LinkedIn show current activity, but store-level coverage is unknown because Open Library and one Internet Archive retry were unavailable; the valid zero-item FeedBurner channel is also not evidence of quiet. Long-form thinness is a true finding: the fully indexed Redeye first-person corpus ends in 2014. The Tavel-to-Kopelman blog-corpus absence remains a fact but is not promoted to a no-edge after the Tavel ingest found two X replies.'
 WHERE id='run_ingest_kopelman_20260903';

COMMIT;
