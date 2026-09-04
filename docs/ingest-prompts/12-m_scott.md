# `m_scott` · Kendra Scott

Kendra Scott — Founder and Chief Creative Officer, Austin. Prominence unmeasured; measure a named
platform before assigning a tier. Seniority founder.
Read `00-COMMON.md` first.

**Expansion prerequisite.** Kendra Scott is not in the current ten-member `db/roster.sql`. Before
ingest, seed audited identity and label rows, review vocabulary changes, and recompute expanded-roster
baselines. Until then this file is a source plan only. Once seeded, write to
**`db/arena.m_scott.db`** and `ingest/sql/m_scott-NN-*.sql`; use `run_ingest_scott_<date>` and
`f_scott_NNN` ids.

## Identity and attribution boundary

The company founder page and ABC's current *Shark Tank* biography anchor this Kendra Scott. On the
company blog, ingest a post as her own only where the page is explicitly written in her voice,
bylined to her, or preserves a direct quotation. General brand copy is company-authored.

**LinkedIn has a measured collision:** `https://www.linkedin.com/in/kendra-scott` is a different
Kendra Scott whose public career is in marketing/financial services. Put that URL in
`person_identity_negative` and never collect it for the founder. A third-party video description
that links this slug does not override the profile's contradictory identity. Continue the required
LinkedIn discovery attempt without guessing another slug.

## Fetch

| url | ownership / what it can establish |
|---|---|
| `https://www.kendrascott.com/about-kendra.html` | **Company official founder page. Identity anchor:** founding story, current company role, WELI and philanthropic programs. Treat unsigned prose as company-published |
| `https://www.detpress.com/storage/uploads/46/61/4661EEC2-22B7-3C25-B037-0509A5ACA9EF/Shark_Tank_S17_Kendra_Scott_Bio_2025-2026.pdf` | **ABC/Disney press biography for 2025–26.** Current role corroboration and dated public-profile evidence; third-party, not her writing |
| `https://blog.kendrascott.com/blog/getting-to-know-kendra-scott` | **Company-owned interview/profile.** Attribute only answers or direct quotations to Kendra |
| `https://blog.kendrascott.com/blog/kendra-scott-on-nprs-how-i-built-this` | **Company-owned first-person framing plus an NPR episode lead.** Fetch the original episode before quoting audio or transcript |
| `https://blog.kendrascott.com/blog/kendra-on-austin-our-hometown` | **Company-owned, Kendra-focused post.** Check byline/voice on the rendered page before classing a sentence as first-person |
| `https://blog.kendrascott.com/blog/kendra-on-being-a-mom-first` | Same rule: signed/direct first-person passages may be hers; surrounding brand prose is not |
| `https://blog.kendrascott.com/blog/what-jewelry-means-to-kendra` | Product and design philosophy, with sentence-level speaker attribution required |
| `https://blog.kendrascott.com/blog/kendras-tips-and-tricks-for-entrepreneurs` | Founder advice. Preserve page title, date, and exact byline/quotation boundary |
| `https://www.youtube.com/watch?v=2AAyr2tj27k` | **Foundr's 2025 direct interview.** Her recorded answers are attributable; description links are discovery leads, not identity proof |
| `https://www.iheart.com/podcast/1324-giants-official-podcast-n-79840354/episode/her-playbook-kendra-scott-306863702/` | **2025 direct interview with machine transcript.** Verify material quotations against audio and keep timestamps; ASR text is not exact by default |

## Never fetch / identity traps

- `https://www.linkedin.com/in/kendra-scott` — confirmed wrong person; deny-list it.
- Treat `@kendrascott` as a **company/brand account**, not automatically as Kendra's personal
  account. A signed video or direct quote can still be attributed at item level.
- Do not invent a personal handle such as `@officialkendra`, and do not transfer a profile link from
  a podcast description into the allow-list without corroboration.
- Retail product pages, influencer posts, and unsourced founder-quote collections are not evidence
  of her words or current activity.

## Inner circle (one hop)

Prefer explicitly documented professional relationships: current company leadership, named
co-presenters, and the University of Texas Women's Entrepreneurial Leadership Institute team. If
using former executives, date the relationship and do not label them current. Her children or other
family members enter only when her own sourced statement makes the relationship relevant; never
expand into their independent activity.

## Edges

- Company leadership overlap may support `shared_org`; a named joint event may support
  `co_appearance`.
- Philanthropic participation is not `co_investment`, and appearing in different *Shark Tank*
  episodes is not `co_appearance`.
- Do not infer an edge to a celebrity merely because they wear the brand or appear in brand media.

## Topics needing evidence

Candidate topics: founder-led retail, jewelry and product design, omnichannel retail, women-led
entrepreneurship, and philanthropy. They require controlled-vocabulary review. Do not map retail
growth to `product-led-growth` without evidence that satisfies that topic's actual definition.

## Deep cut

Start with the small set of company-blog pages where Kendra's voice is explicit. The useful vein is
how she connects design, Austin, motherhood, giving, and founder advice—not a generic retelling of
the $500 origin story. The Foundr and 2025 podcast interviews provide newer claims; confirm them
against audio rather than copying show-note superlatives.

## Recency / backfill

Use the current ABC biography for role and the 2025 recordings for possible activity. Recency is
`active` only if a dated item containing her own speech is actually read; an updated brand page alone
does not prove she published. Backfill `career_start_decade` from the official founding chronology.
Leave `name_respelling` NULL absent a recording need. Prominence remains unmeasured until a verified
personal account is read on the measurement date.
