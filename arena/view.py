"""View models — the ten card states, and the shape each surface renders.

`docs/ui-states.md` assigns every state its trigger, content, actions and exit. This module is that
table in code, so a state is chosen by rule rather than by whichever branch a template happened to
take. Nothing here decides anything a fixture asserts; it presents what the operations returned.
"""
from __future__ import annotations

import hashlib
import re

from markupsafe import Markup, escape

#: R-059 / P0-5. No member name appears in a URL or a page title, so a name cannot leak through a
#: referrer header or a browser-history entry. This is DISCOVERY MITIGATION, not access control,
#: and the README says so in those words.
def token_for(member_id: str, secret: str) -> str:
    return hashlib.blake2s(f"{secret}:{member_id}".encode(), digest_size=6).hexdigest()


def resolve_token(token: str, member_ids, secret: str) -> str | None:
    for mid in member_ids:
        if token_for(mid, secret) == token:
            return mid
    return None


#: The five bare nouns, and what the host actually reads above each one.
#:
#: The BLOCK IDS are the domain vocabulary — `Who`, `Now`, `Room`, `Notice`, `Say`. They are the
#: gate contract (`config.REQUIRED_BLOCKS`), they are what every golden fixture asserts, and they
#: are what `arena.card` and `arena.narrator` branch on. Nothing here changes any of that.
#:
#: What changed on 2026-09-03 is the RENDERED TITLE. A bare noun is a good name for a slot in a
#: schema and a bad name for a heading on a phone: "Now" and "Notice" tell a host standing at a
#: door nothing about what is under them, and "Room" reads as a place when it means the people in
#: it. The titles below say what the block is for, in the host's words. See
#: docs/design-additions.md A-6.
BLOCK_TITLES = {
    "Who": "Who they are",
    "Now": "Recent activity",
    "Room": "Who's here",
    "Notice": "Personal detail",
    "Say": "Your opening line",
}


def block_title(label: str) -> str:
    """Render-time only. An unmapped label renders as itself rather than disappearing."""
    return BLOCK_TITLES.get(label, label)


#: Separators an operator may have typed into `member_label.current_label`. The stored string is
#: never rewritten — R-014 — only its punctuation is normalised to the club's middot.
_LABEL_SPLIT = re.compile(r"\s*(?:[,;/|·]|—|–)\s*")

#: A canonical geo tag: `boulder-co`, `new-york-ny`, `sydney-au`. Free-text place contexts
#: ("Good Room, Greenpoint, Brooklyn") are NOT this shape and are never used for the subtitle.
_GEO_SLUG = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*-[a-z]{2}$")


#: "Reddit, Inc." is ONE organisation with a comma in it, not an org and a role. Splitting it gives
#: "Reddit · Inc. · CEO", which reads as a company nobody works for.
_SUFFIX = re.compile(r"^(?:inc|llc|l\.l\.c|ltd|co|corp|plc|gmbh|s\.a|sa|lp|llp|pbc)\.?$", re.I)


def affiliation_line(label: str, *, max_parts: int | None = None) -> str:
    """Where they are and what they do there, as measured.

    `member_label.current_label` already holds exactly that — "Foundry, General Partner" — so this
    joins its parts with the club's middot and adds nothing. It does not title-case, expand an
    abbreviation, or guess a role from an org: the line says what the store says.

    `max_parts` is for the EYEBROW, which is one short line at 11px with 3.5px tracking. The stored
    label is free text and does not always respect that: Ries's is "LTSE; author, Incorruptible
    (2026-05-26)", which set uppercase and tracked wrapped onto two lines and broke mid-date. The
    first two parts are the organisation and the role — everything an eyebrow is for. Prose that
    can afford the full string passes no limit.
    """
    parts: list[str] = []
    for part in (p.strip() for p in _LABEL_SPLIT.split(label or "")):
        if not part:
            continue
        if parts and _SUFFIX.match(part):
            parts[-1] = f"{parts[-1]}, {part}"      # a legal suffix rejoins the name it belongs to
        else:
            parts.append(part)
    if max_parts is not None:
        parts = parts[:max_parts]
    return " · ".join(parts)


def _place(member: dict) -> str | None:
    """The one resolved, canonical place tag. Unresolved contexts never reach the banner (S4)."""
    for c in member.get("contexts") or []:
        if c.get("type") != "place" or not c.get("resolved"):
            continue
        value = str(c.get("value") or "")
        if _GEO_SLUG.match(value):
            return value.rsplit("-", 1)[0].replace("-", " ").title()
    return None


def subject_subtitle(member: dict, *, industry_labels: dict, vocabulary: dict) -> str:
    """The banner's one line under the name. Assembled from STORED STRUCTURED ATTRIBUTES only.

    Two parts, both of them lookups:

      1. `industry.label` + the resolved canonical place — "Venture capital in Boulder."
      2. up to two `topic.label`s, DISCRIMINATING ONES FIRST. Genericity is already measured over
         the member base and stored (`topic.discriminating`), so a topic that 40% of the club
         shares is the last thing that should be used to tell one member from another.

    No sentence here is composed by a model and none of it is inferred. A member with neither an
    industry nor a discriminating topic gets a shorter line, not an invented one.
    """
    industries = [industry_labels[s] for s in (member.get("industries") or [])
                  if s in industry_labels]
    place = _place(member)
    head = ""
    if industries:
        head = " and ".join(industries[:2])
        head = f"{head} in {place}." if place else f"{head}."

    topics = sorted(
        (s for s in (member.get("topics_professional") or []) if s in vocabulary),
        key=lambda s: (0 if vocabulary[s].get("discriminating") else 1, s),
    )
    tail = " · ".join(vocabulary[s]["label"] for s in topics[:2])
    return " ".join(p for p in (head, tail) if p)


#: State copy for the surfaces where the STATE is the subject: the ingesting screen, the
#: resolution chooser, and a token that resolves to nobody.
#:
#: `ready` and `unknown_coverage` are deliberately absent. They were here, and the card banner
#: printed them — a card for a member who is standing at the door read "READY / Brad Feld / Five
#: blocks, under ninety seconds." Both lines described the SOFTWARE. The host does not need to be
#: told the render succeeded, and "Unknown coverage" as a headline announces a retrieval fact
#: before it announces a person. Those two states still exist and still change what the card
#: renders — they are just no longer the words above someone's name. See docs/design-additions.md
#: A-6. The card banner is now derived from the member: `affiliation_line` over the eyebrow,
#: `subject_subtitle` under the name.
STATE_COPY = {
    # The chooser's own three outcomes. `resolved` used to borrow the card's `ready` copy, which
    # is why removing `ready` broke it — the chooser was never describing a card state.
    "resolved": ("Resolved", "One corroborated candidate. Picking binds identity for this arrival "
                             "only."),
    "no_strong_match": (
        "No strong match",
        "Nobody present clears the floor. No name is offered — a weak introduction spends "
        "credibility that a strong one will need."),
    "cold_trail": (
        "Cold trail",
        "No first-person item inside a year. The gap is stated; old material is not dressed as "
        "current."),
    "unknown_coverage": (
        "Unknown coverage",
        "A source could not be read on the last run. No claim is made about silence in either "
        "direction."),
    "empty_room": ("Empty room", "First one here. Not an error."),
    "ingesting": ("Ingesting", "A live GREEN re-run is in progress. Unavailable sources are named."),
    "withheld": ("Withheld", "A hard gate failed. This degrades to a greeting, never to a guess."),
    "ambiguous": ("Ambiguous", "More than one corroborated candidate. The host picks; the engine "
                               "never guesses identity."),
    "not_found": ("Not found", "No corroborated profile. Greet and log."),
    "thin_profile": (
        "Thin profile",
        "Identity is resolved and the evidence cannot carry a full card. Fewer facts, nothing "
        "invented."),
}


#: A quotation the member actually made, already inside curly quotes by the time the narrator is
#: done with it. R-034 puts one on every card and the design gives it the italic-gold device.
_BORROWED = re.compile(r"(&#34;|“)(.+?)(&#34;|”)", re.S)


def mark_borrowed(text: str) -> Markup:
    """Wrap an already-quoted span in `.borrowed`. TYPOGRAPHY ONLY.

    The text is escaped FIRST and the markup added second, so nothing a narrator or a fact body
    contains can inject an element. A card with no quotation renders unchanged.
    """
    return Markup(_BORROWED.sub(
        lambda m: f'<span class="borrowed">{m.group(1)}{m.group(2)}{m.group(3)}</span>',
        str(escape(text or ""))))


def card_banner(member: dict | None, label: dict | None, state: str, *,
                industry_labels: dict, vocabulary: dict) -> tuple[str, str]:
    """(eyebrow, subtitle) for the card banner.

    The banner is about the PERSON, in every state where there is one — including the degraded
    ones. A withheld card still opens on "Foundry · General Partner / Brad Feld"; the reason it is
    withheld belongs in the body, next to the gate that failed, not stamped over someone's name.

    Only `not_found` has no member, and only there does the state supply the words.
    """
    if member is None:
        return STATE_COPY["not_found"]
    eyebrow = affiliation_line((label or {}).get("current_label") or "", max_parts=2)
    subtitle = subject_subtitle(member, industry_labels=industry_labels, vocabulary=vocabulary)
    if not eyebrow:
        # No measured label. The industry is the next most specific true thing; the club is the
        # last. Never the supplied door label — that is the hint this engine exists to verify.
        eyebrow = " · ".join(
            industry_labels[s] for s in (member.get("industries") or []) if s in industry_labels)
    if not eyebrow:
        eyebrow = "Arena Hall · Austin, Texas"
    if not subtitle:
        subtitle = STATE_COPY.get(state, ("", ""))[1]
    return eyebrow, subtitle


def card_state(digest: dict, *, present_count: int, renderable_count: int) -> str:
    """Choose the card state. Order matters: the most restrictive answer wins.

    There is no opt-out state. Members are never told this service exists, so none of them has
    ever been in a position to decline it, and a card announcing that one had was describing
    something that never happened (DEC-15).
    """
    if digest.get("card_state") == "withheld":
        return "withheld"
    if not digest.get("gates_passed"):
        # A thin profile is a withheld card with a KNOWN cause: there was not enough sourced
        # material to carry the band, and nothing was invented to close the gap (R-041).
        # A card that came out SHORT ran out of sourced material; a card that came out long is a
        # composition failure. Only the first one is a thin profile, and it is not a defect.
        short = next((g for g in digest.get("gate_failures", [])
                      if g["gate"] == "word_count_in_band"
                      and (g.get("observed") or 0) < (g.get("allowed") or [250])[0]), None)
        if short is not None:
            return "thin_profile"
        return "withheld"
    if present_count == 0:
        return "empty_room"
    if (digest.get("recency") or {}).get("recency_state") == "unknown":
        return "unknown_coverage"
    if (digest.get("recency") or {}).get("recency_state") == "cold":
        return "cold_trail"
    if digest.get("surfaced_count", 0) == 0:
        return "no_strong_match"
    return "ready"


def why_view(arriving: dict, other: dict, *, forward, reverse, excluded_topics, names) -> dict:
    """R-046. Fired signals with weights, the ones that did NOT fire and why, the excluded generic
    topics with their share of the stored member base, and the reverse-direction score.

    This is the whole answer to "expose the reasoning", and it is one tap from Room — never on the
    card, where it would turn a host into a scorer (DEC-2).
    """
    return {
        "from_name": names.get(arriving["id"], arriving["id"]),
        "to_name": names.get(other["id"], other["id"]),
        "score": forward.score,
        "score_excluding_s8": forward.score_excluding_s8(),
        "ceiling": 16,
        "fired": [s.as_dict() for s in sorted(forward.fired, key=lambda s: s.signal_id)],
        "not_fired": sorted(forward.not_fired, key=lambda s: s["signal_id"]),
        "reverse_score": reverse.score,
        "reverse_fired": [s.as_dict() for s in sorted(reverse.fired, key=lambda s: s.signal_id)],
        "excluded_topics": excluded_topics,
        "large_count": forward.large_count,
    }
