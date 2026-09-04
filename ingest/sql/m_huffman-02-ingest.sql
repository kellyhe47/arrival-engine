-- m_huffman / Steve Huffman — content ingest, run_ingest_huffman_20260903
-- Target: db/arena.m_huffman.db only. Facts are append-only and namespaced f_huffman_NNN.
PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO run (id, started_at, execution_ctx, notes) VALUES
 ('run_ingest_huffman_20260903','2026-09-04T01:05:00Z','operator_machine',
  'Steve Huffman ingest. SEC-first; Wayback recovered u/spez comments; LinkedIn read in the operator session. The supplied /in/shuffman slug is Sarah Huffman, so the YC-corroborated /in/shuffman56 profile was used. Reddit live remains unavailable; coverage is unknown, not quiet. One SEC Form 4 fact is finance-suppressed.');

-- One hop only. Shared names use stable ids and INSERT OR IGNORE for ten-way merge safety.
INSERT OR IGNORE INTO person
  (id,is_member,display_name,name_respelling,seniority_tier,career_start_decade,
   prominence_tier,prominence_basis,created_run) VALUES
 ('p_alexis_ohanian',0,'Alexis Ohanian',NULL,NULL,NULL,NULL,NULL,'run_ingest_huffman_20260903'),
 ('p_michael_seibel',0,'Michael Seibel',NULL,NULL,NULL,NULL,NULL,'run_ingest_huffman_20260903'),
 ('p_adam_goldstein',0,'Adam Goldstein',NULL,NULL,NULL,NULL,NULL,'run_ingest_huffman_20260903');

INSERT INTO fact
 (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,
  observed_at,composed_from,search_first_page,via_edge_type,via_person_id,superseded_by,
  run_id,suppression_class) VALUES

('f_huffman_001','m_huffman','The SEC submissions record names "Huffman Steve Ladd" under CIK 0001827011 and lists 88 recent filings from 2020-10-01 through 2026-09-02. CIK 0001690226 is a different Steve Huffman.','on_record','publisher','https://data.sec.gov/submissions/CIK0001827011.json','data.sec.gov','2026-09-02','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_002','m_huffman','The SEC submissions record for Reddit, Inc. is CIK 0001713445, identifies the exchange and ticker as NYSE: RDDT, and lists 478 recent filings.','on_record','publisher','https://data.sec.gov/submissions/CIK0001713445.json','data.sec.gov','2026-09-03','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_003','m_huffman','Wikipedia records that Steve Huffman graduated from the University of Virginia in 2005, entered Y Combinator with Alexis Ohanian that year, and launched Reddit in June 2005. This supports a 2000s career-start decade.','third_party','publisher','https://en.wikipedia.org/w/index.php?title=Steve_Huffman&action=raw','en.wikipedia.org','2026-09-03','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_004','m_huffman','Reddit''s SEC-filed 424B4 says Steven Huffman co-founded Reddit and led it from 2005 to 2009, co-founded Hipmunk and served as its CTO from June 2010 to October 2015, and has served as Reddit''s CEO, president, and a director since July 2015.','on_record','publisher','https://www.sec.gov/Archives/edgar/data/1713445/000162828024012380/reddit-final424b4.htm','sec.gov','2024-03-21','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_005','m_huffman','In Reddit''s Q2 2026 shareholder letter, signed by Steve Huffman as co-founder and CEO, Huffman argues that authentic human context, personal opinion, and firsthand experience become more valuable as synthetic content proliferates.','self_published','subject_authored','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/exhibit992q226.htm','sec.gov','2026-07-30','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_006','m_huffman','In the same signed Q2 2026 letter, Huffman describes Reddit''s product goal as becoming a daily destination and says the company is focused on converting weekly users into daily users.','self_published','subject_authored','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/exhibit992q226.htm','sec.gov','2026-07-30','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_007','m_huffman','Reddit''s SEC-filed Q2 2026 shareholder letter says the company combines AI with community-led moderation to catch and remove spam and coordinated inauthentic behavior. The letter reports 23 million spam views blocked daily and a 20% reduction in exposure to spam; those figures are company-published claims.','on_record','publisher','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/exhibit992q226.htm','sec.gov','2026-07-30','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_008','m_huffman','Reddit''s SEC-filed earnings release formally designates CEO Steve Huffman''s Reddit account, u/spez, as one of the channels the company may use for Regulation FD disclosures.','on_record','publisher','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm','sec.gov','2026-07-30','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_009','m_huffman','Y Combinator''s official Reddit company page identifies Reddit as a Summer 2005 company and names Steve Huffman and Alexis Ohanian as founders. The founder record links Steve Huffman to linkedin.com/in/shuffman56.','on_record','publisher','https://www.ycombinator.com/companies/reddit','ycombinator.com','2026-09-03','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_010','m_huffman','Y Combinator''s official Kiko company page identifies Kiko as a Summer 2005 company and names Emmett Shear among its former founders.','on_record','publisher','https://www.ycombinator.com/companies/kiko','ycombinator.com','2026-09-03','2026-09-04T01:41:31Z',NULL,0,'shared_org','m_shear',NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_011','m_huffman','YC''s official directory returns exactly nine Summer 2005 companies, including both Huffman''s Reddit and Shear''s Kiko. This establishes shared cohort membership, not direct interaction. The bridge is Kiko to Reddit; Justin.tv/Twitch belongs to a later batch.','inferred','publisher','https://www.ycombinator.com/companies?batch=Summer%202005','ycombinator.com','2026-09-03','2026-09-04T01:41:31Z','["f_huffman_009","f_huffman_010"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_012','m_huffman','Reddit''s SEC-filed 424B4 says Michael Seibel has served as a Reddit director since July 2020 and formerly served as CEO of Justin.tv, now Twitch, from June 2007 to October 2011.','on_record','publisher','https://www.sec.gov/Archives/edgar/data/1713445/000162828024012380/reddit-final424b4.htm','sec.gov','2024-03-21','2026-09-04T01:41:31Z',NULL,0,'board_together','p_michael_seibel',NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_013','m_huffman','Softmax''s official team page identifies Adam Goldstein as a board member and founder emeritus and says he co-founded Hipmunk.','on_record','publisher','https://www.softmax.com/about','softmax.com','2026-09-03','2026-09-04T01:41:31Z',NULL,0,'shared_org','p_adam_goldstein',NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_014','m_huffman','The SEC record that Huffman co-founded Hipmunk and Softmax''s record that Adam Goldstein co-founded Hipmunk establish Huffman and Goldstein as Hipmunk co-founders. Goldstein''s current Softmax board role makes him an institutional bridge, not evidence of a second-hop Huffman–Shear relationship.','inferred','publisher','https://www.softmax.com/about','softmax.com','2026-09-03','2026-09-04T01:41:31Z','["f_huffman_004","f_huffman_013"]',0,'shared_org','p_adam_goldstein',NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_015','m_huffman','The YC-corroborated LinkedIn profile linkedin.com/in/shuffman56 rendered in the operator''s logged-in session as Steve Huffman, CEO at Reddit, in San Francisco, with University of Virginia education. Its Activity page showed 8,128 followers on 2026-09-03, placing him in prominence tier 2 under the stored 1,000–24,999 ladder. Personalization and recommendation rails were stripped.','self_published','subject_authored','https://www.linkedin.com/in/shuffman56/','linkedin.com','2026-09-03','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_016','m_huffman','Archived copies independently corroborate linkedin.com/in/shuffman56: a 2010 capture names Steve Huffman as co-founder of reddit.com, a 2016 capture lists Reddit and Y Combinator roles, and a 2024 capture links Reddit and Hipmunk.','on_record','publisher','https://web.archive.org/web/20240616093902id_/https://www.linkedin.com/in/shuffman56','web.archive.org','2024-06-16','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_017','m_huffman','In a 2010 first-person Mixergy interview, Huffman describes Reddit''s first summer as almost entirely coding, calls user and community moderation central to scaling, and says early outside moderators chiefly handled spam. This is historical product experience, not a claim about current policy.','self_published','subject_authored','https://mixergy.com/interviews/steve-huffman-reddit-interview/','mixergy.com','2010-10-20','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_018','m_huffman','On u/spez, Huffman gave a worked licorice preference: he grew up with Twizzlers, came to prefer Red Vines after moving west, and called Good & Plenty the best licorice.','self_published','subject_authored','https://web.archive.org/web/20220623234630id_/https://old.reddit.com/user/spez/comments/','web.archive.org','2022-01-07','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_019','m_huffman','In an archived u/spez comment in r/ModSupport, Huffman said Weird Al Yankovic was his first concert.','self_published','subject_authored','https://web.archive.org/web/20220623234630id_/https://old.reddit.com/user/spez/comments/','web.archive.org','2022-05-18','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_020','m_huffman','In an archived u/spez comment in r/CavaPoo, Huffman described his dog as an eight-year-old puppy whose energy was still all-or-nothing, just active a little less often.','self_published','subject_authored','https://web.archive.org/web/20220623234630id_/https://old.reddit.com/user/spez/comments/','web.archive.org','2021-06-07','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_021','m_huffman','The HN Algolia corpus for author spez returned all 67 comments in one page, dated 2006-10-10 through 2019-04-01. A case-insensitive search of all 67 bodies found zero occurrences of emmett, shear, or kiko and zero exact full-name occurrences for the other eight arena members. This is a bounded corpus result, not a lifetime claim.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_008"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_022','m_huffman','A case-insensitive full-text search of Reddit''s 2024 SEC-filed 424B4 found zero exact full-name occurrences for Fred Wilson, Brad Feld, Josh Kopelman, Sarah Tavel, Hunter Walk, Emmett Shear, Eric Ries, Nabeel Qureshi, and Melanie Perkins. Michael Seibel is a non-member and is present.','inferred','publisher','https://www.sec.gov/Archives/edgar/data/1713445/000162828024012380/reddit-final424b4.htm','sec.gov','2024-03-21','2026-09-04T01:41:31Z','["f_huffman_004"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_023','m_huffman','No Huffman-to-Fred-Wilson reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_024','m_huffman','No Huffman–Brad-Feld reference was found in the complete 67-comment HN spez corpus or Reddit''s 424B4; the reciprocal audit of Feld''s named 5,551-post body corpus also found zero Huffman occurrences. The absence is limited to those corpora.','inferred','publisher','https://feld.com/archives/','feld.com','2026-09-03','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_025','m_huffman','No Huffman-to-Josh-Kopelman reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_026','m_huffman','No Huffman–Sarah-Tavel reference was found in the complete 67-comment HN spez corpus or Reddit''s 424B4; the supplied reciprocal audit of Tavel''s named 113-post Adventurista corpus also found zero Huffman occurrences. The absence is limited to those corpora; a separate ingest reports that 104 distinct archived post URLs were reproducible, so the reciprocal count remains a supplied-audit figure rather than a new measurement here.','inferred','publisher','https://web.archive.org/web/20140110041657/http://www.adventurista.com/','web.archive.org','2015-10-07','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_027','m_huffman','No Huffman-to-Hunter-Walk reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_028','m_huffman','No Huffman-to-Eric-Ries reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_029','m_huffman','No Huffman-to-Nabeel-Qureshi reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

('f_huffman_030','m_huffman','No Huffman-to-Melanie-Perkins reference was found in either the complete 67-comment HN spez corpus or Reddit''s 424B4. The measured absence is limited to those named corpora.','inferred','publisher','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','hn.algolia.com','2019-04-01','2026-09-04T01:41:31Z','["f_huffman_021","f_huffman_022"]',0,NULL,NULL,NULL,'run_ingest_huffman_20260903',NULL),

-- Collected with full SEC provenance, but structurally withheld. Card output may expose only
-- "1 withheld: finance"; it must never expose this fact's text.
('f_huffman_031','m_huffman','The SEC Form 4 filed 2026-09-02 reports a 2026-08-31 option exercise for 18,000 Class A shares at $25.29 followed by four sale lots totaling 18,000 shares at weighted-average prices from $147.66 to $151.17 under a Rule 10b5-1 plan adopted 2025-05-19.','on_record','publisher','https://www.sec.gov/Archives/edgar/data/1827011/000182701126000038/wk-form4_1788388675.xml','sec.gov','2026-09-02','2026-09-04T01:41:31Z',NULL,0,NULL,NULL,NULL,'run_ingest_huffman_20260903','finance');

-- New allow-list rows only; the five roster-seeded Huffman rows remain unchanged.
INSERT INTO person_identity
 (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
 ('m_huffman','sec_424b4','https://www.sec.gov/Archives/edgar/data/1713445/000162828024012380/reddit-final424b4.htm',NULL,'canonical','GREEN','["named_in_sec_filing"]',200,'2026-09-03','Reddit IPO prospectus; role history, Michael Seibel board service, and exact-name corpus audit.'),
 ('m_huffman','sec_q2_letter','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/exhibit992q226.htm',NULL,'canonical','GREEN','["named_in_sec_filing","subject_self_identifies"]',200,'2026-09-03','SEC-hosted Q2 2026 shareholder letter signed Steve Huffman, Co-Founder & Chief Executive Officer.'),
 ('m_huffman','sec_q2_release','https://www.sec.gov/Archives/edgar/data/1713445/000171344526000098/earningspressreleaseq226.htm','spez','canonical','GREEN','["named_in_sec_filing"]',200,'2026-09-03','SEC-filed release designates u/spez as a Regulation FD disclosure channel.'),
 ('m_huffman','sec_form4','https://www.sec.gov/Archives/edgar/data/1827011/000182701126000038/wk-form4_1788388675.xml',NULL,'canonical','GREEN','["named_in_sec_filing"]',200,'2026-09-03','Collected into one finance-suppressed fact; transaction content cannot render.'),
 ('m_huffman','yc_reddit','https://www.ycombinator.com/companies/reddit',NULL,'canonical','GREEN','["linked_from_own_canonical"]',200,'2026-09-03','Official YC company record for Reddit S05, Steve Huffman, Alexis Ohanian; links /in/shuffman56/.'),
 ('m_huffman','hn_comments','https://hn.algolia.com/api/v1/search?tags=comment%2Cauthor_spez&hitsPerPage=200','spez','api','GREEN','["subject_self_identifies","named_in_sec_filing"]',200,'2026-09-03','All 67 HN comments in one page; used only for a named-corpus search.'),
 ('m_huffman','linkedin_session','https://www.linkedin.com/in/shuffman56/','shuffman56','canonical','SESSION','["linked_from_own_canonical","display_name_matches"]',NULL,'2026-09-03','Read-only operator session. YC official Reddit page links this exact profile. 8,128 followers. Personalization stripped.'),
 ('m_huffman','linkedin_wayback','https://web.archive.org/web/20240616093902id_/https://www.linkedin.com/in/shuffman56','shuffman56','archive','GREEN','["linked_from_own_canonical","display_name_matches"]',200,'2026-09-03','Three HTTP-200 captures in 2010, 2016, and 2024 independently corroborate the correct profile.');

INSERT INTO person_identity_negative
 (person_id,value,kind,belongs_to,basis,measured_at) VALUES
 ('m_huffman','https://www.linkedin.com/in/shuffman/','url','Sarah Huffman, Healthvana',
  'Live logged-in LinkedIn read resolved to Sarah Huffman, headline "Nerd for hire," at Healthvana; Wayback''s 2008-02-19 HTTP-200 snapshot also identifies Sarah Huffman. The supplied slug is a measured identity collision.','2026-09-03');

UPDATE person
   SET career_start_decade='2000s',
       prominence_tier=2,
       prominence_basis='LinkedIn 8,128 followers on the YC-corroborated /in/shuffman56 profile (SESSION, measured 2026-09-03). Highest measured single-platform figure; tier 2 is the 1,000-24,999 band.'
 WHERE id='m_huffman';

UPDATE person_topic SET evidence_fact_id='f_huffman_007'
 WHERE person_id='m_huffman' AND topic_slug='content-moderation';

INSERT INTO context (person_id,type,value,resolved,evidence_fact_id) VALUES
 ('m_huffman','institution','Reddit, Inc.',1,'f_huffman_004'),
 ('m_huffman','institution','Y Combinator Summer 2005',1,'f_huffman_009'),
 ('m_huffman','institution','Hipmunk',1,'f_huffman_004'),
 ('m_huffman','institution','University of Virginia',1,'f_huffman_003'),
 ('m_huffman','place','San Francisco, California',1,'f_huffman_015'),
 ('m_huffman','life_event','First concert: Weird Al Yankovic',1,'f_huffman_019'),
 ('m_huffman','pursuit','Cavapoo dog ownership',1,'f_huffman_020');

INSERT INTO edge
 (from_id,to_id,type,evidence_fact_id,observed_at,strength,run_id) VALUES
 ('m_huffman','p_alexis_ohanian','shared_org','f_huffman_009','2026-09-04T01:41:31Z','STRONG','run_ingest_huffman_20260903'),
 ('m_huffman','p_michael_seibel','board_together','f_huffman_012','2026-09-04T01:41:31Z','STRONG','run_ingest_huffman_20260903'),
 ('m_huffman','p_adam_goldstein','shared_org','f_huffman_014','2026-09-04T01:41:31Z','STRONG','run_ingest_huffman_20260903'),
 ('m_huffman','m_shear','shared_org','f_huffman_011','2026-09-04T01:41:31Z','STRONG','run_ingest_huffman_20260903'),
 ('m_huffman','m_wilson','no_edge_confirmed','f_huffman_023','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_feld','no_edge_confirmed','f_huffman_024','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_kopelman','no_edge_confirmed','f_huffman_025','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_tavel','no_edge_confirmed','f_huffman_026','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_walk','no_edge_confirmed','f_huffman_027','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_ries','no_edge_confirmed','f_huffman_028','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_qureshi','no_edge_confirmed','f_huffman_029','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903'),
 ('m_huffman','m_perkins','no_edge_confirmed','f_huffman_030','2026-09-04T01:41:31Z','MEDIUM','run_ingest_huffman_20260903');

INSERT INTO source_status
 (person_id,source_id,tier,status,reason,http_code,fact_count,checked_at,run_id) VALUES
 ('m_huffman','sec_person','GREEN','ok','Required contact user-agent used. Correct person CIK 0001827011 returned 88 recent filings; the known wrong CIK was not collected.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','sec_company','GREEN','ok','Required contact user-agent used. Reddit CIK 0001713445 returned 478 recent filings and the Q2 2026 accession.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','sec_424b4','GREEN','ok','IPO prospectus fetched from the SEC archive and searched in full for all nine other member names.',200,3,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','sec_q2_letter','GREEN','ok','SEC-hosted shareholder letter fetched and signature verified. First-person prose is separated from company-reported metrics.',200,3,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','sec_q2_release','GREEN','ok','SEC-hosted earnings release fetched; it names u/spez as a Regulation FD channel.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','sec_form4','GREEN','ok','Latest Form 4 fetched with required contact user-agent. One fact stored with suppression_class=finance; content is excluded from v_renderable_fact.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','wikipedia','GREEN','ok','Raw wikitext fetched and used only for career-start backfill.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','reddit_archive','GREEN','ok','Initial chained pass did not complete; targeted CDX retry found 15 unique HTTP-200 captures and five snapshots were fetched successfully. Three subject-authored deep cuts retained.',200,3,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','interview','GREEN','ok','Full Mixergy transcript fetched; historical first-person moderation evidence retained.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','yc_reddit','GREEN','ok','Official YC page confirms Reddit S05, Huffman and Ohanian, and links the correct LinkedIn profile.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','yc_kiko','GREEN','ok','Official YC page confirms Kiko S05 and Emmett Shear; combined with Reddit S05 for the shared_org edge.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','softmax_about','GREEN','ok','Official Softmax team page confirms Adam Goldstein as board member, founder emeritus, and Hipmunk co-founder. One hop only.',200,2,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','hn_comments','GREEN','ok','HN Algolia returned all 67 comments in one page. Case-insensitive body search produced the bounded absence measurements.',200,8,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','linkedin_session','SESSION','ok','Operator''s existing Chrome session rendered the YC-corroborated /in/shuffman56 profile and Activity count. Read-only; personalization, degree, recommendation rails, and operator identity stripped. Browser client exposed no HTTP code, so none is fabricated.',NULL,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','linkedin_wayback','GREEN','ok','Wayback availability and CDX exposed three HTTP-200 captures for /in/shuffman56 in 2010, 2016, and 2024.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','feld_corpus_audit','GREEN','ok','Named reciprocal corpus: Feld''s supplied 5,551-post body crawl reported zero Huffman occurrences.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','tavel_corpus_audit','GREEN','ok','Named reciprocal corpus: the supplied 113-post Adventurista audit reported zero Huffman occurrences. A separate ingest reproduced 104 distinct archived URLs, so 113 is not presented as a fresh measurement by this run.',200,1,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','linkedin_attested_collision','SESSION','unavailable','The supplied /in/shuffman URL was read live and through Wayback and belongs to Sarah Huffman, not Steve Huffman. Recorded as a deny-list collision; zero facts collected.',NULL,0,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','reddit_live','SESSION','unavailable','Live Reddit is inaccessible without OAuth: old.reddit redirects to login, www.reddit returns 403, and RSS rate-limits. No keyless retry was attempted after the explicit protocol warning. Archive coverage is partial, so recency remains unknown.',NULL,0,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903'),
 ('m_huffman','investor_relations','GREEN','skipped','Explicit per-person protocol says investor.redditinc.com is 403 and must not be fetched. Equivalent SEC-hosted filings were used instead.',403,0,'2026-09-04T01:41:31Z','run_ingest_huffman_20260903');

UPDATE run
   SET finished_at='2026-09-04T01:48:13Z',
       notes='Steve Huffman ingest complete with partial coverage: 17 of 20 source attempts ok, 2 unavailable, 1 deliberately skipped. LinkedIn /in/shuffman is a measured Sarah Huffman collision; YC corroborates /in/shuffman56, where 8,128 followers backfill tier 2. Reddit live remains auth-blocked, so coverage is unknown rather than quiet. One finance fact is withheld structurally.'
 WHERE id='run_ingest_huffman_20260903';

COMMIT;
