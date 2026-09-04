"""The arrival webhook (R-001).

The brief says arrival detection is solved: a webhook fires with a name and one or two identifying
details. What is NOT solved by that assumption is who is allowed to fire it. R-001 requires the
endpoint to accept events only from its configured arrival system, over a channel that is
authenticated, integrity-checked and replay-protected, and to reject malformed or unknown
identities BEFORE any profile or Room data is read.

Three mechanisms, in that order:

  * **Authenticated and integrity-checked** — HMAC-SHA256 over `timestamp.body` with a shared
    secret, compared in constant time. A modified body fails the same check that a forged sender
    does, because the signature covers both.
  * **Replay-protected** — the signed timestamp must be inside a short window, and each signature
    is accepted exactly once within it. A captured-and-resent request is refused even though its
    signature is perfectly valid.
  * **Rejected before any read** — resolution happens after the signature check and before the
    store is touched for anything but the name.

The shared secret is operator-local and arrives through the environment. It is never written to the
repo, the SQLite file, a log line, or a URL.
"""
from __future__ import annotations

import hashlib
import hmac
import os
import time

#: Signed timestamps outside this window are refused, which is what bounds the replay cache.
MAX_SKEW_SECONDS = 300


class WebhookRejected(Exception):
    def __init__(self, reason: str, status: int = 401):
        super().__init__(reason)
        self.reason = reason
        self.status = status


def secret() -> str | None:
    return os.environ.get("ARENA_WEBHOOK_SECRET") or None


def sign(body: bytes, timestamp: str, key: str) -> str:
    mac = hmac.new(key.encode(), f"{timestamp}.".encode() + body, hashlib.sha256)
    return f"sha256={mac.hexdigest()}"


class ReplayGuard:
    """Signatures already spent, inside the skew window. Bounded by the window, not by luck."""

    def __init__(self, window: int = MAX_SKEW_SECONDS):
        self.window = window
        self._seen: dict[str, float] = {}

    def spend(self, signature: str, now: float | None = None) -> None:
        now = now if now is not None else time.time()
        for sig, seen_at in list(self._seen.items()):
            if now - seen_at > self.window:
                del self._seen[sig]
        if signature in self._seen:
            raise WebhookRejected("replayed_signature", 409)
        self._seen[signature] = now


def verify(body: bytes, *, signature: str | None, timestamp: str | None,
           key: str | None, guard: ReplayGuard, now: float | None = None) -> None:
    """Raise unless this request came from the configured arrival system, intact and once."""
    if not key:
        raise WebhookRejected("webhook_not_configured", 503)
    if not signature or not timestamp:
        raise WebhookRejected("missing_signature")
    try:
        skew = abs((now if now is not None else time.time()) - float(timestamp))
    except (TypeError, ValueError):
        raise WebhookRejected("malformed_timestamp") from None
    if skew > MAX_SKEW_SECONDS:
        raise WebhookRejected("stale_timestamp")
    if not hmac.compare_digest(sign(body, timestamp, key), signature):
        raise WebhookRejected("bad_signature")
    guard.spend(signature, now)


def resolve_arrival_name(name: str, members: list[dict]) -> dict:
    """Resolve the supplied name to exactly one member, or say which failure it was.

    The engine never guesses identity. Zero matches is `not_found`; two or more is `ambiguous`, the
    host picks, and no brief is emitted (R-013).
    """
    wanted = " ".join((name or "").split()).casefold()
    if not wanted:
        return {"resolution": "not_found", "candidates": []}
    matches = [m for m in members if m["display_name"].casefold() == wanted]
    if not matches:
        matches = [m for m in members if wanted in m["display_name"].casefold()]
    if not matches:
        return {"resolution": "not_found", "candidates": []}
    if len(matches) > 1:
        return {"resolution": "ambiguous",
                "candidates": sorted(matches, key=lambda m: m["id"])}
    return {"resolution": "resolved", "candidates": matches}
