PRAGMA foreign_keys = ON;
BEGIN;

-- Operator correction, 2026-09-03: @jkopelman was manually reviewed and rejected as Josh
-- Kopelman's account. Keep only deny markers so neither this candidate nor the known @joshk
-- collision can be attributed to him in a future collection pass. No profile or post content is
-- retained from either account.
INSERT OR IGNORE INTO person_identity_negative
  (person_id,value,kind,belongs_to,basis,measured_at) VALUES
  ('m_kopelman','https://www.instagram.com/jkopelman/','url',NULL,
   'Operator manually reviewed the account through their logged-in Instagram session on 2026-09-03 and confirmed it is not Josh Kopelman. Do not collect or attribute this account.',
   '2026-09-03'),
  ('m_kopelman','https://www.instagram.com/joshk/','url','Josh K, owner of Kelly Media Inc.',
   'SESSION read 2026-09-03: verified profile display name Josh K; bio says Owner @kellymediainc and links leaguesportsandentertainment.com. This collides with Kopelman''s X handle but is a different person. No profile or post content is retained.',
   '2026-09-03');

COMMIT;
