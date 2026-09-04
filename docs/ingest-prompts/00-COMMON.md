# Common contract — read before any per-member prompt

Collect public data on one member and write it into the local SQLite graph at `db/`.
Also read: `docs/ingest-spec.md` (fetch contract), `db/roster.sql` (cast, allow-list, deny-list),
`db/schema.sql` (what you write into).

## Rules

1. **Never assert what you failed to observe.** "Looked, found nothing" (`quiet`) and "couldn't
   look" (`unknown`) are different rows. One unreachable source makes the whole profile `unknown`.
2. **A 200 is not identity confirmation.** Nor is valid XML, a matching name, or a matching handle.
3. **Read-only. No write op against any account, ever** — no post, reply, like, repost, follow,
   connect, message, subscribe, save, block, report, profile edit, mark-as-read, or consent-dialog
   click. If a page won't render without one, that source is `unavailable`.
4. **No credentials, no account creation, no captcha solving, no paying.**
5. **Never fetch anything in `person_identity_negative`.** If you find a *new* collision, add a row.
6. **Corroboration before collection:** ≥1 STRONG (`named_in_sec_filing`, `api_name_field_matches`,
   `linked_from_own_canonical`, `subject_self_identifies`) **or** ≥2 WEAK
   (`bio_backlink_to_canonical`, `display_name_matches`, `handle_matches`) from different sources.
   Never handle-match alone. A deceased candidate is never auto-resolved.

## Auth failures — expected, never swallowed

On any wall (999, login redirect, captcha, challenge, expired session):

1. **Do not authenticate.** That is the user's to do.
2. Write a `source_status` row: `status='unavailable'`, real `http_code`, precise `reason`.
3. **Surface it immediately** — append to `ingest/BLOCKERS.md` and print:
   `AUTH BLOCKED — <person>/<source> · <url> · HTTP <code>, <what the page said> · need: <what the
   user must do> · impact: <signals lost>`
4. Work around it: Wayback via curl, a full-text feed mirror, a public API, a headless browser for a
   JS-only page. Never substitute another person's source or fill from a snippet.
5. **Never report success with a blocker outstanding.** Put `BLOCKED: n auth errors` in `run.notes`,
   reprint the list, name which members are partial, exit non-zero.

## Scope

The allow-list is where you start, not stop. The open web is in scope — the deep cut is never on the
allow-list. Three anchors: every fact traces to a URL you fetched with a quote you read; only the
ten are `is_member=1`; **the walk is exactly one hop** (anyone reached enters `is_member=0`, never
scored, never surfaced).

Budget per source: newest-first, stop at 200 items or 2016-01-01. Large archives are mined by
**targeted search**, not walked. A source that 429s twice is `unavailable` for the run.

UA: `ArenaHall/1.0 (kellyqhe47@gmail.com)` — `data.sec.gov` 403s without it. Have a GitHub PAT
(unauth is 10/hr search). Autodiscover feeds from `<link rel="alternate">`. On SESSION sources use
the **accessibility tree** — text extraction returns empty and looks like "no data".

## Write

Open one `run` row; stamp everything with `run_id`.

- **`source_status`** — one row per *attempt*, with `http_code` and `fact_count`. A 200 with zero
  items is not silence.
- **`fact`** — append-only, never UPDATE. Needs `source_url`, `source_host`, `source_date`,
  `observed_at`, `provenance_class` (who published), `trust_class` (who could have *written* it —
  independent), `run_id`. `inferred` must fill `composed_from`. Set `search_first_page` honestly.
- **`third_party_open`** (tagged tabs, comments, other people's images) — traversal hint only. Never
  attributed without corroboration, never rendered, never put in a model prompt as fact.
- **`edge`** — directed, typed, with evidence. `no_edge_confirmed` only where you actually searched;
  name the corpus.
- **`context`** — a caption is a claim, not a geotag. Ambiguous places get `resolved=0`.
- **Family/partner sources** (DEC-12) — a partner's public writing is a legitimate source of facts
  about the member and **renders without needing corroboration**; tag those facts
  `via_edge_type='family_or_partner'` and `via_person_id`. The edge itself never scores and is never
  named on a card. **But the partner doing something is not observation that the member did it** —
  that step is `provenance_class='inferred'` and must name `composed_from`. "We were in Venice" is
  observation; "he was in Venice" from a post that says only "I" is an inference.
- **Backfill** `person_topic.evidence_fact_id` (all NULL now) and `person.career_start_decade`
  (S1 can't fire without it). `name_respelling` only if you can source a recording; else leave NULL.

**Strip personalization at the boundary.** Extract only: bio, headline, location, company, follower
*counts*, post bodies and dates, in-post tag lines, following-list handles, captions, location tags.
Never: "Followed by X", "N others you know", degree-of-connection, suggestion rails, the operator's
own account, notification counts, signed CDN URLs.

**Images:** scene, object, venue, text-in-image only. **No face recognition or inference from a
face, ever.** An image fact must corroborate a textual one.

## Output — keep it short

Write `ingest/reports/<person_id>.md`, **one page max**:

```
Status:     complete | partial (n blockers)
Sources:    n ok, n unavailable
Written:    n facts, n edges, n contexts
Recency:    active | quiet | unknown — <one-line reason>
Deep cuts:  <one line each, with URL>
New denies: <one line each, or none>
Not established: <bullets — the most valuable part>
Blockers:   <bullets, or none>
```

No narrative, no restating this contract. The database is the deliverable; the report is the
exception list.
