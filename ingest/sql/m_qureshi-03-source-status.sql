-- m_qureshi — one row per source attempt and final run summary.
-- Apply after m_qureshi-02-edges-contexts.sql.
PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO source_status
 (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_qureshi','substack_rss','GREEN','ok','410,253-byte RSS feed; all 14 item bodies present, dated 2019-12-15 through 2026-05-03. Full corpus searched for Feld and Tavel; zero occurrences of both.',200,9,'2026-09-04T01:25:50Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','personal_site','GREEN','ok','curl received 429 with x-vercel-mitigated: challenge; the legitimate Vercel browser challenge rendered normally in a real browser. Essays, projects, interviews, Contact, and More About Me were read.',200,5,'2026-09-04T01:35:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','personal_rss','GREEN','skipped','Known title-only feed. The confirmed Substack feed has the same catalog with full bodies and was strictly better, so no inferior duplicate fetch was made.',NULL,0,'2026-09-04T01:35:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','github_api','GREEN','ok','Confirmed account nqureshi: name field matches, 25 public repositories, and current user metadata.',200,1,'2026-09-04T01:40:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','github_activity','GREEN','ok','September 2026 commit APIs checked: 10 ev-winners commits plus 1 ev-search-python commit, all on 2026-09-03.',200,1,'2026-09-04T01:40:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','github_chess_trainer','GREEN','ok','Repository metadata and base64 README fetched through the GitHub API; the three kata positions and Stockfish practice loop were recovered.',200,1,'2026-09-04T01:40:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','x_profile','GREEN','ok','API mirror returned confirmed display name, canonical backlink, bio, counters, and joined date. Followers are 37,925, a drift of three from the roster basis; roster prominence was not updated.',200,1,'2026-09-04T01:50:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','x_session','SESSION','ok','Read-only operator session. Timeline supplied posts through 2026-09-03; X search returned repeated direct @eshear replies. Following list used real wheel events, primaryColumn-only selectors, and two passes with a reload. Both silently capped at the same 70 of 890; Who-to-follow rail discarded; no absence asserted for 820 unreached accounts.',200,4,'2026-09-04T02:00:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','linkedin_session','SESSION','ok','Exact slug first attested from nabeelqu.co. Read-only operator session reached the live top card: generic stealth headline, NYC area, 2,615 followers, 500+ connections. Personalized degree markers, feed suggestions, and recommendation rails were stripped; no account write was issued.',200,1,'2026-09-04T02:03:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','linkedin_wayback','GREEN','ok','archive.org/wayback/available returned snapshot 20260123092938; fetched 200, 283,006 bytes. Structured profile named Mercatus, Oxford 2007-2010, NYC area, 2,440 followers, and 500+ connections.',200,1,'2026-09-04T01:45:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','dialectic_50','GREEN','ok','Public 2026-06-29 page rendered a roughly 120k-character transcript with 149 Nabeel-attributed turns. No paywall.',200,3,'2026-09-04T01:38:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','offsite','GREEN','ok','Minutes article fully readable and jointly bylined by Will Manidis and Nabeel S. Qureshi; schema metadata says isAccessibleForFree=true.',200,1,'2026-09-04T01:30:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','newstatesman','METERED','unavailable','HTTP 200 and the byline/opening three paragraphs were readable, but schema marks isAccessibleForFree=false and the 1,985-word remainder is behind a subscriber wall. The wall was not bypassed; only visible material was imported.',200,1,'2026-09-04T01:32:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','feld_archive_crosscheck','GREEN','ok','Current 2.58 MB Feld archive fetched 200 and independently enumerated 5,551 unique post links; zero Qureshi strings in the index. The no-edge also names the retained prior full-body audit and its current-Pagefind caveat.',200,2,'2026-09-04T01:43:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','uncensored_toc','GREEN','ok','Current Leanpub contributor/table-of-contents page fetched 200; zero Nabeel Qureshi or nabeelqu occurrences while other roster members appear.',200,1,'2026-09-04T01:44:00Z','run_ingest_qureshi_20260903'),
 ('m_qureshi','openlibrary','GREEN','unavailable','Current Open Library author-search request failed to connect and returned no HTTP status. The prompt''s prior zero was not restated as a current measurement; no fact depends on this attempt.',NULL,0,'2026-09-04T01:44:00Z','run_ingest_qureshi_20260903');

UPDATE run
   SET finished_at='2026-09-04T02:06:00Z',
       notes='Content ingest, m_qureshi. 13 sources ok, 1 deliberately skipped inferior feed, 2 unavailable. Profile coverage is unknown because the New Statesman body is subscriber-only and Open Library failed to connect. X is active through 2026-09-03; following graph served 70 of 890 after two real-wheel passes. LinkedIn live session and Wayback both succeeded. No auth blocker remains.'
 WHERE id='run_ingest_qureshi_20260903';

COMMIT;
