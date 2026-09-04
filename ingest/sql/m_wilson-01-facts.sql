PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO run (id, started_at, execution_ctx, notes) VALUES
 ('run_ingest_wilson_20260903','2026-09-03T23:40:00Z','operator_machine',
  'Content ingest, m_wilson. GREEN sources first, SESSION second.');

-- ── One-hop non-members (is_member=0: never scored, never surfaced) ───────────
INSERT OR IGNORE INTO person (id,is_member,display_name,seniority_tier,prominence_tier,created_run) VALUES
 ('p_joanne_wilson',0,'Joanne Wilson',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_brad_burnham',0,'Brad Burnham',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_albert_wenger',0,'Albert Wenger',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_john_buttrick',0,'John Buttrick',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_andy_weissman',0,'Andy Weissman',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_rebecca_kaden',0,'Rebecca Kaden',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_nick_grossman',0,'Nick Grossman',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_kerriann_rachlin',0,'KerriAnn Rachlin',NULL,NULL,'run_ingest_wilson_20260903'),
 ('p_jerry_colonna',0,'Jerry Colonna',NULL,NULL,'run_ingest_wilson_20260903');

-- ── Facts ─────────────────────────────────────────────────────────────────────
INSERT INTO fact (id,subject_id,text,provenance_class,trust_class,source_url,source_host,source_date,observed_at,composed_from,search_first_page,via_edge_type,via_person_id,run_id) VALUES

-- avc.xyz, the LIVE blog (subject-authored)
('f_wil_001','m_wilson','Chairman of SoundCloud, and listens there by preference: "I like to listen to music on SoundCloud. For one, I am the Chairman of the Company. For another, I love the unsigned artists, remixes, and mixed tapes that make up more than half of the catalog on the service and mostly don''t exist anywhere else."','self_published','subject_authored','https://avc.xyz/free-your-music','avc.xyz','2026-01-15','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_002','m_wilson','Over the 2025 holidays he synced playlists into SoundCloud via Library Sync — among them a friend''s annual year-end playlist, the Gus Van Sant film "Dead Man''s Wire" soundtrack, the soundtrack to Mark Ronson''s book, and Radiohead ("we all need Radiohead").','self_published','subject_authored','https://avc.xyz/free-your-music','avc.xyz','2026-01-15','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_003','m_wilson','Wrote his first code in high school, paid part of his way through MIT writing Fortran in a research lab, and then stopped: "When I got into VC in the mid 80s, I stopped writing code ... I have not written much code in almost forty years." AI coding tools have reversed that.','self_published','subject_authored','https://avc.xyz/im-coding-again','avc.xyz','2026-01-26','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_004','m_wilson','In one weekend of January 2026 he shipped two apps, both about music: a web app built in Claude Code in the Mac Terminal that plays back everything he has recently liked on SoundCloud (deployed on Railway), and "Music Casts", a Farcaster/Base mini-app built in Neynar Studio that collects the music links posted by people he follows.','self_published','subject_authored','https://avc.xyz/im-coding-again','avc.xyz','2026-01-26','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_005','m_wilson','Built "Pele", a World Cup betting agent, on an old Mac Mini pulled out of his storage basement and factory-reset with no iCloud or Gmail attached, running the Hermes harness from Nous Research on an inexpensive Gemini model via OpenRouter. He funded a Solana wallet with $1,500 in SOL and USDC, gave the agent the keys, and traded the Pascal onchain prediction market entirely through Telegram — total token spend to date $21.84.','self_published','subject_authored','https://avc.xyz/my-pele-agent','avc.xyz','2026-06-24','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_006','m_wilson','On the Pele portfolio: qualifier bets on Senegal, South Korea, Turkey and Scotland, longshots on Portugal, Germany and the Netherlands — and a verdict on himself: "I am not a great picker when it comes to the World Cup ... I could have and may should have asked Pele to make all of the picks for me. He probably would have done better than me. But picking stuff (stocks, bets, etc) is so much fun for me. I''m not turning that over to an agent so quickly."','self_published','subject_authored','https://avc.xyz/my-pele-agent','avc.xyz','2026-06-24','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_007','m_wilson','On the Digital Asset Market Clarity Act: "My partners at USV and I have been investing in the crypto industry for fifteen years without the benefit of clearly written rules on what is allowed and what is not. I have been sued, dragged into the basement of the SEC and interrogated, threatened, and more." He backs the bill while calling it "far from a perfect bill".','self_published','subject_authored','https://avc.xyz/the-clarity-act','avc.xyz','2026-07-23','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_008','m_wilson','His live blog is avc.xyz, published on Paragraph; the feed carries 20 full-text posts from 2025-12-18 to 2026-07-23. avc.com is the frozen 2003-2024 archive, not the current blog.','self_published','subject_authored','https://api.paragraph.com/blogs/rss/@avc.xyz','api.paragraph.com','2026-07-23','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- avc.com, the frozen archive — mined by targeted search, not walked
('f_wil_009','m_wilson','Born at the United States Military Academy: "I was born at and spent a fair bit of my childhood at the United States Military Academy where my father taught engineering."','self_published','subject_authored','https://avc.com/2018/08/duty-honor-country/','avc.com','2018-08-26','2026-09-03T23:40:00Z',NULL,1,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_010','m_wilson','His father, General Robert Maris Wilson, died 2020-12-21 aged 92 after 33 years of active Army duty; he ran the Department of Mechanical Engineering at West Point for the last decade of his service. From the four-page biography his father wrote for his own obituary, quoted by Wilson: "During the last half of his tour (in Vietnam), he headed a small group of officers assembled at the direction of General Abrams to plan for the initial withdrawal of U.S. forces from Vietnam." Wilson''s comment: "When you needed to figure out how to get an Army out of somewhere, he was your man."','self_published','subject_authored','https://avc.com/2020/12/general-robert-maris-wilson/','avc.com','2020-12-23','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_011','m_wilson','Keeps a vinyl collection and turntable at a second home on the east end of Long Island — "the merger of three collections; Gotham Gal''s (Joni Mitchell, Jackson Brown, etc), mine (rock and roll), and a friend who donated his entire collection to us when CDs arrived". Nothing in it post-early-80s: every Stones record until Tattoo You, most of Neil Young, Bob Marley, Elvis Costello up to King of America, Dylan until Infidels, Led Zeppelin. Filed under his "My Music" category.','self_published','subject_authored','https://avc.com/2007/06/vinyl_records/','avc.com','2007-06-04','2026-09-03T23:40:00Z',NULL,1,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_012','m_wilson','Cites Josh Kopelman in his own writing as "Josh Kopelman (one of my favorite VCs)", posting a Disrupt panel video with his USV partner Andy Weissman and Kopelman''s LP Chris Douvos.','self_published','subject_authored','https://avc.com/2016/05/from-the-investors-perspective/','avc.com','2016-05-16','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_013','m_wilson','Builds a post around Kopelman''s writing: "As I was reading Josh Kopelman''s excellent post on the seed boom and Series A bust, I got thinking of some words of wisdom Mike Arrington once shared with me."','self_published','subject_authored','https://avc.com/2015/03/numbers-can-ruin-a-good-story/','avc.com','2015-03-11','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_014','m_wilson','Gave a whole post over to quoting Brad Feld at length during the 2008 crash, under the title "Great Advice From Brad Feld".','self_published','subject_authored','https://avc.com/2008/10/great-advice-fr/','avc.com','2008-10-10','2026-09-03T23:40:00Z',NULL,1,NULL,NULL,'run_ingest_wilson_20260903'),

-- usv.com — the firm publishing about its own partner
('f_wil_015','m_wilson','USV''s own bio: "Fred Wilson has been a venture capitalist since 1987. He currently is a partner at Union Square Ventures and also founded Flatiron Partners." BS in Mechanical Engineering from MIT, MBA from Wharton; married with three children, lives in New York City.','on_record','publisher','https://www.usv.com/people/fred-wilson/','usv.com','2026-09-03','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_016','m_wilson','Chairman of the NYC Department of Education''s CS4All Capital Campaign and co-Chairman of Tech:NYC.','on_record','publisher','https://www.usv.com/people/fred-wilson/','usv.com','2026-09-03','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_017','m_wilson','His last post on the USV site is "Twelve Days In Korea and Japan", 2024-10-08; the firm feed has since been carried by other partners.','on_record','publisher','https://www.usv.com/people/fred-wilson/','usv.com','2024-10-08','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- SEC — Form ADV. STRONG identity binding.
('f_wil_018','m_wilson','Named in Union Square Ventures'' Form ADV Schedule A (Direct Owners and Executive Officers) as "WILSON, FREDERICK, R." — an individual MEMBER since 01/2004, ownership code B (10% to under 25%), Control Person: Yes, CRD 4530741. Filing dated 2026-03-27.','on_record','publisher','https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf','reports.adviserinfo.sec.gov','2026-03-27','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

('f_wil_019','m_wilson','Union Square Ventures, LLC is an ACTIVE SEC-registered investment adviser, SEC# 802-75126 / CRD 162375, at 817 Broadway, 14th Floor, New York NY 10003. Schedule A also lists Brad Burnham (2004), Albert Wenger and John Buttrick (2012), Andy Weissman (2014), Rebecca Kaden (2019), Nick Grossman (2021) and KerriAnn Rachlin (2022).','on_record','publisher','https://reports.adviserinfo.sec.gov/reports/ADV/162375/PDF/162375.pdf','reports.adviserinfo.sec.gov','2026-03-27','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- Farcaster
('f_wil_020','m_wilson','Farcaster user #169 — fid 169, username fredwilson.eth, bio "I am a VC", 14,729 followers against 254 following, referred onto the network by dwr. His profile carries an AVC token deployed on Base.','self_published','subject_authored','https://api.warpcast.com/v2/user-by-username?username=fredwilson','api.warpcast.com','2026-09-03','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- fxtwitter counters
('f_wil_021','m_wilson','X profile @fredwilson: name "Fred Wilson", bio "I am a VC", location "New York City", website avc.xyz, joined 2007-03-12, 640,844 followers against 1,345 following, 19,911 posts.','self_published','subject_authored','https://api.fxtwitter.com/fredwilson','api.fxtwitter.com','2026-09-03','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- Wikipedia. Anyone could have written it -> third_party_open. Stored, deliberately not renderable.
('f_wil_022','m_wilson','Wikipedia: born August 20, 1961; associate then General Partner at Euclid Partners 1987-1996; co-founded Flatiron Partners with Jerry Colonna in 1996 and shut it down in 2001; co-founded Union Square Ventures with Brad Burnham in 2004. Married to Joanne Wilson; three children, all Wesleyan; homes in New York City and Venice Beach.','third_party','third_party_open','https://en.wikipedia.org/wiki/Fred_Wilson_(financier)','en.wikipedia.org','2026-09-03','2026-09-03T23:40:00Z',NULL,0,NULL,NULL,'run_ingest_wilson_20260903'),

-- Partner's blog. DEC-12: renders without corroboration, tagged with the edge it came through.
('f_wil_023','m_wilson','His wife Joanne Wilson publishes the Gotham Gal blog at gothamgal.com on a near-daily cadence — ten posts between 2026-08-05 and 2026-08-27, more recent than anything on his own blog.','third_party','publisher','https://gothamgal.com/feed/','gothamgal.com','2026-08-27','2026-09-03T23:40:00Z',NULL,0,'family_or_partner','p_joanne_wilson','run_ingest_wilson_20260903');

COMMIT;
