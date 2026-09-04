PRAGMA foreign_keys = ON;
BEGIN;

-- ── Backfill the two person columns S1 needs ─────────────────────────────────
-- 1980s, from two independent non-Wikipedia sources: his own "I got into VC in the mid 80s"
-- (f_wil_003) and USV's "a venture capitalist since 1987" (f_wil_015).
UPDATE person SET career_start_decade='1980s' WHERE id='m_wilson';
-- name_respelling stays NULL: "Fred Wilson" is obvious, and no recording was sought.

-- ── Edges ─────────────────────────────────────────────────────────────────────
INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_wilson','m_feld','cited_in_own_writing','f_wil_014','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','m_kopelman','cited_in_own_writing','f_wil_012','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_joanne_wilson','family_or_partner','f_wil_023','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_brad_burnham','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_albert_wenger','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_john_buttrick','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_andy_weissman','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_rebecca_kaden','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_nick_grossman','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_kerriann_rachlin','shared_org','f_wil_019','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_jerry_colonna','employer_history','f_wil_022','2026-09-03T23:40:00Z','MEDIUM','run_ingest_wilson_20260903');

-- ── Contexts (S4) ─────────────────────────────────────────────────────────────
INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_wilson','place','New York City',1,'f_wil_015'),
 ('m_wilson','place','East end of Long Island, New York',1,'f_wil_011'),
 ('m_wilson','institution','United States Military Academy, West Point',1,'f_wil_009'),
 ('m_wilson','institution','Massachusetts Institute of Technology',1,'f_wil_015'),
 ('m_wilson','institution','The Wharton School, University of Pennsylvania',1,'f_wil_015'),
 ('m_wilson','institution','Union Square Ventures',1,'f_wil_018'),
 ('m_wilson','institution','SoundCloud',1,'f_wil_001'),
 ('m_wilson','institution','Tech:NYC',1,'f_wil_016'),
 ('m_wilson','pursuit','vinyl records',1,'f_wil_011'),
 ('m_wilson','pursuit','AI-assisted coding',1,'f_wil_004'),
 ('m_wilson','pursuit','onchain prediction markets',1,'f_wil_005'),
 ('m_wilson','life_event','death of his father, December 2020',1,'f_wil_010');

-- ── Topic evidence backfill (§8.3) ────────────────────────────────────────────
UPDATE person_topic SET evidence_fact_id='f_wil_015' WHERE person_id='m_wilson' AND topic_slug='venture-capital-craft';
UPDATE person_topic SET evidence_fact_id='f_wil_007' WHERE person_id='m_wilson' AND topic_slug='crypto-protocols';
UPDATE person_topic SET evidence_fact_id='f_wil_011' WHERE person_id='m_wilson' AND topic_slug='music-collecting';

-- ── Allow-list rows for the three sources measured this run (§3.1) ────────────
INSERT INTO person_identity (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_wilson','usv_bio','https://www.usv.com/people/fred-wilson/','fredwilson','firm','GREEN','["named_in_sec_filing","bio_backlink_to_canonical"]',200,'2026-09-03',
  'Firm page. Bound STRONG by Form ADV Schedule A naming "WILSON, FREDERICK, R." a MEMBER of this exact firm (CRD 162375); page also links @fredwilson and avc.com'),
 ('m_wilson','sec_adv_pdf','https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf',NULL,'api','GREEN','["named_in_sec_filing"]',200,'2026-09-03',
  '6.7 MB, pdftotext -layout. Schedule A at line 11841. Filing dated 2026-03-27'),
 ('m_wilson','partner_blog','https://gothamgal.com/feed/','gothamgal','feed','GREEN','["linked_from_own_canonical"]',200,'2026-09-03',
  'NOT his. Joanne Wilson''s blog, admitted under DEC-12 as a family_or_partner source of facts ABOUT him. Every fact from it carries via_edge_type=family_or_partner and via_person_id=p_joanne_wilson. The edge itself never scores and is never named on a card');

-- ── Source attempts, GREEN half ───────────────────────────────────────────────
INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_wilson','blog_rss','GREEN','ok','20 items, full content:encoded, 2025-12-18 to 2026-07-23',200,7,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','blog_search','GREEN','ok','6 targeted queries (brad feld, josh kopelman, my father, MBA Mondays, vinyl, vietnam). NOTE: /?s= 302s to /search/<q>/ — curl needs -L or every query silently returns 0 bytes',200,0,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','blog_archive','GREEN','ok','6 individual posts fetched by URL from search results. Archive NOT walked',200,6,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','wikipedia','GREEN','ok','Disambiguated title Fred_Wilson_(financier), action=raw wikitext, 7,162 bytes',200,1,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','farcaster','GREEN','ok','fid 169, full JSON, no wall',200,1,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','sec_iapd','GREEN','ok','3 hits; firm_source_id 162375 is the right one (UNION LABS is a different San Mateo firm and matches the same query)',200,0,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','sec_adv_pdf','GREEN','ok','6,667,899 bytes, Schedule A parsed',200,2,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','usv_bio','GREEN','ok','Bio + recent/most-read lists. His newest item there is 2024-10-08',200,3,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','x_profile','GREEN','ok','Counters only, no content. 640,844 followers (roster says 640,845 — drift of 1, not restated as a new measurement)',200,1,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','partner_blog','GREEN','ok','10 items, 2026-08-05 to 2026-08-27. Scanned all 10 for any mention of him: zero hits',200,1,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903');

COMMIT;
