"""Adapter registries. The deployed one cannot contain a SESSION adapter.

`R-053` says SESSION adapters are absent from the deployed runtime registry — not disabled,
absent. `deployed_registry()` builds from the GREEN/METERED catalogue only and then asserts the
result, so the property is checked rather than remembered.
"""
from __future__ import annotations

from .base import AdapterSpec, assert_read_only
from .recorded import RecordedAdapter
from .session import SESSION_SPECS, SessionAdapter

#: GREEN and METERED only. Measured statuses come from docs/audit/04 and docs/ingest-spec.md §4.
CATALOGUE = (
    AdapterSpec("personal_blog_rss", "GREEN", "ok", "full-text RSS; the richest open vein"),
    AdapterSpec("blog_archive", "GREEN", "ok", "on-site archive index"),
    AdapterSpec("newsletter", "GREEN", "ok", "archive page; no working RSS for several"),
    AdapterSpec("wikipedia", "GREEN", "ok", "wikitext; disambiguated titles are load-bearing"),
    AdapterSpec("sec_edgar", "GREEN", "ok", "contact User-Agent required or 403"),
    AdapterSpec("wayback", "GREEN", "ok", "serial only; fails silently under concurrency"),
    AdapterSpec("podcast_rss", "GREEN", "ok", "date by recording, not publication"),
    AdapterSpec("youtube_rss", "GREEN", "ok", "channel_id, never ?user="),
    AdapterSpec("open_library", "GREEN", "ok", "ISBN lookup"),
    AdapterSpec("hn_api", "GREEN", "ok", "Firebase + Algolia"),
    AdapterSpec("github_api", "GREEN", "ok", "name field is STRONG corroboration"),
    AdapterSpec("bluesky_api", "GREEN", "ok", "public, no auth"),
    AdapterSpec("farcaster_api", "GREEN", "ok", "the one social wall with a door"),
    AdapterSpec("x_counts", "GREEN", "ok", "counts and profile fields only, never content"),
    AdapterSpec("x_api", "METERED", "ok", "costs money per call"),
)


class SessionAdapterInDeployedRegistry(RuntimeError):
    """The one error this module exists to make impossible."""


def _build(specs) -> dict:
    registry = {}
    for spec in specs:
        adapter = SessionAdapter(spec) if spec.tier == "SESSION" else RecordedAdapter(spec)
        assert_read_only(adapter)          # no write path may be registered, at any tier
        registry[spec.source_id] = adapter
    return registry


def deployed_registry() -> dict:
    """What the live URL is allowed to hold. GREEN and METERED, structurally."""
    registry = _build(s for s in CATALOGUE if s.tier != "SESSION")
    session = [sid for sid, a in registry.items() if a.spec.tier == "SESSION"]
    if session:
        raise SessionAdapterInDeployedRegistry(session)
    return registry


def registry_from_sources(rows, *, include_session: bool = False) -> dict:
    """Build a registry from `v_collectable_source` rows.

    Source ids are coined by the collectors, not by this catalogue, so the deployed registry has to
    be derived from the store's own allow-list rather than from a hardcoded list that will always
    be behind. The structural property is unchanged and still checked: with `include_session`
    false, a SESSION row cannot produce an adapter, so it is ABSENT rather than disabled.
    """
    specs = []
    for row in rows:
        tier = row["tier"]
        if tier == "SESSION" and not include_session:
            continue
        specs.append(AdapterSpec(row["source_id"], tier, "ok", row.get("notes") or ""))
    registry = _build(specs)
    if not include_session:
        session = [sid for sid, a in registry.items() if a.spec.tier == "SESSION"]
        if session:
            raise SessionAdapterInDeployedRegistry(session)
    return registry


def ingest_registry() -> dict:
    """What the OPERATOR's machine holds. Everything, including SESSION."""
    return _build(list(CATALOGUE) + list(SESSION_SPECS))
