PRAGMA foreign_keys = ON;
BEGIN;

-- ── Second pass: the operator's own Chrome ────────────────────────────────────
-- The in-app browser is a logged-out profile; the operator's Chrome carries live sessions. Same
-- SESSION tier, same operator machine, read-only, no write op issued. This turns two blockers into
-- measurements, and one of them into a MEASURED QUIET rather than an unknown.

INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

('f_wil_039','m_wilson','Instagram @fredwilson, read logged in 2026-09-04: 414 posts, 7,063 followers, 110 following, bio "I am a vc", link avc.com (the frozen archive, not avc.xyz). The newest post is 2021-04-24 — the same newest post the logged-out grid shows, so this is a MEASURED QUIET, not a wall artifact. He has not posted to Instagram in over five years.','self_published','subject_authored','https://www.instagram.com/fredwilson/','instagram.com','2026-09-04','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_040','m_wilson','Instagram post 2015-06-16, structured location tag "Paris Aeroport - Charles de Gaulle (CDG)", caption "In France on our way to Berlin".','self_published','subject_authored','https://www.instagram.com/fredwilson/p/3-5MCqRNy7/','instagram.com','2015-06-16','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_041','m_wilson','Instagram post 2015-05-11, caption in full: "In Venice this week". NO structured location tag. This is AUD-07-6 measured firsthand: the caption alone cannot distinguish Venice, Italy from Venice, California, and his profile carries support for both — a confirmed Los Angeles house and a Santa Monica coffee shop on one side, European travel on the other. Stored resolved=0; it must never match for S4.','self_published','subject_authored','https://www.instagram.com/fredwilson/p/2iv28_RNzB/','instagram.com','2015-05-11','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_042','m_wilson','Instagram post 2015-03-27: "Leaving LA today. I will miss these palm trees in front of our house. And freshly made corn tortillas and warm rice sushi and driving a convertible in February and all of our LA friends". A second home in Los Angeles, in his own words.','self_published','subject_authored','https://www.instagram.com/fredwilson/p/0vOH4FxN2E/','instagram.com','2015-03-27','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_043','m_wilson','Instagram post 2015-03-24, structured location tag "Primo Passo Coffee Company" — Santa Monica, California — three days before the "Leaving LA today" post.','self_published','subject_authored','https://www.instagram.com/fredwilson/p/0nUhRBxN6P/','instagram.com','2015-03-24','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_044','m_wilson','X following list, first page read logged in 2026-09-04 (1,345 entries total, virtualized): bgurley, mattturck, semil, msuster, ttunguz, joshelman, albertwenger, bryce, arampell, aweissman, chrisfralic. Two are his own USV partners. Notably @joshk (Kopelman) is NOT on the first page; the remaining ~1,334 entries were not walked, so his absence is NOT asserted.','self_published','subject_authored','https://x.com/fredwilson/following','x.com','2026-09-04','2026-09-04T01:45:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903');

-- Superseded: written when only the logged-out grid was reachable, so it could only say "newest
-- reachable". The logged-in grid shows the same newest post, which makes it a fact about him.
UPDATE fact SET superseded_by='f_wil_039' WHERE id='f_wil_029';

-- follows edges only for people already in the graph. The other nine first-page handles are not
-- written as person rows: a one-hop walk of 1,345 follows would collect strangers wholesale, which
-- is the privacy failure ingest-spec 9 bounds. Handles are retained in f_wil_044 as text.
INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_wilson','p_albert_wenger','follows','f_wil_044','2026-09-04T01:45:00Z','STRONG','run_ingest_wilson_20260903'),
 ('m_wilson','p_andy_weissman','follows','f_wil_044','2026-09-04T01:45:00Z','STRONG','run_ingest_wilson_20260903');

INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_wilson','place','France',1,'f_wil_040'),
 ('m_wilson','place','Berlin',1,'f_wil_040'),
 ('m_wilson','place','Los Angeles, California',1,'f_wil_042'),
 ('m_wilson','place','Santa Monica, California',1,'f_wil_043');

-- Re-point the unresolved Venice context off Wikipedia and onto the caption that actually creates
-- the ambiguity. Still resolved=0.
UPDATE context SET evidence_fact_id='f_wil_041'
 WHERE person_id='m_wilson' AND type='place' AND value='Venice (Venice CA vs Venice Italy — UNRESOLVED)';

-- Both walls cleared in the operator's Chrome.
UPDATE source_status SET status='ok', fact_count=4,
  reason='Two attempts. In-app browser: LOGGED OUT — a Sign up / Log in dialog overlays the profile and "Show more posts" is the wall. Operator''s own Chrome: OK, full grid and post pages. 414 posts confirmed; newest is 2021-04-24 in BOTH views, so the quiet is real, not a wall artifact. STRIPPED per ingest-spec 6.3: the operator''s own account handle, which is present in the logged-in page tree. /tagged/ present in the tree and NOT fetched — deny-listed injection surface. Post comments are third-party writing and were not attributed.',
  http_code=200, checked_at='2026-09-04T01:45:00Z'
 WHERE person_id='m_wilson' AND source_id='instagram_session' AND run_id='run_ingest_wilson_20260903';

UPDATE source_status SET status='ok', fact_count=1,
  reason='Two attempts. In-app browser: LOGGED OUT — /following redirects to the profile and renders "Something went wrong. Try reloading." Operator''s own Chrome: OK, the follow list renders. First page captured (11 handles). The remaining ~1,334 of 1,345 entries were NOT walked — that is a slow batch job, not a request-time call (ingest-spec 6.2), so no absence is assertable from this read. STRIPPED per 6.3: the trends rail and the "Who to follow" suggestion rail.',
  http_code=200, checked_at='2026-09-04T01:45:00Z'
 WHERE person_id='m_wilson' AND source_id='x_session' AND run_id='run_ingest_wilson_20260903';

-- linkedin_public was not a distinct source, only a different access mode on the same URL. Fold it
-- into linkedin_session's record rather than letting it stand as an unreached source.
DELETE FROM source_status
 WHERE person_id='m_wilson' AND source_id='linkedin_public' AND run_id='run_ingest_wilson_20260903';

UPDATE run SET finished_at='2026-09-04T01:50:00Z',
  notes='Content ingest, m_wilson. 17 sources ok, 1 unavailable. All three SESSION walls (X, Instagram, LinkedIn) cleared by reading in the OPERATOR''S OWN Chrome rather than the logged-out in-app browser. Coverage is still `unknown`, on one thing only: web.archive.org CDX 504''d, so the LinkedIn snapshot history was never enumerated.'
 WHERE id='run_ingest_wilson_20260903';

COMMIT;
