# `m_musk` · Elon Musk

Tesla — CEO; SpaceX — Founder and CEO. Prominence unmeasured in this expansion set; measure X on the
run date before assigning a tier. Seniority chief-executive.
Read `00-COMMON.md` first.

**Expansion prerequisite.** Elon Musk is not in the current ten-member `db/roster.sql`. Seed and
review the expanded roster before any database write, including current role labels and topic-base
recalculation. Once approved, use **`db/arena.m_musk.db`**, replayable SQL under
`ingest/sql/m_musk-NN-*.sql`, run id `run_ingest_musk_<date>`, and facts `f_musk_NNN`.

## Identity and attribution boundary

Tesla's leadership page, SpaceX's leadership page, and Tesla/SEC filings establish identity and
current roles. Tesla's SEC exhibits are unusually valuable because they preserve complete interview
transcripts and specific social posts as filed evidence. A corporate filing can authenticate the
material it reproduces without making every surrounding corporate claim Musk's own statement.

`https://x.com/elonmusk` is **strongly bound** to Elon Musk by Tesla's filed exhibits that name the
handle and reproduce its posts. Use the API card for public metadata and the read-only SESSION flow
for posts/follows. Walk the following list as far as the platform actually serves, report reached
versus claimed totals, and never declare an exhaustive negative from a capped list.

**LinkedIn remains a required attempt, but no personal profile is verified here.** Do not guess a
slug or treat a Tesla/SpaceX company page as his.

## Fetch

| url | ownership / what it can establish |
|---|---|
| `https://ir.tesla.com/corporate/elon-musk` | **Tesla official leadership page.** Identity, board/CEO role, and dated career history; corporate-authored |
| `https://ir.spacex.com/leadership/` | **SpaceX official leadership page.** Current SpaceX role; corporate-authored |
| `https://new.spacex.com/mission` | **SpaceX official mission page.** Organization context only unless an exact passage is expressly attributed to Musk |
| `https://ir.tesla.com/_flysystem/s3/sec/000110465925105632/tm252289d47_defa14a-gen.pdf` | **Tesla-filed 2025 exhibit.** Preserves Musk's All-In/Joe Rogan interview material and identified X posts. Keep exhibit page and original item date |
| `https://ir.tesla.com/_flysystem/s3/sec/000110465925101876/tm252289d41_defa14a-gen.pdf` | **Tesla-filed shareholder-meeting transcript.** Direct remarks with speaker labels; high-value strategy and governance source |
| `https://ir.tesla.com/_flysystem/s3/sec/000110465925100451/tm252289d37_defa14a-gen.pdf` | **Tesla-filed screenshots of identified `@elonmusk` posts.** Strong handle binding and item-level evidence; transcribe conservatively |
| `https://x.com/elonmusk` · `https://api.fxtwitter.com/elonmusk` | **Verified personal account.** SESSION for content/follows; public API metadata is not a substitute for a successful timeline read |
| `https://www.sec.gov/Archives/edgar/data/1418091/000119312522142446/d257150ddefa14a.htm` | **Twitter SEC filing.** Primary evidence for the acquisition context and for a documented Musk–Dorsey connection; distinguish filed third-party posts from company prose |

Use Tesla and SpaceX sources for the role each controls. Do not let a Tesla biography establish an
unstated current role at X, xAI, Neuralink, or another organization. For every current-role claim,
record a date and an authoritative source for that organization.

## Never fetch / identity traps

- Do not guess personal LinkedIn, Instagram, Threads, Facebook, TikTok, Telegram, or Bluesky
  profiles. Many fan, parody, archive, impersonation, and automated repost accounts use his name.
- Do not treat `@Tesla`, `@SpaceX`, `@xAI`, or other organization accounts as Musk's personal feed.
- Quote-image aggregators and “Musk said” compilations are discovery-only. Resolve every claim to
  the original post, recording, transcript, or filed exhibit.
- A screenshot without a stable source page, date, and authenticated handle is not ingestible.

## Inner circle (one hop)

Use named executive officers and directors from current Tesla or SpaceX sources. **Kimbal Musk** may
support both a documented family relationship and Tesla board overlap, but each edge needs its own
evidence. Other executives—such as the SpaceX president or Tesla chair—enter only from the current
leadership/filing that names their actual role. Do not infer closeness from public visibility.

## Edges

- The Twitter filing supports a documented historical connection with **Jack Dorsey** in the
  acquisition context. Store directional edges separately and use only the edge type the text
  actually supports; an acquisition is not automatically friendship, `follows`, or
  `co_investment`.
- Board and employer overlap must be dated. A person being an executive at one of Musk's companies
  is not evidence of an edge to every other company he leads.
- X follows require the actual complete-or-capped following-list observation, never a search result.

## Topics needing evidence

`crypto-protocols` is already controlled vocabulary but still needs a qualifying fact. Candidate
new topics include reusable spaceflight, electric vehicles and energy, AI, manufacturing systems,
and founder control/governance. Propose vocabulary changes rather than stuffing them into a nearby
existing label.

## Deep cut

Mine the filed full-length interview and shareholder-meeting exhibits before quote roundups. They
preserve context, speaker labels, dates, and often the exact social item that prompted the filing.
Separate durable operating principles from product forecasts, political claims, jokes, and
time-bound promotion; all can be facts, but they should not be summarized as the same kind of
signal.

## Recency / backfill

His public footprint is likely active, but the run earns `active` only through successfully observed
dated first-person material. An X wall makes X `unavailable`, not quiet; continue with current SEC
exhibits and official recordings. Backfill `career_start_decade` from a dated official biography.
Leave `name_respelling` NULL. Store platform, measurement date, and collection method alongside any
prominence number.
