PRAGMA foreign_keys = ON;
BEGIN;

INSERT OR IGNORE INTO person (id,is_member,display_name,seniority_tier,prominence_tier,created_run) VALUES
 ('p_michael_mignano',0,'Michael Mignano',NULL,NULL,'run_ingest_wilson_20260903');

INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

-- X, read logged out. Profile fields + post bodies only; no follow graph.
('f_wil_024','m_wilson','Left X for Farcaster and said so on X: "Hi Everyone. This Twitter account has been dormant, except when it got hacked last year, for the last eighteen months. I''ve been sharing my thoughts on tech, startups, VC, music, life, etc onchain at Farcaster. If you still want to hear from me on that stuff, come follow me there" — posted 12:34 PM, 2024-05-21.','self_published','subject_authored','https://x.com/fredwilson/status/1792972279934267639','x.com','2024-05-21','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_025','m_wilson','His X account was taken over by a hacker in February 2024 and used to run a scam; he wrote up the incident himself as "Anatomy Of A Twitter/X Account Takeover Hack" and posted the explanation on 2024-02-09.','self_published','subject_authored','https://x.com/fredwilson/status/1755927442865229987','x.com','2024-02-09','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_026','m_wilson','The single exception to that X dormancy: on 2026-04-29 he posted "I took a walk around the Union Square neighborhood a couple of Fridays ago with our new partner @mignano and we recorded it so everyone can listen to our conversation." Michael Mignano is a new USV partner as of 2026.','self_published','subject_authored','https://x.com/fredwilson/status/2049492770331467867','x.com','2026-04-29','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- Threads. A measured dead channel.
('f_wil_027','m_wilson','Opened a Threads account on 2023-07-06 ("Setting up my threads"), posted four times over two days, and never posted again. 3,867 followers; bio "I am a vc", link avc.com. Last item 2023-07-07.','self_published','subject_authored','https://www.threads.com/@fredwilson','threads.com','2023-07-07','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_028','m_wilson','On Threads, 2023-07-07: "I''ve always wished the internet would let you share scents. @thegothamgal just baked this apricot thing (while doing a conference call) and the house smells amazing."','self_published','subject_authored','https://www.threads.com/@fredwilson','threads.com','2023-07-07','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- Instagram, read logged out. Post pages carry caption + structured location tag + absolute date.
('f_wil_029','m_wilson','Instagram @fredwilson: display name "fred wilson", bio "I am a vc", link avc.com (the frozen archive, not avc.xyz), 7,063 followers, following 110. Newest post reachable on the public grid is 2021-04-24.','self_published','subject_authored','https://www.instagram.com/fredwilson/','instagram.com','2021-04-24','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_030','m_wilson','Instagram post 2021-04-24, structured location tag "Greenwich Village", caption "Greenwich Village, NYC".','self_published','subject_authored','https://www.instagram.com/fredwilson/p/CODDKZJpxLn/','instagram.com','2021-04-24','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_031','m_wilson','Instagram post 2017-12-13, structured location tag "Good Room" — a Greenpoint, Brooklyn music venue — caption "Uzi".','self_published','subject_authored','https://www.instagram.com/fredwilson/p/Bcq3gykjLu6/','instagram.com','2017-12-13','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_032','m_wilson','Instagram post 2017-08-12, caption "Spesh giving Josh a putting lesson on eight" — golf, no location tag.','self_published','subject_authored','https://www.instagram.com/fredwilson/p/BXs-Ge3jpVj/','instagram.com','2017-08-12','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_033','m_wilson','Instagram post 2016-06-02, caption "View of the Williamsburg Bridge from inside the Domino Sugar Refinery".','self_published','subject_authored','https://www.instagram.com/fredwilson/p/BGKvNakRN2e/','instagram.com','2016-06-02','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903');

INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_wilson','p_michael_mignano','shared_org','f_wil_026','2026-09-03T23:40:00Z','STRONG','run_ingest_wilson_20260903');

INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_wilson','place','Greenwich Village, New York',1,'f_wil_030'),
 ('m_wilson','place','Good Room, Greenpoint, Brooklyn',1,'f_wil_031'),
 -- AUD-07-6 / ingest-spec 6.5. The only Venice evidence reached this run is Wikipedia, which is
 -- third_party_open and unrenderable, and the captions that would disambiguate LA from Italy sit
 -- behind the session wall. resolved=0: never matches for S4.
 ('m_wilson','place','Venice (Venice CA vs Venice Italy — UNRESOLVED)',0,'f_wil_022'),
 ('m_wilson','pursuit','golf',1,'f_wil_032'),
 ('m_wilson','pursuit','live music',1,'f_wil_031');

-- New allow-list rows measured this run
INSERT INTO person_identity (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_wilson','x_public','https://x.com/fredwilson','fredwilson','canonical','GREEN','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03',
  'Logged-OUT read. Contra ingest-spec 7.9, the logged-out profile DOES render bio, location, website, joined date, counters and post bodies via read_page. What it does NOT render is /following — that redirects to the profile and dies on "Something went wrong". Follow graph is session-only'),
 ('m_wilson','instagram_public','https://www.instagram.com/fredwilson/','fredwilson','canonical','GREEN','["bio_backlink_to_canonical","display_name_matches"]',200,'2026-09-03',
  'Logged-OUT read. Grid shows 12 tiles with dated alt text and no post count; /p/<id>/ pages DO render caption, structured location tag and absolute date. get_page_text works here — the a11y-tree-only rule is X-specific'),
 ('m_wilson','threads','https://www.threads.com/@fredwilson','fredwilson','canonical','GREEN','["linked_from_own_canonical","bio_backlink_to_canonical"]',200,'2026-09-03',
  'NEW this run. Linked from his own Instagram profile, which makes it linked_from_own_canonical (STRONG). Dead: 4 posts, all 2023-07-06/07');

INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_wilson','x_session','SESSION','unavailable','NO OPERATOR SESSION. Browser is logged out: profile shows Log in / Sign up. x.com/fredwilson/following redirects to the profile and renders "Something went wrong. Try reloading." No authentication attempted (00-COMMON rule 4). LOST: the 1,345-entry follow graph, and with it the Wilson->Kopelman follows edge and any test of the reverse',NULL,0,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','x_public','GREEN','ok','Logged-out profile + first 5 timeline items via a11y tree; two status pages opened for full text and absolute dates',200,3,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','instagram_session','SESSION','unavailable','NO OPERATOR SESSION. Logged out; a Sign up / Log in dialog overlays the profile. LOST: the full 414-post grid (only 12 tiles are reachable, "Show more" is the wall), the post COUNT, and every caption after 2021-04-24 — which is where the France / Berlin / Venice / cycling contexts live',NULL,0,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','instagram_public','GREEN','ok','Profile + 5 of the 12 reachable post pages. Walk stopped at the 2016-01-01 budget floor; 7 older tiles left unfetched',200,5,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','threads','GREEN','ok','4 posts, all 2023-07-06/07, then "Log in to see more" — but the account is visibly abandoned, not truncated',200,2,'2026-09-03T23:40:00Z','run_ingest_wilson_20260903');

UPDATE run SET finished_at='2026-09-04T00:20:00Z',
  notes='Content ingest, m_wilson. 15 sources ok, 2 unavailable. BLOCKED: 2 auth errors (x_session, instagram_session) — no operator session in the browser. Coverage is therefore unknown, not quiet. See ingest/BLOCKERS.md'
 WHERE id='run_ingest_wilson_20260903';

COMMIT;
