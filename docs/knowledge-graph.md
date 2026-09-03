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
The provenance fields are required. A fact without `source_url` cannot render (G-011).
An `inferred` fact without `composed_from` cannot render (G-012).

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

1. **Personalization stripped at the boundary** (DEC-7, G-029/G-030). The logged-in view is
   personalised — "Followed by Alexandr Wang and Sam Altman", "3rd degree", "5 others you know" are
   facts about the *operator*, not the member. Whitelist member-owned fields; drop everything else.
2. **Wide collection, narrow disclosure.** The graph holds the inner circle so it can be traversed.
   The *card* renders only facts about the member, each with a visible source. A family edge can
   inform a match; it never appears as a sentence a host reads out loud.
