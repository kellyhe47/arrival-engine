"""SESSION adapters — operator's machine only, read-only, whitelist-extracted.

These are the ones that run through the operator's own logged-in browser. Three rules make that
safe to ship, and all three are mechanisms rather than intentions:

  * no write operation exists in the interface (`assert_read_only`);
  * extraction is against a WHITELIST of member-owned fields, so personalized strings about the
    OPERATOR are dropped at the boundary and never enter a fact record (DEC-7);
  * a captcha or bot-detection wall is `unavailable`, never something to work around (R-008).

`registry.deployed_registry()` cannot return anything from this module.
"""
from __future__ import annotations

from .base import AdapterSpec

#: DEC-7 / R-009 / G-029. Member-owned fields only. Whitelist, never blacklist — a blacklist
#: silently admits every field nobody thought of.
SESSION_FIELD_WHITELIST = (
    "display_name", "headline", "location", "employer", "education", "follower_count",
    "post_body", "post_published_at", "post_tagged_people", "repost_of", "following_handles",
    "bio", "joined_at",
)

#: Facts about the operator, not the member: not reproducible by Arena Hall, and storing them puts
#: the operator's own contact graph inside a member's profile.
_OPERATOR_SHAPED = ("followed_by", "you_know", "degree_of_connection", "viewer_", "people_you")


class SessionAdapter:
    """Read operations only. There is no post, like, follow, connect or message method here, and
    `assert_read_only` refuses to register one if somebody adds it."""

    def __init__(self, spec: AdapterSpec):
        assert spec.tier == "SESSION"
        self.spec = spec

    def fetch_profile(self, person_id: str) -> dict:
        raise NotImplementedError("driven by the operator's browser at ingest time")

    def fetch_activity(self, person_id: str) -> list[dict]:
        raise NotImplementedError("driven by the operator's browser at ingest time")

    def list_following(self, person_id: str) -> list[str]:
        """Read from the accessibility tree, never text extraction (AUD-07-5), as a slow batch job."""
        raise NotImplementedError("driven by the operator's browser at ingest time")


SESSION_SPECS = (
    AdapterSpec("linkedin_profile", "SESSION", "ok", "AUD-07: full post bodies, dates, tagged people"),
    AdapterSpec("x_profile", "SESSION", "ok", "AUD-07: bio, counts, join date; following via a11y tree"),
    AdapterSpec("instagram_profile", "SESSION", "ok", "AUD-07: captions carry S4 contexts"),
    AdapterSpec("facebook_profile", "SESSION", "unverified", "DEC-6/K-2: attempted, never measured"),
    AdapterSpec("tiktok_profile", "SESSION", "blocked",
                "R-008: 25 captcha references. A wall is unavailable, never worked around"),
)


def extract_session_fields(raw: dict, *, whitelist=SESSION_FIELD_WHITELIST) -> dict:
    """Keep whitelisted member-owned fields; drop everything else at the boundary."""
    fields = (raw or {}).get("fields") or {}
    allowed = set(whitelist)
    stored = sorted(k for k in fields if k in allowed)
    dropped = sorted(k for k in fields if k not in allowed)
    leaked = [k for k in stored if any(marker in k for marker in _OPERATOR_SHAPED)]
    return {
        "stored_fields": stored,
        "dropped_fields": dropped,
        "stored_values": {k: fields[k] for k in stored},
        "operator_data_stored": len(leaked),
    }
