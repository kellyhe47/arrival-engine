# `m_dorsey` · Jack Dorsey

Block — Block Head and Chairperson; co-founder. Prominence unmeasured in this expansion set; measure
X on the run date before assigning a tier. Seniority chief-executive.
Read `00-COMMON.md` first.

**Expansion prerequisite.** Jack Dorsey is not in the current ten-member `db/roster.sql`. Add and
audit the expanded member/identity rows, review topic vocabulary, and recompute roster-wide
baselines before collection. Then write to **`db/arena.m_dorsey.db`**, preserve SQL in
`ingest/sql/m_dorsey-NN-*.sql`, and use `run_ingest_dorsey_<date>` / `f_dorsey_NNN` ids.

## Identity and attribution boundary

Block's current leadership page and SEC filings establish Jack Dorsey's role. Block shareholder
letters and Investor Day transcripts are the strongest long-form sources because they carry dates,
speaker labels, and/or his signature. Attribute corporate team statements to Block unless a letter,
transcript, or passage explicitly identifies Jack as the author or speaker.

`https://x.com/jack` is **strongly verified**: Twitter's own SEC filing explicitly identifies “Jack
Dorsey (`@jack`).” Use the public profile card for metadata and SESSION for timeline/follows. A
following-list cap is partial, never a confirmed absence.

**LinkedIn is a required attempt, but no personal slug is verified here.** Do not guess one. A Block
company page or a matching-name directory entry is not his profile.

## Fetch

| url | ownership / what it can establish |
|---|---|
| `https://investors.block.xyz/governance/leadership/default.aspx` | **Block official leadership page. Identity anchor:** current Block title and board role; corporate-authored |
| `https://www.sec.gov/Archives/edgar/data/1512673/000162828026027203/sq-20260423.htm` | **Block 2026 proxy filed with the SEC.** Current role, governance, tenure, and dated biography |
| `https://www.sec.gov/Archives/edgar/data/1512673/000162828026053368/exhibit311q226.htm` | **2026 signed SEC certification.** Strong current identity/role evidence; substantive company facts still require their underlying filing context |
| `https://block.xyz/investor-day-2025` | **Block official Investor Day with video/transcript.** Attribute speaker-labeled Jack sections directly and retain timestamps/page locations |
| `https://investors.block.xyz/files/doc_downloads/2022/05/Block-Investor-Day-2022-Our-Ecosystems.pdf` | **Block official transcript.** Historical strategy source; use speaker labels and event date |
| `https://investors.block.xyz/files/doc_financials/2024/q1/Shareholder-Letter_1Q24_Block.pdf` | **Block shareholder letter.** High-value Bitcoin/treasury blueprint; confirm authorship/signature and page before assigning first-person provenance |
| `https://investors.block.xyz/files/doc_financials/2024/q4/Shareholder-Letter_Block-4Q24pdf.pdf` | **Block shareholder letter.** Later operating context; same authorship and page-level rule |
| `https://block.xyz/csr/2023` | **Block corporate report containing a letter from Jack.** The letter is attributable; the rest of the report is Block-authored |
| `https://investors.block.xyz/investor-news/news-details/2021/Square-Incs-Federal-Comment-Letter-Regarding-FinCENs-Proposed-Rulemaking-on-Requirements-for-Certain-Transactions-Involving-Convertible-Virtual-Currency-or-Digital-Assets/default.aspx` | **Official signed policy comment.** Directly attributable position in its dated regulatory context |
| `https://x.com/jack` · `https://api.fxtwitter.com/jack` | **Verified personal X account.** SESSION for content and follows; retain original post ids/dates |
| `https://www.sec.gov/Archives/edgar/data/1418091/000119312522142446/d257150ddefa14a.htm` | **Twitter SEC filing.** Explicit `@jack` identity binding and primary evidence for a Musk acquisition-context edge |
| `https://www.ted.com/talks/jack_dorsey_how_twitter_needs_to_change?view=transcript` | **TED's direct talk/interview transcript.** Historical platform-governance views; preserve speaker turns and talk date |

## Candidate protocol identity: Nostr

The public key
`npub1sg6plzptd64u62a878hep2kev88swjh3tw00gjsfl8f237lmu63q0uf63m` and NIP-05
`jack@primal.net` are discovery candidates, **not yet accepted identity anchors in this brief**.
A display name, avatar, or NIP-05 alone is insufficient. Require a statement from verified `@jack`,
a Block-controlled page, or another strong source that binds Jack Dorsey to the exact public key.
Until then, do not collect notes, follows, or counts from it.

## Never fetch / identity traps

- Do not guess LinkedIn, Instagram, Bluesky, Threads, TikTok, Facebook, Telegram, or alternate X
  accounts.
- Nostr relays and web mirrors can show the same unauthenticated display name on unrelated keys;
  identity is the exact public key, not the label.
- Block, Cash App, Square, TIDAL, Proto, and Twitter/X organization feeds are not automatically
  Jack's personal speech.
- Quote sites and screenshots detached from an original post id or filed exhibit are discovery-only.

## Inner circle (one hop)

Use the current Block leadership page/proxy for professional relationships. **Jim McKelvey** may be
included where an authoritative source documents co-founding or board overlap. Current Block named
executives enter with their exact dated roles. Protocol developers or Bitcoin figures do not become
inner-circle members merely because Jack follows, funds, or praises a project; each relation needs
its own source and edge type.

## Edges

- The Twitter SEC filing supports a documented acquisition-context connection with **Elon Musk**.
  It does not prove friendship, a follow, or shared investment. Store each direction/evidence item
  separately.
- A current shared board can support `board_together`; a recorded joint interview can support
  `co_appearance`.
- X and future Nostr follows must come from an actual observed graph for the verified account/key.

## Topics needing evidence

`crypto-protocols` and `content-moderation` already exist but each needs qualifying evidence with a
date. Candidate additions include payment ecosystems, open social protocols, corporate treasury,
and decentralized identity. Review vocabulary before inserting any of them.

## Deep cut

Start with Block's complete Investor Day transcript, signed shareholder material, and the federal
comment letter. Together they expose how Dorsey connects product ecosystems, Bitcoin, financial
access, and protocol openness with more context than isolated posts. Use the older TED transcript
to mark what is historical Twitter-era thinking rather than silently treating it as his current
Block position.

## Recency / backfill

Current filings establish that he remains in role; recent first-person activity still requires an
observed post, signed letter, or speaker-labeled 2025–26 transcript. If X is blocked, mark that source
`unavailable`, not quiet, and continue with Block's official material. Backfill
`career_start_decade` from a dated official biography and leave `name_respelling` NULL. Store the
platform and measurement date with any prominence count.
