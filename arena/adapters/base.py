"""The adapter interface. Read operations only — structurally, not by convention."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol, runtime_checkable

#: An operation whose name does not start with one of these is not an operation this interface can
#: express. There is no `post_`, `like_`, `follow_`, `message_` or `connect_` prefix, and adding one
#: would fail `assert_read_only` before it could ever be called.
ALLOWED_OPERATION_PREFIXES = ("fetch_", "read_", "list_")


class WriteOperationRefused(RuntimeError):
    """Raised at construction, not at call time. A write path never gets as far as being called."""


@dataclass(frozen=True)
class AdapterSpec:
    source_id: str
    tier: str                      # GREEN | METERED | SESSION
    measured_status: str = "ok"    # ok | blocked | unverified
    note: str = ""


@runtime_checkable
class ReadOnlyAdapter(Protocol):
    spec: AdapterSpec

    def fetch_profile(self, person_id: str) -> dict: ...

    def fetch_activity(self, person_id: str) -> list[dict]: ...


def declared_operations(adapter) -> list[str]:
    """Public callables an adapter exposes. This is what `assert_read_only` inspects."""
    return sorted(
        name for name in dir(adapter)
        if not name.startswith("_") and callable(getattr(adapter, name, None))
    )


def assert_read_only(adapter) -> list[str]:
    """Prove the absence of a write path, and return the declared operations.

    Called at registry construction, so an adapter with a write method cannot be registered — the
    failure happens at import, in front of a developer, not in front of a member's account.
    """
    ops = declared_operations(adapter)
    writes = [op for op in ops if not op.startswith(ALLOWED_OPERATION_PREFIXES)]
    if writes:
        raise WriteOperationRefused(
            f"{getattr(adapter, 'spec', adapter)} exposes non-read operations: {writes}")
    return ops
