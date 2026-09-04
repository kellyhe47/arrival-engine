-- Follow-up authenticated Instagram identity probe for Brad Feld.

PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;
BEGIN IMMEDIATE;

INSERT INTO run (id, started_at, finished_at, execution_ctx, notes)
VALUES (
  'run_ingest_feld_instagram_20260903',
  '2026-09-04T01:24:00Z',
  '2026-09-04T01:30:08Z',
  'operator_machine',
  'Follow-up logged-in Instagram probe for m_feld. PARTIAL: two candidates were inspected but neither passed identity corroboration, so no Instagram content was attributed and zero facts were written.'
);

-- Candidate records are deliberately non-collectable. A matching name or
-- handle is not enough to attribute either account to Brad Feld.
INSERT INTO person_identity
  (person_id, source_id, url, handle, role, tier, corroboration,
   http_status, measured_at, notes)
VALUES
  ('m_feld','instagram_candidate_brad_feld','https://www.instagram.com/brad_feld/','brad_feld','negative_probe','SESSION','["display_name_matches"]',200,'2026-09-03','Logged-in profile render: private; display name Brad Feld; 241 posts, 116 followers, 285 following; no bio, verified badge, Foundry/feld.com link, or other independent corroboration. Its linked Threads profile had 21 followers, no bio, and no posts.'),
  ('m_feld','instagram_candidate_bfeld','https://www.instagram.com/bfeld/','bfeld','negative_probe','SESSION','["handle_matches"]',200,'2026-09-03','Logged-in profile render: public; 25 posts, 31 followers, 0 following; no display name, bio, verified badge, or external link. A visible post opened to June 7, 2011 with no caption. Handle equality alone is not identity evidence.')
ON CONFLICT(person_id, source_id, url) DO UPDATE SET
  handle=excluded.handle,
  role=excluded.role,
  tier=excluded.tier,
  corroboration=excluded.corroboration,
  http_status=excluded.http_status,
  measured_at=excluded.measured_at,
  notes=excluded.notes;

INSERT INTO source_status
  (person_id, source_id, tier, status, reason, http_code, fact_count, checked_at, run_id)
VALUES
  ('m_feld','instagram_session','SESSION','unavailable','Authenticated Instagram search and both surfaced candidates were readable, but no account passed the required identity threshold. The private @brad_feld account had only a matching display name; @bfeld had only a colliding handle and no identifying profile text. Feld''s canonical About page links X and LinkedIn but no Instagram. No follow request was sent.',200,0,'2026-09-04T01:30:08Z','run_ingest_feld_instagram_20260903');

COMMIT;
