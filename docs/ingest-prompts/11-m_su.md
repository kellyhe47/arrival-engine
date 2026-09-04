# `m_su` · Lisa Su

AMD — Chair and CEO. Prominence unmeasured; measure a named platform before assigning a tier.
Seniority chief-executive.
Read `00-COMMON.md` first.

**Expansion prerequisite.** Lisa Su is not in the current ten-member `db/roster.sql`. This is a
source plan, not authorization to write her into a database built from the current seed. Before
collection, add audited `person`, `member_label`, and `person_identity` rows, decide any vocabulary
extensions, and recompute topic and prominence baselines for the expanded roster. Then write only to
**`db/arena.m_su.db`**, with replayable SQL in `ingest/sql/m_su-NN-*.sql`. Namespace ids
`run_ingest_su_<date>` and `f_su_NNN`.

## Identity and attribution boundary

AMD's leadership page and current proxy are the identity anchors. They establish the person and
role; their narrative prose is **company-published**, not Lisa Su's first-person writing. A recorded
interview, hearing testimony, or keynote may be attributed to her only where the source provides her
actual words or clearly labels her as the speaker. Do not turn an AMD press release into a Lisa Su
quote.

**LinkedIn is still a required attempt.** No personal LinkedIn slug is verified in this brief.
AMD's corporate LinkedIn link is not hers. Discover a candidate from a confirmed personal or
official bio, then apply the common corroboration rule; otherwise record `unavailable` or
`skipped` with the precise discovery failure. Never guess `/in/lisasu`.

## Fetch

| url | ownership / what it can establish |
|---|---|
| `https://www.amd.com/en/corporate/leadership/lisa-su.html` | **AMD official. Identity anchor:** current title, dated career history, board and public-service roles. Company-authored except for clearly marked quotations |
| `https://ir.amd.com/financial-information/sec-filings/content/0001193125-26-129057/d85856ddef14a.htm` | **AMD/SEC proxy, filed 2026-03-27. Strong identity and current-role evidence.** Prefer the filing's dated facts over undated biographies |
| `https://www.gsb.stanford.edu/insights/dream-big-lisa-su-talks-chips-curiosity-chance` | **Stanford GSB interview.** Direct Lisa Su answers are attributable speech; Stanford's framing is third-party editorial prose |
| `https://www.commerce.senate.gov/meetings/winning-the-ai-race-strengthening-u-s-capabilities-in-computing-and-innovation/` | **Official Senate hearing record.** Establishes appearance, date, subject, and links the prepared statement |
| `https://www.commerce.senate.gov/wp-content/uploads/meetings/5E6FFBDC-13B0-4BD5-9117-EAF6A1D18B82/AMD%20CEO%20Lisa%20Su%20Senate%20Commerce%20Committee%20Prepared%20Remarks%20May%202025.pdf` | **Prepared testimony submitted under her name.** High-value first-person policy and semiconductor-strategy source; preserve page numbers |
| `https://www.youtube.com/watch?v=MCi8jgALPYA` | **AMD's official YouTube upload of her Computex 2024 keynote.** Attribute only her spoken remarks, using captions plus timestamp; do not ingest unrelated AMD channel videos as hers |
| `https://www.amd.com/en/corporate/events/advancing-ai/sessions-catalog/shaping-the-future-of-ai-through-openness--a-fireside-chat-with-lisa-su-and-clem-delangue.html` | **AMD event page.** Current co-appearance lead; use the recording/transcript, if exposed, for speech and the page for event metadata |
| `https://x.com/LisaSu` · `https://api.fxtwitter.com/LisaSu` | **Candidate personal X account.** Collect only after the API name field and a confirmed AMD-controlled backlink satisfy identity; X remains SESSION for posts and follows |

For talks, store the event page and the exact media URL separately. A page saying that she spoke is
evidence of an appearance; the recording is evidence of what she said.

## Never fetch / identity traps

- Do not attribute AMD's corporate social accounts, newsroom, or general YouTube catalog to Lisa Su.
- Do not guess LinkedIn, Instagram, TikTok, Facebook, Threads, or Bluesky handles from her name.
- Search results and fan-uploaded keynote clips are discovery leads only. Prefer the full official
  AMD upload or the institution that hosted the event.
- A biography repeating her résumé is not first-person evidence, even when accurate.

## Inner circle (one hop)

Use only professional relationships made explicit by a primary source: current AMD named executive
officers and directors in the proxy; predecessor/successor or former-employer relationships in the
official bio; and a co-speaker such as **Clément Delangue** only for the specific documented event.
Do not infer friendship from photographs or repeated conference appearances. Family is out of scope
unless Lisa Su or an official filing makes it material to a collected fact.

## Edges

- A joint panel or fireside chat can support `co_appearance` when the event page or recording names
  both people.
- AMD board service can support `board_together`; dated employer history can support
  `employer_history` or `shared_org` as defined by the schema.
- Do not create a relationship merely because two executives work in the semiconductor industry or
  appear on the same conference agenda on different sessions.

## Topics needing evidence

Candidate topics: AI compute, semiconductor manufacturing and supply chains, open AI ecosystems,
high-performance computing, and technical leadership. These are **not automatically controlled
vocabulary values**. Add a topic only after vocabulary review and a qualifying evidence fact; do
not force them into an existing topic such as `product-led-growth`.

## Deep cut

Mine the prepared Senate testimony and the full Stanford interview before generic profiles. They
contain attributable reasoning about national capacity, ecosystem openness, risk, curiosity, and
leadership—not just career chronology. In the keynote, retain timestamps and separate product
announcements from longer-lived beliefs.

## Recency / backfill

Her proxy and current AMD event pages establish continuing public activity, but recency still
depends on a successfully read first-person source in the run. Backfill `career_start_decade` from
the dated AMD bio. Leave `name_respelling` NULL unless a recording supplies a clear pronunciation.
Record every attempted social source and never assign prominence from an unattributed search-result
count.
