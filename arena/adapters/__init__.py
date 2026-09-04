"""The fetch boundary.

Two structural properties, both load-bearing:

1. **No write operation exists.** `ReadOnlyAdapter` declares `fetch_*` / `read_*` / `list_*` and
   nothing else, and `assert_read_only` proves it for any adapter handed to it. Posting, liking,
   following, messaging and connecting are unreachable by bug, by retry, or by an instruction
   injected into a page (DEC-6, R-007, B-018).
2. **SESSION adapters are ABSENT from the deployed registry, not disabled.** `deployed_registry()`
   cannot return one; `arena.web` imports only that function (R-053, B-010).

A captcha or bot-detection wall is `unavailable`, at every tier. It is never something to work
around (R-008).
"""
from .base import (  # noqa: F401
    ALLOWED_OPERATION_PREFIXES,
    AdapterSpec,
    ReadOnlyAdapter,
    assert_read_only,
    declared_operations,
)
from .registry import CATALOGUE, deployed_registry, ingest_registry  # noqa: F401
from .session import SESSION_FIELD_WHITELIST, extract_session_fields  # noqa: F401
