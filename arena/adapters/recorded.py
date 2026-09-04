"""Offline adapters backed by a recorded corpus.

The deployed app makes zero external calls: every fixture asserts `external_calls: []`, and the
serving path reads the frozen SQLite file. These adapters are what an ingest run exercises in
tests and what the on-stage GREEN re-run replays, so a demo cannot fail on somebody's wifi.
"""
from __future__ import annotations

import json
from pathlib import Path

from .base import AdapterSpec

CORPUS = Path(__file__).resolve().parent.parent.parent / "eval" / "recorded"


class RecordedAdapter:
    """Reads a recorded corpus file. Declares read operations only."""

    def __init__(self, spec: AdapterSpec, corpus: Path | None = None):
        self.spec = spec
        self.corpus = corpus or CORPUS

    def _path(self, person_id: str) -> Path:
        return self.corpus / f"{person_id}__{self.spec.source_id}.json"

    def fetch_profile(self, person_id: str) -> dict:
        path = self._path(person_id)
        if not path.exists():
            return {}
        return json.loads(path.read_text()).get("profile", {})

    def fetch_activity(self, person_id: str) -> list[dict]:
        """Return the recorded items. An empty list is empty, never backfilled from a snippet."""
        path = self._path(person_id)
        if not path.exists():
            return []
        return json.loads(path.read_text()).get("items", [])
