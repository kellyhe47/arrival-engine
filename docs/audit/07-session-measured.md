# 07 — Session-assisted access, MEASURED (2026-09-03)

Audit 04 measured **logged-out** access and marked the social platforms RED. The user pushed back:
that is the wrong measurement if an operator is logged in. Correct. This file records what a
**logged-in Chrome session, driven read-only at human pace**, actually returns.

Method: Claude in Chrome against the operator's own signed-in browser. Read-only — no post, message,
like, follow, comment or connection request was issued, and the adapter interface has no write path
(DEC-6, fixture G-028). Every row below was observed, not inferred.

## Results

| Platform | URL fetched | Result | Verdict |
|---|---|---|---|
| **LinkedIn** | `linkedin.com/in/melanieperkins/` | **200, fully rendered.** Headline, location, company, university, follower count (370,639), degree-of-connection, and **full post bodies** for 10+ posts back to ~1yr. | **SESSION-GREEN — richest recency source found for Perkins anywhere** |
| **X profile** | `x.com/fredwilson` | **200.** Bio "I am a VC", 1,345 Following, 640.8K Followers, joined March 2007, location, website, **birthday "Born August 20"**. Timeline posts did NOT appear in text extraction. | **SESSION-GREEN for profile; timeline needs the a11y tree or scroll** |
| **X following list** | `x.com/fredwilson/following` | **Empty in text extraction, but PRESENT in the accessibility tree.** First virtualized page returned `bgurley`, `mattturck`, `semil`, `msuster`, `ttunguz`, `joshelman` with their bio-linked orgs. Full list requires scrolling (1,345 entries). | **SESSION-GREEN via `read_page`, not `get_page_text`** |
| **Instagram** | `instagram.com/melanieperkins/` | "Profile isn't available… Log in / Sign up". Session is **not logged in to Instagram**, or the handle is wrong. | **UNVERIFIED — retest after login** |
| Facebook | not tested | — | **UNVERIFIED** |
| TikTok | not tested | — | **UNVERIFIED** |

## Findings that change the spec

**AUD-07-1 — A prior finding is overturned.** Audit 03 concluded: *"No first-person Perkins
publication in Mar–Sep 2026 is fetchable at all; every 2026 quote is journalist-mediated."*
**That is now false.** Her most recent LinkedIn post is dated **1d** — one day before this audit.
LinkedIn is the single best recency source for her, and the logged-out audit could not see it.
The AUD-STALE risk shrinks for anyone who posts on LinkedIn. It does NOT vanish: Kopelman's and
Tavel's staleness must be re-measured the same way before it is treated as fixed.

**AUD-07-2 — Tagged people and reposts are real, retrievable edge signals.** Perkins' post carries
a literal tag line: `cc: Melanie Perkins, Lachlan Andrews, Kelly Steckelberg, Ian Lee`. Her feed also
carries `Melanie Perkins reposted this — Cliff Obrecht`, her co-founder. This is direct evidence for
the user's proposed signals (tagged associates, professional inner circle) and it feeds the edge
store as `co_mention` and `repost` edge types.

**AUD-07-3 — The follow-graph is now free.** Audit 04 priced Fred Wilson's 1,345-entry following
list at ~$13.45 per pull via the metered X API. The logged-in accessibility tree returns the same
list at $0. S5 (directed declared link, LARGE 3) becomes cheap to populate.
Cost: it is virtualized, so it must be scrolled; treat as a slow batch job, not a request-time call.

**AUD-07-4 — THE METHODOLOGICAL CATCH, and it is the important one.**
The logged-in view is **personalized**. Fred Wilson's X profile rendered
`Followed by Alexandr Wang and Sam Altman`; Perkins' LinkedIn rendered
`Followed by Upasana, Imshan and 5 others you know` and `· 3rd` degree-of-connection.

Those strings are facts about **the operator's own account**, not about the member. Three
consequences, all of which must be handled in the spec:
  1. **Not reproducible.** The same URL yields different bytes for a different operator. Any fact
     derived from a personalized string is not verifiable by Arena Hall later.
  2. **Visibility is graph-dependent.** A 1st-degree connection shows more than a 3rd. Coverage will
     silently differ per member depending on who the operator knows.
  3. **It leaks the operator into the member's profile.** "5 others you know" is data about the
     operator's contacts. It must never reach a fact record or a card.

Rule adopted: **personalized strings are stripped at the adapter boundary and never stored.**
Whitelist what a session adapter may extract; do not blacklist. See B-019 / G-029.

**AUD-07-5 — `get_page_text` is not sufficient; use the accessibility tree.** X returned nothing
useful from text extraction and the full follow list from `read_page`. An implementation built on
text extraction alone will silently return empty lists and look like "no data" rather than "wrong
method". This is the same class of trap as audit 04's YouTube `timedtext` decoy.

## Still RED regardless of login
- **Dating apps** — no access path at any login state; special-category data. Unchanged.
- **Captcha / bot-detection evasion** — not built, at any tier. TikTok's 25 captcha references stand.
