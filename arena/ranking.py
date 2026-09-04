"""Ordering the room: the R-022a pipeline, and the three tie-break tiers.

The order of operations, verbatim from the PRD:

    1. Score every pair in the room, both directions, S1–S8.
    2. Drop everything below the floor.
    3. Class every survivor. I8 on either side means open.
    4. Rank: complement, then parallel, then open / neutral / unknown on score, guarded last.
    5. Add S9 to the displayed score where the class is complement. The floor excludes it.
    6. Write the reason from the intent, not the overlap.

Tie-break tier 2 is the one with the trap. Signals are computed from member attribute SETS, which
carry no dates — only facts have `source_date`. So a fired signal's date comes from the fact
backing it, and a match's recency is the LATEST such date across its fired signals. S8 is EXCLUDED
from that maximum: its date is when a follower count was last read, not a dated event between two
people, and including it makes every match tie at today's date, silently collapsing tier 2 into
tier 3.
"""
from __future__ import annotations

import functools

from .scoring import (PairScore, WEIGHTS, excluded_topic_records, excluded_topic_slugs,
                      score_pair, surfaces)

#: R-022a step 4. Complement first, parallel next, open/neutral/unknown together on score,
#: guarded last — ranked, never suppressed: the card names the asymmetry instead.
CLASS_ORDER = {"complement": 0, "parallel": 1, "open": 2, "neutral": 2, "unknown": 2, "guarded": 3}


def evidence_recency(signal_evidence: dict, member_id: str, fired_ids: set[str]) -> str | None:
    """Latest evidence date across a match's fired signals, or None when undated.

    S8 is excluded (see the module docstring). Undated on either side falls through to tier 3
    rather than guessing an order.
    """
    ev = (signal_evidence or {}).get(member_id) or {}
    dates = [d for sig, d in ev.items() if d and sig != "S8" and sig in fired_ids]
    return max(dates) if dates else None


def _compare(x: dict, y: dict):
    """Total order over matches.

    Surfaced matches come first, ordered by intent class (R-022a.4), then score desc, then the
    tie-break tiers. Below-floor matches trail in plain score order — they are listed for honesty
    on Why-this-score, never named.
    """
    if x["surfaced"] != y["surfaced"]:
        return -1 if x["surfaced"] else 1
    if x["surfaced"] and x["_class_order"] != y["_class_order"]:
        return -1 if x["_class_order"] < y["_class_order"] else 1
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
    signal_evidence: dict | None = None,
    aliases: dict | None = None,
) -> dict:
    """Score every present member against the arriving member and order them.

    Every member present is a candidate. There is no opt-out to honour: members are never told
    this service exists, so they have never been in a position to decline it (DEC-15).
    R-055: people reached by traversal (`is_member = 0`) are never scored and never surfaced.
    """
    excluded_records = excluded_topic_records(settings.vocabulary)
    excluded = excluded_topic_slugs(settings.vocabulary)

    candidates: list[dict] = []
    for b in present:
        if b.get("id") == arriving.get("id"):
            continue
        if b.get("is_member") == 0:
            continue                           # R-055: never scored, never surfaced
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
            # R-022a.5: the displayed score carries S9 where the class is complement. The floor
            # was already tested without it inside `surfaces`.
            "score": pair.display_score(),
            "intent_class": pair.intent_class,
            "surfaced": surfaces(pair, minimum=settings.surface_min_score,
                                 requires_any_of=settings.surface_requires_any_of),
            "fired_signals": pair.as_dict()["fired_signals"],
            "_large": pair.large_count,
            "_class_order": CLASS_ORDER.get(pair.intent_class, 2),
            "_recency": evidence_recency(signal_evidence or {}, b["id"], fired_ids),
            "_pair": pair,
        })

    matches.sort(key=functools.cmp_to_key(_compare))

    tie_broken_by = None
    for i in range(len(matches) - 1):
        hi, lo = matches[i], matches[i + 1]
        if hi["score"] == lo["score"] and hi["_class_order"] == lo["_class_order"]:
            tie_broken_by = _tier_that_decided(hi, lo)
            break

    ranked = []
    for i, m in enumerate(matches, start=1):
        ranked.append({
            "member_id": m["member_id"],
            "rank": i,
            "score": m["score"],
            "intent_class": m["intent_class"],
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
        # R-038: exactly one candidate is named. An empty or all-below-floor room is an honest
        # absence, never an error and never a forced recommendation.
        "room_block_kind": "match" if surfaced_count else "honest_absence",
        "_matches": matches,
    }


def seat_tables(present: list[dict], *, per: int, settings, aliases: dict | None = None,
                labels: dict | None = None) -> list[dict]:
    """R-062. Partition the present members into tables of `per`, in arrival order, and give each
    table a one-line reason built only from the measured edges INSIDE it.

    A trailing table of one merges into the previous table rather than seating anyone alone. A
    table with no measured edges says so and tells the host to stay. Seating reuses scored edges;
    it never invents one.
    """
    from .reason import _clause
    from .scoring import excluded_topic_slugs

    if per < 2 or len(present) < 2:
        return []
    excluded = excluded_topic_slugs(settings.vocabulary)

    groups: list[list[dict]] = [present[i:i + per] for i in range(0, len(present), per)]
    if len(groups) > 1 and len(groups[-1]) == 1:
        groups[-2].extend(groups.pop())

    def last(name: str) -> str:
        return name.split()[-1]

    tables = []
    for i, g in enumerate(groups, start=1):
        links: list[str] = []
        for x in range(len(g)):
            for y in range(x + 1, len(g)):
                a, b = g[x], g[y]
                found = None
                for src, dst in ((a, b), (b, a)):
                    pair = score_pair(src, dst, excluded_topics=excluded, aliases=aliases,
                                      s8_requires_substrate=settings.s8_requires_substrate)
                    fired = {s.signal_id: s for s in pair.fired}
                    for sid in ("S7", "S5", "S3", "S6"):    # substance first, strongest first
                        if sid in fired:
                            clause = _clause(fired[sid].as_dict(),
                                             last(src.get("display_name") or src["id"]),
                                             last(dst.get("display_name") or dst["id"]), labels)
                            if clause:
                                found = (src, dst, clause)
                                break
                    if found:
                        break
                if found:
                    src, dst, clause = found
                    links.append(f"{last(src.get('display_name') or src['id'])} and "
                                 f"{last(dst.get('display_name') or dst['id'])}: {clause}.")
        if links:
            why = " ".join(links[:2])
            extra = len(links) - 2
            if extra > 0:
                why += (f" Plus {extra} more measured link{'s' if extra != 1 else ''} "
                        f"at this table.")
        else:
            why = f"Nothing measured between these {len(g)}. A host should stay."
        tables.append({
            "number": i,
            "seats": len(g),
            "members": [m.get("display_name") or m["id"] for m in g],
            "why": why,
        })
    return tables


def mutuality(forward: PairScore, reverse: PairScore, *, minimum: int = 6,
              requires_any_of=("S3", "S5", "S6", "S7")) -> str:
    """Whether the pull runs both ways, for the card's Who's-here prose.

    The brokering machinery is retired (PRD R-022a); what the host physically does is carried in
    words backed by edges instead. `mutual` reads "leave them to it"; `one_way` reads "stay and
    carry the reason across"; `neither` never reaches a card, because nobody was named.
    """
    f_ok = surfaces(forward, minimum=minimum, requires_any_of=requires_any_of)
    r_ok = surfaces(reverse, minimum=minimum, requires_any_of=requires_any_of)
    if f_ok and r_ok:
        return "mutual"
    if f_ok or r_ok:
        return "one_way"
    return "neither"
