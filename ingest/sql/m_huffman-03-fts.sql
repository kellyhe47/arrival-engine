-- Rebuild contentless FTS after facts are loaded. Suppressed rows remain outside
-- v_renderable_fact; consumers must query the view, never fact_fts alone, for card material.
INSERT INTO fact_fts(fact_fts) VALUES('rebuild');

