-- m_perkins / Melanie Perkins — parallel ingest overlay, file 2 of 2.
-- Topic backfill, contexts, edges, the measured-absence corpus, every source attempt,
-- and the close of run_ingest_perkins_20260903. Apply AFTER m_perkins-01-facts.sql.

PRAGMA foreign_keys = ON;
BEGIN;

-- ── The absence corpus, written as a fact so the no_edge_confirmed rows below
--    have something that names what was actually searched (K-5 / R-011). ─────
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES
 ('f_perkins_050','m_perkins',
  'MEASURED ABSENCE, corpus named. Searched in full this run for each of the other nine members by name, and for Union Square Ventures, Foundry, First Round Capital, Benchmark, Homebrew, Techstars, Y Combinator and The Lean Startup: (1) the complete Wikipedia wikitext for Melanie Perkins, 14,469 bytes - zero hits for all nine; (2) both archived parts of her 21 Questions memoir, 104,287 characters of extracted first-person text - the only hit anywhere is the book title "The Lean Startup", named as a book that was "in vogue" while she was raising, with no person attached; (3) the archived canva.com newsroom index of 2026-08-25, 12 article slugs - zero hits; (4) the 20 LinkedIn posts read in this run. Within those four corpora she names Cliff Obrecht, Cameron Adams, Lars Rasmussen, Bill Tai, Greg Mitchell, Niki Scevak, Lenny Rachitsky, Jonathan Shriftman, Alex Konrad, and the funds Matrix Partners, InterWest Partners, Blackbird Ventures and Commercialisation Australia - and none of the nine, and none of their firms. Her X following list is EXCLUDED from this corpus: it was read only 56 of 246 and cannot carry an absence.',
  'inferred','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T21:20:00Z',
  '["f_perkins_005","f_perkins_017","f_perkins_019","f_perkins_022","f_perkins_023","f_perkins_048","f_perkins_049"]',1,NULL,NULL,'run_ingest_perkins_20260903');

-- ── person_topic backfill (hers only) ───────────────────────────────────────
UPDATE person_topic
   SET evidence_fact_id = 'f_perkins_026'
 WHERE person_id = 'm_perkins' AND topic_slug = 'product-led-growth';

-- ── Contexts (S4). A caption is a claim, not a geotag. ──────────────────────
INSERT OR IGNORE INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_perkins','place','Perth, Western Australia',1,'f_perkins_001'),
 ('m_perkins','place','Sydney, Australia',1,'f_perkins_031'),
 ('m_perkins','place','San Francisco, California',1,'f_perkins_020'),
 -- She writes "our two offices in Sydney and Manila" and captions a Manila team photo. That is
 -- the company being in Manila, not an observation that she was. resolved=0.
 ('m_perkins','place','Manila, Philippines',0,'f_perkins_027'),
 -- "Spending time with families in Malawi was incredibly moving" is first-person presence.
 ('m_perkins','place','Malawi',1,'f_perkins_034'),
 ('m_perkins','institution','University of Western Australia',1,'f_perkins_003'),
 ('m_perkins','institution','Sacred Heart College, Sorrento',1,'f_perkins_002'),
 ('m_perkins','institution','Canva',1,'f_perkins_031'),
 ('m_perkins','institution','Fusion Books',1,'f_perkins_033'),
 ('m_perkins','life_event','Married Cliff Obrecht, January 2021, Rottnest Island',1,'f_perkins_011'),
 ('m_perkins','life_event','Signed the Giving Pledge, 2021',1,'f_perkins_008'),
 ('m_perkins','pursuit','Kitesurfing - learned instrumentally, and disliked',1,'f_perkins_018'),
 ('m_perkins','pursuit','Journalling, including Morning Pages',1,'f_perkins_029'),
 ('m_perkins','pursuit','Figure skating (school years)',1,'f_perkins_002');

-- ── Edges. Directed, typed, evidenced. All targets are is_member = 0. ───────
INSERT OR IGNORE INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 -- Cliff Obrecht: BOTH, per the prompt and DEC-12. Neither edge is ever scored or named.
 ('m_perkins','p_cliff_obrecht','family_or_partner','f_perkins_011','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_cliff_obrecht','shared_org','f_perkins_005','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_cliff_obrecht','repost','f_perkins_043','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_cameron_adams','shared_org','f_perkins_022','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_cameron_adams','follows','f_perkins_048','2026-09-03','MEDIUM','run_ingest_perkins_20260903'),
 ('m_perkins','p_lars_rasmussen','cited_in_own_writing','f_perkins_042','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_bill_tai','cited_in_own_writing','f_perkins_017','2026-09-03','STRONG','run_ingest_perkins_20260903'),
 ('m_perkins','p_bill_tai','follows','f_perkins_048','2026-09-03','MEDIUM','run_ingest_perkins_20260903'),
 ('m_perkins','p_greg_mitchell','cited_in_own_writing','f_perkins_015','2026-09-03','MEDIUM','run_ingest_perkins_20260903'),
 ('m_perkins','p_niki_scevak','follows','f_perkins_048','2026-09-03','WEAK','run_ingest_perkins_20260903'),
 ('m_perkins','p_mike_cannon_brookes','follows','f_perkins_048','2026-09-03','WEAK','run_ingest_perkins_20260903'),
 ('m_perkins','p_alex_konrad','follows','f_perkins_048','2026-09-03','WEAK','run_ingest_perkins_20260903'),
 ('m_perkins','p_lenny_rachitsky','co_appearance','f_perkins_039','2026-09-03','MEDIUM','run_ingest_perkins_20260903'),
 ('m_perkins','p_jonathan_shriftman','co_mention','f_perkins_038','2026-09-03','WEAK','run_ingest_perkins_20260903'),
 ('m_perkins','p_antony_sguazzin','co_mention','f_perkins_034','2026-09-03','WEAK','run_ingest_perkins_20260903');

-- Measured absence against the four corpora named in f_perkins_050, and ONLY those.
INSERT OR IGNORE INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_perkins','m_wilson','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_feld','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_kopelman','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_tavel','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_walk','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_huffman','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_shear','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_ries','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903'),
 ('m_perkins','m_qureshi','no_edge_confirmed','f_perkins_050','2026-09-03',NULL,'run_ingest_perkins_20260903');

-- ── source_status: one row per ATTEMPT. This table is what makes 'quiet'
--    distinguishable from 'unknown'. Three sources were unreachable, so her
--    coverage is 'unknown' by v_recency_state - which is the correct record.
INSERT OR REPLACE INTO source_status (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_perkins','linkedin_session','SESSION','ok',
  'Read live and read-only in the OPERATOR''S OWN Chrome (the in-app browser pane is logged out and redirects to Sign Up). Headline, location, company, school, follower count, experience block and 20 public activity posts extracted. Newest post ONE DAY old. Personalization stripped at the boundary: the "Followed by <names> and 5 others you know" line, the "3rd" degree-of-connection badge, the operator''s own account, and the "More profiles for you" rail were all discarded - that rail named Cliff Obrecht and Cameron Adams and was still thrown away, because a recommendation is not evidence of an edge. No write operation of any kind was issued.',
  200,16,'2026-09-03T21:05:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','x_profile','GREEN','ok',
  'api.fxtwitter.com/MelanieCanva 200. name="Melanie Perkins" is the STRONG corroboration. 56,593 followers against a seeded 56,591 - drift recorded, tier untouched.',
  200,1,'2026-09-03T20:49:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','x_session','SESSION','ok',
  'PARTIAL WALK, recorded as partial. x.com/MelanieCanva/following read in the operator''s Chrome. Two passes with a reload between them, real wheel events only, selectors scoped to [data-testid="primaryColumn"] and to each UserCell''s own @handle line. Reached 56 of a claimed 246 (23%) and then the list stopped at @alexrkonrad - no spinner, no error, no 429: the silent ceiling. A first naive selector also picked up bio @-mentions inside each cell (117 "handles", including five from Mike Cannon-Brookes'' bio alone) and was discarded before anything was written. No no_edge_confirmed rests on this read.',
  200,1,'2026-09-03T21:12:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','newsroom_archive','GREEN','ok',
  'Memoir part 1 via Wayback and curl: 611,471 bytes of HTML, 64,439 characters of extracted text. WebFetch refuses web.archive.org; curl retrieves it fine.',
  200,17,'2026-09-03T20:50:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','newsroom_archive_p2','GREEN','ok',
  'Memoir part 2 via Wayback and curl: 453,911 bytes of HTML, 39,848 characters, 21 numbered first-person answers.',
  200,2,'2026-09-03T20:50:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','newsroom_index','GREEN','ok',
  '200 with content and still an absence: 12 article slugs and ZERO occurrences of "Melanie" anywhere in the archived index. A 200 with zero items of hers is not silence from her, it is a company channel.',
  200,1,'2026-09-03T20:50:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','wikipedia','GREEN','ok',
  '14,469 bytes of wikitext. Supplied career_start_decade, birth, education, funding history, philanthropy and net worth. Names none of the other nine.',
  200,11,'2026-09-03T20:52:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','canva_live','GREEN','unavailable',
  'Every canva.com path tested returns 403 to a plain curl AND to a full desktop-Chrome UA: /, /newsroom/, /newsroom/news/. Blanket bot denial at the edge. CONSEQUENCE, recorded rather than papered over: a guessed RSS path returns the same 403, which is indistinguishable from "absent", so this run may neither confirm nor deny that a feed exists.',
  403,1,'2026-09-03T20:49:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','podcast_guest','GREEN','unavailable',
  'npr.org/2019/01/24/688299882/canva-melanie-perkins was NOT reachable from this host. HTTP/2 attempt died with "stream 1 was not closed cleanly: INTERNAL_ERROR"; an HTTP/1.1 retry timed out after 60s with 0 bytes. The roster already carried transcript presence as UNVERIFIED; it remains unverified, and now the page status is unknown too. Her own LinkedIn post about the episode ("It was fun sharing the long and winding journey of getting Canva off the ground with Guy Raz on How I Built This") is the only evidence of the appearance this run actually read.',
  NULL,0,'2026-09-03T21:16:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','openlibrary_inside','GREEN','unavailable',
  'openlibrary.org/search/inside.json was unreachable: curl exit 7, "Failed to connect to openlibrary.org port 443", on two separate attempts, while archive.org, wikipedia.org, x.com and canva.com all resolved from the same host in the same minutes. The planned in-book co-mention search of Perkins against each of the nine DID NOT RUN. Any earlier claim of "0 hits for all nine" from Open Library is not re-confirmed by this run and is not what f_perkins_050 rests on.',
  NULL,0,'2026-09-03T21:14:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','instagram_session','SESSION','unavailable',
  'IDENTITY, NOT ACCESS - and this resolves an audit question that was left open. Read through the operator''s LOGGED-IN Instagram session, instagram.com/melanieperkins/ still returns "Sorry, this page isn''t available. The link you followed may be broken, or the page may have been removed." The earlier "Profile isn''t available" was therefore NOT a logged-out artifact: there is no reachable Instagram account at that handle. Written as a negative_probe so v_collectable_source excludes it. Nothing was collected and no write operation was issued.',
  404,0,'2026-09-03T21:10:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','facebook_session','SESSION','unavailable',
  'AUTH BLOCKED, and doubly weak. The URL was a GUESSED vanity slug, and this Chrome carries no Facebook session: the page rendered the logged-out Email/Password bar over the body "This content isn''t available right now". Logged out it establishes neither existence nor identity in either direction, so even a successful read would have needed independent corroboration first. No credentials were entered.',
  200,0,'2026-09-03T21:08:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','tiktok_public','SESSION','skipped',
  'NOT FETCHED BY RULE. @melaniecanva is on this member''s never-fetch list: a contradictory payload with 9 followers, effectively nothing, and no corroboration path. Skipping it is a targeting decision, not an access failure - but it is still a source this run did not reach, so it is written down rather than omitted.',
  NULL,0,'2026-09-03T21:18:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','youtube_rss','GREEN','skipped',
  'NOT FETCHED BY RULE. youtube.com/feeds/videos.xml?user=canva is deny-listed: it silently resolves to an unrelated Hong Kong personal channel and returns valid XML with no error. No substitute channel for her was found, so YouTube contributes nothing.',
  NULL,0,'2026-09-03T21:18:00Z','run_ingest_perkins_20260903'),
 ('m_perkins','personal_site','GREEN','skipped',
  'NOT FETCHED BY RULE. melanieperkins.com does not resolve and melanieperkins.com.au is a deny-listed GoDaddy parking page listed for sale. She has no personal site - that absence is the biggest structural fact about her footprint, and it is why the memoir only exists on archive.org.',
  NULL,0,'2026-09-03T21:18:00Z','run_ingest_perkins_20260903');

-- ── Close the run. This is the ONLY place finished_at is set. ───────────────
UPDATE run
   SET finished_at = '2026-09-03T21:25:00Z',
       notes = 'Melanie Perkins content ingest. 50 facts, 24 edges (15 real, 9 measured absences), 14 contexts, 15 source attempts. LinkedIn SESSION read cleanly in the operator''s own Chrome and is the load-bearing recency source: newest post ONE DAY old, so she is ACTIVE, and the retracted "no fetchable first-person 2026 publication" claim is not repeated. X SESSION also live but her 246-entry following list served only 56 and stopped silently - recorded as partial, and no absence rests on it. BLOCKED: 5 sources unreachable - canva.com 403 to every client (so no feed may be confirmed or denied), npr.org unreachable from this host, openlibrary.org connection-refused twice (the planned in-book co-mention search DID NOT RUN), Instagram returns page-not-available even logged in (identity, not access - this resolves the open audit question), Facebook logged out on a guessed slug. Members partial: m_perkins. See ingest/BLOCKERS.md.'
 WHERE id = 'run_ingest_perkins_20260903';

COMMIT;

INSERT INTO fact_fts(fact_fts) VALUES('rebuild');
