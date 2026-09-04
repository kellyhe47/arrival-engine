-- m_perkins / Melanie Perkins — parallel ingest overlay, file 1 of 2 (facts).
-- Shard: db/arena.m_perkins.db. NEVER apply to db/arena.db.
-- Owns run_ingest_perkins_20260903, f_perkins_001..f_perkins_049, her person/person_topic
-- backfills and her person_identity rows. finished_at is deliberately left NULL here; file 2
-- closes the run, so an interruption between files cannot look complete.

PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO run (id, started_at, finished_at, execution_ctx, notes) VALUES
  ('run_ingest_perkins_20260903','2026-09-03T20:48:00Z',NULL,'operator_machine',
   'Melanie Perkins content ingest. LinkedIn SESSION read cleanly in the operator''s own Chrome and is the load-bearing recency source (newest post 1d). X SESSION also live; her 246-entry following list served only 56 and then stopped. canva.com is 403 to every automated client, openlibrary.org and npr.org were unreachable from this host. RUN IS PARTIAL — see file 2 and ingest/BLOCKERS.md.');

-- ── person backfill (hers only) ──────────────────────────────────────────────
-- career_start_decade: Wikipedia infobox years_active = 2007-present, and her own LinkedIn
-- experience block gives Fusion Books from January 2007. Two independent sources, same decade.
-- name_respelling stays NULL: no recording of her saying her own name was fetched.
UPDATE person
   SET career_start_decade = '2000s'
 WHERE id = 'm_perkins';

-- prominence_tier / prominence_basis are NOT touched. Both figures drifted between the roster
-- baseline and this run (LinkedIn 370,639 -> 370,636; X 56,591 -> 56,593). Drift is recorded as
-- dated facts below rather than re-baselined into a shared roster field.

-- ── one-hop non-members (shared ground: INSERT OR IGNORE, stable ids) ────────
INSERT OR IGNORE INTO person (id,is_member,display_name,name_respelling,seniority_tier,career_start_decade,prominence_tier,prominence_basis,created_run) VALUES
  ('p_cliff_obrecht',0,'Cliff Obrecht',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_cameron_adams',0,'Cameron Adams',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_lars_rasmussen',0,'Lars Rasmussen',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_bill_tai',0,'Bill Tai',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_niki_scevak',0,'Niki Scevak',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_lenny_rachitsky',0,'Lenny Rachitsky',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_jonathan_shriftman',0,'Jonathan Shriftman',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_greg_mitchell',0,'Greg Mitchell',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_antony_sguazzin',0,'Antony Sguazzin',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_mike_cannon_brookes',0,'Mike Cannon-Brookes',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903'),
  ('p_alex_konrad',0,'Alex Konrad',NULL,NULL,NULL,NULL,NULL,'run_ingest_perkins_20260903');

-- ── allow-list rows measured this run ───────────────────────────────────────
INSERT OR IGNORE INTO person_identity
  (person_id,source_id,url,handle,role,tier,corroboration,http_status,measured_at,notes) VALUES
  ('m_perkins','wikipedia','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw',NULL,'canonical','GREEN','["display_name_matches"]',200,'2026-09-03',
   '14,469 B of wikitext. Names Blackbird, Lars Rasmussen, Cliff Obrecht, Cameron Adams and NONE of the other nine (grep over the full text: 0 hits for all nine names and for Union Square / Foundry / First Round / Benchmark / Homebrew / Techstars / Y Combinator).'),
  ('m_perkins','newsroom_archive_p2','http://web.archive.org/web/20251031134619/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-2/',NULL,'archive','GREEN','["subject_self_identifies"]',200,'2026-09-03',
   'Part two of the memoir, 39,848 characters of extracted text, 21 numbered first-person answers. Same Wayback-via-curl path as part one.'),
  ('m_perkins','newsroom_index','http://web.archive.org/web/20260825193821/https://www.canva.com/newsroom/news/',NULL,'archive','GREEN','["linked_from_own_canonical"]',200,'2026-09-03',
   '12 article slugs on the archived index and ZERO occurrences of the string "Melanie" anywhere in the page. The newsroom is a company channel, not her byline.'),
  ('m_perkins','x_session','https://x.com/MelanieCanva/following','MelanieCanva','canonical','SESSION','["subject_self_identifies","api_name_field_matches"]',200,'2026-09-03',
   'Following list read read-only in the operator''s Chrome. PARTIAL: 56 of a claimed 246 entries reached across two passes with a reload between them; the list stopped at @alexrkonrad with no spinner, no error and no 429 - the silent ceiling. Selector scoped to [data-testid="primaryColumn"] and to each UserCell''s own @handle line, so neither the "Who to follow" rail nor bio @-mentions entered the graph.'),
  ('m_perkins','canva_live','https://www.canva.com/newsroom/news/',NULL,'dead','GREEN','[]',403,'2026-09-03',
   '403 to plain curl AND to a desktop-Chrome UA, as is canva.com/newsroom/ and canva.com/ itself. Blanket bot denial at the edge, so a guessed RSS path would also 403 and "absent" is indistinguishable from "blocked". No feed may be asserted to exist or not to exist.'),
  ('m_perkins','instagram_session','https://www.instagram.com/melanieperkins/','melanieperkins','negative_probe','SESSION','[]',404,'2026-09-03',
   'Read through the operator''s LOGGED-IN Instagram session and the page still returns "Sorry, this page isn''t available. The link you followed may be broken, or the page may have been removed." This DISAMBIGUATES the open audit question: the earlier "Profile isn''t available" was not a logged-out artifact. Nothing was collected.'),
  ('m_perkins','facebook_session','https://www.facebook.com/melanieperkins',NULL,'negative_probe','SESSION','[]',200,'2026-09-03',
   'GUESSED vanity slug, and this Chrome has no Facebook session: the page rendered the logged-out Email/Password bar plus "This content isn''t available right now". Establishes neither existence nor identity in either direction. Nothing was collected.');

-- ═══════════════════════════════════════════════════════════════════════════
-- FACTS. Append-only.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Wikipedia (on_record / publisher) ───────────────────────────────────────
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES
 ('f_perkins_001','m_perkins',
  'Perkins was born in 1987 in Perth, Western Australia, to an Australian-born mother who worked as a teacher and a Malaysian engineer of Filipino and Sri Lankan heritage.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_002','m_perkins',
  'She attended Sacred Heart College in the northern Perth suburb of Sorrento, where she trained seriously in figure skating and started a small business selling handmade scarves.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_003','m_perkins',
  'She enrolled at the University of Western Australia majoring in communications, psychology and commerce, tutored students in graphic design, and left university at 19 to pursue a startup with Cliff Obrecht.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_004','m_perkins',
  'Wikipedia''s infobox records years_active as 2007-present: in 2007 Perkins and Obrecht founded Fusion Books, which let schools create yearbooks with an online drag-and-drop editor, and which later operated in New Zealand and France. This is the source for career_start_decade = 2000s.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_005','m_perkins',
  'In 2012 Perkins spent several months in San Francisco seeking venture funding and was rejected by more than 100 investors, with stated concerns including her Australian location, her romantic relationship with her co-founder and the founders'' lack of technical background. Lars Rasmussen introduced them to former Google designer Cameron Adams, who joined in 2012 as third co-founder and chief product officer; after an investor advised appointing a single leader, Obrecht nominated Perkins as chief executive. Blackbird Ventures became the first major institutional investor.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_006','m_perkins',
  'Perkins used annual company priorities to sequence Canva''s expansion: internationalisation in 2016, when the platform launched in six languages beyond English, and a rewrite of the editor code base in 2017 that later enabled video editing. Canva reported positive free cash flow annually from 2017, and in September 2022 announced workplace tools aimed at Adobe, Google and Microsoft.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_007','m_perkins',
  'In 2024 Canva acquired Affinity and Leonardo.Ai and introduced the Dream Lab image generator; in April 2025 Perkins introduced Canva Code and Canva Sheets, at which point Fortune reported 230 million users and US$3 billion annual revenue.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_008','m_perkins',
  'Perkins and Obrecht joined the Giving Pledge in 2021, committing most of their wealth through the Canva Foundation. The foundation partnered with GiveDirectly on unconditional cash transfers in Malawi; a further four-year US$100 million commitment announced in October 2025 brought their total commitment to that programme to US$150 million.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_009','m_perkins',
  'In July 2026 Perkins and Obrecht launched the Global Goals Platform, an initiative to survey people internationally about the changes they most want to see, to inform the Canva Foundation''s future grantmaking.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_010','m_perkins',
  'Forbes included Perkins in its 2016 30 Under 30 Asia list for enterprise technology, and Fortune ranked her 56th on its 2026 Most Powerful Women list.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_011','m_perkins',
  'Perkins and Obrecht married in January 2021 on Rottnest Island. As of May 2025 the Australian Financial Review assessed their joint net worth at A$14.14 billion; as of August 2026 Forbes estimated her net worth at US$7.6 billion.',
  'on_record','publisher','https://en.wikipedia.org/w/index.php?title=Melanie_Perkins&action=raw','en.wikipedia.org','2026-09-03','2026-09-03T20:52:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903');
COMMIT;

-- ── Memoir, part 1 (self_published / subject_authored) ──────────────────────
-- ~64,000 characters of first-person writing that exists nowhere fetchable except archive.org,
-- because every canva.com path is 403. This is the deepest vein she has.
BEGIN;
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES
 ('f_perkins_012','m_perkins',
  'She writes that at university in Perth in 2008 she taught design programs part-time and found the tools "really clunky and difficult to use", thought it "absurd that it took so long to use them" while Facebook was something people could just jump into, and wanted to make design software "simple, online and collaborative" - but, having "very little business, marketing, software development experience", applied the idea to school yearbooks first because her mother was a teacher who spent hundreds of hours on her school''s yearbook.',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_013','m_perkins',
  'Of the founding of Fusion Books she writes: "My boyfriend, Cliff, became my business partner. My mum''s living room became our office. And we set to work." The family operation is itemised in the same piece - her mother checking books word by word, Obrecht''s mother doing accounts, his father collecting the mail - and the printing ran 24/7 out of the same house''s garage, driveway and hallway.',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_014','m_perkins',
  'Their first customer found Fusion Books through the web in March 2008 and sent a $100 deposit. She writes: "We couldn''t decide if we should frame the cheque or cash it. We opted to cash it because it might seem a little strange if it wasn''t cashed and also, we needed the money."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_015','m_perkins',
  'The first Fusion Books software was built by a Perth development company, Indepth (now Cirrena), led by Greg Mitchell. She quotes his recollection of her pitch: "Before you told us anything you tested us... you made Peter (our dev) do a drag and drop grid zone, which in Internet explorer 6 was incredibly difficult."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_016','m_perkins',
  'Fusion Books was bootstrapped, and she writes they did not choose that: "We didn''t really decide to bootstrap Fusion, we just didn''t know there was an alternative." She names the Australian government''s R&D tax concession and a $20k NAB small-business loan as the two things without which "we would have run out of money in those early days".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_017','m_perkins',
  'Fusion Books came runner-up in the WA Inventor of the Year competition in 2008. Invited back to the awards the following year, she had a five-minute conversation with Bill Tai, whom she describes as "the first Silicon Valley venture capitalist I''d ever met" and "the first investor we''d ever met"; she writes that the short chat "felt like a window had opened into a whole new world".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_018','m_perkins',
  'DEEP CUT, in her own words: she took up kitesurfing purely as an instrument to reach an investor, and hated it. "I was also learning to kitesurf, as I knew Bill ran a conference called MaiTai which was a gathering of entrepreneurs and kitesurfers. Kitesurfing scares the hell out of me, and learning to kitesurf in the dreary, cold, shark-invested waters of San Francisco was far from enjoyable. But I wanted to get Canva off the ground, so it was just a small inconvenience. It also gave me another reason to email Bill." Of the MaiTai conference itself she adds: "Kitesurfing scares me a lot, I hate feeling out of control, but it didn''t even feel like a choice - when a door opens, even if it''s only a little crack it''s important to wedge your foot right in there."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_019','m_perkins',
  'She quotes Bill Tai''s email introducing her to Lars Rasmussen - "you should also meet up with Lars Rasmussen at Facebook (ex google wave lead) ill intro you separately" - and writes that the meeting with Rasmussen "went much, much better", that they spoke for hours about the future of publishing, and that Rasmussen offered to screen engineers for her. She then spent a year unable to clear his bar: "No resume I brought him was up to scratch. No person I found on Linkedin was good enough."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_020','m_perkins',
  'Her account of the 2011 San Francisco trip: a two-week visit that became three months, an "office" set up in the food court of a Nordstrom shopping centre because it was free and had wifi, a 4:30am train to make a 7:30am meeting, and 36 hours awake to hit a self-imposed deadline after which "my eyesight started to go fuzzy - looking in the mirror I could hardly see myself". She spent $9k, went home when her visa expired, and writes "I felt like a complete and utter failure".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_021','m_perkins',
  'She describes herself as an introvert twice in the memoir, and both times as a cost: "Naturally, I''m an introvert and constantly putting myself out there and not making any progress started to get to me."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_022','m_perkins',
  'Lars Rasmussen introduced her to Cameron Adams, describing him as "a world-class designer and web developer... the Google Wave team''s designer, is a co-founder of fluent.io, and is the man in themaninblue.com". She pitched him three times, was turned down twice, and quotes his eventual reply, subject line "The Answer...": "...is YES :) ... (btw, that''s yes to you guys, just to be clear)". She adds that finding a technical co-founder had no playbook: "I just kept on planting seed after seed, and in some cases the same seed in different patches of the field, until eventually, eventually one grew!"',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_023','m_perkins',
  'Naming her own seed round, she writes: "we closed a round of $1.6 million USD with some great investors like Bill and Lars, but also some VC funds such as Matrix Partners, InterWest Partners and Blackbird Ventures", plus a further $1.4 million from a Commercialisation Australia grant, for $3 million total. Bill Tai''s own cheque started at $25k and reached $100k after "an hour-long chat and my absolute best debating skills".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_024','m_perkins',
  'She quotes verbatim the investor rejections she kept, including "My biggest issue is physical distance... I''m honestly, and unfortunately, not comfortable doing a deal in Australia" and "We have reached the conclusion that the $8 million cap (15% discounted) is above the top end of what we think is fair value for the early stage risk of Canva". She frames the pattern as pedigree matching: investors "look for patterns... Harvard, MIT, Stanford educations... Google, Apple, Facebook former employee", and "we didn''t tick any of the boxes".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_025','m_perkins',
  'On launch day an outlet broke the embargo with a piece headlined "Canva attempts to bring Photoshop-like design power to the Web". She writes: "The word ''attempts'' stung", and "My goodness. What have I done. Roped all these investors in, our whole team and no one even likes it."',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_026','m_perkins',
  'Her stated growth playbook is product-led in her own terms: "Offer a free tier that delivers a lot of value... it will naturally help your product to spread much more rapidly"; "Start niche and go wide"; "Ensure great onboarding: so users get immediate value and then share your product"; plus SEO and affordability. She describes spending months on onboarding after usertesting.com sessions showed users "wandered around aimlessly... and then left feeling dejected", concluding that "it was not just the tools themselves that were preventing people from creating great designs, but also people''s own belief that they can''t design".',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_027','m_perkins',
  'She records the growth curve from the inside: 350k designs in a single month eight months after launch, one million signups in October 2014, three million designs a month at twenty months, and "over 34 million designs created each month" by the time of writing, with a team of 250 across offices in Sydney and Manila.',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_028','m_perkins',
  'She names the company value she organises around - "set crazy big goals and make them happen" - and describes structuring teams around goals rather than titles, because "the old-school hierarchies of years gone by with rigid structures and hierarchies were certainly not made for rapidly growing startups". The same phrase recurs in her LinkedIn writing years later.',
  'self_published','subject_authored','http://web.archive.org/web/20250729222616/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-1/','web.archive.org','2025-07-29','2026-09-03T20:55:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),

-- ── Memoir, part 2 ──────────────────────────────────────────────────────────
 ('f_perkins_029','m_perkins',
  'Asked "Have you always journalled?", she describes a documented practice: Morning Pages ("the first thing you do in the morning is write three large pages or six short pages in a stream of consciousness" - though "I tend to do it in the evening, and I don''t stick to the page limit"), and the School of Life''s Philosophical Meditations. She ties it back to the product: "I''ve always found I need to spend quite a lot of time to clarify and distill my thoughts... perhaps because I''m an introvert", and "I think that may have been one of the reasons behind wanting the whole world to be able to design. It felt like without it, many people couldn''t communicate their ideas."',
  'self_published','subject_authored','http://web.archive.org/web/20251031134619/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-2/','web.archive.org','2025-10-31','2026-09-03T20:57:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_030','m_perkins',
  'Asked directly about gender bias as a female founder, she declines to attribute: "although I''ll never really know if some of these rejections were because I was a female, or due to some other extraneous factor... every time we were rejected, we''d try to solicit feedback and then use that feedback to refine and improve our pitch." Her formulation is "see each rejection as redirection".',
  'self_published','subject_authored','http://web.archive.org/web/20251031134619/https://www.canva.com/newsroom/news/melanie-perkins-21-questions-part-2/','web.archive.org','2025-10-31','2026-09-03T20:57:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903');
COMMIT;

-- ── LinkedIn, SESSION, operator's own Chrome, read-only ─────────────────────
-- Her single best recency source. Overturns AUD-03's retracted "no fetchable first-person
-- 2026 publication": the newest post was ONE DAY old when this run read it.
BEGIN;
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES
 ('f_perkins_031','m_perkins',
  'Read live and read-only in the operator''s Chrome session on 2026-09-03, LinkedIn shows the headline "Co-founder & CEO at Canva", the line "Canva - University of Western Australia", location "Greater Sydney Area", and 370,636 followers.',
  'self_published','subject_authored','https://www.linkedin.com/in/melanieperkins/','linkedin.com','2026-09-03','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_032','m_perkins',
  'Her LinkedIn follower count measured 370,636 on 2026-09-03, three lower than the 370,639 the roster''s prominence_basis was baselined on, and her X count measured 56,593 against a seeded 56,591. Both are within noise and neither tier changes; the seeded prominence_tier and prominence_basis are deliberately left untouched by this parallel overlay.',
  'on_record','publisher','https://www.linkedin.com/in/melanieperkins/','linkedin.com','2026-09-03','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_033','m_perkins',
  'Her LinkedIn experience block lists "CEO & Co-founder, Canva, May 2012 - Present" (Greater Sydney Area) and "Founder and Director, Fusion Books, Jan 2007 - Present" (Greater Perth Area). The January 2007 start independently corroborates Wikipedia''s years_active = 2007 and fixes career_start_decade at 2000s.',
  'self_published','subject_authored','https://www.linkedin.com/in/melanieperkins/details/experience/','linkedin.com','2026-09-03','2026-09-03T21:02:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_034','m_perkins',
  'RECENCY ANCHOR. Her newest LinkedIn post was one day old when read on 2026-09-03. It opens "At Canva, we have a crazy big dream: that by the end of our lifetimes, everyone on this planet will have their basic human needs met", describes the GiveDirectly partnership, and reports a field visit: "Spending time with families in Malawi was incredibly moving. We heard firsthand how they were using direct cash transfers to shape a better future: sending children to school, making homes safer, starting or expanding small businesses, and investing in the tools and livestock that can create long-term security." Its in-post tag line thanks Antony Sguazzin, and it links a Bloomberg feature, "What Happens If You Give Everyone $700? A Local Economy Thrives".',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7500823196447744001/','linkedin.com','2026-09-02','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_035','m_perkins',
  'One month before this run she announced the Goals Platform: "Since day one, we''ve had a two-step plan at Canva: build one of the world''s most valuable companies, then use that value to do as much good as we can. At the heart of both steps has always been empowerment." The post links wollongonggoals.org, usagoals.org and goalsplatform.org.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7483649415686160384/','linkedin.com','2026-08','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_036','m_perkins',
  'On the fifth Canva Create she wrote: "So extraordinarily proud of everything our team brought to life yesterday. In many ways, it felt like launching Canva all over again. This time, we got to do it alongside our incredible community of more than a quarter of a billion people. We''re so excited to unveil Canva AI 2.0, our biggest product launch ever."',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7450930104735784960/','linkedin.com','2026-05','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_037','m_perkins',
  'Three days before that launch she wrote: "We''re less than three days away from our fifth Canva Create, and it''s shaping up to be the biggest moment in Canva''s history... We often say we''re only 1% of the way there, and that feels more true than ever." The event filled SoFi Stadium.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7449716963100000256/','linkedin.com','2026-05','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_038','m_perkins',
  'She shared an interview her co-founder gave: "Loved this deep dive into Canva with Jonathan Shriftman and Cliff Obrecht. Excited to share everything we''ve been working on in just a couple of days!" The quoted post, by Shriftman (Partner at Quiet Capital, and an investor in Canva), reports $4B in ARR, 265M monthly active users, usage by 95% of the Fortune 500, enterprise revenue growing 100% year on year, and AI tools used 27 billion times. The figures are Shriftman''s, not hers.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7449870522709880832/','linkedin.com','2026-05','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_039','m_perkins',
  'On recording a podcast with Lenny Rachitsky she wrote: "Just recorded a podcast with Lenny Rachitsky such a joy to dive deep into ideas and philosophies I don''t often get to talk about! He was incredibly prepared, which made for one of my favorite conversations yet."',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7390880805071491072/','linkedin.com','2025-11','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_040','m_perkins',
  'Announcing a further US$100 million from the Canva Foundation she wrote: "We have a crazy big dream: that by the end of our lifetimes, everyone on this planet will have their basic human needs met. It''s terribly sad that this is still considered a crazy big dream", and reported that since 2021 the GiveDirectly partnership had provided $50 million in direct cash transfers to more than 85,000 people in Malawi.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7381828153788268545/','linkedin.com','2025-11','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_041','m_perkins',
  'In a post about creative work she wrote: "I feel like I just got a new job. A pretty important one, I think. I''ve joined the PR team for Imagination... When imagination gets dismissed as naive or unrealistic, we stop taking it seriously, even though it''s the single most powerful force shaping our shared future... If we don''t imagine the world we want, how can we possibly create it?"',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7394315980769980416/','linkedin.com','2025-12','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_042','m_perkins',
  'She wrote a tribute to Lars Rasmussen that dates his contribution precisely: "One of those people is Lars Rasmussen, who has had a profound impact on Canva from our earliest days. Before Canva had a single line of code, before we even had an engineering team, he generously shared his wisdom, helping me understand the extraordinarily strong engineering talent we needed to bring our vision to life. We dreamed about the future together, and his guidance played a pivotal role in helping us to get started."',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7305556453342265345/','linkedin.com','2025-03','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_043','m_perkins',
  'DEC-12 traversal, recorded as her act rather than his statement: her LinkedIn activity carries "Melanie Perkins reposted this" above a post by Cliff Obrecht, whose LinkedIn headline reads "Founder and COO at Canva". The reposted body is Obrecht''s, on Gaza: "What''s happening in Gaza is devastating... The starvation of children is not a political issue. It is a human one, and one we must not look away from." What is observed of Perkins is the repost; nothing in the body is attributed to her.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7355769009763438593/','linkedin.com','2025-08','2026-09-03T21:00:00Z',NULL,0,'family_or_partner','p_cliff_obrecht','run_ingest_perkins_20260903'),
 ('f_perkins_044','m_perkins',
  'On working habits she wrote: "As we enter 2025, I''ve been reflecting on my goals for the year and the lessons I''ve learned about sustaining energy and focus. I used to work seven days a week, barely pausing to breathe, thinking it was the only way to succeed - but I''ve since realized how unsustainable that was."',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7281870969856532482/','linkedin.com','2025-01','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_045','m_perkins',
  'THE DATE TRAP, measured. LinkedIn activity 7313006523847192576 sits under the Canva Create 2026 branding elsewhere on the platform, but its own body reads "It''s hard to believe we''re less than 10 days away from Canva Create 2025! This will be our fourth time bringing our community together". The body and the platform''s own relative-date field agree on 2025; the surrounding slug and title do not. Dates for this member are taken from the body or the platform field, never from a slug.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7313006523847192576/','linkedin.com','2025-04','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_046','m_perkins',
  'On the 1% Pledge she wrote: "A number of years ago we took the 1% Pledge where we donated 1% of our team''s product, time, profits and equity. I''m pleased to say that we''ve just crossed another pretty huge milestone of donating more than $1 billion worth of annual product value through our Canva for Education and Nonprofit" programmes.',
  'self_published','subject_authored','https://www.linkedin.com/feed/update/urn:li:activity:7226515296004534272/','linkedin.com','2024','2026-09-03T21:00:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),

-- ── X ───────────────────────────────────────────────────────────────────────
 ('f_perkins_047','m_perkins',
  'api.fxtwitter.com/MelanieCanva returns name "Melanie Perkins", handle MelanieCanva, 56,593 followers, 246 following, 1,314 posts, 84 media, joined 2011-06-05, location "Sydney, Australia", website canva.com, and the bio "Co-founder and CEO of @Canva. Working with an incredible team to empower the world to design." The name field is what makes this identity STRONG; the handle is capitalised.',
  'on_record','publisher','https://api.fxtwitter.com/MelanieCanva','api.fxtwitter.com','2026-09-03','2026-09-03T20:49:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),
 ('f_perkins_048','m_perkins',
  'PARTIAL follow-graph read. Her X following list was walked read-only in the operator''s Chrome in two passes with a reload between them, using real wheel events and selectors scoped to the primary column and to each cell''s own @handle line. 56 of a claimed 246 entries were reached before the list stopped at @alexrkonrad with no spinner, no error and no 429. Among those 56: Bill Tai (@KiteVC), Cameron Adams (@themaninblue), Niki Scevak, @blackbirdvc, @HowIBuiltThis, Mike Cannon-Brookes, Alex Konrad, Rutger Bregman, Bill Gates, Stewart Butterfield, Harry Stebbings, and the Canva company accounts. None of the other nine members appeared, but at 23% coverage that is NOT an assertable absence and no no_edge_confirmed edge rests on it.',
  'on_record','publisher','https://x.com/MelanieCanva/following','x.com','2026-09-03','2026-09-03T21:12:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903'),

-- ── The structural fact about her footprint ─────────────────────────────────
 ('f_perkins_049','m_perkins',
  'Her long-form first-person writing lives inside a newsroom no automated client can read: canva.com/, canva.com/newsroom/ and canva.com/newsroom/news/ all return 403 to a plain curl and to a full desktop-Chrome UA alike. A guessed RSS path would return the same 403, so the existence of a feed can be neither confirmed nor denied. Separately, the archived newsroom index of 2026-08-25 carries 12 article slugs and zero occurrences of the string "Melanie" - the newsroom is a company channel, not her byline. She has no personal site: melanieperkins.com does not resolve and melanieperkins.com.au is a parking page listed for sale.',
  'on_record','publisher','http://web.archive.org/web/20260825193821/https://www.canva.com/newsroom/news/','web.archive.org','2026-08-25','2026-09-03T20:50:00Z',NULL,0,NULL,NULL,'run_ingest_perkins_20260903');
COMMIT;
