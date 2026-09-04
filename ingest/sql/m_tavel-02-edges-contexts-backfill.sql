-- m_tavel — edges, contexts, source_status, identity rows, and the three backfills.
-- run_ingest_tavel_20260903. Apply AFTER m_tavel-01-facts.sql.
PRAGMA foreign_keys = ON;
BEGIN;

-- ═══ The absence-evidence fact the no_edge_confirmed rows point at ════════════
-- K-5 / R-011: an absence is only assertable if the corpus was actually searched.
-- v_assertable_absence reads only rows with a non-NULL evidence_fact_id.
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,run_id) VALUES
('f_tavel_051','m_tavel','MEASURED ABSENCE, corpus named. Searched: all 104 Adventurista posts (full text, 999,416 characters, 103/103 Wayback fetches succeeded and the failure count was kept — 0); all 23 Substack posts; all 10 Medium items; and her own X output via logged-in from:sarahtavel queries on both handles and full names. Zero hits for Brad Feld, Josh Kopelman, Steve Huffman, Emmett Shear, Eric Ries, Nabeel Qureshi or Melanie Perkins in the Adventurista corpus; the strings "Twitch" and "Lean Startup" never appear in it either. from:sarahtavel ("Fred Wilson" OR "Brad Feld" OR "Josh Kopelman" OR "Eric Ries" OR "Emmett Shear" OR "Melanie Perkins") returns NO RESULTS on X, and from:sarahtavel (bfeld OR ericries OR eshear OR MelanieCanva OR nabeelqu OR spez OR stevehuffman) returns only her two @joshk replies. "Reddit" and "Canva" appear in her blog only inside lists of product names, never as people.','inferred','subject_authored','https://web.archive.org/web/20140110041657/http://www.adventurista.com/','adventurista.com','2026-09-03','2026-09-03T23:55:00Z','["f_tavel_047","f_tavel_006","f_tavel_008","f_tavel_014"]',1,'run_ingest_tavel_20260903');

-- ═══ EDGES ════════════════════════════════════════════════════════════════════
-- Directed, typed, evidenced. Absences are written ONLY where the corpus was searched.
INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES

-- Wilson. Four citations across Adventurista, all about blogging or VC conduct.
 ('m_tavel','m_wilson','cited_in_own_writing','f_tavel_041','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','m_wilson','co_mention','f_tavel_015','2026-09-03T23:55:00Z','WEAK','run_ingest_tavel_20260903'),

-- Walk. The one member of the room she actually talks TO.
 ('m_tavel','m_walk','co_mention','f_tavel_017','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','m_walk','cited_in_own_writing','f_tavel_042','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),

-- Kopelman. Two replies, seven years apart. Thin, but real and directed.
 ('m_tavel','m_kopelman','co_mention','f_tavel_016','2026-09-03T23:55:00Z','WEAK','run_ingest_tavel_20260903'),

-- Measured ABSENCES. Corpus named in the evidence fact (f_tavel_051), below.
 ('m_tavel','m_feld','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),
 ('m_tavel','m_huffman','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),
 ('m_tavel','m_shear','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),
 ('m_tavel','m_ries','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),
 ('m_tavel','m_qureshi','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),
 ('m_tavel','m_perkins','no_edge_confirmed','f_tavel_051','2026-09-03T23:55:00Z',NULL,'run_ingest_tavel_20260903'),

-- Family. DEC-12: the edge itself never scores and is never named on a card.
 ('m_tavel','p_christine_lemke','family_or_partner','f_tavel_032','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),

-- Benchmark: SEC names the nine managing members of BCMC VIII in one footnote.
 ('m_tavel','p_matt_cohler','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_peter_fenton','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_bill_gurley','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_anyen_hu','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_mitchell_lasky','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_chetan_puttagunta','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_steven_spurlock','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_eric_vishria','shared_org','f_tavel_033','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_victor_lazarte','shared_org','f_tavel_003','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),
 ('m_tavel','p_miles_grimshaw','shared_org','f_tavel_003','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),

-- Former employers, from her own writing about the people there.
 ('m_tavel','p_ben_silbermann','employer_history','f_tavel_028','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_evan_sharp','employer_history','f_tavel_028','2026-09-03T23:55:00Z','STRONG','run_ingest_tavel_20260903'),
 ('m_tavel','p_john_lilly','employer_history','f_tavel_004','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),
 ('m_tavel','p_jeremy_levine','employer_history','f_tavel_020','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),
 ('m_tavel','p_philippe_botteri','employer_history','f_tavel_046','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903'),
 ('m_tavel','p_byron_deeter','employer_history','f_tavel_043','2026-09-03T23:55:00Z','MEDIUM','run_ingest_tavel_20260903');

-- ═══ CONTEXTS (S4) ════════════════════════════════════════════════════════════
-- A caption is a claim, not a geotag. Everything here is a place she states plainly
-- about herself, so resolved=1 — except the one that is genuinely a family origin
-- rather than a place she lives.
INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_tavel','place','San Francisco, California',1,'f_tavel_030'),
 ('m_tavel','place','New York City',1,'f_tavel_032'),
 ('m_tavel','place','Menlo Park, California',1,'f_tavel_027'),
 -- She has never said she lives in or is from Argentina; her mother emigrated from it
 -- and she has family there. resolved=0 so S4 never matches a member to her on it.
 ('m_tavel','place','Argentina',0,'f_tavel_019'),
 ('m_tavel','institution','Harvard University',1,'f_tavel_024'),
 ('m_tavel','institution','Stuyvesant High School',1,'f_tavel_025'),
 ('m_tavel','institution','Benchmark',1,'f_tavel_030'),
 ('m_tavel','institution','Pinterest',1,'f_tavel_028'),
 ('m_tavel','institution','Greylock Partners',1,'f_tavel_029'),
 ('m_tavel','institution','Bessemer Venture Partners',1,'f_tavel_027'),
 ('m_tavel','pursuit','rugby',1,'f_tavel_038'),
 ('m_tavel','pursuit','philosophy',1,'f_tavel_024'),
 ('m_tavel','pursuit','blogging',1,'f_tavel_036'),
 ('m_tavel','life_event','Shifted from General Partner to Venture Partner at Benchmark, 2025-04-29',1,'f_tavel_001');

-- ═══ SOURCE STATUS — one row per ATTEMPT ══════════════════════════════════════
-- This table is the only thing that separates "quiet" from "unknown" (R-040).
INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_tavel','blog_rss','GREEN','ok','20 full-text items, 2023-04-24 to 2025-09-03. sarahtavel.substack.com 301s to the custom domain',200,5,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','blog_archive_api','GREEN','ok','Substack archive API: 23 posts LIFETIME, 2023-02-22 to 2025-09-03. offset=50 returns an empty array, so 23 is a real total, not a window',200,1,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','substack_api','GREEN','ok','Bio verbatim, profile created 2023-01-04',200,1,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','medium_rss','GREEN','ok','10 items 2023-01-04 to 2024-04-02. The HTML profile 403s; the feed does not. A 10-item WINDOW, not a lifetime count',200,1,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','medium_html','GREEN','skipped','medium.com/@sarahtavel is 403 to automated clients; the feed carries the same posts and was used instead',403,0,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','x_profile','GREEN','ok','api.fxtwitter.com counts and bio only. 52,899 followers, 1,435 following, 9,417 posts, joined 2008-05-24',200,0,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','blog_archive','GREEN','ok','Wayback/adventurista.com. CDX returned 806 rows; 103 distinct post URLs after filtering, plus 1 recovered by hand = 104. ALL 103 CRAWL FETCHES SUCCEEDED, 0 FAILURES, COUNTED (ingest-spec 7.1)',200,13,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','podcast_guest','GREEN','ok','every.to "AI & I" with Dan Shipper, published 2025-04-30; full public transcript at /podcast/transcript-c09360f3-efda-4688-952d-203b9f5f4315',200,6,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','sec_person','GREEN','ok','CIK 0001774645 = "Tavel Sarah E". 17 filings (Forms 3/4/5) 2021-06-23 to 2022-12-02. Roster/prompt said 14 and mentioned Form Ds; measured is 17 and there are none',200,2,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','firm_site','GREEN','ok','benchmark.com, 2,297 bytes. Name, two addresses, one link. No bios, no blog, no feed; /people 404s. One fetch, not probed further',200,1,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','wikipedia','GREEN','ok','en.wikipedia.org/wiki/Sarah_Tavel is 404. She has no English Wikipedia article — so career_start_decade could not come from wikitext and came from SESSION LinkedIn instead',404,0,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','linkedin_session','SESSION','ok','linkedin.com/in/sarahtavel read through the operator''s logged-in browser, accessibility tree + article text. Headline, location, follower count, full experience and education, own post bodies and repost attribution lines. Personalization stripped at the boundary: degree-of-connection, "More profiles for you", "Explore Premium profiles", "Pages for you" and every "N connections work here" line were discarded, not stored',200,8,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','x_session','SESSION','ok','x.com/sarahtavel logged in. Bio, counts, joined date, post bodies and dates; targeted from: searches for all nine other members. "Followed by ..." and the Who-to-follow rail were discarded, not stored. The 1,435-entry FOLLOWING LIST was not walked — see the report',200,9,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','instagram_session','SESSION','ok','instagram.com/sarahtavel logged in. Bio, external handle refs and the three counters render; the account is PRIVATE, so the 119-post grid, all captions, all location tags and all post dates are closed. Not an auth failure — a setting of hers. The "Suggested for you" rail was discarded, not stored',200,1,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','tiktok_public','SESSION','unavailable','tiktok.com/@sarahtavel renders LOGGED OUT (a Log in button, no session on this machine): "Sarah Tavel", 378 following, 716 followers, 312 likes, bio "💫💯", and exactly ONE video ever, 107 views. IDENTITY NOT ESTABLISHED — handle_matches + display_name_matches from the SAME platform is precisely the @spez pair R-012 forbids, and the bio carries no backlink. No fact was written from it',200,0,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903'),
 ('m_tavel','facebook_session','SESSION','unavailable','No Facebook session on this machine (the page renders a logged-out Email/Password form). facebook.com/sarah.tavel — a GUESSED vanity URL, which is itself against the LinkedIn-protocol rule generalised — returns "This content isn''t available right now". Neither existence nor identity established in either direction',200,0,'2026-09-03T23:55:00Z','run_ingest_tavel_20260903');

-- ═══ IDENTITY — new allow-list rows measured this run ════════════════════════
-- Scoped to m_tavel only. No person_identity_negative row is added: no NEW collision
-- was measured. The TikTok account is unresolved, not proven-wrong — see the report.
INSERT OR IGNORE INTO person_identity (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_tavel','blog_archive_api','https://www.sarahtavel.com/api/v1/archive?sort=new&limit=50&offset=0',NULL,'api','GREEN','["subject_self_identifies"]',200,'2026-09-03','23 posts LIFETIME. offset=50 is empty, so this is a total, not a page'),
 ('m_tavel','medium_rss','https://medium.com/feed/@sarahtavel','sarahtavel','feed','GREEN','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03','THE FEED WORKS WHERE THE HTML 403s. 10-item window, dormant since 2024-04-02'),
 ('m_tavel','sec_person','https://data.sec.gov/submissions/CIK0001774645.json',NULL,'api','GREEN','["named_in_sec_filing"]',200,'2026-09-03','CIK binds the name: "Tavel Sarah E". 17 filings. Form 3 footnote names her a managing member of BCMC VIII alongside eight other Benchmark partners'),
 ('m_tavel','linkedin_session','https://www.linkedin.com/in/sarahtavel/','sarahtavel','canonical','SESSION','["bio_backlink_to_canonical","subject_self_identifies"]',200,'2026-09-03','NOT a guessed slug: the Websites block links sarahtavel.com, already confirmed hers, and the experience list reproduces the Bessemer/Pinterest/Greylock/Benchmark sequence her own Substack bio states and the SEC independently binds. Richest single Tavel artifact — it is the ONLY source for career_start_decade and for the rugby captaincy'),
 ('m_tavel','x_session','https://x.com/sarahtavel','sarahtavel','canonical','SESSION','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03','Website field is sarahtavel.com. Bio names @Benchmark and @pinterest. Her recency lives here, not on the blog'),
 ('m_tavel','instagram_session','https://www.instagram.com/sarahtavel/','sarahtavel','canonical','SESSION','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03','PRIVATE ACCOUNT — measured, not guessed. 119 posts, 623 followers. Bio names @cklemke, the same handle her X bio names. No grid, no captions, no location tags, no dates'),
 ('m_tavel','firm_site','https://www.benchmark.com/',NULL,'firm','GREEN','["display_name_matches"]',200,'2026-09-03','2,297 bytes. Deliberately empty. /people 404s. STOP PROBING IT'),
 ('m_tavel','tiktok_public','https://www.tiktok.com/@sarahtavel','sarahtavel','negative_probe','SESSION','["handle_matches","display_name_matches"]',200,'2026-09-03','UNRESOLVED, NOT ACCEPTED. Both corroboration kinds are WEAK and from the SAME platform — the exact pair R-012 forbids. Recorded as a negative_probe so it stays out of v_collectable_source. 1 video ever, 107 views');

-- ═══ BACKFILL (my rows only) ═════════════════════════════════════════════════
UPDATE person SET career_start_decade = '2000s'
 WHERE id = 'm_tavel';
-- name_respelling deliberately left NULL: no recording of her saying her own name was
-- obtained. The Every.to episode has audio and video, but only its TRANSCRIPT was read,
-- and a transcript cannot source a pronunciation. Never guess this column.

UPDATE person_topic SET evidence_fact_id = 'f_tavel_021' WHERE person_id='m_tavel' AND topic_slug='venture-capital-craft';
UPDATE person_topic SET evidence_fact_id = 'f_tavel_018' WHERE person_id='m_tavel' AND topic_slug='marketplace-dynamics';
UPDATE person_topic SET evidence_fact_id = 'f_tavel_038' WHERE person_id='m_tavel' AND topic_slug='rugby';

UPDATE run SET finished_at = '2026-09-04T00:40:00Z',
  notes = 'Content ingest, m_tavel. 16 source attempts: 13 ok, 2 unavailable, 1 skipped. BLOCKED: 1 auth error (facebook_session — no operator session). tiktok_public reached but IDENTITY UNRESOLVED, no facts written from it. Instagram is private BY HER SETTING, not by a wall. Recency OVERTURNED: her blog is 12 months silent but she posted on X three days before this run and reposts on LinkedIn one week before it — do not call her stale. Wayback/Adventurista: 103/103 fetches succeeded, failures counted (0). Prominence NOT touched: fxtwitter now reads 52,899 against the roster''s 52,896.'
 WHERE id = 'run_ingest_tavel_20260903';

COMMIT;
