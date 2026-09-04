"""View models — the ten card states, and the shape each surface renders.

`docs/ui-states.md` assigns every state its trigger, content, actions and exit. This module is that
table in code, so a state is chosen by rule rather than by whichever branch a template happened to
take. Nothing here decides anything a fixture asserts; it presents what the operations returned.
"""
from __future__ import annotations

import hashlib

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


STATE_COPY = {
    "ready": ("Ready", "Five blocks, under ninety seconds."),
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
    "do_not_brief": (
        "Do not brief",
        "This member has opted out of recognition. Name and role only, no score computed in "
        "either direction, and they are absent from other members' rooms."),
}


def card_state(digest: dict, *, present_count: int, renderable_count: int,
               opted_out: bool = False) -> str:
    """Choose the card state. Order matters: the most restrictive answer wins."""
    if opted_out:
        return "do_not_brief"
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
