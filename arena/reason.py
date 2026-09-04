"""The reason names only signals that actually fired (R-037, G-020) — and says it in English.

Two audiences, one source of truth. `Signal.evidence` is the slug-level string a host reads in the
Why-this-score table when they are challenging the number. `reason_sentence` phrases the SAME fired
signals for the card, where the words go out loud in a lobby and internal vocabulary would be
worse than no reason at all.

A reason that cites a connection the engine did not find is a hard gate failure, not a lint.
"""
from __future__ import annotations

from .scoring import SIGNAL_NAMES

GATE = "reason_cites_only_fired_signals"


def validate_reason(scored_pair: dict, narration: dict) -> dict:
    fired = {s["signal_id"] for s in (scored_pair.get("fired_signals") or [])}
    cited = list(narration.get("cited_signal_ids") or [])
    unfired = sorted(set(cited) - fired)
    result = {"valid": not unfired}
    result["gate_failures"] = (
        [{"gate": GATE, "unfired_cited": unfired}] if unfired else [])
    return result


def humanize(slug: str | None, labels: dict | None = None) -> str:
    """A stored slug, said out loud. Prefers the vocabulary's own label when there is one."""
    if not slug:
        return ""
    label = (labels or {}).get(slug)
    if label:
        return label[0].lower() + label[1:]
    return str(slug).replace("-", " ").replace("_", " ")


#: How a directed link is said out loud. The edge type is the fact; this is the sentence.
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
    "pursuit": "both {value}",
}

#: Ordered by how much a host can actually open with. A shared thesis is a conversation; a shared
#: industry is small talk; prominence is never offered to a host as a reason at all.
_PRIORITY = ("S5", "S7", "S3", "S4", "S6", "S1", "S2")


def _clause(signal: dict, a_name: str, b_name: str, labels: dict | None) -> str | None:
    """One clause naming one fired signal, with no pronoun guessed about anybody."""
    sid = signal["signal_id"]
    d = signal.get("detail") or {}
    if sid == "S5":
        return _LINK_PHRASE.get(d.get("kind"), "{a} has publicly named {b}").format(
            a=a_name, b=b_name)
    if sid == "S7":
        return f"both keep returning to {humanize(d.get('topic'), labels)}"
    if sid == "S3":
        return (f"they work in different fields and are circling the same question — "
                f"{humanize(d.get('topic'), labels)}")
    if sid == "S4":
        return _CONTEXT_PHRASE.get(d.get("type"), "both share {value}").format(
            value=humanize(d.get("value"), labels))
    if sid == "S6":
        return f"both are into {humanize(d.get('topic'), labels)}"
    if sid == "S1":
        return f"same seniority, same cohort — both started in the {d.get('decade')}"
    if sid == "S2":
        return f"both are in {humanize(d.get('industry'), labels)}"
    return None                                  # S8 is never offered to a host as a reason


#: The same signals, said to the member rather than about them. "them" always means the OTHER
#: person, who has just been named — so no pronoun is ever guessed for anybody.
def _say_clause(signal: dict, labels: dict | None) -> str | None:
    sid = signal["signal_id"]
    d = signal.get("detail") or {}
    if sid == "S5":
        return {"cited_in_own_writing": "you have cited them in print before",
                "co_mention": "you have named them in your own work",
                "repost": "you have reposted them",
                "follows": "you follow them"}.get(d.get("kind"), "you have named them publicly")
    if sid == "S7":
        return f"you both keep coming back to {humanize(d.get('topic'), labels)}"
    if sid == "S3":
        return (f"you are circling the same question from different fields — "
                f"{humanize(d.get('topic'), labels)}")
    if sid == "S4":
        return f"you have {humanize(d.get('value'), labels)} in common"
    if sid == "S6":
        return f"you are both into {humanize(d.get('topic'), labels)}"
    if sid == "S1":
        return "you started out in the same decade"
    if sid == "S2":
        return f"you are both in {humanize(d.get('industry'), labels)}"
    return None


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


def say_line(fired_signals: list[dict], display_name: str, labels: dict | None = None) -> str:
    """R-039: a name-drop, never an instruction. Members are not routed.

    One clause — the strongest thing that fired — put in the host's mouth as an observation.
    """
    clause = next((c for c in (_say_clause(s, labels) for s in _ordered(fired_signals)) if c), None)
    if clause is None:
        return f"Mention that {display_name} is in tonight, and leave the rest to them."
    return (f"Tell them {display_name} is in tonight, and that {clause} — then leave it there and "
            f"let them decide whether to walk over.")


def cited_signal_ids(fired_signals: list[dict]) -> list[str]:
    return sorted(s["signal_id"] for s in fired_signals)
