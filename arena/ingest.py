"""Ingestion — offline, authenticated, slow. It never runs on the serving path.

Every attempt is recorded, not every success (R-058). `source_status` takes a row per
(person, source, run) with `ok` / `unavailable` / `skipped`, an http code and a fact count, and it
is the only thing that distinguishes `quiet` from `unknown`. A 200 with zero items is not silence:
`feeds.feedburner.com/redeyevc` is a live feed that has had no items since 2019.

A session that dies mid-run yields a PARTIAL profile that is marked partial. The facts already
collected are good and are kept; the gap is reported so nobody reads a half-built profile as a
complete one.
"""
from __future__ import annotations

from .adapters import deployed_registry, ingest_registry
from .adapters.registry import SessionAdapterInDeployedRegistry


def run_ingestion(inputs: dict, *, configuration: dict, registry: dict | None = None) -> dict:
    """Execute a fetch plan and report what was reached, what was not, and why."""
    cfg_adapters = (configuration or {}).get("adapters") or {}
    context = (configuration or {}).get("execution_context", "operator_machine")
    registry = registry or (deployed_registry() if context == "deployed_runtime"
                            else ingest_registry())

    # R-053 / B-010, checked rather than remembered.
    runtime_ids = (configuration or {}).get("deployed_runtime_adapter_ids")
    if runtime_ids is not None:
        session_ids = [sid for sid in runtime_ids
                       if cfg_adapters.get(sid, {}).get("tier") == "SESSION"]
        if session_ids:
            raise SessionAdapterInDeployedRegistry(session_ids)

    statuses, events = [], []
    facts_total = 0

    for step in inputs.get("fetch_plan") or []:
        source_id = step["source_id"]
        member_id = step["member_id"]
        cfg = cfg_adapters.get(source_id, {})
        tier = cfg.get("tier", "GREEN")
        adapter = registry.get(source_id)

        row = {"source_id": source_id, "member_id": member_id, "tier": tier,
               "status": "ok", "reason": None, "http_code": None, "facts": 0}

        if adapter is None:
            # Absent from this registry is a real answer, not an error to route around.
            row.update(status="skipped", reason="absent_from_registry")
        elif cfg.get("enabled") is False:
            row.update(status="skipped", reason="disabled")
        elif cfg.get("measured_status") == "blocked" or adapter.spec.measured_status == "blocked":
            # A captcha or bot-detection wall is unavailable. It is never worked around (R-008).
            row.update(status="unavailable", reason="blocked_by_bot_detection")
        elif tier == "SESSION" and cfg.get("session_present") is False:
            row.update(status="unavailable", reason="session_expired")
        else:
            try:
                items = adapter.fetch_activity(member_id)
            except NotImplementedError:
                row.update(status="unavailable", reason="requires_operator_session")
                items = []
            row["facts"] = len(items)
            facts_total += len(items)

        if row["status"] == "unavailable":
            events.append({"type": "source_unavailable", "source_id": source_id})
        statuses.append(row)

    unreached = [s for s in statuses if s["status"] != "ok"]
    complete = not unreached
    if not complete:
        events.append({"type": "profile_marked_partial",
                       "member_id": (inputs.get("fetch_plan") or [{}])[0].get("member_id")})

    return {
        "facts_ingested": facts_total,
        "profile_complete": complete,
        "profile_marked_partial": not complete,
        "source_status": sorted(statuses, key=lambda s: s["source_id"]),
        "_events": sorted(events, key=lambda e: e["type"]),
    }
