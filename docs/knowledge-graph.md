# Knowledge graph — schema

One graph per member, merged into one store. Social is a first-class source tier, not an add-on.
Every node and edge carries provenance from birth; nothing enters without a source.

## Node types

### Person
`id, display_name, seniority_tier, career_start_decade, prominence_tier, industries[],
 topics_professional[], topics_personal[], contexts[], is_member(bool)`
`is_member=false` covers the inner circle — co-founders, colleagues, tagged associates. They are
graph nodes so their edges are traversable, but they are **never scored and never surfaced**.

### Org
`id, name, kind(company|fund|nonprofit|gov), industries[]`

### Fact
`id, subject_id, text, provenance_class(self_published|on_record|third_party|inferred),
 source_url, source_host, source_date, composed_from[], search_first_page(bool)`
The provenance fields are required. A fact without `source_url` cannot render (B-007 / G-034).
An `inferred` fact without `composed_from` cannot render (B-008 / G-034).

### Topic
Controlled vocabulary slug, shared across people so overlaps are computable.
`venture-capital-craft`, `ai-alignment`, `startup-communities`, `endurance-running`, ...
AUD-EDGES measured `venture-capital-craft` on 5 of the 10 — hence the genericity gate.

### Context
`type(place|institution|life_event|pursuit), value` — the non-professional overlap S4 reads.

## Edge types (directed)

| type | source tier | feeds |
|---|---|---|
| `follows` | SESSION (X follow list via a11y tree) | **S5** |
| `cited_in_own_writing` | GREEN (blog RSS full text, HN) | **S5** |
| `co_mention` | SESSION (LinkedIn "cc: A, B, C") | **S5**, inner circle |
| `repost` | SESSION (LinkedIn/X reposts) | **S5**, inner circle |
| `co_investment` / `board_together` | GREEN (SEC Form D related persons) | S2, S3 |
| `employer_history`, `shared_org` | GREEN + SESSION | S1, S2 |
| `family_or_partner` | SESSION | inner-circle traversal ONLY — never scored, never on a card |
| `co_appearance` | GREEN (podcast RSS, event pages) | S3, S7 |
| `no_edge_confirmed` | audit | suppresses invented connections |

`no_edge_confirmed` is deliberate. AUD-EDGES measured real absences (feld.com's 5,551 posts contain
**zero** occurrences of Tavel, Huffman, Shear, Qureshi or Perkins). Recording an absence stops the
engine dressing topical similarity up as a relationship.

## Source tiers feeding the graph

| tier | sources | runs where |
|---|---|---|
| **GREEN** | blog RSS full-text, HN Algolia, SEC EDGAR, Wikipedia, Wayback, YouTube transcripts, podcast RSS, Open Library | anywhere, incl. the deployed URL |
| **METERED** | X API (now largely superseded by SESSION) | anywhere, costs money |
| **SESSION** | **LinkedIn, X, Instagram, Facebook, TikTok** — read-only, operator's browser | ingestion only, never deployed |

## Two rules that keep the social layer safe to ship

1. **Personalization stripped at the boundary** (DEC-7, B-019 / G-029). The logged-in view is
   personalised — "Followed by Alexandr Wang and Sam Altman", "3rd degree", "5 others you know" are
   facts about the *operator*, not the member. Whitelist member-owned fields; drop everything else.
2. **Wide collection, narrow disclosure.** The graph holds the inner circle so it can be traversed.
   The *card* renders only facts about the member, each with a visible source. A family edge can
   inform a match; it never appears as a sentence a host reads out loud.


---

# Storage

**Graph shape, relational store.** `db/schema.sql` (SQLite), seeded by `db/vocabulary.sql`.
Both validated: they apply cleanly to an empty database.

## Why not a graph database

No operation in `eval/golden/*.json` traverses more than one hop. `resolve_identity`,
`run_ingestion`, `rank_room`, `select_renderable_facts`, `build_now_block` and `render_card` between
them read A->B directly (does A follow B, did A cite B) and never further. There is no
friend-of-a-friend, no path finding, no variable-length traversal, no centrality.

Inner-circle expansion *looks* like traversal but is not: scraping a co-founder's feed to learn
something about the member is an **ingest-time** walk that writes facts back onto the member. By
render time everything is a point lookup. So — **graph shape at ingest, flat lookups at serve time.**

A graph database earns its keep on query-time traversal you cannot predict in advance. This system
has none, `rank_room` is at most ~50 point lookups plus an edge check, and the brief rules out
"infrastructure theatre" outright.

**The file IS the cache** that DEC-3 and R-049 require: ingestion writes it on the operator's
machine, the deployed app opens it read-only. That split stops being architecture and becomes a
file copy — which is also why a live demo cannot fail on a network call.

## Tables that carry a requirement rather than data

| Object | What it enforces |
|---|---|
| `topic.discriminating` | **P0-1.** Genericity is a property of the tag, measured once over the member base, room-independent. Replaces the room statistic that was non-monotonic, room-size-inverted, and failed on its own justifying case (5 of 10 is exactly 50%). `holder_count` / `base_size` are stored so the flag is recomputable, not trusted. |
| `source_status` | **P-4.** The only way to distinguish *"we looked and there was nothing"* from *"we could not look"*. Without this table, "Eric Ries is dormant" and "archive.org returned 503" are the same row — the exact error the audit caught. |
| `v_recency_state` | Makes unreachability **contagious**: one unreached source downgrades a profile to `unknown`. Absence of evidence from a source you could not read is not evidence of absence. |
| `v_renderable_fact` | Enforces B-007 (no source, no render), B-008 (inferred facts name their inputs) and R-026 (`third_party_open` never renders); the mixed contract is G-034. Enforcement lives in the **store**, not in application care. |
| `fact.trust_class` | **P-5.** Independent of `provenance_class`: a fact can be public, sourced, and still authored by a stranger. The Instagram tagged tab is the measured case. |
| `edge` type `no_edge_confirmed` | **R-019.** Records measured *absence*, so topical similarity can never be dressed up as a relationship. |
| `member_flags.do_not_brief` + `v_present` | **P-3.** The opt-out removes the member from *other* members' rooms too. Honoured at scoring time, so no digest is built and then discarded. |
| `ON DELETE CASCADE` throughout | **R-032.** `DELETE FROM person` is a real purge. Explicitly the opposite of OpenTable, where a hidden profile auto-reinstates with its notes intact. |
| `card` | If a member ever asks what was said about them, this answers it — with the exact fact ids that rendered. |
| `person.name_respelling` | **P-1.** NPR pronouncer convention, `[EL-suh]`, NULL when the name is obvious. |

## Two rules that are not negotiable

**Facts are append-only.** Never `UPDATE` a fact; insert a superseding one and set `superseded_by`.
Provenance requires it, and it is what makes *"what did the card say on Friday, and why"* answerable.

**Every row names its `run_id`.** Ingestion becomes reproducible and diffable. A re-scrape that
changes a member's recency state is then visible as a diff — which is how the Perkins staleness
error would have been caught automatically instead of by a human noticing.

## What is NOT stored

Images. Per DEC-8, only the derived structured observation is kept, with the post permalink as
provenance. No member photographs enter the store. Signed CDN URLs are never persisted either —
they are short-lived and carry session-derived tokens (AUD-07-11).

## When a graph database would be right

If Arena Hall later wants **introduction chains** (A should meet B, who should meet C) or community
detection across thousands of members, that is real traversal and worth the infrastructure.

Note that it is also exactly AUD-LINE-5 — *composition is the danger, not collection*. Multi-hop
inference about people is the Uber "Rides of Glory" shape: two boring facts joined into an intimate
one. That should be a deliberate product decision with the taste argument made explicitly, never
something drifted into because the database made it cheap.
