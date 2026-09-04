"""Recency has three states, not two (R-040).

`active` · `quiet` (every source reached, genuinely nothing) · `unknown` (a source was unreachable).
Only `quiet` may state silence. One unreached source downgrades the whole profile to `unknown`,
because absence of evidence from a source you could not read is not evidence of absence. Ries
looked dormant and had shipped a book that month; the staleness was a retrieval artifact.
"""
from __future__ import annotations

from datetime import date


def _d(value: str) -> date:
    return date.fromisoformat(str(value)[:10])


def effective_date(item: dict) -> str:
    """The date an item actually happened.

    A republished recording carries a fresh publication date and a stale recording date. Reading it
    aloud as this month's news is the specific way this pipeline embarrasses a host: Tavel's
    Aug-2026 podcast is a rerun of an Apr-2025 conversation.
    """
    if item.get("is_rerun") and item.get("recorded_at"):
        return item["recorded_at"]
    return item.get("recorded_at") or item.get("published_at")


def build_now_block(inputs: dict, *, settings, as_of: str) -> dict:
    """Decide what the Now block is allowed to claim.

    Accepts either a list of `items`, a `profile.latest_first_person_item`, or a
    `latest_reached_item` alongside `source_status` rows — the store supplies all three shapes
    through `v_recency_state`.
    """
    today = _d(as_of)
    statuses = inputs.get("source_status")
    coverage_evaluated = statuses is not None

    # The STORE decides coverage where the store is available. `v_recency_state` is the rule; the
    # row-level count below is the same arithmetic for callers that hand rows in directly (the
    # fixture path), and the two are asserted to agree whenever both are present.
    verdict = inputs.get("store_recency")
    unreached = sum(1 for s in (statuses or []) if s.get("status") != "ok")
    if verdict is not None:
        coverage_evaluated = True
        if statuses is not None and verdict["unreached_sources"] != unreached:
            raise AssertionError(
                f"v_recency_state says {verdict['unreached_sources']} unreached, the rows say "
                f"{unreached}. The view is the rule; fix the caller, not the view.")
        unreached = verdict["unreached_sources"]
    reached_fact_count = sum(int(s.get("fact_count") or 0) for s in (statuses or []))

    items = list(inputs.get("items") or [])
    excluded_items = []
    latest = None

    for item in items:
        eff = effective_date(item)
        if item.get("is_rerun") and item.get("published_at") and eff and eff < item["published_at"]:
            # Kept, but dated by recording. Listed so the demotion is visible rather than silent.
            excluded_items.append({"item_id": item["item_id"], "reason": "rerun_dated_by_recording"})
        if eff and (latest is None or eff > latest):
            latest = eff

    if latest is None:
        prof = inputs.get("profile") or {}
        if prof.get("latest_first_person_item"):
            latest = prof["latest_first_person_item"].get("published_at")
        elif inputs.get("latest_reached_item"):
            latest = inputs["latest_reached_item"].get("published_at")

    days_since_latest = (today - _d(latest)).days if latest else None

    if unreached:
        recency_state = "unknown"
        coverage_state = "unknown"
        block_kind = "coverage_gap"
    elif latest is None:
        # Every source reached and genuinely nothing found. This — and only this — is silence.
        recency_state = "cold"
        coverage_state = "quiet" if coverage_evaluated else "unknown"
        block_kind = "honest_absence"
    elif days_since_latest >= settings.stale_after_days:
        recency_state = "cold"
        coverage_state = "quiet" if coverage_evaluated else "unknown"
        block_kind = "honest_absence"
    else:
        recency_state = "warm"
        coverage_state = "active" if coverage_evaluated else "unknown"
        block_kind = "current"

    result = {
        "recency_state": recency_state,
        "coverage_state": coverage_state,
        "days_since_latest": days_since_latest,
        "latest_effective_date": latest,
        "unreached_sources": unreached,
        "unavailable_source_ids": sorted(
            s.get("source_id") for s in (statuses or []) if s.get("status") != "ok"
        ),
        "claims_recent_activity": recency_state == "warm",
        # Only `quiet` may state silence, and only when coverage was actually evaluated.
        "claims_silence": bool(coverage_evaluated and not unreached
                               and latest is None and reached_fact_count == 0),
        "block_kind": block_kind,
        "excluded_items": excluded_items,
    }
    if days_since_latest is None:
        result.pop("days_since_latest")
    return result
