-- THE ARRIVAL ENGINE — storage schema (SQLite)
--
-- Graph SHAPE, relational STORE. No operation in eval/golden/*.json traverses more than one hop,
-- so query-time graph traversal is never needed. Inner-circle expansion is an INGEST-time walk that
-- writes facts back onto the member; by render time everything is a point lookup.
--
-- The file IS the cache required by DEC-3 / R-049: ingestion writes it on the operator's machine,
-- the deployed app opens it read-only. That split becomes a file copy rather than architecture.

PRAGMA foreign_keys = ON;

-- ── Provenance of the ingestion run itself ────────────────────────────────────
-- Every row that enters the store names the run that produced it, so a re-scrape is diffable and
-- "what did the card say on Friday, and why" is answerable. Facts are APPEND-ONLY; nothing is
-- UPDATEd in place.
CREATE TABLE run (
  id            TEXT PRIMARY KEY,
  started_at    TEXT NOT NULL,
  finished_at   TEXT,
  execution_ctx TEXT NOT NULL CHECK (execution_ctx IN ('operator_machine','deployed_runtime')),
  notes         TEXT
);

-- ── People ────────────────────────────────────────────────────────────────────
-- is_member = 0 covers the inner circle (co-founders, colleagues, tagged associates). They exist so
-- their edges are traversable at ingest. They are NEVER scored and NEVER surfaced (R-055).
CREATE TABLE person (
  id                  TEXT PRIMARY KEY,
  is_member           INTEGER NOT NULL CHECK (is_member IN (0,1)),
  display_name        TEXT NOT NULL,
  name_respelling     TEXT,            -- P-1: "[EL-suh]", NPR convention, NULL when obvious
  seniority_tier      TEXT REFERENCES seniority_tier(slug),
  career_start_decade TEXT,            -- '1980s' … '2010s'
  prominence_tier     INTEGER CHECK (prominence_tier BETWEEN 1 AND 4),
  prominence_basis    TEXT,            -- the measured figure the tier was derived from. See vocabulary.sql.
  -- PRD R-022/R-022b: the measured intents for the evening, I1..I8, or NULL, which the engine
  -- reads as I0 (unknown — coverage incomplete, never read as I8). A member may hold TWO; a
  -- third is treated as none, so there is no third column. Each needs the R-022b evidence bar:
  -- two corroborating dated items inside the rolling 180-day window.
  intent              TEXT CHECK (intent IN ('I1','I2','I3','I4','I5','I6','I7','I8')),
  intent_secondary    TEXT CHECK (intent_secondary IN
                                  ('I1','I2','I3','I4','I5','I6','I7','I8')),
  intent_basis        TEXT,            -- the evidence the intents were read from. Never assumed.
  created_run         TEXT NOT NULL REFERENCES run(id)
);

-- P-3: the opt-out. Honoured at SCORING time, not render time, so no digest is ever built and then
-- discarded, and the member also disappears from OTHER members' Room blocks.
CREATE TABLE member_flags (
  person_id    TEXT PRIMARY KEY REFERENCES person(id) ON DELETE CASCADE,
  do_not_brief INTEGER NOT NULL DEFAULT 0 CHECK (do_not_brief IN (0,1)),
  -- K-11: applies to ANY person row, member or not. A non-member partner reached by traversal has
  -- no way to ask for this, so it is operator-set — but the mechanism exists rather than the rule
  -- living only in prose. Honoured at INGEST time by v_traversable_person.
  do_not_traverse INTEGER NOT NULL DEFAULT 0 CHECK (do_not_traverse IN (0,1)),
  set_at       TEXT NOT NULL,
  set_by       TEXT
);

-- ── Facts ─────────────────────────────────────────────────────────────────────
-- provenance_class = who published it.  trust_class = who could have WRITTEN it (P-5/R-026).
-- The two are independent: a fact can be public, sourced, and still authored by a stranger.
CREATE TABLE fact (
  id               TEXT PRIMARY KEY,
  subject_id       TEXT NOT NULL REFERENCES person(id),
  text             TEXT NOT NULL,
  provenance_class TEXT NOT NULL CHECK (provenance_class IN
                     ('self_published','on_record','third_party','inferred')),
  trust_class      TEXT NOT NULL CHECK (trust_class IN
                     ('subject_authored','publisher','third_party_open')),
  source_url       TEXT,              -- NULL is legal in the store, but see v_renderable_fact
  source_host      TEXT,
  source_date      TEXT,
  observed_at      TEXT NOT NULL,
  composed_from    TEXT,              -- JSON array of fact ids; required when provenance='inferred'
  search_first_page INTEGER DEFAULT 0 CHECK (search_first_page IN (0,1)),
  via_edge_type    TEXT,              -- DEC-12: the edge traversed to reach this fact, when any.
                                      -- 'family_or_partner' is the one that matters: it does not
                                      -- gate rendering, but it makes the class countable, visible
                                      -- in Why-this-score, and reversible by policy without a
                                      -- re-ingest. NULL = reached directly from the subject.
  via_person_id    TEXT REFERENCES person(id),   -- whose source it came through, when traversed
  superseded_by    TEXT REFERENCES fact(id),   -- append-only: correct by superseding, never by UPDATE
  run_id           TEXT NOT NULL REFERENCES run(id)
);
CREATE INDEX fact_subject ON fact(subject_id, source_date DESC);
CREATE INDEX fact_live    ON fact(subject_id) WHERE superseded_by IS NULL;

-- The render gate as a view, so B-007/B-008/R-025/R-026 are enforced by the store rather than by care.
CREATE VIEW v_renderable_fact AS
  SELECT * FROM fact
   WHERE superseded_by IS NULL
     AND source_url IS NOT NULL                                    -- B-007 / G-034
     AND NOT (provenance_class = 'inferred'
              AND (composed_from IS NULL OR json_array_length(composed_from) = 0))  -- B-008 / G-034
     AND trust_class <> 'third_party_open';                        -- P-5 / R-026

-- Full-text over fact bodies. This is the deep-cut mining surface.
CREATE VIRTUAL TABLE fact_fts USING fts5(text, content='fact', content_rowid='rowid');

-- ── Controlled vocabulary (P0-6) ──────────────────────────────────────────────
CREATE TABLE seniority_tier (slug TEXT PRIMARY KEY, rank INTEGER NOT NULL, label TEXT NOT NULL);
CREATE TABLE industry       (slug TEXT PRIMARY KEY, label TEXT NOT NULL);

-- discriminating = 0 is the P0-1 fix. Genericity is a property of the TAG, measured once from the
-- member base, room-independent. It is NOT a room statistic — that version was non-monotonic,
-- room-size-inverted, and failed on its own justifying case (5 of 10 is exactly 50%).
CREATE TABLE topic (
  slug            TEXT PRIMARY KEY,
  kind            TEXT NOT NULL CHECK (kind IN ('professional','personal')),
  label           TEXT NOT NULL,
  discriminating  INTEGER NOT NULL CHECK (discriminating IN (0,1)),
  holder_count    INTEGER,      -- measured over the member base
  base_size       INTEGER,      -- the denominator, so the flag is recomputable and auditable
  basis           TEXT
);
CREATE TABLE topic_alias (alias TEXT PRIMARY KEY, canonical TEXT NOT NULL REFERENCES topic(slug));

CREATE TABLE person_topic (
  person_id        TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  topic_slug       TEXT NOT NULL REFERENCES topic(slug),
  evidence_fact_id TEXT REFERENCES fact(id),
  PRIMARY KEY (person_id, topic_slug)
);
CREATE TABLE person_industry (
  person_id     TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  industry_slug TEXT NOT NULL REFERENCES industry(slug),
  PRIMARY KEY (person_id, industry_slug)
);

-- S4. A caption is a CLAIM, not a geotag (AUD-07-6): "In Venice this week" is ambiguous between
-- Venice CA and Venice Italy and the same profile supports both. resolved=0 means do not match on it.
CREATE TABLE context (
  person_id        TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  type             TEXT NOT NULL CHECK (type IN ('place','institution','life_event','pursuit')),
  value            TEXT NOT NULL,
  resolved         INTEGER NOT NULL DEFAULT 1 CHECK (resolved IN (0,1)),
  evidence_fact_id TEXT REFERENCES fact(id),
  PRIMARY KEY (person_id, type, value)
);

-- ── Edges ─────────────────────────────────────────────────────────────────────
-- Directed. 'no_edge_confirmed' records a MEASURED ABSENCE so topical similarity can never be
-- dressed up as a relationship (R-019). An absence is only assertable if the corpus was searched —
-- see source_status.
CREATE TABLE edge (
  from_id          TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  to_id            TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  type             TEXT NOT NULL CHECK (type IN (
                     'follows','cited_in_own_writing','co_mention','repost',
                     'co_investment','board_together','employer_history','shared_org',
                     'family_or_partner','co_appearance','no_edge_confirmed')),
  evidence_fact_id TEXT REFERENCES fact(id),
  observed_at      TEXT,
  strength         TEXT CHECK (strength IN ('STRONG','MEDIUM','WEAK')),
  run_id           TEXT NOT NULL REFERENCES run(id),
  PRIMARY KEY (from_id, to_id, type)
);
CREATE INDEX edge_out ON edge(from_id, type);

-- K-5: an absence is only assertable if the corpus was actually searched. Recording
-- `no_edge_confirmed` with no evidence naming the corpus is the exact error the audit caught, so the
-- engine reads absences through this view and never off the base table.
CREATE VIEW v_assertable_absence AS
  SELECT * FROM edge
   WHERE type = 'no_edge_confirmed' AND evidence_fact_id IS NOT NULL;

-- K-11: who the ingest walk may step through.
CREATE VIEW v_traversable_person AS
  SELECT p.* FROM person p
    LEFT JOIN member_flags f ON f.person_id = p.id
   WHERE COALESCE(f.do_not_traverse, 0) = 0;

-- ── Source attempts ───────────────────────────────────────────────────────────
-- P-4. This table is what makes "quiet" distinguishable from "unknown". You cannot answer
-- "did we look?" unless you wrote down what you attempted. Without it, "Eric Ries is dormant" and
-- "archive.org returned 503" are the same row — which is exactly the error the audit caught.
CREATE TABLE source_status (
  person_id  TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  source_id  TEXT NOT NULL,
  tier       TEXT NOT NULL CHECK (tier IN ('GREEN','METERED','SESSION')),
  status     TEXT NOT NULL CHECK (status IN ('ok','unavailable','skipped')),
  reason     TEXT,
  http_code  INTEGER,
  fact_count INTEGER NOT NULL DEFAULT 0,
  checked_at TEXT NOT NULL,
  run_id     TEXT NOT NULL REFERENCES run(id),
  PRIMARY KEY (person_id, source_id, run_id)
);

-- A profile is only 'quiet' if EVERY source was reached. One unreachable source makes it 'unknown'.
-- Unreachability is contagious: absence of evidence from a source you could not read is not
-- evidence of absence.
CREATE VIEW v_recency_state AS
  SELECT s.person_id,
         CASE WHEN SUM(s.status <> 'ok') > 0 THEN 'unknown' ELSE 'reached' END AS coverage,
         SUM(s.status <> 'ok')                                                AS unreached_sources
    FROM source_status s
   GROUP BY s.person_id;

-- ── Presence ──────────────────────────────────────────────────────────────────
CREATE TABLE roster (
  person_id   TEXT NOT NULL REFERENCES person(id),
  arrived_at  TEXT NOT NULL,
  departed_at TEXT,
  PRIMARY KEY (person_id, arrived_at)
);
CREATE VIEW v_present AS
  SELECT r.person_id FROM roster r
    LEFT JOIN member_flags f ON f.person_id = r.person_id
   WHERE r.departed_at IS NULL
     AND COALESCE(f.do_not_brief, 0) = 0;      -- P-3: opt-out removes you from OTHERS' rooms too

-- ── Emitted cards, kept ───────────────────────────────────────────────────────
-- Not an audit-trail nicety: if a member ever asks what was said about them, this is the answer.
CREATE TABLE card (
  id             TEXT PRIMARY KEY,
  subject_id     TEXT NOT NULL REFERENCES person(id),
  rendered_at    TEXT NOT NULL,
  word_count     INTEGER NOT NULL,
  gates_passed   INTEGER NOT NULL CHECK (gates_passed IN (0,1)),
  gate_failures  TEXT,   -- JSON
  body           TEXT,
  fact_ids       TEXT,   -- JSON array: exactly which facts were rendered
  run_id         TEXT NOT NULL REFERENCES run(id)
);

-- PRD R-060 (2026-09-04 re-baseline): the card closes the loop. Append-only, one row per logged
-- observation, keyed to the introduction it grades — the only proof an introduction worked is
-- what happened next.
CREATE TABLE outcome (
  id             TEXT PRIMARY KEY,
  subject_id     TEXT NOT NULL REFERENCES person(id),     -- the arriving member
  matched_id     TEXT REFERENCES person(id),              -- who the card named, if anyone
  -- R-060: a log needs the observation OR a tag; either alone is worth keeping.
  outcome        TEXT CHECK (outcome IN
                   ('never_introduced','brief_hello','talked_a_while',
                    'together_all_night','swapped_details')),
  observation    TEXT,                                    -- the host's own words
  logged_at      TEXT NOT NULL,
  run_id         TEXT NOT NULL REFERENCES run(id),
  CHECK (outcome IS NOT NULL OR observation IS NOT NULL)
);

-- ── Deletion (P-3 / R-032) ────────────────────────────────────────────────────
-- ON DELETE CASCADE above makes `DELETE FROM person WHERE id=?` a real purge: facts, topics,
-- contexts, edges, source attempts and flags all go. Explicitly the opposite of OpenTable's
-- "no way for a restaurant to permanently delete a guest", where hidden profiles auto-reinstate
-- with notes intact.

-- ═══════════════════════════════════════════════════════════════════════════════
-- IDENTITY — the targeting layer (closes P0-8 and P1-11)
--
-- The engine's core invariant is "never assert what you merely failed to observe".
-- Its ingest-side twin is "never collect from a source you have not confirmed is the subject".
-- These four tables are that mechanism. Seeded by db/roster.sql; contract in docs/ingest-spec.md.
-- ═══════════════════════════════════════════════════════════════════════════════

-- What counts as corroboration (R-012). G-016 passes an opaque list; this enumerates it.
-- STRONG: the source itself names the subject, or a filing/registry binds handle to legal person.
-- WEAK:   consistent-but-forgeable signal (a bio backlink, a matching display name).
-- Rule (R-012): accept an account on >=1 STRONG, or >=2 WEAK from DIFFERENT sources. Never on
-- handle equality alone — `spez` on Reddit is Huffman, `@spez` on X is a stranger (G-016).
CREATE TABLE corroboration_kind (
  slug     TEXT PRIMARY KEY,
  strength TEXT NOT NULL CHECK (strength IN ('STRONG','WEAK')),
  label    TEXT NOT NULL,
  basis    TEXT NOT NULL
);

-- The allow-list. An adapter may fetch a (person, source) pair ONLY if a row exists here.
-- There is no discovery-by-guessing path: `eshear.com` returns 200 on every path it is asked for,
-- so "the URL resolved" is not evidence of anything (AUD-03-1.5).
CREATE TABLE person_identity (
  person_id     TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
  source_id     TEXT NOT NULL,          -- matches source_status.source_id
  url           TEXT NOT NULL,
  handle        TEXT,
  role          TEXT NOT NULL CHECK (role IN
                  ('canonical','feed','api','archive','dead','firm','negative_probe')),
  tier          TEXT NOT NULL CHECK (tier IN ('GREEN','METERED','SESSION')),
  corroboration TEXT NOT NULL,          -- JSON array of corroboration_kind.slug
  http_status   INTEGER,
  measured_at   TEXT NOT NULL,
  notes         TEXT,
  PRIMARY KEY (person_id, source_id, url)
);

-- The deny-list, and the more important of the two. Every row is a MEASURED collision: a URL or
-- handle that a naive name- or handle-based lookup will reach, that is not the member.
-- An adapter that is about to fetch a URL matching one of these must refuse, not down-weight.
CREATE TABLE person_identity_negative (
  person_id  TEXT REFERENCES person(id) ON DELETE CASCADE,  -- who it would be mis-attributed TO
  value      TEXT NOT NULL,             -- the URL, handle or domain that collides
  kind       TEXT NOT NULL CHECK (kind IN ('url','handle','domain','wikipedia_title')),
  belongs_to TEXT,                      -- who it actually is, where measured. NULL = unknown, still refuse.
  basis      TEXT NOT NULL,             -- the audit line that measured it
  measured_at TEXT NOT NULL,
  PRIMARY KEY (value, kind)
);

-- R-014 / R-015. The webhook's label is a hint to verify, never a fact to echo.
-- `supplied` is what the door says; `current` is what was measured. stale = they differ.
CREATE TABLE member_label (
  person_id      TEXT PRIMARY KEY REFERENCES person(id) ON DELETE CASCADE,
  supplied_label TEXT NOT NULL,
  current_label  TEXT NOT NULL,
  stale          INTEGER NOT NULL CHECK (stale IN (0,1)),
  basis          TEXT NOT NULL,
  measured_at    TEXT NOT NULL
);

-- An account is only collectable if it is allow-listed AND not deny-listed. Belt and braces:
-- the deny-list is checked by value across ALL members, because the failure mode is cross-attribution.
CREATE VIEW v_collectable_source AS
  SELECT i.* FROM person_identity i
   WHERE i.role <> 'negative_probe'
     AND NOT EXISTS (SELECT 1 FROM person_identity_negative n
                      WHERE n.value = i.url OR n.value = i.handle);
