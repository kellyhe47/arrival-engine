# Common contract — read before any per-member prompt

Collect public data on one member and write it into **your own** SQLite file under `db/`.
Also read: `docs/ingest-spec.md` (fetch contract), `db/roster.sql` (cast, allow-list, deny-list),
`db/schema.sql` (what you write into).

## You are one of ten agents running in parallel

The operator is running all ten member ingests **concurrently**, and merges them at the end.

> **Write to `db/arena.<person_id>.db`. Never write to `db/arena.db`.**

`db/arena.db` is the shared roster seed. Treat it as read-only: another agent may be reading it, and
a rebuild of it destroys whatever a third agent just wrote. Build your own file instead:

```bash
rm -f db/arena.<person_id>.db                                  # e.g. db/arena.m_tavel.db
for f in db/schema.sql db/vocabulary.sql db/roster.sql; do
  sqlite3 db/arena.<person_id>.db < "$f"
done
# ... then apply your own ingest SQL, then:
sqlite3 db/arena.<person_id>.db "INSERT INTO fact_fts(fact_fts) VALUES('rebuild');"
```

**Keep your writes as replayable `.sql` files** in `ingest/sql/<person_id>-NN-<what>.sql`, not just
as a binary that happened to come out right. The merge step re-applies those files against one
store; a `.db` nobody can regenerate is not mergeable. Add a
`ingest/sql/<person_id>-00-README.md` with the rebuild command and a list of every shared-table row
you touch.

**Rules that make the ten files mergeable:**

- **Namespace everything you create.** `run.id` = `run_ingest_<person>_<date>`; `fact.id` =
  `f_<person>_NNN`. Two agents minting `f_001` collide on a primary key at merge time.
- **`UPDATE` only rows that are yours** — your member's `person` row, your member's `person_topic`
  rows, your own `run` row. Never touch another member's row, and never re-baseline a
  `prominence_tier` or a `vocabulary.sql` count; if a figure has drifted, say so in your report and
  leave the row alone.
- **One-hop non-members are shared ground.** Several members orbit the same people. Write those rows
  as `INSERT OR IGNORE INTO person ...` with a stable `p_<firstname>_<lastname>` id, so two agents
  reaching the same person merge instead of colliding.
- **`ingest/BLOCKERS.md` is shared and append-only.** Append with `>>` under an `##` heading naming
  your run. `cat >` clobbers another agent's blockers.
- **`db/schema.sql` can change under you mid-run** — it is being edited while you work. If it does,
  rebuild your file from the current schema and re-apply your SQL. That is free if you kept the SQL.

Your report still goes to `ingest/reports/<person_id>.md`; that path is already per-person. State
which `.db` file you wrote at the top of it.

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

**Before you call anything blocked: there are TWO browsers.** The in-app browser pane
(`mcp__Claude_Browser__*`) is a fresh profile and is logged out of everything. The operator's real
Chrome (`mcp__claude-in-chrome__*`) carries their existing sessions. A SESSION source that walls the
first will often read cleanly in the second, and *that* is the sanctioned operator-machine path —
you are using a session the operator already established, not creating one. Measured this run:
`linkedin.com/in/fredwilson` is a Sign Up redirect in the in-app pane and a complete profile in
Chrome. Try Chrome before you write `unavailable`, and say which browser you used in `reason`.

Read-only still applies in Chrome, and harder: every write affordance is live and one click from
your cursor. No post, reply, like, follow, connect, message, or accept. Strip personalization at the
boundary — the logged-in view is full of facts about the *operator*, not the member. The
"More profiles for you" / "People also viewed" rails are recommendations, **not evidence of an
edge**; this run's rail for Wilson named two real USV partners and was still discarded.

On any wall (999, login redirect, captcha, challenge, expired session) that survives both browsers:

1. **Do not authenticate.** That is the user's to do.
2. Write a `source_status` row: `status='unavailable'`, real `http_code`, precise `reason`.
3. **Surface it immediately** — append to `ingest/BLOCKERS.md` and print:
   `AUTH BLOCKED — <person>/<source> · <url> · HTTP <code>, <what the page said> · need: <what the
   user must do> · impact: <signals lost>`
4. Work around it: Wayback via curl, a full-text feed mirror, a public API, a headless browser for a
   JS-only page. Never substitute another person's source or fill from a snippet.
5. **Never report success with a blocker outstanding.** Put `BLOCKED: n auth errors` in `run.notes`,
   reprint the list, name which members are partial, exit non-zero.

**Facebook and TikTok** are now SESSION sources too — attempt them through the operator's logged-in
browser like LinkedIn, X and Instagram, and record what you find. Neither has ever been measured
logged in, so treat any result as new evidence. The read-only rules and the no-captcha rule are
unchanged: if TikTok walls you, that is `unavailable` plus a blocker, not something to bypass.

## Scope

The allow-list is where you start, not stop. The open web is in scope — the deep cut is never on the
allow-list. Three anchors: every fact traces to a URL you fetched with a quote you read; only the
ten are `is_member=1`; **the walk is exactly one hop** (anyone reached enters `is_member=0`, never
scored, never surfaced).

Budget per source: newest-first, stop at 200 items or 2016-01-01. Large archives are mined by
**targeted search**, not walked. A source that 429s twice is `unavailable` for the run.

**ALWAYS walk the WHOLE following list — never just the first page.** It is the follow graph, and
a first-page read answers nothing: `@joshk` sits at position 20 of Wilson's list, so a 12-entry
sample would have "found nothing" and been wrong. Walk until the list is exhausted or the platform
stops serving, then record **how many of the claimed total you actually got** in
`source_status.reason`. Never write `no_edge_confirmed` off a partial walk (R-011).

Three measured traps, all of which make a partial walk look like a complete one:

1. **Programmatic scrolling does not drive X's loader.** `window.scrollTo` / `scrollBy` move the
   viewport, the virtualizer never fetches, and your collector reports "no new entries" at whatever
   was already in the DOM. Only **real wheel events** (the `computer` scroll action) page the list.
2. **A stalled virtualizer is fixed by a reload, not by more scrolling.** Wilson's list stalled at
   42; reloading and re-walking reached 69, with the first 42 a strict subset. Two passes with a
   merge is the reliable pattern.
3. **The "Who to follow" rail uses the SAME `data-testid="UserCell"` markup as the list.** Scope
   every selector to `[data-testid="primaryColumn"]` or you will silently write the operator's
   personalized recommendations into the member's follow graph.

And the platform may simply cap you: X served **69 of Wilson's 1,345** and then stopped — no
spinner, no error, no 429, a page that looks finished. That is a silent ceiling, not the end of the
list, and it must be recorded as a partial read.

**LinkedIn is in scope for ALL TEN, every run — and as of 2026-09-04 all ten slugs are ATTESTED.**
`db/roster.sql` only carries a `linkedin_session` row for Kopelman and Perkins; that is a gap in the
allow-list, not a scoping decision. Every member still gets an attempt and a `source_status` row —
`ok`, or `unavailable` with the wall it hit. Omitting it silently is the R-004 error: it makes "he
has no LinkedIn" and "we never looked" the same row.

**Do not re-derive these. Each was corroborated from a page already confirmed as the member's**
(`linked_from_own_canonical`, STRONG) **and read live in the operator's Chrome:**

| member | slug | attested from |
|---|---|---|
| Wilson | `/in/fredwilson` | live headline vs Form ADV; Wayback 2025-01-26 |
| Feld | `/in/bfeld` | linked from `feld.com` footer |
| Kopelman | `/in/jkopelman` | linked from his First Round bio |
| Tavel | `/in/sarahtavel` | her own Substack profile `userLinks` |
| Walk | `/in/hunterwalk` | his site's "More of Me?" block |
| **Huffman** | **`/in/shuffman56`** | ⚠️ **NOT `/in/shuffman` — that is Sarah Huffman** |
| Shear | `/in/emmettshear` | `softmax.com/about`, `aria-label="Emmett Shear … LinkedIn"` |
| Ries | `/in/eries` | linked from `theleanstartup.com` |
| Qureshi | `/in/nabeelqu` | his own contact block on `nabeelqu.co` |
| Perkins | `/in/melanieperkins` | live headline `subject_self_identifies` |

Protocol, because LinkedIn is the most collision-prone surface in the set:

1. **Do not guess `/in/<handle>` and collect from it.** Logged out, `linkedin.com/in/<anything>`
   redirects to a Sign Up page — the wall fires *before* any profile content, so a redirect is not
   evidence the profile exists, and certainly not that it is the member. `/in/shuffman` is the
   measured proof: it looks exactly like Huffman's slug and belongs to someone else.
2. **Find the URL, don't invent it.** Best is a link from a page already confirmed as theirs (firm
   bio, personal site) → `linked_from_own_canonical`, STRONG. Note that a firm often links its
   **company** page, not the person's — `usv.com` links the USV company page, not Wilson.
3. **Read it through Wayback via `curl` — and you MUST use the `id_` raw variant.**
   `archive.org/wayback/available?url=linkedin.com/in/<h>` gives a timestamp; then fetch
   **`https://web.archive.org/web/<ts>id_/https://www.linkedin.com/in/<h>`**. ⚠️ **Without `id_`,
   archive.org now serves its own `Checking your browser - reCAPTCHA` interstitial** — a 200, ~21 KB,
   with a `<title>` and no profile in it. That is a wall, not a capture; if you parse it as one you
   will record "no data" for a profile that archived fine. Count CDX failures; it 504s and it also
   returns empty on transient failure, which is NOT the same as zero snapshots.
4. **Expect most captures to be walls.** Contrary to earlier guidance, the archived logged-out page
   usually does NOT carry og:title, counts, Websites and About. Most captures since ~2017 are
   **HTTP 999**. Pre-2017 captures are the reliably server-rendered ones, and they carry the
   Experience and Education spine — which is how Huffman's 2016 capture settled both of his NULL
   columns. Read the `statuscode` column in CDX and go for the 200s.
5. **Corroborate before collecting.** `handle_matches` + `display_name_matches` on LinkedIn alone is
   exactly the `@spez` pair and is NOT sufficient. What usually breaks the tie is the Websites block
   linking a domain you have already confirmed (`bio_backlink_to_canonical`), plus career detail
   that matches an independently sourced history.
6. A live logged-in read is SESSION tier, operator's machine only, and is what upgrades a
   weak identity. Never authenticate to get it.
7. **LinkedIn follower counts are NOT interchangeable with X counts.** Measured: Walk 882,825 on
   LinkedIn vs 246,611 on X; Ries 582,687 vs 301,420. Both would move tiers. **Do not re-baseline
   `prominence_tier` yourself** — report the drift and leave the row alone (K-9).

Common names are the hazard: `linkedin.com/pub/dir/<First>/<Last>/` is a directory of everyone
sharing the name. If you find a genuine collision, add a `person_identity_negative` row.

**Instagram, logged out, tells you NOTHING — do not treat a 200 as existence.** Every handle returns
a byte-identical ~616 KB login shell with no og tags. Measured control 2026-09-04: an invented
handle (`zzqq_notarealhandle_9931`) returned HTTP 200 at 616,898 bytes, *larger* than
`instagram.com/fredwilson`. Response size tracks handle length and nothing else. So a logged-out
Instagram probe can never distinguish real / private / nonexistent, for anyone: it is `unknown`,
never `quiet`, and never a deny-list row on its own. Only two Instagram accounts in this set are
identity-confirmed, both from the member's own site: `instagram.com/fredwilson` and
`instagram.com/hunterwalk`.

UA: `ArenaHall/1.0 (kellyqhe47@gmail.com)` — `data.sec.gov` 403s without it. Have a GitHub PAT
(unauth is 10/hr search). Autodiscover feeds from `<link rel="alternate">`. On SESSION sources use
the **accessibility tree** — text extraction returns empty and looks like "no data".

## Write

Into `db/arena.<person_id>.db` — never `db/arena.db`. Open one `run` row named
`run_ingest_<person>_<date>`; stamp everything with `run_id`.

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
