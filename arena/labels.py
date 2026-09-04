"""The supplied label is a hint to verify, never a fact to echo (R-014 / R-015).

The brief's own roster says "Emmett Shear — Twitch"; he has run Softmax since 2025. A host who
opens with "so, Twitch..." has damaged the relationship before the handshake.
"""
from __future__ import annotations

import re

_SPLIT = re.compile(r"[/,;]| and ")
_WORD = re.compile(r"[a-z0-9][a-z0-9.&'-]{2,}")

#: Words that appear in an organisation label without identifying one.
_NOISE = frozenset({
    "the", "group", "capital", "ventures", "partners", "inc", "llc", "ltd", "co", "company",
    "general", "partner", "principal", "ceo", "founder", "co-founder", "and", "interim",
})


def _parts(label: str) -> list[str]:
    return [p.strip().lower() for p in _SPLIT.split(label or "") if p.strip()]


def _names(label: str) -> set[str]:
    """Identifying words in a label. "Foundry Group" and "Foundry, General Partner" share `foundry`;
    substring matching on the whole phrase would miss that and report a current label as stale."""
    return {w for w in _WORD.findall((label or "").lower()) if w not in _NOISE}


def resolve_label(arrival: dict, profile: dict) -> dict:
    """Compare what the door said against what was measured.

    Staleness is a MEASURED property where the store has measured it (`member_label.stale`), and is
    otherwise derived: the supplied label is stale when it names a former organisation and names
    nothing in the current one. When neither holds, staleness is not asserted — an unrecognised
    label is not evidence that the label is wrong (R-004).
    """
    supplied = arrival.get("supplied_label") or ""
    current = profile.get("current_label") or profile.get("current_org") or ""

    if "stale" in profile and profile["stale"] is not None:
        stale = bool(profile["stale"])
    else:
        supplied_names = _names(supplied)
        names_current = bool(supplied_names & _names(current))
        names_former = any(supplied_names & _names(f) for f in (profile.get("former_orgs") or []))
        stale = bool(names_former and not names_current)

    return {
        "label_correction": {"supplied": supplied, "current": current, "stale": stale},
        # R-015: when stale, the card shows it explicitly, because the host may have read the door.
        "show_correction_to_host": stale,
        "echo_supplied_label": False,
        "correction_line": (
            f"formerly {supplied}; it is {current} now" if stale else None
        ),
    }
