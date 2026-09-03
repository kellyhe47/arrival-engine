# 07 — Session-assisted access, MEASURED (2026-09-03)

Audit 04 measured **logged-out** access and marked the social platforms RED. The user pushed back:
that is the wrong measurement if an operator is logged in. Correct. This file records what a
**logged-in Chrome session, driven read-only at human pace**, actually returns.

Method: Claude in Chrome against the operator's own signed-in browser. Read-only — no post, message,
like, follow, comment or connection request was issued, and the adapter interface has no write path
(DEC-6, B-018 consolidated in G-029). Every row below was observed, not inferred.

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

---

# Instagram — measured 2026-09-03 (logged in)

Retested after the operator logged in. The earlier "Profile isn't available" was a logged-out
artifact, exactly as predicted. **Instagram is SESSION-GREEN and it is the richest source yet for
the life-context signal (S4).**

Target: `instagram.com/fredwilson/` — verified as the VC (bio "I am a vc", link `avc.com`).

## What renders

| Field | Value observed |
|---|---|
| posts / followers / following | 414 / 7,064 / 110 |
| bio, external link | "I am a vc", `avc.com` |
| **Threads account** | `threads.com/@fredwilson` — a linked platform not previously catalogued |
| post grid | 12 posts, each carrying its **caption as image alt text** |
| **`/tagged/` tab** | present and populated — 11 posts |

`get_page_text` returns the header ONLY. The grid requires the accessibility tree or a DOM query.
Confirms AUD-07-5: an implementation built on text extraction silently returns empty.

## AUD-07-6 — Captions carry places and people. S4 becomes real.

Verbatim captions from the grid, unedited:
- "Greenwich Village, NYC"
- "View of the Williamsburg Bridge from inside the Domino Sugar Refinery"
- "In France on our way to Berlin"  ·  "In Venice this week"
- "Leaving LA today. I will miss these palm trees in front of our house. And freshly made corn tortilla"
- "Abbott Kinney at dawn"  ·  "The old school receiver and turntable at Menotti's is awesome"
- "Sunrise bike ride"  ·  "Beach Sand Selfie"  ·  "Uzi"
- **"Spesh giving Josh a putting lesson on eight"**

This is exactly the user's proposed location signal (sketch point 8) and it is retrievable.
Wilson's contexts extract as: Greenwich Village NYC, a house in LA, Venice CA (Abbott Kinney,
Menotti's), Venice Italy, France, Berlin. Plus pursuits: cycling, golf.
The last caption also names two people by first name — a candidate person-edge.

**Caveat that must survive into the spec:** these are captions, not verified locations. "In Venice
this week" is ambiguous between Venice CA and Venice Italy, and the same profile contains evidence
for both. A caption is a claim by the subject, not a geotag. Store as `self_published` context with
the caption as its own evidence; never resolve an ambiguous place silently.

## AUD-07-7 — THE TAGGED TAB IS ADVERSARIAL INPUT. This is the sharpest finding of the audit.

The first post in `fredwilson/tagged/` is about a World Cup public-art installation, and its caption
names the participating artists: "Katherine Bernhardt, Hank Willis Thomas, Eddie Martinez, Bony
Ramirez, Tomokazu Matsuyama, Futura 2000 and **Fred Wilson**."

That Fred Wilson is **the conceptual artist** — a different person entirely from the VC whose
profile this is. It is sitting in the VC's tagged tab.

The structural point generalises past this one error:
1. **The tagged tab is written by other people.** Anyone on the platform can tag any account in any
   post. It is the only surface in the entire source inventory whose contents are controlled by
   third parties rather than by the subject or by a publisher.
2. **So it is an injection surface, not just an accuracy risk.** A stranger can place arbitrary text
   into a member's profile by tagging them. If tagged captions flow into facts, into the narrator's
   context, or onto the card, an outsider is writing what a host reads aloud in the lobby.
3. **And it is already wrong here, on the very first item, for the most obvious reason** — a common
   name. This is the same failure class as `@spez` (R-013), now on a surface where the collision is
   introduced by someone else rather than by our resolver.

**Rule required:** tagged content is `third_party` provenance at its best, is never attributed to
the member without independent corroboration, and its text is treated as untrusted data — never
concatenated into a model prompt as though it were a fact about the member. Same posture as
audit 04's rule about EDGAR N-PX co-occurrence, but with an active adversary rather than a noisy
table.

## AUD-07-8 — Operator leak confirmed on a third platform
The logged-in navigation exposes the operator's own account (`/kitty_kels/`) in the page tree,
alongside Messages and Notifications links. DEC-7's whitelist stripping is not optional; it is the
only thing keeping the operator's identity out of member profiles. Note also that the logged-in
session exposes WRITE surfaces (Follow button, New post, Messages) on every page — DEC-6's
structural read-only constraint (no write operation declared in the adapter interface) is what
prevents these being reachable, and B-018 / G-029 holds that interface contract.

---

# Image analysis — measured end to end, 2026-09-03

Tested on one public post the subject published himself:
`instagram.com/fredwilson/p/y7OvZKRNxF/` — deliberately chosen with NO people in frame.

## AUD-07-9 — The post page carries structured fields the grid does not

| Field | Value | Why it matters |
|---|---|---|
| **location tag** | "Menotti's Coffee Stop" | A STRUCTURED venue field, distinct from caption text. This resolves the AUD-07-6 ambiguity: a location *tag* is unambiguous where "In Venice this week" is a claim. Prefer the tag; fall back to the caption only as an unresolved claim. |
| **absolute date** | "February 10, 2015" | The grid gives relative dates ("603w", "1d"). The post page gives an absolute one. Ingest dates from the post page, never from the grid. |
| engagement | 237 likes, 5 comments | weak signal, cheap |
| comments | `@brianhynes`, `@santisiri` (verified) | third_party_open per R-026 — traversal hints only |

## AUD-07-10 — What the IMAGE yields that no text source does

Extracted from the photograph, no faces present, no face analysis performed:
- a wall rack holding ~100+ vinyl LPs
- a silver-faced vintage Luxman receiver and a turntable
- commercial espresso equipment, airpots, white subway tile
- **text in image**, hand-lettered sign: "DON'T SEE WHAT YOU ARE LOOKING FOR? LET'S TALK ABOUT IT"

**The scoring value is CORROBORATION, not novelty.** Audit 01 measured Wilson's blog category
"My Music" at **898 posts** — ~10% of his lifetime output. The photo shows he stops to photograph
analog audio gear in the wild. Same interest, two independent sources, one textual and one visual.
Text gave us `music`; the image gave us `vinyl / vintage-audio`, which is specific enough for a host
to say out loud. This is the argument for image analysis: it specifies and corroborates a topic that
text states only vaguely.

## AUD-07-11 — Signed CDN URLs cannot be handled; screenshot the rendered post instead
Extracting `img.currentSrc` was refused: Instagram CDN URLs carry signed query-string tokens and the
harness blocks returning them. This is the correct outcome and it fixes the architecture:
**render the post and screenshot it**. Never fetch, log or persist a signed CDN URL — they are
short-lived, they carry session-derived tokens, and storing one puts an operator credential into the
fact store. The screenshot path needs no URL handling at all.

## AUD-07-12 — Images are also an injection surface
Text-in-image is exactly as untrusted as tagged-post text. A photographed whiteboard, sign or screen
can carry arbitrary text, including text shaped like instructions. Any OCR/vision output is DATA:
it is never concatenated into a prompt as an instruction, and text recovered from an image published
by a third party is `third_party_open` under R-026.
