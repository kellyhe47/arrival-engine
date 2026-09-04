"""The reason names only signals that actually fired (R-037, G-020) — and says it in English.

Two audiences, one source of truth. `Signal.evidence` is the slug-level string a host reads in the
Why-this-score table when they are challenging the number. `reason_sentence` phrases the SAME fired
signals for the card, where the words go out loud in a lobby and internal vocabulary would be
worse than no reason at all.

R-022a step 6: the reason is written from the INTENT, not the overlap. When the pair is a
complement, the S9 clause leads — "he has already built what she is trying to build" is the
sentence a host can actually use; "both hold I3" is not.

A reason that cites a connection the engine did not find is a hard gate failure, not a lint.
"""
from __future__ import annotations

GATE = "reason_cites_only_fired_signals"


def validate_reason(scored_pair: dict, narration: dict) -> dict:
    fired = {s["signal_id"] for s in (scored_pair.get("fired_signals") or [])}
    cited = list(narration.get("cited_signal_ids") or [])
    unfired = sorted(set(cited) - fired)
    result = {"valid": not unfired}
    # `observed` is what the reason wrongly cited; `allowed` is what actually fired — the shape
    # the R-061 gate table reads ("Reason cites fired only · S8 · S1, S2, S5").
    # `unfired_cited` stays for the fixtures that assert it by name.
    result["gate_failures"] = (
        [{"gate": GATE, "unfired_cited": unfired,
          "observed": ", ".join(unfired), "allowed": ", ".join(sorted(fired)) or "none"}]
        if unfired else [])
    return result


def humanize(slug: str | None, labels: dict | None = None) -> str:
    """A stored slug, said out loud. Prefers the vocabulary's own label when there is one."""
    if not slug:
        return ""
    label = (labels or {}).get(slug)
    if label:
        return label[0].lower() + label[1:]
    return str(slug).replace("-", " ").replace("_", " ")


#: How a declared link (S7) is said out loud. The edge type is the fact; this is the sentence.
_LINK_PHRASE = {
    "cited_in_own_writing": "{a} has cited {b} in print",
    "co_mention": "{a} has named {b} alongside their own work",
    "repost": "{a} has reposted {b}",
    "follows": "{a} follows {b}",
}

_CONTEXT_PHRASE = {
    "place": "both are tied to {value}",
    "institution": "both have been at {value}",
    "life_event": "both were part of {value}",
}

#: How B's measured intent completes A's, said as one clause. Keyed on B's intent — the thing B
#: has done is what makes the introduction worth interrupting someone for.
_COMPLEMENT_PHRASE = {
    "I1": "{b} deploys exactly the capital {a} is out raising",
    "I6": "{b} opens the doors {a} is looking for",
    "I4": "{b} has written the body of work {a} is learning from",
    "I7": "{b} has already built one and stepped back from it",
}

#: Ordered by how much a host can actually open with. Intent first (R-022a.6), then a declared
#: link, then substance, then demographics. Prominence is never offered as a reason at all.
_PRIORITY = ("S9", "S7", "S5", "S3", "S6", "S4", "S2", "S1")


def _clause(signal: dict, a_name: str, b_name: str, labels: dict | None) -> str | None:
    """One clause naming one fired signal, with no pronoun guessed about anybody."""
    sid = signal["signal_id"]
    d = signal.get("detail") or {}
    if sid == "S9":
        template = _COMPLEMENT_PHRASE.get(d.get("b_intent"))
        if template:
            return template.format(a=a_name, b=b_name)
        return f"{b_name} has already done what {a_name} is setting out to do"
    if sid == "S7":
        return _LINK_PHRASE.get(d.get("kind"), "{a} has publicly named {b}").format(
            a=a_name, b=b_name)
    if sid == "S5":
        return f"both keep returning to {humanize(d.get('topic'), labels)}"
    if sid == "S3":
        return _CONTEXT_PHRASE.get(d.get("type"), "both share {value}").format(
            value=humanize(d.get("value"), labels))
    if sid == "S6":
        return f"both are into {humanize(d.get('topic'), labels)}"
    if sid == "S4":
        return f"both have spent time inside {humanize(d.get('value'), labels)}"
    if sid == "S2":
        return f"same seniority, same cohort — both started in the {d.get('decade')}"
    if sid == "S1":
        return f"both are in {humanize(d.get('industry'), labels)}"
    return None                                  # S8 is never offered to a host as a reason


def _ordered(fired_signals: list[dict]) -> list[dict]:
    by_id = {s["signal_id"]: s for s in fired_signals}
    return [by_id[sid] for sid in _PRIORITY if sid in by_id]


def reason_sentence(fired_signals: list[dict], display_name: str, labels: dict | None = None,
                    arriving_name: str = "They", limit: int = 3) -> str:
    """Reason first, score small. Names only what fired, and at most three things."""
    clauses = [c for c in (_clause(s, arriving_name, display_name, labels)
                           for s in _ordered(fired_signals)) if c][:limit]
    if not clauses:
        return f"Nothing measured between them and {display_name}."
    body = clauses[0] if len(clauses) == 1 else \
        f"{', '.join(clauses[:-1])}, and {clauses[-1]}"
    return f"{display_name} is here: {body}."


def say_context(fired_signals: list[dict], display_name: str, labels: dict | None = None,
                arriving_name: str = "They") -> dict:
    """Select the material for the Say line without attempting to write it.

    Everything measured rides along — every fired clause, not just the strongest — so the model
    has enough to be specific with. `arena.card` adds the personal detail and the recent-activity
    line before the narrator fires (operator, 2026-09-04: one clause produced generic lines).
    """
    clauses = [c for c in (_clause(s, arriving_name, display_name, labels)
                           for s in _ordered(fired_signals)) if c]
    return {
        "arriving_member": arriving_name,
        "person_here": display_name,
        "useful_fact": clauses[0] if clauses else f"{display_name} is here tonight",
        "measured_reasons": clauses,
    }


def cited_signal_ids(fired_signals: list[dict]) -> list[str]:
    return sorted(s["signal_id"] for s in fired_signals)
