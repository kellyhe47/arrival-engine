# Schema change requests

`db/` is frozen while ingest agents are collecting (see `IMPLEMENTATION-PROMPT.md` §1). Nobody
building the application edits it directly, because the schema is the contract between the builder
and the collectors and changing it under them breaks both sides at once.

**Propose here instead.** Apply the change to your own scratch database so you are not blocked, and
a human merges it into `db/` when ingest is quiet.

One entry per request:

```
## <short title>
Requested by: <agent / session>   Date: <ISO>
Status: proposed | merged | rejected

DDL:
    <the exact statement you want>

Why: <what breaks or cannot be built without it>
Workaround in use: <what your scratch DB does meanwhile, or "none">
Affects ingest: <yes/no — does a collecting agent have to change what it writes?>
```

---

## `fact.recorded_at` + `fact.is_rerun` — so a rerun can be dated by its recording
Requested by: arrival-engine build session (application, not ingest)   Date: 2026-09-03
Status: proposed

DDL:

    ALTER TABLE fact ADD COLUMN recorded_at TEXT;
    ALTER TABLE fact ADD COLUMN is_rerun    INTEGER NOT NULL DEFAULT 0
                                            CHECK (is_rerun IN (0,1));

Why: R-040 and G-014 require that "Tavel's Aug-2026 podcast is a **rerun** of an Apr-2025 recording
and must be dated by recording." `fact` carries `source_date` (when the source published it) and
`observed_at` (when we read it), and neither is the date the thing happened. With only those two
columns the store cannot represent the difference between a fresh episode and a republished one, so
the Now block has no way to demote a rerun and the engine reports a sixteen-month-old conversation
as current — the exact failure G-014 exists to catch. Putting the distinction in application code
instead would mean the rule survives only as long as whoever wrote that code; putting it in the
store makes it a property of the fact, diffable across runs like everything else.

Workaround in use: applied to the scratch/serving store only, by `scripts/build_store.py`
(`_apply_schema_requests`), which is a no-op once the columns exist upstream. `arena/store.items()`
degrades to `recorded_at = NULL, is_rerun = 0` when the columns are absent, so nothing crashes
against an un-migrated file — it simply cannot demote a rerun.

Affects ingest: yes, but additively and optionally. Collectors may keep writing exactly what they
write today; the columns default correctly. A collector that knows an item is a republication
should set both.

## `fact.suppression_class` — so restraint is recorded rather than remembered
Requested by: arrival-engine build session (application, not ingest)   Date: 2026-09-03
Status: proposed

DDL:

    ALTER TABLE fact ADD COLUMN suppression_class TEXT;
    --  NULL      = not suppressed
    --  otherwise = the class shown by the suppression counter, e.g. 'finance_personal',
    --              'family_private', 'health', 'legal'
    DROP VIEW v_renderable_fact;
    CREATE VIEW v_renderable_fact AS
      SELECT * FROM fact
       WHERE superseded_by IS NULL
         AND source_url IS NOT NULL
         AND NOT (provenance_class = 'inferred'
                  AND (composed_from IS NULL OR json_array_length(composed_from) = 0))
         AND trust_class <> 'third_party_open'
         AND suppression_class IS NULL;

Why: R-028 requires the card to show withheld facts as **class and count only**, and R-029 names
the worked example — Huffman's SEC Form 4 share sales are public, filed, verified and suppressed.
`v_renderable_fact` can express "this fact is not renderable because it has no source"; it cannot
express "this fact is perfectly renderable and we chose not to". Those are different facts about
the fact, and only the second one can be counted honestly. Without a column, the suppression
counter has to be recomputed from a rule that lives in code, which means the card can claim
"2 withheld" on Friday and "1 withheld" on Monday with no row anywhere having changed — the
opposite of what R-051's append-only provenance is for. G-022 already hands the runner a
`suppressed_facts` list with a `class` on each; this is the column that list would be read from.

Workaround in use: the column is applied to the scratch/serving store by `scripts/build_store.py`.
The Huffman ingest also recreates `v_renderable_fact` in its isolated scratch DB with the exclusion
shown above, so its Form 4 row is countable but not renderable. The application classifier must
carry the same predicate when this request is merged; otherwise it could diverge from the view.
`arena/store.suppressed_facts()` catches the missing column and returns an empty list, so an
un-migrated file yields a card with no suppression line rather than a crash — which understates
restraint but never overstates it.

Affects ingest: additively. Nullable, defaults to NULL, and ordinary collectors do not have to set
it. A collector explicitly tasked with a suppression case may set the class at collection time;
the Huffman ingest does this for its SEC Form 4 row.

## `ON DELETE` actions on the four tables that block a purge — R-032 is not currently enforceable
Requested by: arrival-engine build session (application, not ingest)   Date: 2026-09-03
Status: proposed   **Severity: this one is a real defect, not an enhancement**

DDL (SQLite cannot ALTER a foreign-key action, so these are DDL-text changes to the CREATE TABLE
statements — see `patched_schema()` in `scripts/build_store.py` for the exact six replacements):

    -- fact
      subject_id       TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
      via_person_id    TEXT          REFERENCES person(id) ON DELETE SET NULL,
      superseded_by    TEXT          REFERENCES fact(id)   ON DELETE SET NULL,
    -- person_topic, context, edge
      evidence_fact_id TEXT          REFERENCES fact(id)   ON DELETE SET NULL,
    -- roster
      person_id        TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
    -- card
      subject_id       TEXT NOT NULL REFERENCES person(id) ON DELETE CASCADE,

Why: `db/schema.sql`'s own closing comment states that `ON DELETE CASCADE` makes
`DELETE FROM person WHERE id=?` "a real purge: facts, topics, contexts, edges, source attempts and
flags all go", and R-032 requires exactly that — "Deletion is a real purge, not a hidden flag that
reinstates." **It is not one today.** `fact.subject_id` — the largest table, and the only one whose
contents are the dossier — references `person(id)` with no `ON DELETE` action, so with
`PRAGMA foreign_keys = ON` the delete raises `FOREIGN KEY constraint failed` and *nothing at all* is
removed. `roster.person_id` and `card.subject_id` block it the same way. Nine of the child tables
cascade correctly; these four do not, and they are the ones that matter. Measured directly:
`tests/test_engine.py::test_deleting_a_person_cascades` failed against the unpatched schema with
that exact error, and passes against the patched one.

Two of the six are `SET NULL` rather than `CASCADE`, deliberately. Purging a non-member partner
must not delete a *member's* facts — it must sever the traversal pointer (`via_person_id`) and leave
the fact and its own provenance intact. Likewise a supersession chain: dropping the newer fact must
not silently drop the older one it replaced.

Workaround in use: `scripts/build_store.py` patches the six lines in `db/schema.sql`'s DDL **text**
before executing it into the scratch store, and asserts that every one of the six target lines was
found — so if the schema changes upstream, the build fails loudly instead of quietly skipping the
fix. `db/schema.sql` itself is never written.

Affects ingest: no. Foreign-key actions change only what happens on DELETE; no collector writes a
DELETE, and every INSERT is unaffected.

## `fact.quote` — so the borrowed line in Who is actually borrowed
Requested by: arrival-engine build session (application, not ingest)   Date: 2026-09-03
Status: proposed

DDL:

    ALTER TABLE fact ADD COLUMN quote TEXT;
    --  NULL     = this fact records no verbatim first-person quotation
    --  otherwise = words the SUBJECT said, verbatim, at this fact's own source_url

Why: R-034 requires the Who block to carry "name + one **borrowed attributed line**", and DEC-2
sources that to the White House palm card — a borrowed superlative with its source attached. A
fact's `text` is a description written by the extractor; it is not the member speaking. Nothing in
the schema distinguishes the two, so the only way to produce a borrowed line without this column is
to lift a quoted span out of the fact body — **and that is measurably wrong.** It was built that
way first, and against real ingest output it put this on Fred Wilson's card, under the heading *in
their own words*:

> “Father. Husband. VC. INTJ. Dad Joke Lover. Partner @FirstRound.”

That is **Josh Kopelman's** X bio, quoted correctly inside a fact whose subject is Wilson (`f_wil_045`,
"Wilson FOLLOWS Josh Kopelman on X … bio …"). The store was right, the extraction was right, and the
card still put one member's words in another member's mouth in the single place a host reads aloud
verbatim. It is R-004 exactly: asserting something never observed. A quoted span inside a fact body
carries no information about *who said it*, and no amount of care in the narrator can recover it.

Workaround in use: applied to the scratch/serving store only, by `scripts/build_store.py`. The
narrator borrows a line **only** from `fact.quote`, so on an un-migrated store no card carries a
borrowed line at all — Who degrades to name and label, which is the correct failure direction.
`seed/synthetic.sql` populates it for the four quotations this repository actually measures
(Feld "Give first."; Wilson's X bio "I am a VC"; Shear's og:description; Tavel's Adventurista line
on rugby). A fifth was drafted for Kopelman and deleted before it shipped: no source anywhere in
this repository records him saying it.

Affects ingest: yes, and it is the request most worth taking. A collector that has the subject's own
words should write them here verbatim rather than paraphrasing them into `text`. Nullable, so no
collector is blocked by it.

## `fact.item_published_at` — so "the trail is cold" can be said at all
Requested by: arrival-engine build session (application, not ingest)   Date: 2026-09-03
Status: proposed   **Severity: R-040's cold-trail state is unreachable without it**

DDL:

    ALTER TABLE fact ADD COLUMN item_published_at TEXT;
    --  NULL     = this fact describes a standing state (a profile page, a bio, a firm page).
    --             It carries no publication date and must never date the Now block.
    --  otherwise = the date the ITEM was published or the event happened, read off the item.

Why: `source_date` is documented as the date of the **source document**, and `observed_at` as when
we read it. For a live profile page those are the same day, correctly — so with real ingest output
the newest `source_date` in the store is today for nine of the ten members, and it is today because
somebody looked, not because anybody published. Three of Josh Kopelman's newest rows are literally
*"The current @joshk X profile describes him as…"*, dated 2026-09-03. His blog has been dead since
November 2014.

Building the Now block on the newest `source_date` therefore says *"the most recent first-person
item is 0 days old"* about a member whose most recent dated activity is an X post from 2026-08-27
and whose last blog post is twelve years old. That is R-004 in the other direction: asserting
freshness nobody observed, and it is the same class of error as "Eric Ries is dormant" — the
retrieval artifact, inverted. `ui-states.md`'s **cold trail** ("no first-person item inside 365
days") cannot fire against this data, because there is no column that says which facts are items.

`recorded_at` / `is_rerun` (requested above) are the related but narrower case — a republished
recording. This is the general one.

Workaround in use: none in the data, and deliberately so — the fix is in the WORDS, not in a
guess. The Now block now says *"the freshest thing **read** on them is dated D"*, which is literally
true of a profile read and of a blog post alike, and it makes no publication claim. The cold-trail
state stays implemented and fixture-covered (G-014), and becomes reachable the moment this column
is populated. No heuristic was invented to separate the two kinds of fact, because none of the
obvious ones work: `source_date < observed_at` passes every one of the Kopelman profile rows.

Affects ingest: yes — this is the one that changes what a collector writes. A collector reading a
dated item (a post, an episode, a filing, a release) sets it; a collector describing a profile
page leaves it NULL. Nullable, so nothing is blocked meanwhile.
