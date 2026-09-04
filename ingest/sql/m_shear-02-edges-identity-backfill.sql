-- m_shear — edges, contexts, identity rows, source attempts, backfill.
-- Apply AFTER m_shear-01-facts.sql: every edge and context here references a fact id from it.
PRAGMA foreign_keys = ON;
BEGIN;

-- ═══ EDGES ════════════════════════════════════════════════════════════════════
-- Directed. The Shear <-> Huffman pair is the point of this profile: SYMMETRIC as
-- shared_org, ASYMMETRIC as citation. Only the Shear -> Huffman citation is measured.
INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_shear','m_huffman','shared_org','f_shear_059','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_huffman','m_shear','shared_org','f_shear_059','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','m_huffman','cited_in_own_writing','f_shear_003','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),

 -- The second, independent bridge: Adam Goldstein cofounded Hipmunk with Huffman and
 -- cofounded Softmax with Shear. Both legs are one-hop; no hop 2 is taken from Goldstein.
 ('m_shear','p_adam_goldstein','shared_org','f_shear_023','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_adam_goldstein','board_together','f_shear_011','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_david_bloomin','shared_org','f_shear_023','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_david_langer','board_together','f_shear_011','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_yatharth_agarwal','shared_org','f_shear_007','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),

 -- Justin.tv / Twitch / Kiko. Kan is the 17-year relationship; Seibel is the Reddit-board leg.
 ('m_shear','p_justin_kan','shared_org','f_shear_020','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_justin_kan','employer_history','f_shear_021','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_michael_seibel','shared_org','f_shear_021','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_kyle_vogt','shared_org','f_shear_021','2026-09-04T01:45:00Z','STRONG','run_ingest_shear_20260903'),
 ('m_shear','p_dan_clancy','employer_history','f_shear_021','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_leonore_estrada','co_appearance','f_shear_024','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','p_alexis_ohanian','cited_in_own_writing','f_shear_005','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),

 -- The one LinkedIn repost in two years.
 ('m_shear','p_michael_seibel','repost','f_shear_049','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),

 -- Follow graph. Only the 70 reached are assertable as follows; see f_shear_034.
 ('m_shear','m_qureshi','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_michael_seibel','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_justin_kan','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_kyle_vogt','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_yatharth_agarwal','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),
 ('m_shear','p_trevor_blackwell','follows','f_shear_034','2026-09-04T01:45:00Z','MEDIUM','run_ingest_shear_20260903'),

 -- MEASURED ABSENCES over a NAMED corpus: 927 HN items, full-text searched. See f_shear_057.
 -- NOTE these are absences in HIS OWN WRITING ON HN ONLY. They are NOT claims about the
 -- follow graph, which was read at 70/1,193 and is far too partial to assert an absence from
 -- (R-011). Wilson gets one too: the name occurs only in HN story titles, never in Shear's text.
 ('m_shear','m_wilson','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_feld','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_kopelman','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_tavel','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_walk','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_ries','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903'),
 ('m_shear','m_perkins','no_edge_confirmed','f_shear_057','2026-09-04T01:45:00Z','WEAK','run_ingest_shear_20260903');

-- ═══ CONTEXTS (S4) ════════════════════════════════════════════════════════════
INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_shear','place','San Francisco, California',1,'f_shear_046'),
 ('m_shear','place','Seattle, Washington',1,'f_shear_018'),
 ('m_shear','institution','Yale University',1,'f_shear_018'),
 ('m_shear','institution','Y Combinator',1,'f_shear_020'),
 ('m_shear','institution','Softmax',1,'f_shear_010'),
 ('m_shear','institution','Twitch',1,'f_shear_021'),
 ('m_shear','institution','SF New Deal',1,'f_shear_024'),
 ('m_shear','life_event','Interim CEO of OpenAI, November 2023',1,'f_shear_022'),
 ('m_shear','life_event','Resigned as CEO of Twitch, March 2023',1,'f_shear_021'),
 ('m_shear','life_event','Co-founded Softmax, March 2025',1,'f_shear_023'),
 ('m_shear','pursuit','Reading and book lists',1,'f_shear_015'),
 ('m_shear','pursuit','Amateur physics, self-described crackpot quantum gravity',1,'f_shear_035'),
 ('m_shear','pursuit','Magic: The Gathering',1,'f_shear_019'),
 -- Deliberately unresolved: "Crystal Towers" is the name he gives a 2006 building in his own
 -- blog post and nothing else in the corpus disambiguates it. Do not match on it.
 ('m_shear','place','Crystal Towers',0,'f_shear_042');

-- ═══ ALLOW-LIST additions (all m_shear; INSERT OR IGNORE, merge-safe) ═════════
INSERT OR IGNORE INTO person_identity
 (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_shear','hn_algolia','https://hn.algolia.com/api/v1/search_by_date?tags=author_emmett','emmett','api','GREEN','["subject_self_identifies"]',200,'2026-09-03','927 items, the mineable form of the Firebase list. Firebase `submitted` reads 1,167 — the gap is dead/deleted items'),
 ('m_shear','firm_team','https://softmax.com/team',NULL,'canonical','GREEN','["subject_self_identifies","linked_from_own_canonical"]',200,'2026-09-03','THE page that fixes his LinkedIn slug. His own card links x.com/eshear and linkedin.com/in/emmettshear and nothing else'),
 ('m_shear','personal_site','https://www.edbs.media/',NULL,'canonical','GREEN','["subject_self_identifies","linked_from_own_canonical"]',200,'2026-09-03','NEW THIS RUN. "Educational Database System". Pages: / (first-person index), /aging (Im/mortality), /books, /books2024. Linked from his own LinkedIn post. Only /aging, /books, /books2024 exist; the nav labels are not the paths'),
 ('m_shear','linkedin_session','https://www.linkedin.com/in/emmettshear/','emmettshear','canonical','SESSION','["linked_from_own_canonical"]',200,'2026-09-04','Slug FOUND on softmax.com/team, never guessed. Read live on the operator Chrome, read-only. Headline "Researching organic alignment", 5,879 followers'),
 ('m_shear','linkedin_archive','http://web.archive.org/web/20260521164402/https://www.linkedin.com/in/emmettshear','emmettshear','archive','GREEN','["linked_from_own_canonical"]',200,'2026-09-04','The logged-out surface, 2026-05-21. Carries og:title, location, 6K followers, 500+ connections, a Languages section and the Justin Kan recommendation. Carries NO Experience or Education section. CDX also shows a decade of 999s: 2016, 2021-2023, 2025-11'),
 ('m_shear','instagram_session','https://www.instagram.com/emmettshear/','emmettshear','canonical','SESSION','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-04','RESOLVED THIS RUN, and it is the emmettshear slug, not eshear. subject_self_identifies is text INSIDE the first post image: "This is my official account". 4 posts / 11 followers — claimed, not used. Treat any content beyond the bio with suspicion'),
 ('m_shear','threadreader','https://threadreaderapp.com/user/eshear','eshear','archive','GREEN','["subject_self_identifies"]',200,'2026-09-03','18 unrolled threads, 2024-04-09 to 2025-11-24. The long-form workaround for the timeline'),
 ('m_shear','yale_paper','http://web.archive.org/web/20230610081136/https://cpsc.yale.edu/sites/default/files/files/tr1285.pdf',NULL,'archive','GREEN','["linked_from_own_canonical","display_name_matches"]',200,'2026-09-03','YALEU/DCS/TR-1285, April 2004. Linked from edbs.media. cpsc.yale.edu 403s every automated client; Wayback is the only path'),
 ('m_shear','substack','https://eshear.substack.com/','eshear','dead','GREEN','["display_name_matches","handle_matches"]',200,'2026-09-03','ONE post ever, "Coming soon", 2023-10-17. Feed and archive API both 200 with that single item. Identity is a WEAK pair on one platform and is NOT sufficient — role is dead and nothing was collected from it as fact beyond its own emptiness'),
 ('m_shear','facebook_session','https://www.facebook.com/emmett.shear','emmett.shear','negative_probe','SESSION','["linked_from_own_canonical"]',200,'2026-09-04','Slug is from the Wikipedia article''s External links ({{Facebook|emmett.shear}}), so it is sourced, not guessed. Chrome has NO Facebook session: the page renders a Log In bar over "This content isn''t available right now". UNVERIFIED at every login state'),
 ('m_shear','tiktok_public','https://www.tiktok.com/@emmettshear','emmettshear','negative_probe','SESSION','["handle_matches"]',200,'2026-09-04','No display name, no bio, no video, 4 followers. handle_matches alone; accepted as nothing. The @eshear handle is a DIFFERENT person and is on the deny-list');

-- ═══ DENY-LIST: one new MEASURED collision ════════════════════════════════════
INSERT OR IGNORE INTO person_identity_negative (person_id,value,kind,belongs_to,basis,measured_at) VALUES
 ('m_shear','https://www.tiktok.com/@eshear','url','"Ramdas Paladi" — a different person',
  'Measured 2026-09-04 in the operator Chrome (logged out): profile renders display name "Ramdas Paladi" over handle eshear, 1 following, 0 followers, 0 likes, "No bio yet." The handle he uses on X and Substack is somebody else here. CORRECTS the standing note that TikTok @eshear returns "Couldn''t find this account" — it now resolves, to the wrong person, which is worse','2026-09-04');

-- ═══ SOURCE ATTEMPTS — one row per attempt, incl. the ones that failed ════════
INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_shear','hn_api','GREEN','ok','Firebase user object, handle `emmett` not `eshear`. karma 4,858, created 2007-02-19, 1,167 ids in `submitted`',200,2,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','hn_algolia','GREEN','ok','927 items 2007-02-19 to 2026-03-02, full corpus pulled in one request (nbPages=1) and full-text searched. 51 submissions, 876 comments',200,5,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','firm_blog','GREEN','ok','6 posts; only 2 carry his byline, both co-credited to Sonnet 3.7, both April 2025. No RSS exists on the domain — every feed path 404s',200,3,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','firm_team','GREEN','ok','Founders, board and 18 staff. Source of the LinkedIn slug and of the Adam Goldstein / Hipmunk line',200,2,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','firm_robots','GREEN','ok','Allows all but /api/observatory/v2/coworlds/replays/. HONOURED — no path under it was requested',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','firm_sitemap','GREEN','ok','5 blog URLs with lastmod, against 6 entries on the blog index; the sixth is /mission. The only machine-readable index that exists',200,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','wikipedia','GREEN','ok','17,453 B wikitext via action=raw. Career start, Softmax co-founders, SF New Deal, and the Facebook slug in External links',200,7,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','github_api','GREEN','ok','name field "Emmett Shear", 9 repos; repos list shows real 2025-2026 pushes, not a dormant 2009 shell',200,2,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','x_profile','GREEN','ok','fxtwitter counters. 123,009 followers against the roster''s 123,007 the same day — drift of 2, same band, roster left alone',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','x_session','SESSION','ok','Read in BOTH browsers. Logged out (in-app pane): og:description and the newest FIVE posts render, so the profile is not fully walled. Logged in (operator Chrome): 23 posts 2026-05-15 to 2026-08-31 collected. Read-only; no like, reply, follow or repost was issued',200,6,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','x_following','SESSION','ok','PARTIAL READ: 70 of 1,193 claimed (5.9%). Two full passes on the operator Chrome, real wheel events, selectors scoped to [data-testid="primaryColumn"] so the Who-to-follow rail could not leak in; the second pass after a reload returned a strict subset of the first. Silent ceiling, not a stall and not an error. Logged out the same URL redirects to the profile with "Something went wrong. Try reloading."',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','blog_archive','GREEN','ok','blog.emmettshear.com via Wayback CDX: 70 captures, 25 distinct posts 2006-08-21 to 2010-02-12. The SUBDOMAIN. 0 CDX failures this run',200,4,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','threadreader','GREEN','ok','18 threads to 2025-11-24, full text. Carries the quantum-gravity thread and the abandoned blog-post-idea list',200,6,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','personal_site','GREEN','ok','edbs.media, four pages. NOT on the allow-list before this run; reached from his own LinkedIn post, not from a search result',200,4,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','yale_paper','GREEN','ok','TR-1285 read from Wayback (6 pp). The live cpsc.yale.edu URL 403s',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','linkedin_archive','GREEN','ok','Wayback snapshot 2026-05-21, 51,015 B, the only 200 in a CDX list otherwise full of 999s',200,2,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','linkedin_session','SESSION','ok','Live read on the operator''s logged-in Chrome, read-only — no connect, message, follow or reaction. Headline, location, company, school, follower count and five own posts. Degree-of-connection, mutual-connection counts and the "Explore Premium profiles" rail were stripped at the boundary',200,3,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','instagram_session','SESSION','ok','Operator Chrome, logged in. /eshear/ does not exist; /emmettshear/ is a real public profile with bio, counts and 4 posts',200,2,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','instagram_eshear','SESSION','unavailable','instagram.com/eshear/ returns "Sorry, this page isn''t available. The link you followed may be broken, or the page may have been removed." Read logged in, so this is the account not existing, not a wall. Recorded because "no account" and "we did not look" must not be the same row',404,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','substack','GREEN','ok','Feed and archive API both 200 and both return exactly one item, "Coming soon", 2023-10-17. A 200 with one placeholder in it is not publication',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','tiktok_public','SESSION','unavailable','NO TikTok session exists on this machine, so both handles were read logged out. @eshear is a different person ("Ramdas Paladi") and is now on the deny-list; @emmettshear has no name, no bio and no video and is accepted as nothing. Identity failure, not only an access failure',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','facebook_session','SESSION','unavailable','AUTH WALL. Chrome has no Facebook session: facebook.com/emmett.shear renders "Log In / Forgot Account?" over "This content isn''t available right now — When this happens, it''s usually because the owner only shared it with a small group of people, changed who can see it or it''s been deleted." Logged out this distinguishes nothing: existence, visibility and identity are all unmeasured. Slug is Wikipedia-sourced, not guessed',200,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','youtube_talks','GREEN','ok','Three talk videos linked from edbs.media, resolved by oEmbed. Each carries his name in the video title on a third-party channel (TED, YC Root Access, Manifold Markets), so attribution does not rest on channel ownership. youtube.com/@eshear stays deny-listed and was NOT fetched',200,1,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','eshear_com','GREEN','skipped','DENY-LISTED and not fetched. GoDaddy parking page that wildcards every path with the same 114-byte 200. Listed here so the skip is a record rather than a silence',NULL,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','emmettshear_com','GREEN','skipped','DENY-LISTED apex, NXDOMAIN, formerly an Indonesian SEO spam blog. His blog was the SUBDOMAIN, which was read separately and is `ok`',NULL,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','youtube_channel','GREEN','skipped','DENY-LISTED: youtube.com/@eshear is "eshwar mr Kannada gamer". Not fetched',NULL,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903'),
 ('m_shear','humanx_speaker','GREEN','skipped','DENY-LISTED 404 that a search result asserted exists. Not fetched',NULL,0,'2026-09-04T01:45:00Z','run_ingest_shear_20260903');

-- ═══ BACKFILL — my member''s rows only ═════════════════════════════════════════
UPDATE person SET career_start_decade = '2000s' WHERE id = 'm_shear';
-- name_respelling stays NULL: no recording of him saying his own name was fetched. The three
-- talk videos would carry one, but audio was not retrieved and a pronunciation is never guessed.

UPDATE person_topic SET evidence_fact_id = 'f_shear_002'
 WHERE person_id = 'm_shear' AND topic_slug = 'ai-alignment';

-- NEW topic assignment. reading-and-books held 2 of 10 (Feld, Qureshi); Shear makes 3 of 10 = 0.30,
-- still under the 0.40 threshold, so `discriminating` is UNCHANGED at 1 and nothing in
-- db/vocabulary.sql needs editing. holder_count there now reads 2 against 3 actual — that drift is
-- REPORTED, not fixed here (00-COMMON: never re-baseline a vocabulary count).
-- Evidence is not thin: a standing ~60-title recommendation database, a 2024 reading log with a
-- paragraph of his own commentary per book, and a photographed book stack whose spines overlap it.
INSERT OR IGNORE INTO person_topic (person_id,topic_slug,evidence_fact_id) VALUES
 ('m_shear','reading-and-books','f_shear_015');

-- member_label was already seeded correct (supplied 'Twitch', current 'Softmax — CEO', stale 1).
-- Re-measured this run on four independent surfaces; only basis and measured_at are touched, and
-- only on my member''s row.
UPDATE member_label SET
  basis = 'STALE, re-measured 2026-09-04 on four independent surfaces the same day: x.com/eshear og:description "CEO of Softmax: Massively Multiplayer Learning Environments"; HN /user/emmett.json about "Founder and CEO of Softmax"; softmax.com/team card "CEO & Founder"; instagram.com/emmettshear bio "CEO of Softmax". He left Twitch March 2023. His LinkedIn headline diverges — "Researching organic alignment" — and is the only surface that does not name the role. Keying an ingest on "Twitch" also loses his strongest edge: the YC tie to Huffman is Kiko <-> Reddit, Summer 2005 (f_shear_003), not Twitch <-> Reddit',
  measured_at = '2026-09-04'
 WHERE person_id = 'm_shear';

UPDATE run SET finished_at = '2026-09-04T02:10:00Z',
  notes = 'Content ingest, m_shear. 27 source attempts: 20 ok, 3 unavailable, 4 skipped (deny-listed, recorded not silently omitted). BLOCKED: 1 auth error (facebook_session — no Facebook session in the operator Chrome). Also partial: x_following read 70 of 1,193 (silent ceiling, two passes). RECENCY IS ACTIVE, NOT UNKNOWN: newest X post 2026-08-31, three days before this run, and five posts render logged out. NEW SOURCE: edbs.media, his personal site, found via his own LinkedIn post. NEW DENY: tiktok.com/@eshear = "Ramdas Paladi". RESOLVED: Instagram is /emmettshear, not /eshear. Vocabulary drift reported not fixed: topic reading-and-books holder_count 2 -> 3 actual (discriminating unchanged); person.prominence_basis 123,007 vs 123,009 measured.'
 WHERE id = 'run_ingest_shear_20260903';

COMMIT;
