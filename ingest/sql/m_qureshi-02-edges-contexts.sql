-- m_qureshi — member backfills, contexts, and directed edges.
-- Apply after m_qureshi-01-facts.sql.
PRAGMA foreign_keys = ON;
BEGIN;

-- Only this member's mutable roster fields are touched. Pronunciation remains NULL: no
-- subject-spoken audio was captured, and a spelling would be a guess.
UPDATE person
   SET career_start_decade='2000s'
 WHERE id='m_qureshi';

UPDATE person_topic SET evidence_fact_id='f_qureshi_003'
 WHERE person_id='m_qureshi' AND topic_slug='essay-craft';
UPDATE person_topic SET evidence_fact_id='f_qureshi_004'
 WHERE person_id='m_qureshi' AND topic_slug='reading-and-books';

INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_qureshi','place','New York City',1,'f_qureshi_009'),
 ('m_qureshi','place','England',0,'f_qureshi_010'),
 ('m_qureshi','institution','University of Oxford',1,'f_qureshi_010'),
 ('m_qureshi','institution','Bank of England',1,'f_qureshi_010'),
 ('m_qureshi','institution','GoCardless',1,'f_qureshi_010'),
 ('m_qureshi','institution','Palantir',1,'f_qureshi_008'),
 ('m_qureshi','institution','Mercatus Center at George Mason University',1,'f_qureshi_009'),
 ('m_qureshi','pursuit','essay writing',1,'f_qureshi_003'),
 ('m_qureshi','pursuit','reading Proust',1,'f_qureshi_004'),
 ('m_qureshi','pursuit','chess endgame training',1,'f_qureshi_015');

INSERT INTO edge
 (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_qureshi','p_will_manidis','co_appearance','f_qureshi_026','2026-09-04T01:30:00Z','STRONG','run_ingest_qureshi_20260903'),
 ('m_qureshi','p_tyler_cowen','co_appearance','f_qureshi_023','2026-09-04T01:38:00Z','STRONG','run_ingest_qureshi_20260903'),
 ('m_qureshi','p_tyler_cowen','follows','f_qureshi_019','2026-09-04T02:00:00Z','STRONG','run_ingest_qureshi_20260903'),
 ('m_qureshi','m_shear','co_mention','f_qureshi_020','2026-09-04T02:00:00Z','STRONG','run_ingest_qureshi_20260903'),
 ('m_qureshi','m_feld','no_edge_confirmed','f_qureshi_029','2026-09-04T01:43:00Z','MEDIUM','run_ingest_qureshi_20260903');

COMMIT;
