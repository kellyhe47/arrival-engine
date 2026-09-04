# m_perkins ingest — plan on disk

Shard: `db/arena.m_perkins.db` (rebuild: schema -> vocabulary -> roster -> ingest/sql/m_perkins-*.sql)
Run id: `run_ingest_perkins_20260903`. Fact ids: `f_perkins_NNN`. Non-members: `p_<first>_<last>`.

## Board
- [x] build shard db
- [x] fxtwitter MelanieCanva (56,593 now vs seeded 56,591 — record, do NOT rebaseline)
- [x] canva.com 403 confirmed (plain UA + Chrome UA, /, /newsroom/, /newsroom/news/)
- [x] Wikipedia raw (14,469 B) — years_active 2007-present -> career_start_decade '2000s'
- [x] Wayback memoir part 1 (611 KB html / 64,439 chars text) + part 2 (453 KB / 39,848)
- [ ] Wayback newsroom index 20260825193821
- [ ] x.com/MelanieCanva server-rendered card
- [ ] NPR How I Built This (curl; transcript presence UNVERIFIED per prompt)
- [ ] LinkedIn: in-app browser first, then operator Chrome. SESSION. Full post bodies + follower count.
- [ ] LinkedIn Wayback via archive.org/wayback/available
- [ ] Follow list walk — WHOLE list, real wheel events, primaryColumn scoping, record reached/claimed
- [ ] Instagram melanieperkins — disambiguate "Profile isn't available" (never resolved at audit)
- [ ] Facebook / TikTok attempts (TikTok @melaniecanva is deny-worthy per prompt: contradictory, 9 followers)
- [ ] Edge searches: Open Library search/inside, podcast feeds, YC directory — the prompt says all measured absences
- [ ] Write ingest/sql/m_perkins-01-facts.sql, -02-edges-contexts-status.sql, -00-README.md
- [ ] ingest/reports/m_perkins.md ; append ingest/BLOCKERS.md with >>

## Hard rules for this member
- Slug `canva-create-2026` date trap: dates from BODY or platform field, never slug.
- If LinkedIn unavailable -> recency `unknown`, NEVER `quiet`. Do not repeat the retracted
  "no first-person 2026 publication" claim.
- Never fetch: youtube.com/feeds/videos.xml?user=canva, melanieperkins.com.au, TikTok @melaniecanva.
- 403 on canva.com is indistinguishable from absent: may neither confirm nor deny an RSS feed.
- Cliff Obrecht = family_or_partner AND shared_org; his facts about her render, tag via_edge_type.
