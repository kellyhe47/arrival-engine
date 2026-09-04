-- Scratch-only application of the pending suppression schema request.
-- Skip this file once db/schema.sql itself contains fact.suppression_class and the view predicate.
PRAGMA foreign_keys = ON;
BEGIN;

ALTER TABLE fact ADD COLUMN suppression_class TEXT;

DROP VIEW v_renderable_fact;
CREATE VIEW v_renderable_fact AS
  SELECT * FROM fact
   WHERE superseded_by IS NULL
     AND source_url IS NOT NULL
     AND NOT (provenance_class = 'inferred'
              AND (composed_from IS NULL OR json_array_length(composed_from) = 0))
     AND trust_class <> 'third_party_open'
     AND suppression_class IS NULL;

COMMIT;

