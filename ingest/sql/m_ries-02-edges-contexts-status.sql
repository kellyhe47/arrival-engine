-- m_ries / Eric Ries — parallel ingest, layer 2 of 2.
-- Identity rows, one-hop people, edges, contexts, topic backfill, source attempts, deny-list
-- additions, and the close of run_ingest_ries_20260903. Apply only after m_ries-01-facts.sql.

PRAGMA foreign_keys = ON;
BEGIN;

-- ── Allow-list additions. Everything measured this run that db/roster.sql does not carry. ──
INSERT OR IGNORE INTO person_identity
  (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes)
VALUES
  ('m_ries','linkedin_session','https://www.linkedin.com/in/eries/','eries','canonical','SESSION','["linked_from_own_canonical","subject_self_identifies","display_name_matches"]',200,'2026-09-03',
   'Slug NOT guessed. `eries` is linked from three pages already confirmed as his: news.theleanstartup.com, incorruptible.co and ericriesshow.com. Read live and read-only in the operator Chrome session; headline, pronouns, location, follower count and public activity extracted, personalization and write affordances stripped. Logged out this URL is a Sign Up redirect.'),
  ('m_ries','linkedin_newsletter','https://www.linkedin.com/pulse/you-cant-inspect-ai-can-watch-how-its-makers-treat-people-eric-ries-aivlc','eries','canonical','SESSION','["subject_self_identifies","linked_from_own_canonical"]',200,'2026-09-03',
   'His LinkedIn newsletter "Trust is Everything", 72,340 subscribers. A first-person long-form channel that appears in NO allow-list in db/roster.sql — the largest coverage gap found for him this run.'),
  ('m_ries','book_site','https://www.incorruptible.co/',NULL,'canonical','GREEN','["subject_self_identifies","bio_backlink_to_canonical"]',200,'2026-09-03',
   'The website field of his verified X profile and the link in his Instagram and TikTok bios. Carries the social rail that attests the Instagram handle.'),
  ('m_ries','book_tracker','https://howisincorruptiblegoing.com/',NULL,'canonical','GREEN','["subject_self_identifies","linked_from_own_canonical"]',200,'2026-09-03',
   'Built and announced by him in his 2026-05-26 newsletter post. Served by GitHub Pages from github.com/ericries/howisincorruptiblegoing. 575 dated entries; the richest single structured record of his 2026 activity and forward calendar.'),
  ('m_ries','github_repos','https://api.github.com/users/ericries/repos?per_page=100&sort=updated','ericries','api','GREEN','["linked_from_own_canonical"]',200,'2026-09-03',
   'CORROBORATION CORRECTION. db/roster.sql records this account as api_name_field_matches; the API name field is null. It holds on linked_from_own_canonical instead: his newsletter links howisincorruptiblegoing.com, which is this account''s Pages deployment.'),
  ('m_ries','podcast_site','https://www.ericriesshow.com/',NULL,'canonical','GREEN','["subject_self_identifies"]',200,'2026-09-03',
   'The <link> target of the podcast RSS channel whose itunes:author is "Eric Ries".'),
  ('m_ries','podcast_rss_ooc','https://anchor.fm/s/477be9bc/podcast/rss',NULL,'feed','GREEN','["linked_from_own_canonical","api_name_field_matches"]',200,'2026-09-03',
   'Out of the Crisis, his earlier show, 29 episodes 2020-03-30 -> 2021-05-24. Reached from the Apple Podcasts id he linked in his own blog post; iTunes lookup artistName is "Eric Ries". Do NOT substitute the guessed vanity domain — see the deny row below.'),
  ('m_ries','sec_formd_services','https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001680712','0001680712','api','GREEN','["named_in_sec_filing"]',200,'2026-09-03',
   'LTSE Services, Inc., formerly Long-Term Stock Exchange, Inc. and LTSE Holdings, Inc. Five Form D / D-A filings 2016-2022.'),
  ('m_ries','sec_formd_group','https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=0001786417','0001786417','api','GREEN','["named_in_sec_filing"]',200,'2026-09-03',
   'LTSE Group, Inc. Three Form D / D-A filings 2019-2022.'),
  ('m_ries','sec_form1','https://www.sec.gov/rules/other/2018/long-term-stock-exchange/long-term-stock-exchange-1.htm',NULL,'archive','GREEN','["named_in_sec_filing"]',200,'2026-09-03',
   'The Form 1 application index: cover letter, execution page, and exhibits A-N with amendments. The execution page carries his manual signature and notarization; the cover letter does not.'),
  ('m_ries','ltse_insights','https://ltse.com/insights',NULL,'firm','GREEN','["linked_from_own_canonical"]',200,'2026-09-03',
   '157 articles. Firm corpus, no article bylines exposed. NO text from it is attributed to Ries. ltse.com/newsroom is a guessed URL and 404s.'),
  ('m_ries','instagram_session','https://www.instagram.com/ericriesactual/','ericriesactual','canonical','SESSION','["linked_from_own_canonical","display_name_matches","bio_backlink_to_canonical"]',200,'2026-09-03',
   'Handle attested by the social rail on incorruptible.co, not guessed. Public account; read in the operator Chrome session.'),
  ('m_ries','tiktok_public','https://www.tiktok.com/@ericriesactual','ericriesactual','canonical','GREEN','["linked_from_own_canonical","display_name_matches","bio_backlink_to_canonical"]',200,'2026-09-03',
   'Handle attested by howisincorruptiblegoing.com, which embeds and cites "@ericriesactual on TikTok" across 51 references. Profile header renders logged out; the video grid does not.'),
  ('m_ries','x_following_session','https://x.com/ericries/following','ericries','canonical','SESSION','["api_name_field_matches"]',200,'2026-09-03',
   'PARTIAL. Two independent reload-and-walk passes both stopped at the same 70 of a claimed 1,835 (3.8%). Silent ceiling, not end of list.'),
  ('m_ries','blog_search','https://www.startuplessonslearned.com/feeds/posts/default?alt=json&max-results=25','startuplessonslearned','api','GREEN','["subject_self_identifies"]',200,'2026-09-03',
   'The Blogger JSON feed serves full post CONTENT, not summaries, 25 at a time. This is what makes an exhaustive literal scan of all 392 posts possible rather than a title-only sweep.'),
  ('m_ries','leanpub_uncensored','https://leanpub.com/uncensored','ericries','canonical','GREEN','["display_name_matches"]',200,'2026-09-03',
   'Publisher metadata names "Hunter Walk and Eric Ries". Single WEAK signal on its own; it is accepted only as evidence of the Walk edge, and no biographical fact is collected from it.');

-- ── One-hop non-members. Namespaced and INSERT OR IGNORE so parallel shards merge. ──
INSERT OR IGNORE INTO person (id,is_member,display_name,name_respelling,seniority_tier,career_start_decade,prominence_tier,prominence_basis,created_run) VALUES
  ('p_john_bautista',0,'John V. Bautista',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903'),
  ('p_brian_singerman',0,'Brian Singerman',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903'),
  ('p_maliz_beams',0,'Maliz Beams',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903'),
  ('p_michelle_greene',0,'Michelle D. Greene',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903'),
  ('p_annette_nazareth',0,'Annette L. Nazareth',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903'),
  ('p_will_harvey',0,'Will Harvey',NULL,NULL,NULL,NULL,NULL,'run_ingest_ries_20260903');

-- ── Edges. Directed, typed, every one carrying an evidence fact. ──
INSERT OR IGNORE INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES

  -- Feld. The strongest member-to-member tie in his corpus, and the only one he states himself.
  ('m_ries','m_feld','cited_in_own_writing','f_ries_032','2026-09-04T02:24:00Z','STRONG','run_ingest_ries_20260903'),
  ('m_ries','m_feld','co_appearance','f_ries_033','2026-09-04T02:24:00Z','STRONG','run_ingest_ries_20260903'),

  -- Walk. STRONG but asymmetric: documented only from the publisher's side. His own 392 posts
  -- never mention Uncensored or Hunter Walk, so nothing here may be rendered in his voice.
  ('m_ries','m_walk','co_appearance','f_ries_034','2026-09-04T02:25:00Z','STRONG','run_ingest_ries_20260903'),

  -- Wilson. One line in eighteen years of blogging, about a conference endorsement.
  ('m_ries','m_wilson','cited_in_own_writing','f_ries_035','2026-09-04T02:25:00Z','WEAK','run_ingest_ries_20260903'),

  -- Kopelman. Same event, his event, adjacent sessions.
  ('m_ries','m_kopelman','co_appearance','f_ries_036','2026-09-04T02:26:00Z','MEDIUM','run_ingest_ries_20260903'),

  -- Shear. A name in a link list under his own podcast episode. Nothing more is supportable.
  ('m_ries','m_shear','co_mention','f_ries_037','2026-09-04T02:26:00Z','WEAK','run_ingest_ries_20260903'),

  -- Measured absences. Assertable ONLY because these corpora were searched in full: all 392 blog
  -- posts by literal scan of the Blogger content feed, plus both of his podcast feeds end to end.
  -- The X follow-graph walk reached 3.8% and contributes NOTHING to these rows (R-011).
  ('m_ries','m_tavel','no_edge_confirmed','f_ries_038','2026-09-04T02:27:00Z',NULL,'run_ingest_ries_20260903'),
  ('m_ries','m_perkins','no_edge_confirmed','f_ries_038','2026-09-04T02:27:00Z',NULL,'run_ingest_ries_20260903'),
  ('m_ries','m_qureshi','no_edge_confirmed','f_ries_038','2026-09-04T02:27:00Z',NULL,'run_ingest_ries_20260903'),

  -- LTSE's related-persons universe, entire.
  ('m_ries','p_john_bautista','board_together','f_ries_022','2026-09-04T02:18:00Z','STRONG','run_ingest_ries_20260903'),
  ('m_ries','p_brian_singerman','board_together','f_ries_022','2026-09-04T02:18:00Z','STRONG','run_ingest_ries_20260903'),
  ('m_ries','p_maliz_beams','board_together','f_ries_022','2026-09-04T02:18:00Z','STRONG','run_ingest_ries_20260903'),
  ('m_ries','p_michelle_greene','shared_org','f_ries_019','2026-09-04T02:17:00Z','MEDIUM','run_ingest_ries_20260903'),
  ('m_ries','p_annette_nazareth','shared_org','f_ries_020','2026-09-04T02:17:00Z','WEAK','run_ingest_ries_20260903'),
  ('m_ries','p_will_harvey','employer_history','f_ries_016','2026-09-04T02:15:00Z','MEDIUM','run_ingest_ries_20260903');

-- NOT written, deliberately: no Huffman edge. LTSE's Insights corpus carries a profile of Steve
-- Huffman and one of Hunter Walk (f_ries_040), which is the shape of a co_appearance and is not
-- one — unbylined firm editorial, neither article naming Ries, neither in either of his feeds.
-- For the same reason Huffman is NOT given a no_edge_confirmed row either: the corpus is not clean.

-- ── Contexts. A caption is a claim; ambiguous places stay resolved=0. ──
INSERT OR IGNORE INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
  ('m_ries','place','San Francisco Bay Area',1,'f_ries_045'),
  ('m_ries','place','New York City',1,'f_ries_002'),
  ('m_ries','place','Los Angeles',1,'f_ries_009'),
  ('m_ries','place','Boulder, Colorado',1,'f_ries_030'),
  ('m_ries','place','Washington, DC',1,'f_ries_028'),
  ('m_ries','place','Seattle',1,'f_ries_012'),
  ('m_ries','place','London',1,'f_ries_054'),
  ('m_ries','institution','Yale University',1,'f_ries_013'),
  ('m_ries','institution','IMVU',1,'f_ries_013'),
  ('m_ries','institution','Long-Term Stock Exchange',1,'f_ries_017'),
  ('m_ries','institution','Harvard Business School',1,'f_ries_055'),
  ('m_ries','institution','Authors Equity',1,'f_ries_058'),
  ('m_ries','life_event','Published Incorruptible, 2026-05-26',1,'f_ries_002'),
  ('m_ries','life_event','Incorruptible reached #5 on the New York Times bestseller list, 2026-06',1,'f_ries_003'),
  ('m_ries','pursuit','Assembling and typesetting the public-domain Tom Lehrer songbook',1,'f_ries_044'),
  ('m_ries','pursuit','Building small evidence-graded public directories (SkinTiers, Seedlist)',1,'f_ries_043'),
  ('m_ries','pursuit','Text-based MUDs, where he first learned to program',1,'f_ries_014'),
  -- "SF" is his own X location string. It is consistent with the Bay Area row above but is not
  -- itself a resolvable place claim, so it is stored unresolved rather than collapsed into it.
  ('m_ries','place','SF',0,'f_ries_049');

-- ── Topic evidence backfill. Only m_ries rows are touched. ──
UPDATE person_topic SET evidence_fact_id='f_ries_031' WHERE person_id='m_ries' AND topic_slug='startup-communities';
UPDATE person_topic SET evidence_fact_id='f_ries_028' WHERE person_id='m_ries' AND topic_slug='tech-policy-immigration';
UPDATE person_topic SET evidence_fact_id='f_ries_018' WHERE person_id='m_ries' AND topic_slug='long-term-governance';

-- ── New deny row. A vanity domain I guessed, measured, and refused. ──
INSERT OR IGNORE INTO person_identity_negative (person_id,value,kind,belongs_to,basis,measured_at) VALUES
  ('m_ries','outofthecrisis.com','domain',NULL,
   'run_ingest_ries_20260903. Guessed as the home of his podcast Out of the Crisis. It answers on 443 but presents a certificate issued for *.outofthecrisis.org which expired 2025-11-25, so every ordinary client refuses it. Ownership is UNVERIFIED in either direction. His attested feed is anchor.fm/s/477be9bc/podcast/rss, reached from the Apple Podcasts id he linked in his own blog post — use that.','2026-09-03');

-- ── Source attempts. One row per attempt. A 200 with zero items is not silence, and a source
--    that could not be reached is never allowed to read as one that was. ──
INSERT INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
  ('m_ries','newsletter','GREEN','ok','beehiiv archive scraped; 12 posts enumerated 2026-05-26 -> 2026-08-23, all 12 fetched individually. No RSS exists.',200,10,'2026-09-04T02:12:00Z','run_ingest_ries_20260903'),
  ('m_ries','blog_archive','GREEN','ok','392 <loc>/<lastmod> pairs, 2008-09-02 -> 2026-05-17.',200,2,'2026-09-04T02:13:00Z','run_ingest_ries_20260903'),
  ('m_ries','blog_search','GREEN','ok','All 392 posts pulled as full content through the Blogger JSON feed in 16 pages and scanned literally for every member name and firm. 10 posts fetched individually for quotes.',200,17,'2026-09-04T02:27:00Z','run_ingest_ries_20260903'),
  ('m_ries','sec_ltse','GREEN','ok','62 filings, one Form 1 (2018-09-21) and 61 Form 1/A through 2026-08-17.',200,1,'2026-09-04T02:18:00Z','run_ingest_ries_20260903'),
  ('m_ries','sec_formd_services','GREEN','ok','5 filings; all 5 primary_doc.xml fetched and parsed for related persons.',200,2,'2026-09-04T02:19:00Z','run_ingest_ries_20260903'),
  ('m_ries','sec_formd_group','GREEN','ok','3 filings; all 3 primary_doc.xml fetched and parsed. 8 Form Ds total, 4 related persons total.',200,1,'2026-09-04T02:19:00Z','run_ingest_ries_20260903'),
  ('m_ries','sec_form1','GREEN','ok','Index plus the cover letter and execution-page PDFs; 34-85828 fetched separately.',200,3,'2026-09-04T02:17:00Z','run_ingest_ries_20260903'),
  ('m_ries','podcast_rss','GREEN','ok','44 episodes 2024-05-05 -> 2026-01-08. Full text swept for all nine other members and their firms: zero hits.',200,1,'2026-09-04T02:37:00Z','run_ingest_ries_20260903'),
  ('m_ries','podcast_rss_ooc','GREEN','ok','29 episodes 2020-03-30 -> 2021-05-24. Same sweep, zero hits. This feed is NOT in db/roster.sql.',200,1,'2026-09-04T02:37:00Z','run_ingest_ries_20260903'),
  ('m_ries','podcast_site','GREEN','ok','ericriesshow.com resolves and carries the linkedin.com/in/eries link that attested the slug.',200,0,'2026-09-04T02:37:00Z','run_ingest_ries_20260903'),
  ('m_ries','youtube_rss','GREEN','unavailable','youtube.com/feeds/videos.xml 404s for channel_id UCQnF0c8GaWDm9T4yMDpGcPA AND for the playlist_id form AND for an unrelated control channel (Google Developers). The endpoint is broken or blocked from this host; this is NOT specific to him and is NOT evidence about his channel.',404,0,'2026-09-04T02:00:00Z','run_ingest_ries_20260903'),
  ('m_ries','youtube_channel','GREEN','ok','Channel page renders. externalId UCQnF0c8GaWDm9T4yMDpGcPA, 112K subscribers. Video dates could not be enumerated without the feed, so no per-video fact was written.',200,0,'2026-09-04T02:00:00Z','run_ingest_ries_20260903'),
  ('m_ries','github_api','GREEN','ok','11 public repos, 3 followers, created 2014-11-15. name/bio/blog/company/twitter_username ALL null — see f_ries_041.',200,1,'2026-09-04T02:29:00Z','run_ingest_ries_20260903'),
  ('m_ries','github_repos','GREEN','ok','All 11 repos listed; 4 inspected individually plus two raw file reads. Three pushed 2026-09-03.',200,3,'2026-09-04T02:30:00Z','run_ingest_ries_20260903'),
  ('m_ries','books','GREEN','unavailable','openlibrary.org resolves to 207.241.234.205 but refuses the TCP connection on 443. curl exit 7 twice, and the in-app browser pane also failed to navigate. Not a rate limit and not a 404 — the host is unreachable from this machine.',NULL,0,'2026-09-04T01:50:00Z','run_ingest_ries_20260903'),
  ('m_ries','books_google','GREEN','unavailable','Google Books volumes API attempted as a substitute bibliographic source for ISBN 9798893311860 and 9780307887894. Rate-limited on the first request.',429,0,'2026-09-04T01:52:00Z','run_ingest_ries_20260903'),
  ('m_ries','wikipedia','GREEN','ok','Raw wikitext. Birth date, Yale, There Inc 2001, IMVU with Will Harvey 2004, LTSE, and the publication list.',200,2,'2026-09-04T02:15:00Z','run_ingest_ries_20260903'),
  ('m_ries','x_profile','GREEN','ok','name="Eric Ries", 301,420 followers, 1,835 following, 35,099 posts. Counts and profile fields only.',200,1,'2026-09-04T02:33:00Z','run_ingest_ries_20260903'),
  ('m_ries','x_syndication','GREEN','unavailable','syndication.twitter.com timeline-profile endpoint returned the 20-byte body "Rate limit exceeded" on two separate attempts. Per the fetch contract a source that 429s twice is unavailable for the run. The 121 recovered tweets it is documented to yield, including the 2020-09-09 "I launched a stock exchange today", were NOT re-obtained and nothing was written from memory of them.',429,0,'2026-09-04T01:52:00Z','run_ingest_ries_20260903'),
  ('m_ries','x_following_session','SESSION','ok','PARTIAL WALK — 70 of a claimed 1,835 (3.8%). Two passes, each a fresh reload followed by real wheel-event scrolling scoped to [data-testid="primaryColumn"]; both halted on the identical 70th entry (@mehdirhasan) with no spinner, no error and no 429. Silent ceiling. NO no_edge_confirmed row anywhere in this shard rests on it.',200,2,'2026-09-04T02:35:00Z','run_ingest_ries_20260903'),
  ('m_ries','linkedin_public','GREEN','unavailable','linkedin.com/in/eries in the logged-out in-app browser pane redirects to the LinkedIn Sign Up page ("Join LinkedIn / Email / Password"). This is what a GREEN-tier client sees, and it fires before any profile content, so logged out it is evidence of nothing.',200,0,'2026-09-04T01:55:00Z','run_ingest_ries_20260903'),
  ('m_ries','linkedin_wayback','GREEN','unavailable','The Wayback availability API returned an empty archived_snapshots object for linkedin.com/in/eries, but the CDX endpoint answered 503 with the page "Internet Archive services are temporarily offline". The empty availability result therefore cannot be read as "no snapshot exists" — the service was down. Not retried further; the SESSION read below made it unnecessary.',503,0,'2026-09-04T01:56:00Z','run_ingest_ries_20260903'),
  ('m_ries','linkedin_session','SESSION','ok','Read in the operator''s own Chrome, read-only, no write affordance touched. Profile, follower count, activity feed and one newsletter article extracted. Degree-of-connection, "Followed by ... you know" and the "Explore Premium profiles" rail were discarded at the boundary.',200,4,'2026-09-04T02:32:00Z','run_ingest_ries_20260903'),
  ('m_ries','linkedin_newsletter','SESSION','ok','"Trust is Everything", 72,340 subscribers. One full article read (2026-06-01). The articles tab itself rendered empty in the accessibility tree, so the newsletter''s full back catalogue was NOT enumerated — subscriber count and one article is all this row supports.',200,1,'2026-09-04T02:32:00Z','run_ingest_ries_20260903'),
  ('m_ries','instagram_session','SESSION','ok','Public account, read in the operator Chrome session. Header counts and grid alt text obtained. No caption carried a place or a date, so Instagram contributed no S4 context.',200,1,'2026-09-04T02:33:00Z','run_ingest_ries_20260903'),
  ('m_ries','tiktok_public','GREEN','ok','Renders logged out; there is no TikTok session on this machine. Header only: name, handle, 22 following, 308 followers, 2,230 likes, bio. The video grid is not served to a logged-out client, so the video list is UNKNOWN, not empty.',200,1,'2026-09-04T02:34:00Z','run_ingest_ries_20260903'),
  ('m_ries','facebook','SESSION','skipped','No Facebook URL is attested for him anywhere on any page confirmed as his: incorruptible.co, howisincorruptiblegoing.com, ericriesshow.com and the newsletter carry only facebook.com/sharer/sharer.php share widgets. Guessing a vanity slug is exactly what the LinkedIn protocol forbids, so nothing was fetched. Facebook is UNKNOWN for him at every login state.',NULL,0,'2026-09-04T02:40:00Z','run_ingest_ries_20260903'),
  ('m_ries','ltse_insights','GREEN','ok','157 articles indexed; swept for all nine other members. Two hits, both firm editorial with no byline — see f_ries_040. Two article pages fetched to verify. ltse.com/newsroom was NOT tried: it is a documented guessed 404.',200,1,'2026-09-04T02:28:00Z','run_ingest_ries_20260903'),
  ('m_ries','book_tracker','GREEN','ok','575 dated entries by permalink, 2025-11-20 -> 2026-10-27. Swept for all nine other members: Brad Feld 6, everyone else zero.',200,3,'2026-09-04T02:36:00Z','run_ingest_ries_20260903'),
  ('m_ries','book_site','GREEN','ok','Carries the social rail that attests the Instagram handle.',200,0,'2026-09-04T02:33:00Z','run_ingest_ries_20260903'),
  ('m_ries','leanpub_uncensored','GREEN','ok','Author line "Hunter Walk and Eric Ries", 2,236 readers, SOPA/PIPA framing.',200,1,'2026-09-04T02:25:00Z','run_ingest_ries_20260903'),
  ('m_ries','personal_site','GREEN','skipped','ericries.com is on the deny-list in db/roster.sql (curl exit 000, DNS/connect failure, AUD-03 §1.1). Not fetched.',NULL,0,'2026-09-04T02:40:00Z','run_ingest_ries_20260903'),
  ('m_ries','kickstarter_leaders_guide','GREEN','skipped','kickstarter.com/projects/ericries/the-leaders-guide is a documented 403. Not fetched. The Leader''s Guide (2015) therefore remains the one book of his unverifiable from a primary page, and Wikipedia''s $588,903 figure stays UNVERIFIED and is not written to any fact.',NULL,0,'2026-09-04T02:40:00Z','run_ingest_ries_20260903');

-- ── Close the run. ──
UPDATE run
   SET finished_at='2026-09-04T02:45:00Z',
       notes='Eric Ries ingest complete. 58 facts, 15 edges (3 of them measured absences), 18 contexts, 3 topic evidence backfills, 1 new deny row, 33 source attempts. RECENCY: ACTIVE, established affirmatively and independently three times over — a GitHub Pages rebuild timestamped 2026-09-03T22:13:02Z, LinkedIn reposts 3 hours before the read, and a newsletter post 11 days old. He is not quiet. The staleness signal is a retrieval artifact of reading only the blog (last post 2026-05-17) and the podcast feed (last episode 2026-01-08). NO AUTH BLOCKERS: LinkedIn, X, Instagram and TikTok all read. Five sources unavailable for non-auth reasons — openlibrary.org refuses TCP, Google Books 429, X syndication 429 twice, the YouTube RSS endpoint 404s even for a control channel, and archive.org CDX was 503 — so v_recency_state coverage is correctly "unknown" and no silence may be asserted anywhere. The X follow-graph walk reached 70 of 1,835 (3.8%) across two converging passes and supports no absence claim (R-011). CORRECTION for the merge: db/roster.sql records m_ries/github_api corroboration as api_name_field_matches; the GitHub API name field is null. GAP for the merge: his LinkedIn newsletter "Trust is Everything", 72,340 subscribers, is a first-person channel absent from every allow-list.'
 WHERE id='run_ingest_ries_20260903';

COMMIT;
