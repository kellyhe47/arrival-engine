PRAGMA foreign_keys = ON;
BEGIN;

-- ── The follow-list walk ──────────────────────────────────────────────────────
-- Two independent passes in the operator's Chrome. Pass 1 reached 42 entries, stalled; a reload
-- reset the virtualizer and pass 2 reached 69. Pass 1 is a strict SUBSET of pass 2, so the list is
-- served in a stable order and X stops at the same place. 69 of 1,345 is 5.1%.

INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

('f_wil_045','m_wilson','Wilson FOLLOWS Josh Kopelman on X. Found at position 20 of his following list, read logged in on 2026-09-04: display name "Josh Kopelman", handle @joshk, bio "Father. Husband. VC. INTJ. Dad Joke Lover. Partner @FirstRound." Confirmed twice — in the DOM inside the primaryColumn (not the personalized "Who to follow" rail, which uses identical markup) and visually on the rendered page.','self_published','subject_authored','https://x.com/fredwilson/following','x.com','2026-09-04','2026-09-04T02:10:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_046','m_wilson','X following list, walked logged in 2026-09-04. X served 69 of the 1,345 entries his profile claims and then stopped — no spinner, no error, no 429, just a page that looks finished. In order: bgurley, mattturck, semil, msuster, ttunguz, joshelman, albertwenger, bryce, arampell, aweissman, chrisfralic, nihalmehta, davemcclure, skupor, dens, aileenlee, harris, TaliaGold, johnolilly, joshk, nyksource, JoshLu, ZachLowe_NBA, packyM, ryderkessler, levie, tobi, ljin18, ix_shells, AdrianYounge, ClubProGuy, raghavakk, Sofarocean, jamiew, philmohun, mona_alsubaei, NaimePakniyat, HFreinacht, q2design, RadiantNuclear, chrislehane, SecurityGuyPhil, jalenbrunson1, JCMacriNBA, usvlibrarian, alive_, sriramk, dN0t, Vince_Van_Dough, natsfert, hendry_hugh, Everette, shrimppepe, uninsightful, gracekcarney, _mattmandel, NeuralBricolage, edward_the6, 6529Museum, ecosapiensxyz, blackbird, fontainesdublin, EurekaEarthPlus, jsmian, Erth_AI, emilyxxie, Nicolas_Sassoon, 5putniko, thomasp85. The visible slice skews to VCs, NBA accounts, and crypto/generative-art accounts.','self_published','subject_authored','https://x.com/fredwilson/following','x.com','2026-09-04','2026-09-04T02:10:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903');

UPDATE fact SET superseded_by='f_wil_046' WHERE id='f_wil_044';

-- THE edge the prompt asked for. Wilson -> Kopelman follows: CONFIRMED.
-- The REVERSE is still untested and is m_kopelman's agent to measure. Preserve the asymmetry.
INSERT INTO edge (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_wilson','m_kopelman','follows','f_wil_045','2026-09-04T02:10:00Z','STRONG','run_ingest_wilson_20260903');

UPDATE edge SET evidence_fact_id='f_wil_046'
 WHERE from_id='m_wilson' AND type='follows' AND to_id IN ('p_albert_wenger','p_andy_weissman');

UPDATE source_status SET fact_count=3,
  reason='Read in the OPERATOR''S OWN Chrome. TWO passes: pass 1 reached 42 entries then stalled; a page RELOAD reset the virtualizer and pass 2 reached 69, with pass 1 a strict subset. X then serves NOTHING further — no spinner, no error banner, no 429 — so 69 of 1,345 (5.1%) is a silent cap that is indistinguishable from the end of the list. TWO mechanical traps: (a) programmatic scrollTo/scrollBy does NOT drive X''s loader, only real wheel events do, so a JS-only scroller reports "list complete" at whatever is already in the DOM; (b) the "Who to follow" rail uses the SAME data-testid=UserCell markup as the list, so any selector not scoped to primaryColumn silently mixes personalized recommendations into the follow graph. Target FOUND at position 20 (@joshk). No absence is assertable for the unserved 1,276.',
  checked_at='2026-09-04T02:10:00Z'
 WHERE person_id='m_wilson' AND source_id='x_session' AND run_id='run_ingest_wilson_20260903';

UPDATE run SET finished_at='2026-09-04T02:15:00Z',
  notes='Content ingest, m_wilson. 17 sources ok, 1 unavailable. All three SESSION walls cleared in the operator''s own Chrome. Follow graph walked: 69 of 1,345 served before X silently capped; Wilson->Kopelman follows CONFIRMED at position 20. Coverage `unknown` on one thing only: web.archive.org CDX 504.'
 WHERE id='run_ingest_wilson_20260903';

COMMIT;
