"""The eleven named operations the golden fixtures dispatch on.

This is the module map the fixture set implies. Each operation is a pure function of its inputs,
its configuration and the clock — plus, where the product genuinely needs it, a read-only store.
Every one of them returns the same four observation surfaces:

    result · state_changes · emitted_events · external_calls

`state_changes` and `external_calls` are empty for every operation here, and that is a property of
the design rather than a convenience: nothing on the render path writes, and nothing on the render
path fetches. Presence and emitted cards are written by `arena.web` through the narrow
`Store.arrive` / `Store.depart` / `Store.record_card` methods, deliberately outside the operations
the fixtures observe.
"""
from __future__ import annotations

from dataclasses import dataclass, field

from .adapters.base import declared_operations as _declared
from .adapters.session import SESSION_FIELD_WHITELIST, extract_session_fields as _extract
from .card import generate_digest as _digest, render_card as _render
from .config import Settings
from .facts import select_renderable_facts as _select
from .identity import resolve_identity as _resolve_identity
from .ingest import run_ingestion as _ingest
from .labels import resolve_label as _resolve_label
from .ranking import rank_room as _rank
from .reason import validate_reason as _validate_reason
from .recency import build_now_block as _now
from .scoring import score_pair as _score

DEFAULT_CLOCK = "2026-09-03T19:00:00Z"

OPERATIONS = (
    "resolve_identity", "resolve_label", "score_pair_both_directions", "rank_room",
    "select_renderable_facts", "build_now_block", "validate_reason", "render_card",
    "generate_digest", "run_ingestion", "extract_session_fields",
)


@dataclass
class Observation:
    """The four surfaces every golden fixture asserts."""

    result: dict
    state_changes: list = field(default_factory=list)
    emitted_events: list = field(default_factory=list)
    external_calls: list = field(default_factory=list)

    def as_dict(self) -> dict:
        return {
            "result": self.result,
            "state_changes": self.state_changes,
            "emitted_events": self.emitted_events,
            "external_calls": self.external_calls,
        }


class UnknownOperation(KeyError):
    pass


def _strip_private(obj):
    """Drop internal plumbing keys before anything is compared or rendered."""
    if isinstance(obj, dict):
        return {k: _strip_private(v) for k, v in obj.items() if not str(k).startswith("_")}
    if isinstance(obj, list):
        return [_strip_private(v) for v in obj]
    return obj


def run(operation: str, given: dict, *, store=None, when: dict | None = None) -> Observation:
    """Execute one named operation against `given` and return its observation envelope."""
    if operation not in OPERATIONS:
        raise UnknownOperation(operation)

    inputs = given.get("inputs") or {}
    configuration = given.get("configuration") or {}
    clock = (given.get("clock") or {}).get("as_of") or DEFAULT_CLOCK
    settings = Settings.from_fixture(configuration)
    aliases = store.aliases() if store else None

    if operation == "resolve_identity":
        result = _resolve_identity(
            inputs.get("candidate_accounts") or [],
            require_corroboration=settings.require_corroboration,
            strengths=store.corroboration_strengths() if store else None,
            deny_list=store.deny_list() if store else None,
        )

    elif operation == "resolve_label":
        result = _resolve_label(inputs.get("arrival") or {}, inputs.get("profile") or {})

    elif operation == "score_pair_both_directions":
        a, b = inputs["member_a"], inputs["member_b"]
        kw = {"aliases": aliases, "s8_requires_substrate": settings.s8_requires_substrate}
        result = {"a_to_b": _score(a, b, **kw).as_dict(), "b_to_a": _score(b, a, **kw).as_dict()}

    elif operation == "rank_room":
        result = _rank(
            inputs.get("arriving_member") or {},
            inputs.get("present_members") or [],
            settings=settings,
            signal_evidence=inputs.get("signal_evidence") or {},
            aliases=aliases,
        )

    elif operation == "select_renderable_facts":
        result = _select(inputs.get("candidate_facts") or [], settings=settings)

    elif operation == "build_now_block":
        result = _now(inputs, settings=settings, as_of=clock)

    elif operation == "validate_reason":
        result = _validate_reason(inputs.get("scored_pair") or {}, inputs.get("narration") or {})

    elif operation == "render_card":
        result = _render(inputs.get("narration") or {}, settings=settings,
                         facts=inputs.get("facts"), scored_pair=inputs.get("scored_pair"))

    elif operation == "generate_digest":
        result = _digest(inputs, settings=settings, clock=clock, store=store)

    elif operation == "run_ingestion":
        raw = _ingest(inputs, configuration=configuration)
        events = raw.pop("_events")
        return Observation(result=_strip_private(raw), emitted_events=events)

    elif operation == "extract_session_fields":
        whitelist = configuration.get("field_whitelist") or SESSION_FIELD_WHITELIST
        result = _extract(inputs.get("raw_session_read") or {}, whitelist=whitelist)
        result.pop("stored_values", None)
        interface = inputs.get("adapter_interface")
        if interface is not None:
            prefixes = tuple(configuration.get("allowed_operation_prefixes")
                             or ("fetch_", "read_", "list_"))
            declared = sorted(interface.get("declared_operations") or [])
            writes = [op for op in declared if not op.startswith(prefixes)]
            result["declared_operations"] = declared
            result["write_operations_available"] = len(writes)

    return Observation(result=_strip_private(result))


__all__ = ["run", "Observation", "OPERATIONS", "UnknownOperation", "_declared"]
