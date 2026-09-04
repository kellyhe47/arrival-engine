PRAGMA foreign_keys = ON;
BEGIN;

-- ── LinkedIn ──────────────────────────────────────────────────────────────────
-- Missing from his allow-list entirely on the first pass; roster.sql only carried a
-- linkedin_session row for Kopelman and Perkins. Three attempts, in order:
--   1. logged-out in the in-app browser  -> Sign Up redirect, wall fires before any content
--   2. Wayback snapshot 2025-01-26       -> readable, but itself a logged-out capture
--   3. the OPERATOR'S OWN Chrome session -> live, complete. SESSION tier, operator machine only.

INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

('f_wil_034','m_wilson','Archived LinkedIn profile (2025-01-26) at /in/fredwilson: og:title "Fred Wilson - Union Square Ventures", location "New York, New York, United States". Its Websites block listed three properties already confirmed as his — Blog http://avc.com, Company Website http://www.usv.com, RSS Feed http://feeds.feedburner.com/AVc — and the About section opened "Associate, Euclid Partners, 1987-1991 General Partner, Euclid Partners...".','self_published','subject_authored','http://web.archive.org/web/20250126031301/https://www.linkedin.com/in/fredwilson','web.archive.org','2025-01-26','2026-09-04T01:10:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_035','m_wilson','As archived 2025-01-26 the profile showed 7,000 followers and 352 connections. Read live on 2026-09-04 it showed 7,584 followers and 346 connections — two orders of magnitude below his X following, so not a candidate for the prominence measure.','on_record','publisher','https://www.linkedin.com/in/fredwilson/','linkedin.com','2026-09-04','2026-09-04T01:30:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_036','m_wilson','LinkedIn headline, read live 2026-09-04: "Managing Partner, Union Square Ventures". Location "New York, United States"; current company Union Square Ventures; education The Wharton School.','self_published','subject_authored','https://www.linkedin.com/in/fredwilson/','linkedin.com','2026-09-04','2026-09-04T01:30:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_037','m_wilson','His LinkedIn Experience section lists exactly two roles: "Partner, Union Square Ventures, Jan 2003 - Present" and "Managing Partner, Flatiron Partners, Jun 1996 - Present". Both disagree with better-sourced records. Form ADV Schedule A gives his USV title as acquired 01/2004 and Wikipedia dates the firm''s founding to 2004, not 2003; and Wikipedia has him and Jerry Colonna shutting Flatiron down in 2001, so "Present" is a two-decade-stale entry he has never cleared. Euclid Partners, which the 2025 archived About named, is absent from Experience altogether.','self_published','subject_authored','https://www.linkedin.com/in/fredwilson/details/experience/','linkedin.com','2026-09-04','2026-09-04T01:30:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_038','m_wilson','LinkedIn reports "Fred has no recent posts" on his activity panel, read live and logged in on 2026-09-04. This is a MEASURED quiet, not an unknown: the source was reached and the panel rendered. It is consistent with his own 2024 statement that he had left X for Farcaster, and with a frozen Threads account — the blog and Farcaster are where he actually publishes.','on_record','publisher','https://www.linkedin.com/in/fredwilson/','linkedin.com','2026-09-04','2026-09-04T01:30:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903');

INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_wilson','institution','Flatiron Partners',1,'f_wil_037');

-- Promoted to canonical: the live headline is self-authored content naming him in the role that
-- SEC Form ADV independently binds him to, which is subject_self_identifies (STRONG). No longer
-- resting on the three on-platform WEAK signals the Wayback pass had to settle for.
INSERT INTO person_identity (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_wilson','linkedin_session','https://www.linkedin.com/in/fredwilson/','fredwilson','canonical','SESSION','["subject_self_identifies","bio_backlink_to_canonical","display_name_matches"]',200,'2026-09-04',
  'Read live in the operator''s own Chrome session. Headline "Managing Partner, Union Square Ventures" matches the firm that Form ADV Schedule A binds him to as a Control Person, and the archived Websites block links avc.com. Logged out this URL is a Sign Up redirect; the Wayback snapshot 20250126031301 is the GREEN fallback and is itself a logged-out capture');

INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_wilson','linkedin_session','SESSION','ok','Read live in the OPERATOR''S OWN Chrome (SESSION tier, operator machine only, read-only, no write op issued). Top card, /details/experience/ and /details/education/ all fetched. Education detail page rendered no entries — Wharton is taken from the top card only. STRIPPED at the boundary per ingest-spec 6.3: the "3rd" degree-of-connection markers, and the entire "More profiles for you" suggestion rail, which named Sarah Tavel, Albert Wenger, Rebecca Kaden and Reid Hoffman. That rail is personalized to the operator and is NOT evidence of any edge — no edge was written from it',200,4,'2026-09-04T01:30:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','linkedin_public','GREEN','unavailable','Logged out, linkedin.com/in/fredwilson redirects to a "Join LinkedIn" Sign Up page. The wall fires BEFORE any profile content, so a logged-out redirect is not evidence the profile exists, let alone whose it is',NULL,0,'2026-09-04T01:10:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','linkedin_wayback','GREEN','ok','archive.org/wayback/available -> snapshot 20250126031301, fetched 200, 260,567 bytes. Superseded as evidence by the live session read, kept because it is the GREEN-only path if no session exists',200,1,'2026-09-04T01:10:00Z','run_ingest_wilson_20260903'),
 ('m_wilson','linkedin_cdx','GREEN','unavailable','web.archive.org/cdx/search/cdx returned 504 Gateway Time-out. Counted, not discarded (ingest-spec 7.1) — so no claim is made about how many archived copies exist',504,0,'2026-09-04T01:10:00Z','run_ingest_wilson_20260903');

COMMIT;
