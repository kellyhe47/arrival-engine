"""The scoring oracle. `docs/scoring-model.md` is normative; this file is its executable form.

Everything here is DETERMINISTIC. No model output reaches this module, and nothing in it consults
the room to decide what a topic means (R-019: genericity is a property of the vocabulary).
"""
from __future__ import annotations

from dataclasses import dataclass, field

BUCKET = {"SMALL": 1, "MID": 2, "LARGE": 3}

#: A signal fires at its full bucket weight or contributes zero. There are no partial firings.
WEIGHTS = {"S1": 2, "S2": 2, "S3": 3, "S4": 3, "S5": 3, "S6": 1, "S7": 3, "S8": 1}

#: S8 may not fire unless one of these has already fired (R-018, B-003). Prominence may break a
#: tie; it may never create a match.
SUBSTRATE = frozenset({"S2", "S3", "S5", "S7"})

#: S2 and S3 are mutually exclusive, so the ceiling takes the larger of the two.
CEILING = (
    WEIGHTS["S1"] + max(WEIGHTS["S2"], WEIGHTS["S3"]) + WEIGHTS["S4"]
    + WEIGHTS["S5"] + WEIGHTS["S6"] + WEIGHTS["S7"] + WEIGHTS["S8"]
)

LARGE_SIGNALS = frozenset(s for s, w in WEIGHTS.items() if w == BUCKET["LARGE"])

SIGNAL_NAMES = {
    "S1": "peer tier and cohort",
    "S2": "same-industry adjacency",
    "S3": "cross-industry complementarity",
    "S4": "life-context overlap",
    "S5": "directed declared link",
    "S6": "shared personal interest",
    "S7": "shared professional thesis",
    "S8": "status gradient",
}


@dataclass(frozen=True)
class Signal:
    """One fired signal, with the one-line evidence string R-023 requires.

    `evidence` is written for the Why-this-score table — a host who is challenging the number and
    wants the slug. `detail` carries the same fact structurally, so `arena.reason` can phrase it
    for a sentence somebody says out loud without the card leaking internal vocabulary.
    """

    signal_id: str
    weight: int
    evidence: str
    detail: dict = field(default_factory=dict)

    def as_dict(self) -> dict:
        return {"signal_id": self.signal_id, "weight": self.weight,
                "evidence": self.evidence, "detail": self.detail}


@dataclass(frozen=True)
class PairScore:
    score: int
    fired: tuple[Signal, ...]
    not_fired: tuple[dict, ...] = field(default=())

    @property
    def signal_ids(self) -> set[str]:
        return {s.signal_id for s in self.fired}

    @property
    def large_count(self) -> int:
        return sum(1 for s in self.fired if s.weight == BUCKET["LARGE"])

    def score_excluding_s8(self) -> int:
        return self.score - (WEIGHTS["S8"] if "S8" in self.signal_ids else 0)

    def as_dict(self) -> dict:
        return {"score": self.score, "fired_signals": [s.as_dict() for s in sorted(
            self.fired, key=lambda s: s.signal_id)]}


def canonical_topics(topics, aliases: dict | None = None) -> set[str]:
    """Fold topic aliases onto their canonical slug (`topic_alias` in the store).

    `seed-stage-investing` and `seed-stage-financing` are the same thesis written twice; scoring
    them as different tags silently deletes a real match.
    """
    aliases = aliases or {}
    return {aliases.get(t, t) for t in (topics or [])}


def _contexts(member) -> set[tuple]:
    """Context keys that may match for S4.

    `resolved = 0` never matches. A caption is a CLAIM, not a geotag: "In Venice this week" is
    ambiguous between Venice CA and Venice Italy and the same profile supports both (AUD-07-6).
    """
    out = set()
    for c in member.get("contexts") or []:
        if int(c.get("resolved", 1)) == 0:
            continue
        out.add((c.get("type"), c.get("value")))
    return out


def score_pair(
    a: dict,
    b: dict,
    *,
    excluded_topics: frozenset[str] = frozenset(),
    aliases: dict | None = None,
    s8_requires_substrate: bool = True,
) -> PairScore:
    """`score(a -> b)` — how much A should want to meet B. Not symmetric.

    `excluded_topics` are the non-discriminating tags (R-019). They are removed from the S3, S6 and
    S7 tests ONLY: the gate is on which topics count, never on how much a signal is worth.
    """
    fired: list[Signal] = []
    not_fired: list[dict] = []

    def miss(sid: str, why: str) -> None:
        not_fired.append({"signal_id": sid, "name": SIGNAL_NAMES[sid],
                          "weight": WEIGHTS[sid], "why_not": why})

    ia = set(a.get("industries") or [])
    ib = set(b.get("industries") or [])
    tpa = canonical_topics(a.get("topics_professional"), aliases) - excluded_topics
    tpb = canonical_topics(b.get("topics_professional"), aliases) - excluded_topics
    tsa = canonical_topics(a.get("topics_personal"), aliases) - excluded_topics
    tsb = canonical_topics(b.get("topics_personal"), aliases) - excluded_topics
    ca, cb = _contexts(a), _contexts(b)

    # S1 — peer tier AND cohort. Both conditions required; `rank` is display order, never distance.
    tier_a, tier_b = a.get("seniority_tier"), b.get("seniority_tier")
    dec_a, dec_b = a.get("career_start_decade"), b.get("career_start_decade")
    if tier_a is not None and tier_a == tier_b and dec_a is not None and dec_a == dec_b:
        fired.append(Signal("S1", WEIGHTS["S1"], f"both {tier_a}, both started in the {dec_a}",
                            {"tier": tier_a, "decade": dec_a}))
    elif dec_a is None or dec_b is None:
        miss("S1", "career start decade is unmeasured for at least one of them, so cohort "
                   "cannot be compared — absence is not a match")
    elif tier_a != tier_b:
        miss("S1", f"different seniority tier ({tier_a} vs {tier_b})")
    else:
        miss("S1", f"different career-start decade ({dec_a} vs {dec_b})")

    # S2 / S3 are mutually exclusive by construction.
    shared_industry = sorted(ia & ib)
    shared_prof = sorted(tpa & tpb)
    if shared_industry:
        fired.append(Signal("S2", WEIGHTS["S2"], f"both work in {shared_industry[0]}",
                            {"industry": shared_industry[0]}))
        miss("S3", "same industry, so complementarity cannot apply (S2 and S3 are exclusive)")
    else:
        miss("S2", "no industry in common")
        if shared_prof:
            fired.append(Signal("S3", WEIGHTS["S3"],
                                f"different industries, shared thesis: {shared_prof[0]}",
                                {"topic": shared_prof[0]}))
        else:
            miss("S3", "different industries but no professional topic in common")

    # S4 — life-context overlap. Never "they are both at the club tonight" (R-016 note).
    shared_ctx = sorted(ca & cb)
    if shared_ctx:
        fired.append(Signal("S4", WEIGHTS["S4"],
                            f"shared {shared_ctx[0][0]}: {shared_ctx[0][1]}",
                            {"type": shared_ctx[0][0], "value": shared_ctx[0][1]}))
    else:
        miss("S4", "no measured place, institution, life event or pursuit in common")

    # S5 — directed. A follows / has cited / has publicly named B, in A's own words.
    link = next((l for l in (a.get("declared_links") or []) if l.get("to") == b.get("id")), None)
    if link:
        fired.append(Signal("S5", WEIGHTS["S5"],
                            f"{link.get('kind', 'declared link')} -> {b.get('id')}",
                            {"kind": link.get("kind", "declared_link")}))
    else:
        miss("S5", "no declared link from them to this person")

    shared_personal = sorted(tsa & tsb)
    if shared_personal:
        fired.append(Signal("S6", WEIGHTS["S6"], f"both: {shared_personal[0]}",
                            {"topic": shared_personal[0]}))
    else:
        miss("S6", "no personal interest in common")

    if shared_prof:
        fired.append(Signal("S7", WEIGHTS["S7"], f"both return to {shared_prof[0]}",
                            {"topic": shared_prof[0]}))
    else:
        miss("S7", "no professional topic in common")

    # S8 — status gradient. Two rules, both required (R-018).
    pa, pb = a.get("prominence_tier"), b.get("prominence_tier")
    substrate_fired = bool({s.signal_id for s in fired} & SUBSTRATE)
    if pa is None or pb is None:
        miss("S8", "prominence is unmeasured for at least one of them; absence is not tier 1")
    elif not pb > pa:
        miss("S8", f"no gradient (tier {pb} is not above tier {pa})")
    elif s8_requires_substrate and not substrate_fired:
        miss("S8", "prominence without substrate — S8 may break a tie, never create a match")
    else:
        fired.append(Signal("S8", WEIGHTS["S8"], f"prominence tier {pb} above tier {pa}",
                            {"from": pa, "to": pb}))

    total = sum(s.weight for s in fired)
    return PairScore(score=total, fired=tuple(fired), not_fired=tuple(not_fired))


def surfaces(pair: PairScore, *, minimum: int = 6,
             requires_any_of=("S3", "S5", "S7")) -> bool:
    """The introduction floor (R-020).

    The threshold is evaluated on the score EXCLUDING S8. The displayed score still includes it.
    Below the floor nobody is named — not as primary, not as backup.
    """
    return pair.score_excluding_s8() >= minimum and bool(pair.signal_ids & set(requires_any_of))


def excluded_topic_records(vocabulary: dict) -> list[dict]:
    """Non-discriminating topics, read from the controlled vocabulary. Room-independent.

    Reported rather than silently applied, so the exclusion is visible in Why-this-score.
    """
    out = []
    for slug in sorted(vocabulary or {}):
        v = vocabulary[slug] or {}
        if v.get("discriminating", True):
            continue
        rec = {"topic": slug, "discriminating": False}
        if "holder_count" in v:
            rec["holder_count"] = v["holder_count"]
        if "base_size" in v:
            rec["base_size"] = v["base_size"]
        out.append(rec)
    return out


def excluded_topic_slugs(vocabulary: dict) -> frozenset[str]:
    return frozenset(r["topic"] for r in excluded_topic_records(vocabulary))
