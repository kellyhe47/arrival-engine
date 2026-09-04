"""The scoring oracle. PRD §4 (re-baselined 2026-09-04 against the prototype) is normative;
this file is its executable form.

Everything here is DETERMINISTIC. No model output reaches this module, and nothing in it consults
the room to decide what a topic means (R-019: genericity is a property of the vocabulary).

The 2026-09-04 signal set (R-016):

    S1  same industry                          MID 2
    S2  comparable seniority + same decade     MID 2
    S3  shared context (place/institution/     LARGE 3
        programme)
    S4  overlapping organisation history       SMALL 1
    S5  shared professional topic, generics    LARGE 3
        excluded
    S6  shared personal topic                  MID 2
    S7  declared link (directed)               LARGE 3
    S8  status gradient (directed)             SMALL 1   — tie-break/display only
    S9  intent complement (directed)           LARGE 3   — display only, complement class

Ceiling = S1..S7 = 16 (R-017). The floor is evaluated over S1..S7, excluding S8 and S9 (R-020).
S9 is added to the DISPLAYED score only when the pair's intent class is complement (R-022a.5).
"""
from __future__ import annotations

from dataclasses import dataclass, field

BUCKET = {"SMALL": 1, "MID": 2, "LARGE": 3}

#: A signal fires at its full bucket weight or contributes zero. There are no partial firings.
WEIGHTS = {"S1": 2, "S2": 2, "S3": 3, "S4": 1, "S5": 3, "S6": 2, "S7": 3, "S8": 1, "S9": 3}

#: The floor's qualifying set (R-020): a shared context, topic, personal interest or declared
#: link. S1/S2/S4 are demographics, and demographics alone never name anyone. The same set gates
#: S8 when `s8_requires_substrate` is on: prominence may break a tie, never create a match.
SUBSTRATE = frozenset({"S3", "S5", "S6", "S7"})

#: R-017. The sum of S1–S7. S8 is outside the ceiling (tie-break and display only); S9 is outside
#: both the ceiling and the floor (displayed only for complement-class pairs).
CEILING = sum(WEIGHTS[s] for s in ("S1", "S2", "S3", "S4", "S5", "S6", "S7"))

LARGE_SIGNALS = frozenset(s for s, w in WEIGHTS.items() if w == BUCKET["LARGE"])

SIGNAL_NAMES = {
    "S1": "same industry",
    "S2": "seniority and cohort",
    "S3": "shared context",
    "S4": "organisation history",
    "S5": "shared professional topic",
    "S6": "shared personal topic",
    "S7": "declared link",
    "S8": "status gradient",
    "S9": "intent complement",
}

# ── intent (R-022) ────────────────────────────────────────────────────────────
#: Every member carries one intent for the evening, measured from evidence, never assumed.
#: I0 is the honest default: coverage incomplete, never read as I8.
INTENTS = {
    "I0": "unknown — coverage incomplete",
    "I1": "deploying capital",
    "I2": "raising or being backed",
    "I3": "building an institution",
    "I4": "publishing a body of work",
    "I5": "learning a domain",
    "I6": "giving access",
    "I7": "stepping back",
    "I8": "being social — attendance without an agenda",
}

#: "B has done what A is trying to do." The map is the policy: each key is A's measured intent,
#: the values are the B intents that complete it. Kept deliberately small — a complement the map
#: does not name is a parallel or a neutral, never a guess.
INTENT_COMPLEMENTS = {
    "I2": frozenset({"I1", "I6"}),   # raising meets deploying capital, or someone giving access
    "I5": frozenset({"I4", "I6"}),   # learning a domain meets a published body of work
    "I3": frozenset({"I7"}),         # building an institution meets someone who built and stepped back
}

#: The asymmetric-ask intents. A guarded pairing is one of these pointed at someone stepping
#: back: the pull is real, and the host should know it runs one way (R-022, guarded class).
_ASKS = frozenset({"I2", "I5"})


def intent_class(a_intent: str | None, b_intent: str | None) -> str:
    """R-022. The pair's intent class for one intent per side. Deterministic given stored intents.

    Precedence: unknown (I0 on either side, never read as I8) > open (I8 on either side) >
    complement > guarded > parallel > neutral.
    """
    a = a_intent or "I0"
    b = b_intent or "I0"
    if a == "I0" or b == "I0":
        return "unknown"
    if a == "I8" or b == "I8":
        return "open"
    if b in INTENT_COMPLEMENTS.get(a, ()):
        return "complement"
    if (a in _ASKS and b == "I7") or (b in _ASKS and a == "I7"):
        return "guarded"
    if a == b:
        return "parallel"
    return "neutral"


def member_intents(m: dict) -> list[str]:
    """The member's measured intents — at most two (R-022b). Empty reads as I0."""
    return [i for i in (m.get("intent"), m.get("intent_secondary")) if i]


#: R-022a: with two intents per side, I0 and I8 are whole-member states checked first; then the
#: class is the best available across the combinations, in this order.
_CLASS_BEST = ("complement", "guarded", "parallel", "neutral")


def pair_intent_class(a_intents: list[str], b_intents: list[str]) -> str:
    """The pair's class across up to two intents per side."""
    if not a_intents or not b_intents or "I0" in a_intents or "I0" in b_intents:
        return "unknown"
    if "I8" in a_intents or "I8" in b_intents:
        return "open"
    found = {intent_class(ai, bi) for ai in a_intents for bi in b_intents}
    for klass in _CLASS_BEST:
        if klass in found:
            return klass
    return "neutral"


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
    """`score` sums the fired S1–S8 signals. S9 lives beside it: `display_score()` adds it only
    when the intent class is complement, and `floor_score()` excludes both S8 and S9 (R-020)."""

    score: int
    fired: tuple[Signal, ...]
    not_fired: tuple[dict, ...] = field(default=())
    intent_class: str = "unknown"
    s9: Signal | None = None

    @property
    def signal_ids(self) -> set[str]:
        return {s.signal_id for s in self.fired}

    @property
    def large_count(self) -> int:
        return sum(1 for s in self.fired if s.weight == BUCKET["LARGE"])

    def score_excluding_s8(self) -> int:
        return self.score - (WEIGHTS["S8"] if "S8" in self.signal_ids else 0)

    def floor_score(self) -> int:
        """The number the floor reads: S1–S7 only. S9 never reaches it by construction —
        `score` does not include S9."""
        return self.score_excluding_s8()

    def display_score(self) -> int:
        """R-022a step 5: add S9 to the displayed score where the class is complement."""
        return self.score + (self.s9.weight if self.s9 else 0)

    def display_fired(self) -> tuple[Signal, ...]:
        """Fired signals as displayed — S9 included when it fired."""
        return self.fired + ((self.s9,) if self.s9 else ())

    def as_dict(self) -> dict:
        return {"score": self.display_score(),
                "intent_class": self.intent_class,
                "fired_signals": [s.as_dict() for s in sorted(
                    self.display_fired(), key=lambda s: s.signal_id)]}


def canonical_topics(topics, aliases: dict | None = None) -> set[str]:
    """Fold topic aliases onto their canonical slug (`topic_alias` in the store).

    `seed-stage-investing` and `seed-stage-financing` are the same thesis written twice; scoring
    them as different tags silently deletes a real match.
    """
    aliases = aliases or {}
    return {aliases.get(t, t) for t in (topics or [])}


#: Context types S3 reads: a place, an institution, a programme (stored as `life_event` — YC
#: S2005 is the measured example). Never an assumed geography, never "both at the club tonight".
_S3_CONTEXT_TYPES = frozenset({"place", "institution", "life_event"})

#: S4 reads overlapping organisation history only.
_S4_CONTEXT_TYPES = frozenset({"organisation"})

#: A pursuit context ("ultrarunning") is a personal topic that happened to be measured as a
#: context; S6 reads it alongside `topics_personal` so the storage shape does not decide the score.
_S6_CONTEXT_TYPES = frozenset({"pursuit"})


def _contexts(member, types: frozenset[str]) -> set[tuple]:
    """Context keys of the given types. `resolved = 0` never matches: a caption is a CLAIM, not a
    geotag — "In Venice this week" supports Venice CA and Venice Italy equally (AUD-07-6)."""
    out = set()
    for c in member.get("contexts") or []:
        if int(c.get("resolved", 1)) == 0:
            continue
        if c.get("type") not in types:
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

    `excluded_topics` are the non-discriminating tags (R-019). They are removed from the topic
    signals S5 and S6 ONLY: the gate is on which topics count, never on how much a signal is worth.
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

    # S1 — same industry, bucketed. Establishes context; does not carry a match (R-020).
    shared_industry = sorted(ia & ib)
    if shared_industry:
        fired.append(Signal("S1", WEIGHTS["S1"], f"both work in {shared_industry[0]}",
                            {"industry": shared_industry[0]}))
    else:
        miss("S1", "no industry in common")

    # S2 — peer tier AND cohort. Both conditions required; `rank` is display order, never distance.
    tier_a, tier_b = a.get("seniority_tier"), b.get("seniority_tier")
    dec_a, dec_b = a.get("career_start_decade"), b.get("career_start_decade")
    if tier_a is not None and tier_a == tier_b and dec_a is not None and dec_a == dec_b:
        fired.append(Signal("S2", WEIGHTS["S2"], f"both {tier_a}, both started in the {dec_a}",
                            {"tier": tier_a, "decade": dec_a}))
    elif dec_a is None or dec_b is None:
        miss("S2", "career start decade is unmeasured for at least one of them, so cohort "
                   "cannot be compared — absence is not a match")
    elif tier_a != tier_b:
        miss("S2", f"different seniority tier ({tier_a} vs {tier_b})")
    else:
        miss("S2", f"different career-start decade ({dec_a} vs {dec_b})")

    # S3 — shared context: a place, institution or programme, measured. Never "they are both at
    # the club tonight", which is true of everyone in the room and carries no information.
    ca3 = _contexts(a, _S3_CONTEXT_TYPES)
    cb3 = _contexts(b, _S3_CONTEXT_TYPES)
    shared_ctx = sorted(ca3 & cb3)
    if shared_ctx:
        ctx_type = str(shared_ctx[0][0]).replace("_", " ")
        fired.append(Signal("S3", WEIGHTS["S3"],
                            f"shared {ctx_type}: {shared_ctx[0][1]}",
                            {"type": shared_ctx[0][0], "value": shared_ctx[0][1]}))
    else:
        places = sorted(v for t, v in ca3 | cb3 if t == "place")
        detail = f" ({' vs '.join(places[:2])})" if len(places) >= 2 else ""
        miss("S3", f"no measured place, institution or programme in common{detail}")

    # S4 — overlapping organisation history.
    shared_org = sorted(_contexts(a, _S4_CONTEXT_TYPES) & _contexts(b, _S4_CONTEXT_TYPES))
    if shared_org:
        fired.append(Signal("S4", WEIGHTS["S4"], f"overlapping history at {shared_org[0][1]}",
                            {"value": shared_org[0][1]}))
    else:
        miss("S4", "no overlapping organisation history in the stored record")

    # S5 — a specific professional topic held by both, generics already excluded.
    shared_prof = sorted(tpa & tpb)
    if shared_prof:
        fired.append(Signal("S5", WEIGHTS["S5"], f"both hold {shared_prof[0]}",
                            {"topic": shared_prof[0]}))
    else:
        miss("S5", "no professional topic in common once generics are excluded")

    # S6 — a personal topic in common. Pursuit contexts count alongside stored personal topics.
    psa = tsa | {v for _, v in _contexts(a, _S6_CONTEXT_TYPES)} - excluded_topics
    psb = tsb | {v for _, v in _contexts(b, _S6_CONTEXT_TYPES)} - excluded_topics
    shared_personal = sorted(psa & psb)
    if shared_personal:
        fired.append(Signal("S6", WEIGHTS["S6"], f"both: {shared_personal[0]}",
                            {"topic": shared_personal[0]}))
    else:
        examples = ""
        if (tsa or psa) and (tsb or psb):
            ea, eb = sorted(psa or tsa)[:1], sorted(psb or tsb)[:1]
            if ea and eb:
                examples = f" ({ea[0]} vs {eb[0]})"
        miss("S6", f"no personal topic in common{examples}")

    # S7 — directed. A cites, follows or has written about B, in A's own words.
    link = next((l for l in (a.get("declared_links") or []) if l.get("to") == b.get("id")), None)
    if link:
        kind = str(link.get("kind", "declared link")).replace("_", " ")
        b_name = b.get("display_name") or b.get("id")
        fired.append(Signal("S7", WEIGHTS["S7"],
                            f"{kind} -> {b_name}",
                            {"kind": link.get("kind", "declared_link")}))
    else:
        miss("S7", "no declared link from them to this person")

    # S8 — status gradient. Fires only when B's tier is strictly above A's, and (when the
    # substrate rule is on) only with real substrate under it. Tie-break and display only either
    # way: the floor never reads it (R-018).
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

    # S9 — intent complement. Directed, display-only, and carried beside the base score so the
    # floor can never read it (R-017/R-022a.5). Each side may hold two intents (R-022b).
    a_intents = member_intents(a)
    b_intents = member_intents(b)
    klass = pair_intent_class(a_intents, b_intents)
    s9 = None
    if klass == "complement":
        a_i, b_i = next((ai, bi) for ai in a_intents for bi in b_intents
                        if intent_class(ai, bi) == "complement")
        s9 = Signal("S9", WEIGHTS["S9"],
                    f"{INTENTS.get(b_i, b_i)} meets {INTENTS.get(a_i, a_i)}",
                    {"a_intent": a_i, "b_intent": b_i})
    elif klass == "unknown":
        miss("S9", "intent is unknown (I0) on at least one side; never read as being social")
    elif klass == "open":
        miss("S9", "one side is here to be social (I8); ranked on score alone")
    elif klass == "parallel":
        shared = next((i for i in a_intents if i in b_intents), a_intents[0])
        miss("S9", f"both hold {shared}, {INTENTS.get(shared, shared)} — "
                   f"parallel, not complement")
    elif klass == "guarded":
        miss("S9", "the intents pull one way — an ask pointed at someone stepping back; "
                   "ranked last, and the card names the asymmetry")
    else:
        miss("S9", f"no intent relation ({' / '.join(a_intents)} against "
                   f"{' / '.join(b_intents)})")

    total = sum(s.weight for s in fired)
    return PairScore(score=total, fired=tuple(fired), not_fired=tuple(not_fired),
                     intent_class=klass, s9=s9)


def surfaces(pair: PairScore, *, minimum: int = 0,
             requires_any_of=("S3", "S5", "S6", "S7")) -> bool:
    """The surfacing test (R-020).

    The 6-point floor is removed (operator, 2026-09-04): a match surfaces on SUBSTANCE — at
    least one non-demographic signal (a shared context, topic, personal interest or declared
    link) must have fired. Demographics alone still never name anyone. A numeric `minimum`
    survives as configuration only, evaluated on S1–S7 with S8 and S9 excluded.
    """
    return pair.floor_score() >= minimum and bool(pair.signal_ids & set(requires_any_of))


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
