# `m_dell` · Michael Dell

Dell Technologies — Chairman and CEO. Prominence unmeasured; measure a verified platform before
assigning a tier. Seniority chief-executive.
Read `00-COMMON.md` first.

**The requested name is canonically spelled Michael Dell, not “Micheal Dell.”** Preserve the latter
only as an input alias if alias storage is needed; never make it the member label.

**Expansion prerequisite.** Michael Dell is not in the current ten-member `db/roster.sql`. Seed the
new member and verified identities, review vocabulary, and recompute roster-wide baselines before
writing. Then use **`db/arena.m_dell.db`**, `ingest/sql/m_dell-NN-*.sql`,
`run_ingest_dell_<date>`, and `f_dell_NNN`.

## Identity and attribution boundary

Dell Technologies' executive biography and current proxy/annual materials anchor the person and
role. Michael Dell's subject-controlled Linktree provides a useful cross-platform map, but each
destination still needs its own corroboration. Corporate biography prose is not first-person;
signed shareholder letters, speaker-labeled transcripts, posts on a corroborated personal account,
and recorded answers are.

The verified LinkedIn candidate is **`https://www.linkedin.com/in/mdell/`**, not a name-derived
slug. It is linked from `https://linktr.ee/michaeldell`; confirm live profile name, role, and a
canonical backlink before collection, then follow the SESSION protocol. The same link hub points to
X `@MichaelDell` and Instagram `@michaeldell`; retain the link hub as identity evidence and record
each platform attempt separately.

## Fetch

| url | ownership / what it can establish |
|---|---|
| `https://www.dell.com/en-us/lp/dt/michael-dell` | **Dell official executive biography. Identity anchor:** current title, founding chronology, selected board/philanthropic context; corporate-authored |
| `https://investors.delltechnologies.com/news-events/past-events` | **Dell investor-relations event index.** Start newest-first; it links the 2026 proxy, chairman's letter, annual meeting, and named-speaker events. Store the final document URL, not only this index |
| `https://investors.delltechnologies.com/financial-information/sec-filings` | **Dell investor-relations filings index.** Use the current proxy for role/governance; filter by filing date and form rather than trusting search-result order |
| `https://investors.delltechnologies.com/events/event-details/dell-technologies-bank-americas-view-top-ceo-series-1` | **Official 2026 event page naming Michael Dell as speaker.** Links the webcast and transcript |
| `https://investors.delltechnologies.com/static-files/f2dd4aa4-5bec-44c1-a75b-9d6dd5a73ee7` | **Official transcript of the 2026 Bank of America CEO interview.** Direct speech is attributable by speaker label |
| `https://linktr.ee/michaeldell` | **Subject-controlled identity hub.** Corroborates the exact social destinations and links Dell, MSD/DFO, foundation, and OneDell; not a source for claims merely implied by link titles |
| `https://www.linkedin.com/in/mdell/` | **Personal LinkedIn candidate linked by the identity hub.** SESSION; collect only after the rendered profile corroborates person and role |
| `https://x.com/MichaelDell` · `https://api.fxtwitter.com/MichaelDell` | **Personal X candidate linked by the identity hub.** Public metadata plus SESSION content/follow attempt after corroboration |
| `https://www.instagram.com/michaeldell/` | **Personal Instagram candidate linked by the identity hub.** SESSION and read-only; captions only, with personalization stripped |
| `https://www.onedell.com/` | **Michael and Susan Dell's official family/philanthropy site.** Use for statements explicitly presented as theirs and for documented shared initiatives |
| `https://www.dell.com/en-us/blog/authors/michael-dell/` | **Official historical author archive.** Enumerate what actually resolves; sparse or old output is not evidence that he is currently quiet elsewhere |

For the event index, store the final transcript/PDF URL—not only the index—and preserve the event
date and speaker label. Earnings material should be attributed line by line because several Dell
executives may speak in one transcript.

## Never fetch / identity traps

- Do not guess `/in/michael-dell`, alternate X spellings, or personal accounts on TikTok, Facebook,
  Threads, or Bluesky.
- Dell corporate accounts and employee-authored Dell blog posts are not Michael Dell sources.
- Do not ingest pirated book text or quotation sites for *Direct from Dell* or *Play Nice But Win*.
  Use an authorized excerpt, publisher page, recording, or a statement he publishes directly.
- A shareholder proposal quoting his posts is corroboration, not the preferred source for the
  underlying statement when the original or a company-filed copy is available.

## Inner circle (one hop)

**Susan Dell** is a documented partner and collaborator on OneDell; apply DEC-12 sentence by
sentence. Current Dell named executives and directors can support dated professional edges.
Frequent public co-speakers—such as technology-company CEOs at Dell events—enter only when the
official event record names both people in the same session. Do not convert a vendor partnership
between companies into a personal relationship.

## Edges

- OneDell may support `family_or_partner` plus a separately evidenced shared initiative.
- Current board service may support `board_together`; speaker-labeled joint sessions may support
  `co_appearance`.
- Company partnerships, compatible products, and keynote mentions do not alone establish
  `co_investment`, `shared_org`, or personal endorsement.

## Topics needing evidence

Candidate topics: AI infrastructure, enterprise computing, the direct/build-to-order model,
founder-led governance, and philanthropy. Review them against the controlled vocabulary first.
Do not map a hardware or sales model to `product-led-growth` merely because it concerns growth.

## Deep cut

The highest-yield current material is the signed annual chairman's letter and the newest
speaker-labeled long-form CEO interview linked from investor relations. Pair those with the older
official author archive to distinguish long-lived operating principles from the current AI cycle.
OneDell is the clean route for shared Michael-and-Susan initiatives; keep its “we” statements intact
rather than silently rewriting them as Michael-only claims.

## Recency / backfill

Investor relations lists current events and annual material, but recency requires reading an item
that actually contains Michael Dell's words. If social sessions fail, do not call him quiet. Backfill
`career_start_decade` from Dell's official founding chronology and leave `name_respelling` NULL.
Store the requested misspelling as an alias only if the schema supports noncanonical input aliases.
