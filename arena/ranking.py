"""Ordering the room, and the three tie-break tiers.

Tier 2 is the one with the trap. Signals are computed from member attribute SETS, which carry no
dates — only facts have `source_date`. So a fired signal's date comes from the fact backing it, and
a match's recency is the LATEST such date across its fired signals. S8 is EXCLUDED from that
maximum: its date is when a follower count was last read, not a dated event between two people, and
including it makes every match tie at today's date, silently collapsing tier 2 into tier 3.
"""
from __future__ import annotations

import functools

from .scoring import PairScore, WEIGHTS, excluded_topic_records, excluded_topic_slugs, score_pair, surfaces


def evidence_recency(signal_evidence: dict, member_id: str, fired_ids: set[str]) -> str | None:
    """Latest evidence date across a match's fired signals, or None when undated.

    S8 is excluded (see the module docstring). Undated on either side falls through to tier 3
    rather than guessing an order.
    """
    ev = (signal_evidence or {}).get(member_id) or {}
    dates = [d for sig, d in ev.items() if d and sig != "S8" and sig in fired_ids]
    return max(dates) if dates else None


def _compare(x: dict, y: dict):
    """Total order over matches: score desc, LARGE count desc, evidence recency desc, id asc."""
    if x["score"] != y["score"]:
        return -1 if x["score"] > y["score"] else 1
    if x["_large"] != y["_large"]:
        return -1 if x["_large"] > y["_large"] else 1
    rx, ry = x["_recency"], y["_recency"]
    if rx is not None and ry is not None and rx != ry:
        return -1 if rx > ry else 1
    if x["member_id"] != y["member_id"]:
        return -1 if x["member_id"] < y["member_id"] else 1
    return 0


def _tier_that_decided(x: dict, y: dict) -> str:
    if x["_large"] != y["_large"]:
        return "large_signal_count_desc"
    rx, ry = x["_recency"], y["_recency"]
    if rx is not None and ry is not None and rx != ry:
        return "evidence_recency_desc"
    return "member_id_asc"


def rank_room(
    arriving: dict,
    present: list[dict],
    *,
    settings,
    flags: dict | None = None,
    signal_evidence: dict | None = None,
    aliases: dict | None = None,
) -> dict:
    """Score every present member against the arriving member and order them.

    P-3 / R-032 is honoured HERE, at scoring time, not at render time — so no digest is ever built
    and then discarded, and an opted-out member also disappears from OTHER members' Room blocks.
    R-055: people reached by traversal (`is_member = 0`) are never scored and never surfaced.
    """
    flags = flags or {}
    excluded_records = excluded_topic_records(settings.vocabulary)
    excluded = excluded_topic_slugs(settings.vocabulary)

    arriving_opted_out = bool((flags.get(arriving.get("id")) or {}).get("do_not_brief"))

    candidates: list[dict] = []
    if not arriving_opted_out:
        for b in present:
            if b.get("id") == arriving.get("id"):
                continue
            if b.get("is_member") == 0:
                continue                       # R-055: never scored, never surfaced
            if (flags.get(b.get("id")) or {}).get("do_not_brief"):
                continue                       # R-032: honoured before a pair is ever scored
            candidates.append(b)

    matches = []
    for b in candidates:
        pair = score_pair(
            arriving, b,
            excluded_topics=excluded,
            aliases=aliases,
            s8_requires_substrate=settings.s8_requires_substrate,
        )
        fired_ids = pair.signal_ids
        matches.append({
            "member_id": b["id"],
            "score": pair.score,
            "surfaced": surfaces(pair, minimum=settings.surface_min_score,
                                 requires_any_of=settings.surface_requires_any_of),
            "fired_signals": pair.as_dict()["fired_signals"],
            "_large": pair.large_count,
            "_recency": evidence_recency(signal_evidence or {}, b["id"], fired_ids),
            "_pair": pair,
        })

    matches.sort(key=functools.cmp_to_key(_compare))

    tie_broken_by = None
    for i in range(len(matches) - 1):
        hi, lo = matches[i], matches[i + 1]
        if hi["score"] == lo["score"]:
            tie_broken_by = _tier_that_decided(hi, lo)
            break

    ranked = []
    for i, m in enumerate(matches, start=1):
        ranked.append({
            "member_id": m["member_id"],
            "rank": i,
            "score": m["score"],
            "surfaced": m["surfaced"],
            "fired_signals": m["fired_signals"],
        })

    surfaced_count = sum(1 for m in ranked if m["surfaced"])
    return {
        "excluded_topics": excluded_records,
        "ranked_matches": ranked,
        "surfaced_count": surfaced_count,
        "pairs_scored": len(candidates),
        "tie_broken_by": tie_broken_by,
        # R-038: one primary, one backup, everyone else collapses. An empty or all-below-floor room
        # is an honest absence, never an error and never a forced recommendation.
        "room_block_kind": "match" if surfaced_count else "honest_absence",
        "_matches": matches,
    }


def brokering_mode(forward: PairScore, reverse: PairScore, *, minimum: int = 6,
                   requires_any_of=("S3", "S5", "S7")) -> str:
    """R-022. Computed from the S8-EXCLUDED surfacing scores, in precedence order.

    It changes what the host physically does: `mutual` means introduce and step away; `broker`
    means stay and carry the reason across.
    """
    f_ok = surfaces(forward, minimum=minimum, requires_any_of=requires_any_of)
    r_ok = surfaces(reverse, minimum=minimum, requires_any_of=requires_any_of)
    if f_ok and r_ok:
        return "mutual"
    gap = abs(forward.score_excluding_s8() - reverse.score_excluding_s8())
    if (f_ok or r_ok) and gap >= 6:
        return "broker"
    return "light_touch"
