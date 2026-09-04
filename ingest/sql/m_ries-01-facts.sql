-- m_ries / Eric Ries — parallel ingest, layer 1 of 2 (immutable facts).
-- Shard file: db/arena.m_ries.db. Never apply against db/arena.db directly except at merge time.
-- Run leaves finished_at NULL; m_ries-02-edges-contexts-status.sql closes it.

PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO run (id, started_at, execution_ctx, notes) VALUES
  ('run_ingest_ries_20260903','2026-09-04T02:05:00Z','operator_machine',
   'Eric Ries sidecar ingest in progress. Facts load here; identity rows, edges, contexts, topic backfill, source attempts, final counts and finished_at are applied by m_ries-02-edges-contexts-status.sql.');

-- Career start. His own 2008/2011 "About the author" post: paid Java work while still in high
-- school, a 1996 book, and Catalyst Recruiting co-founded as a Yale undergraduate before the
-- dot-com bust. Wikipedia's Early life section agrees on the 1996 book and the Yale company;
-- its Career section starts at 2001 (There, Inc.), which is the later of the two readings.
-- name_respelling stays NULL: no recording was sourced this run.
-- prominence_tier is NOT touched. The seeded 4 stands; a higher LinkedIn follower count is
-- recorded below as a dated fact instead of re-baselining a shared roster field.
UPDATE person
   SET career_start_decade='1990s'
 WHERE id='m_ries';

INSERT INTO fact
  (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id)
VALUES

-- ── The live channel. This is the fact R-040 turns on: the blog looks dormant, the man is not. ──
  ('f_ries_001','m_ries',
   'His current primary channel is the beehiiv newsletter at news.theleanstartup.com, titled "Eric Ries" and described as "Eric Ries on why great companies go bad — and what founders, CEOs, and operators can do about it." The archive page carried exactly 12 posts, newest "The force that kills companies" dated 2026-08-23 and oldest "Today''s the day!" dated 2026-05-26.',
   'self_published','subject_authored','https://news.theleanstartup.com/archive','news.theleanstartup.com','2026-08-23','2026-09-04T02:07:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_002','m_ries',
   'On publication day he wrote "Waking up on publication day for a new book never gets old. This is my fourth time, and it''s as surreal as all the other ones," and pointed readers to a dynamic site he built to answer "How is Incorruptible Going?" at howisincorruptiblegoing.com.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/today-s-the-day','news.theleanstartup.com','2026-05-26','2026-09-04T02:08:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_003','m_ries',
   'Twelve days after publication he announced "Incorruptible is #5 on the New York Times bestseller list!" and credited his publisher Authors Equity with a launch highlight reel.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/on-the-list-f1d7','news.theleanstartup.com','2026-06-07','2026-09-04T02:08:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_004','m_ries',
   'His definition of profit, excerpted from the book in his own newsletter: "Profit is the maximization of human flourishing. To be precise, profit itself is the surplus of human flourishing that an organization creates." He frames the conventional definition as having "fatal blind spots" because "it can''t see externalities" and "ignores human costs."',
   'self_published','subject_authored','https://news.theleanstartup.com/p/what-is-profit','news.theleanstartup.com','2026-05-28','2026-09-04T02:09:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_005','m_ries',
   'On corporate charters he wrote "there is no neutral position. Every organization serves something," arguing the standard charter formulation — a corporation existing to "conduct or promote any lawful business or purposes" — is read in practice as an obligation to maximize shareholder returns.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/there-s-no-neutral-position','news.theleanstartup.com','2026-08-09','2026-09-04T02:09:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_006','m_ries',
   'His newest newsletter post opens on Edwin Land and Polaroid — Land forced into retirement by his own board in 1982, Steve Jobs calling it "the dumbest thing I''ve ever heard," and the company bankrupt by 2001 — as his lead example of what he calls "unusual failure."',
   'self_published','subject_authored','https://news.theleanstartup.com/p/the-force-that-kills-companies','news.theleanstartup.com','2026-08-23','2026-09-04T02:10:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_007','m_ries',
   'He names the chapter ethos "harder-is-easier" and writes that great leaders "realize that impossibilities are opportunities in disguise. They don''t accept the lazy defaults," adding "One hard is depleting. One hard is exhilarating."',
   'self_published','subject_authored','https://news.theleanstartup.com/p/harder-is-easier-here-s-why','news.theleanstartup.com','2026-07-26','2026-09-04T02:10:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_008','m_ries',
   'He spent launch day as a guest on TBPN, the daily three-hour tech talk show hosted by John Coogan and Jordi Hays, and used the 30-minute segment format to go deep on the Mondragon Corporation — a Spanish network of worker cooperatives employing around 80,000 people that he profiles in the book.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/tbpn-highlights-from-launch-day','news.theleanstartup.com','2026-05-27','2026-09-04T02:11:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_009','m_ries',
   'He wrapped a US book tour in late June 2026 and describes an LA event hosted by Cosmic Buildings, "one of the first companies to put Incorruptible''s main principles and mission protections into place," whose work became more urgent after the Los Angeles fires in 2025.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/stories-from-the-field-2468','news.theleanstartup.com','2026-06-28','2026-09-04T02:11:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_010','m_ries',
   'Ten days after publication he opened a free "Incorruptible community" at community.incorruptible.co as a book club and discussion space, and offered book buyers a live Q&A on 2026-06-10.',
   'self_published','subject_authored','https://news.theleanstartup.com/p/the-incorruptible-community-is-open','news.theleanstartup.com','2026-06-04','2026-09-04T02:12:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── The retrieval artifact itself, measured. ──
  ('f_ries_011','m_ries',
   'His blog Startup Lessons Learned carries 392 posts in its sitemap, from 2008-09-02 to 2026-05-17. The distribution is heavily front-loaded — 59 posts in 2008, 88 in 2009, then 5 in 2021, 1 in 2024 and 1 in 2026 — so a recency read taken from this archive alone reports a nearly dormant author, which the newsletter and the code repositories contradict.',
   'on_record','publisher','https://www.startuplessonslearned.com/sitemap.xml','www.startuplessonslearned.com','2026-05-17','2026-09-04T02:13:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_012','m_ries',
   'The single 2026 post on his blog is the pre-launch announcement "Incorruptible: My new book comes out May 26!", which relays GeekWire''s coverage of his book preview talk at Seattle Flow Startup Day and calls it "a bookend to my first appearance there in 2011, when The Lean Startup came out."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2026/05/incorruptible-my-new-book-comes-out-may.html','www.startuplessonslearned.com','2026-05-17','2026-09-04T02:13:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Career start, in his own words. ──
  ('f_ries_013','m_ries',
   'His own "About the author" post says he became a Java "expert" while still in high school and was paid to write and program then, co-founded Catalyst Recruiting as a Yale undergraduate, and is co-author of The Black Art of Java Game Programming (Waite Group Press, 1996). Catalyst folded with the dot-com crash and he continued as a Senior Software Engineer at There.com before co-founding IMVU, where he was CTO for almost five years.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2008/10/about-author.html','www.startuplessonslearned.com','2008-10-01','2026-09-04T02:14:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_014','m_ries',
   'In the same post he traces his start to text-based MUDs: "it was thanks to MUDs that I first discovered the internet. Those early text-based games were programmed by their own users... In a MUD, you could literally conjure new objects that never existed before, just by programming them. I know many people who think that software works like magic, but to me it actually was magic." He got his start on an old IBM XT.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2008/10/about-author.html','www.startuplessonslearned.com','2008-10-01','2026-09-04T02:14:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_015','m_ries',
   'The bio paragraph in that post — updated by him in February 2011 and otherwise unchanged since October 2008 — still misspells his own university as "Yale Unviersity."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2008/10/about-author.html','www.startuplessonslearned.com','2011-02-01','2026-09-04T02:15:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_016','m_ries',
   'English Wikipedia records his birth date as 22 September 1978, education at Yale University, a BS in computer science, a move to Silicon Valley in 2001 as a software engineer at There, Inc., co-founding IMVU with Will Harvey in 2004, and the Black Art of Java Game Programming book published while he was in high school.',
   'third_party','publisher','https://en.wikipedia.org/w/index.php?title=Eric_Ries&action=raw','en.wikipedia.org','2026-09-03','2026-09-04T02:15:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Long-term governance / LTSE, the richest verifiable vein. ──
  ('f_ries_017','m_ries',
   'He announced LTSE on his own blog in 2016: "I''m the CEO of a new company with a mission to fix the root cause of one of the worst problems plaguing our whole business ecosystem: the malign philosophy of short-termism that emanates from our public markets. We call this new company The Long-Term Stock Exchange (LTSE)."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2016/06/introducing-long-term-stock-exchange.html','www.startuplessonslearned.com','2016-06-13','2026-09-04T02:16:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_018','m_ries',
   'The SEC approved LTSE as a national securities exchange on 2019-05-10 by Release No. 34-85828, File No. 10-234, on a Form 1 application LTSE filed on 2018-11-09 under Section 6 of the Securities Exchange Act of 1934.',
   'on_record','publisher','https://www.sec.gov/rules/other/2019/34-85828.pdf','www.sec.gov','2019-05-10','2026-09-04T02:16:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_019','m_ries',
   'He personally executed and swore the Form 1 Execution Page for LTSE, signing as "Eric Ries" on behalf of Long-Term Stock Exchange, Inc. on 11/09/18. The notary block stamped on the page reads "QUALIFIED IN KINGS COUNTY" with commission number 01GE6340718 expiring 04-25-2020. The applicant address given is 300 Montgomery St., STE 790, San Francisco, CA 94104 and the named contact employee is Michelle D. Greene, Chief Policy Officer.',
   'on_record','publisher','https://www.sec.gov/rules/other/2018/long-term-stock-exchange/long-term-stock-exchange-form1-cover-page.pdf','www.sec.gov','2018-11-09','2026-09-04T02:17:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_020','m_ries',
   'The cover letter transmitting his own exchange''s Form 1 to the SEC is not his. It is written on Davis Polk & Wardwell letterhead, signed by Annette L. Nazareth, addressed to Brett Redfearn, Director of the Division of Trading and Markets, dated November 9, 2018 and delivered by hand. Ries appears once, on the last line: "cc: Mr. Eric Ries, Long-Term Stock Exchange, Inc."',
   'on_record','publisher','https://www.sec.gov/rules/other/2018/long-term-stock-exchange/long-term-stock-exchange-form1-filing-letter.pdf','www.sec.gov','2018-11-09','2026-09-04T02:17:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_021','m_ries',
   'The exchange entity, CIK 0001757271 "Long-Term Stock Exchange, Inc.", has 62 filings on EDGAR — one Form 1 dated 2018-09-21 and 61 Form 1/A amendments running to 2026-08-17, every one of them an auto-generated paper document. It is incorporated in Delaware and now files from 101 Greenwich St., Ste 11A, New York, NY 10006.',
   'on_record','publisher','https://data.sec.gov/submissions/CIK0001757271.json','data.sec.gov','2026-08-17','2026-09-04T02:18:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_022','m_ries',
   'Across all eight LTSE Form D filings — five for LTSE Services, Inc. (CIK 0001680712, formerly Long-Term Stock Exchange, Inc. and LTSE Holdings, Inc.) and three for LTSE Group, Inc. (CIK 0001786417) — the entire related-persons universe is four people: Eric Ries, John V. Bautista, Brian Singerman, and Maliz Beams, who first appears in 2022. Ries is listed as Executive Officer and Director on every filing, and additionally as Promoter on the 2016, 2017 and 2019 Group filings.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1680712/000168071222000004/primary_doc.xml','www.sec.gov','2022-08-08','2026-09-04T02:18:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_023','m_ries',
   'The first LTSE Form D, filed 2016-07-27 for a company its own filing dates to 2012, reports $18,310,009 raised from 62 investors and gives the issuer address as 340 S. Lemon Avenue, Suite 2197, Walnut, CA 91789. By 2019 the address is 300 Montgomery Street in San Francisco and by 2022 it is 250 Montgomery Street, Suite 800; the 2022 LTSE Services filings report $103,352,935 raised.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1680712/000168071216000001/primary_doc.xml','www.sec.gov','2016-07-27','2026-09-04T02:19:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_024','m_ries',
   'Maliz Beams'' address on all four 2022 LTSE Form D filings is typed "SAN FRANCSICO" while Ries'', Bautista''s and Singerman''s on the same page read "SAN FRANCISCO" — a transposition that survived into a signed federal filing and was never amended.',
   'on_record','publisher','https://www.sec.gov/Archives/edgar/data/1680712/000168071222000003/primary_doc.xml','www.sec.gov','2022-07-07','2026-09-04T02:19:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_025','m_ries',
   'On LTSE''s first two listings he wrote: "Ten years ago, I first put forth the idea of a stock exchange that could help reimagine capitalism as a force that serves not just some of us, but all of us... Today, LTSE has its first two listings: Asana and Twilio."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2021/08/a-letter-to-our-future.html','www.startuplessonslearned.com','2021-08-26','2026-09-04T02:20:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_026','m_ries',
   'His last substantive blog post before the book, on governance: "I''ve spent a lot of time in recent years thinking about governance... Over and over, I''ve seen founders succumb to the idea that their governance has to be the same as everyone else''s in order to succeed." He builds it around a Matt Levine Bloomberg column on common versus separate ownership.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2024/08/strong-governance-actually-makes-weak.html','www.startuplessonslearned.com','2024-08-11','2026-09-04T02:20:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Tech policy: immigration and elections, both in his own voice. ──
  ('f_ries_027','m_ries',
   'Writing from Washington DC on the Geeks on a Plane tour, he says he presented at the White House on "reducing the personal cost of failure for entrepreneurs, innovation-friendly legal reforms, and access to the digital means of production," then asked readers to back the Startup Founders Visa, naming "a serious structural barrier to entrepreneurship: a glitch" in US immigration policy.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2009/09/support-startup-founders-visa-with.html','www.startuplessonslearned.com','2009-09-22','2026-09-04T02:21:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_028','m_ries',
   'On a second Startup Visa lobbying trip he wrote: "This trip was designed to build momentum following last week''s announcement that Senators Kerry and Lugar have introduced a Senate bill to make the Startup Visa a reality: the Startup Visa Act of 2010. This follows Congressman Jared Polis, who has introduced a similar bill as part of comprehensive immigration reform in the House. Our trip was bipartisan, bicameral, and bi-branches-of-government... we have no lobbyists, no PAC, and no organized presence in Washington." Over 5,000 registered voters joined the "tweet hall" on the flight.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2010/03/startup-visa-update.html','www.startuplessonslearned.com','2010-03-09','2026-09-04T02:21:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_029','m_ries',
   'He broke his own no-politics norm on the blog in 2016: "This is not an ordinary year and it requires us to take extraordinary steps to safeguard our community and our nation," publishing a transcript of the political section of his Lean Startup Week keynote and offering "If you''re thinking about voting but aren''t sure if you can or how to do it, please email me."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2016/11/please-vote.html','www.startuplessonslearned.com','2016-11-06','2026-09-04T02:22:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Startup communities. ──
  ('f_ries_030','m_ries',
   'On visiting Boulder at TechStars'' invitation: "It was a great experience to see a relatively new startup hub in action - and thriving. It''s easy to take Silicon Valley for granted. The startup scene here can be ostentatious and serve as an echo chamber... Traveling to Boulder I had the feeling of stepping back in time. It felt like I was watching a new startup hub in the process of being created."',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2009/08/building-new-startup-hub.html','www.startuplessonslearned.com','2009-08-26','2026-09-04T02:23:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_031','m_ries',
   'Announcing conference simulcasts across roughly a dozen countries he wrote: "These simulcasts are important community-building opportunities. Although knowledge about the new science of entrepreneurship has gone global, startup ecosystems are always local. (BTW, you can read more about why in Brad Feld''s new book, Startup Communities.)"',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2012/10/host-livestream-of-lean-startup.html','www.startuplessonslearned.com','2012-10-15','2026-09-04T02:23:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Edges, evidence facts. ──
  ('f_ries_032','m_ries',
   'On Brad Feld, in his own voice: "Brad Feld and I have a bit of a mutual admiration society going. He and I have worked together on the Startup Visa initiative. He''s said nice things about me and my book. I think he''s a great guy." The post is his endorsement of Feld''s book Venture Deals, and he prefaces it by saying he refuses to endorse a book he does not believe helps entrepreneurs.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2011/07/venture-deals.html','www.startuplessonslearned.com','2011-07-26','2026-09-04T02:24:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_033','m_ries',
   'His own book-tracking site records a free virtual fireside chat between him and Brad Feld on 2026-04-29, sourced to feld.com, in which Feld connects his Give First philosophy to the book: "The Lean Startup helps you build a valuable company. Incorruptible is about how to protect it... Incorruptible is about how and why to protect it, keeping a company mission-driven over the long term instead of letting it rot from the inside."',
   'self_published','subject_authored','https://howisincorruptiblegoing.com/e/2026-04-29-brad-feld-fireside-chat/','howisincorruptiblegoing.com','2026-04-29','2026-09-04T02:24:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_034','m_ries',
   'Leanpub''s publisher page for Uncensored, "A Charitable Project to Support The Open Internet," names its authors as "Hunter Walk and Eric Ries" and describes it as arising from the SOPA/PIPA debates; it reports 2,236 readers. The book is not mentioned anywhere in his own 392-post blog archive, so this edge is documented only from the publisher''s side, never from his voice.',
   'on_record','publisher','https://leanpub.com/uncensored','leanpub.com','2012-01-01','2026-09-04T02:25:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_035','m_ries',
   'Announcing expanded conference simulcasts he wrote: "Thanks to Fred Wilson''s endorsement, it looks like we''ll now have well north of one hundred cities participating." This is the only mention of Fred Wilson in the whole 392-post archive.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2011/05/new-speakers-ignite-streaming-locations.html','www.startuplessonslearned.com','2011-05-15','2026-09-04T02:25:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_036','m_ries',
   'The published agenda for his Lean Startup Intensive at Web 2.0 Expo on 2010-05-03 lists Josh Kopelman as a panelist on "Investing in the era of the lean startup" alongside Ann Miura-Ko and Jeff Clavier, moderated by Dave McClure, with a joint closing session that includes Q&A with Eric Ries. This is the only mention of Josh Kopelman in the whole 392-post archive.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2010/05/lean-startup-intensive-is-tomorrow-at.html','www.startuplessonslearned.com','2010-05-02','2026-09-04T02:26:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_037','m_ries',
   'The show-notes resource list he published for Out of the Crisis #15 with Lenore Estrada names "Emmett Shear, Twitch" among the linked resources. It is the only occurrence of Emmett Shear in the whole 392-post archive, and it is a link list rather than a claim of contact.',
   'self_published','subject_authored','https://www.startuplessonslearned.com/2020/07/out-of-crisis-15-lenore-estrada-on-her.html','www.startuplessonslearned.com','2020-07-22','2026-09-04T02:26:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_038','m_ries',
   'A literal scan of the full text of all 392 posts in his blog''s Blogger feed found zero occurrences of Hunter Walk, Sarah Tavel, Steve Huffman, Melanie Perkins or Nabeel, and only one each of Fred Wilson, Josh Kopelman and Emmett Shear against thirteen of Brad Feld.',
   'on_record','publisher','https://www.startuplessonslearned.com/feeds/posts/default?alt=json&max-results=25','www.startuplessonslearned.com','2026-09-03','2026-09-04T02:27:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_039','m_ries',
   'A literal scan of both of his own podcast feeds — The Eric Ries Show, 44 episodes from 2024-05-05 to 2026-01-08, and Out of the Crisis, 29 episodes from 2020-03-30 to 2021-05-24, titles plus full show-note descriptions — found zero occurrences of any of the other nine members or their firms.',
   'on_record','publisher','https://anchor.fm/s/f51132a8/podcast/rss','anchor.fm','2026-01-08','2026-09-04T02:27:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_040','m_ries',
   'LTSE''s own Insights corpus, 157 articles, carries two profile write-ups of other members of the room: "Hunter Walk shares insights from the Homebrew Computer Club" and "Inside Reddit, with Co-Founder and CEO Steve Huffman." Neither article carries a byline, neither names Eric Ries in its body, and neither appears in either of his podcast feeds — so they document his company''s editorial reach, not a co-appearance by him.',
   'on_record','publisher','https://ltse.com/insights','ltse.com','2026-09-03','2026-09-04T02:28:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Code. The GitHub identity, corrected. ──
  ('f_ries_041','m_ries',
   'The GitHub account github.com/ericries has 11 public repositories, 3 followers, and was created 2014-11-15. Its API "name", "bio", "blog", "company" and "twitter_username" fields are all null or empty, so the corroboration recorded for this source in db/roster.sql — api_name_field_matches — is not available from the API: there is no name field to match.',
   'on_record','publisher','https://api.github.com/users/ericries','api.github.com','2026-09-03','2026-09-04T02:29:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_042','m_ries',
   'The identity holds on a stronger basis instead. His own newsletter links howisincorruptiblegoing.com; that domain is served by GitHub Pages, ericries.github.io/howisincorruptiblegoing/ redirects to it, and it is built from the Astro repository github.com/ericries/howisincorruptiblegoing. The account also holds the repository incorruptible-videos-media, described as "Media assets for Incorruptible book launch videos."',
   'inferred','publisher','https://api.github.com/repos/ericries/howisincorruptiblegoing','api.github.com','2026-09-03','2026-09-04T02:29:00Z','["f_ries_002","f_ries_041"]',0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_043','m_ries',
   'Three of his repositories were pushed on 2026-09-03, the day of the audit: howisincorruptiblegoing (Astro), seedlist ("LLM-researched directory of active startup investors", serving seedlist.com) and skintiers ("SkinTiers — a skeptical, evidence-first directory of skincare: what the research actually shows, graded on a consistent effect-size x evidence-quality rubric"), which he created 2026-07-27. The howisincorruptiblegoing.com response header last-modified reads Thu, 03 Sep 2026 22:13:02 GMT.',
   'on_record','publisher','https://api.github.com/users/ericries/repos?per_page=100&sort=updated','api.github.com','2026-09-03','2026-09-04T02:30:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_044','m_ries',
   'He built and self-published a 320-page Tom Lehrer songbook. The repository github.com/ericries/tom-lehrer is a wget mirror of tomlehrersongs.com taken in December 2022 after Lehrer''s 2022 public domain release; his README documents stitching the sheet music into one PDF with Ghostscript, generating the table of contents with pandoc and MacTeX, and adding page numbers and PDF bookmarks by script. The output is titled "If He Could Only See Us: The Complete Public Domain Tom Lehrer Songbook," 320 pages, and his open TODOs include getting the Ghostscript parameters right for Amazon KDP and looking at other print-on-demand publishers.',
   'self_published','subject_authored','https://raw.githubusercontent.com/ericries/tom-lehrer/main/README.md','raw.githubusercontent.com','2023-01-17','2026-09-04T02:30:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── LinkedIn, read in the operator's Chrome session. ──
  ('f_ries_045','m_ries',
   'Read live and read-only in the operator''s Chrome session, LinkedIn shows Eric Ries at linkedin.com/in/eries with pronouns He/Him, the headline "NYT Bestselling Author of Incorruptible: Why Good Companies Go Bad...and How Great Companies Stay Great & The Lean Startup | Founder, LTSE", location San Francisco Bay Area, and an Influencer badge.',
   'self_published','subject_authored','https://www.linkedin.com/in/eries/','www.linkedin.com','2026-09-03','2026-09-04T02:31:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_046','m_ries',
   'LinkedIn showed 582,687 followers on 2026-09-03, nearly double his 301,420 on X the same day. The seeded prominence tier and its X-based basis are left unchanged for merge safety; both readings land him in tier 4 regardless.',
   'on_record','publisher','https://www.linkedin.com/in/eries/','www.linkedin.com','2026-09-03','2026-09-04T02:31:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_047','m_ries',
   'He runs a LinkedIn newsletter called "Trust is Everything" with 72,340 subscribers — a first-person publication channel that appears in no allow-list in db/roster.sql. Its 2026-06-01 essay "You Can''t Inspect an AI. You Can Watch How Its Makers Treat People." argues "A company''s true character — its ethos — is revealed most clearly in what it does with power when the choice is entirely its own," and builds the case on Meta''s arbitration campaign against author Sarah Wynn-Williams, on Llama''s training data, and on Meta''s 2026 layoffs.',
   'self_published','subject_authored','https://www.linkedin.com/pulse/you-cant-inspect-ai-can-watch-how-its-makers-treat-people-eric-ries-aivlc','www.linkedin.com','2026-06-01','2026-09-04T02:32:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_048','m_ries',
   'His LinkedIn activity feed loaded 20 posts, of which the two newest were reposts timestamped 3 and 4 hours before the read on 2026-09-03. Whatever his blog cadence suggests, he was active on the platform the same day.',
   'self_published','subject_authored','https://www.linkedin.com/in/eries/recent-activity/all/','www.linkedin.com','2026-09-03','2026-09-04T02:32:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── X, Instagram, TikTok. ──
  ('f_ries_049','m_ries',
   'His X profile @ericries reports name "Eric Ries", 301,420 followers, 1,835 following, 35,099 posts, joined 2008-04-01, location "SF", verified, website incorruptible.co, and the bio "Order my new book INCORRUPTIBLE & unlock exclusive bonuses at incorruptible.co". The seeded roster figure of 301,423, measured the same day, differs by three — counts drift and measured_at matters.',
   'on_record','publisher','https://api.fxtwitter.com/ericries','api.fxtwitter.com','2026-09-03','2026-09-04T02:33:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_050','m_ries',
   'Read in the operator''s Chrome session, Instagram @ericriesactual shows "Eric Ries", he/him, 310 posts, 1,867 followers, 337 following, and the bio "Author of The Lean Startup Incorruptible: Why Good Companies Go Bad... And How Great Companies Stay Great" with a link to incorruptible.co. The account is public. Its recent grid is book-promotion clips and quote cards rather than personal photography, so it yields no place or life-event context.',
   'self_published','subject_authored','https://www.instagram.com/ericriesactual/','www.instagram.com','2026-09-03','2026-09-04T02:33:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_051','m_ries',
   'TikTok @ericriesactual renders logged out and shows "Eric Ries", 22 following, 308 followers, 2,230 likes, and the bio "Author of The Lean Startup. New book INCORRUPTIBLE out May 26. Building companies that stay true to their mission. incorruptible.co". No video grid is served without a session, so the video list could not be enumerated from the profile page.',
   'on_record','publisher','https://www.tiktok.com/@ericriesactual','www.tiktok.com','2026-09-03','2026-09-04T02:34:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_052','m_ries',
   'Two independent walks of his X following list, each a reload followed by real wheel-event scrolling scoped to the primary column, both terminated at exactly the same 70 accounts ending on @mehdirhasan — 70 of a claimed 1,835, or 3.8%. The stop was silent: no spinner, no error, no 429. No absence may be asserted from this walk.',
   'on_record','publisher','https://x.com/ericries/following','x.com','2026-09-03','2026-09-04T02:34:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_053','m_ries',
   'Of the 70 accounts reached in his X following list, none belongs to any of the other nine members. @tbpn, the show he appeared on at launch, is among them, as are @semil and @joshelman, who also appear in Fred Wilson''s partially-walked list.',
   'on_record','publisher','https://x.com/ericries/following','x.com','2026-09-03','2026-09-04T02:35:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── The tracker, and the forward calendar. ──
  ('f_ries_054','m_ries',
   'The tracking site he built for the book, howisincorruptiblegoing.com, holds 575 dated entries counted by its own permalinks, running from 2025-11-20 to a scheduled 2026-10-27, and its own header counts "611 moments" and "159 voices". Its forward calendar puts him in London on 8-11 September 2026 (Soho House, Mishcon de Reya in Cambridge, Octopus Energy on Oxford Street, Huckletree at Oxford Circus and KPMG in Canary Wharf), then Oakland on 23 September, Stanford ETL on 7 October, Dallas on 14 October, the Presidio on 20 October and Berkeley on 27 October.',
   'self_published','subject_authored','https://howisincorruptiblegoing.com/','howisincorruptiblegoing.com','2026-09-03','2026-09-04T02:36:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_055','m_ries',
   'The same site records that Harvard Business School professor Tatiana Sandino hosted him in her Systems for Scaling Ventures class in 2026, and quotes her endorsement of the book on LinkedIn.',
   'self_published','subject_authored','https://howisincorruptiblegoing.com/','howisincorruptiblegoing.com','2026-09-03','2026-09-04T02:36:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── Podcasts. ──
  ('f_ries_056','m_ries',
   'The Eric Ries Show, at ericriesshow.com, carries 44 episodes from 2024-05-05 to 2026-01-08 with itunes:author "Eric Ries", described as conversations about "how to build profitable companies for the long-term benefit of society." His earlier show Out of the Crisis carries 29 episodes from 2020-03-30 to 2021-05-24, opening with Sam Altman and Mark Cuban. Taken alone the podcast feeds also read as stale — the newer show''s last item is eight months before the audit — while his YouTube channel for the same show, 112,000 subscribers, was live the day of the audit.',
   'self_published','subject_authored','https://anchor.fm/s/f51132a8/podcast/rss','anchor.fm','2026-01-08','2026-09-04T02:37:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

  ('f_ries_057','m_ries',
   'The Apple Podcasts record for Out of the Crisis, which he linked from his own blog, gives artistName "Eric Ries", 29 tracks, and the feed anchor.fm/s/477be9bc/podcast/rss. The vanity domain outofthecrisis.com was a guess and is not his attested property: it answers on 443 with a certificate issued for *.outofthecrisis.org that expired 2025-11-25.',
   'on_record','publisher','https://itunes.apple.com/lookup?id=1505392824&entity=podcast','itunes.apple.com','2026-09-03','2026-09-04T02:37:00Z',NULL,0,NULL,NULL,'run_ingest_ries_20260903'),

-- ── The book. ──
  ('f_ries_058','m_ries',
   'Incorruptible: Why Good Companies Go Bad... and How Great Companies Stay Great was published by Authors Equity on 2026-05-26 in the US and 2026-05-28 elsewhere. Wikipedia lists it alongside The Startup Way (Currency, 2017) and The Lean Startup (Currency, 2011). His own newsletter calls it his fourth book, which matches those three plus the self-published The Leader''s Guide of 2015.',
   'inferred','publisher','https://en.wikipedia.org/w/index.php?title=Eric_Ries&action=raw','en.wikipedia.org','2026-09-03','2026-09-04T02:38:00Z','["f_ries_002","f_ries_012","f_ries_016"]',0,NULL,NULL,'run_ingest_ries_20260903');

COMMIT;
