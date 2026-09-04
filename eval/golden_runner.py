#!/usr/bin/env python3
"""test-golden — drive the REAL implementation against every fixture in eval/golden/.

Not to be confused with `validate-spec` (`scripts/validate_golden.py` + `eval/verify_fixtures.py`),
which checks that the fixtures are well-formed and arithmetically self-consistent without executing
any product code. This runner imports `arena.operations` and compares the four observation surfaces
every fixture asserts: `result`, `state_changes`, `emitted_events`, `external_calls`.

Comparison, stated precisely because the difference matters:

  * `result` is compared as a PROJECTION. Every key a fixture asserts must be present and equal,
    recursively; a list must have exactly the asserted length and compare element-wise; `null`
    asserted means the actual must be null. Extra keys in the ACTUAL result are allowed, and they
    have to be — G-019 and G-022 assert card blocks as `{order, label}` while a real rendered block
    obviously also carries text. Extra list ELEMENTS are never allowed, so an extra ranked match or
    an extra rejection still fails.
  * `state_changes`, `emitted_events` and `external_calls` are compared the same way, and because
    their lengths are checked, an unasserted event or an unexpected external call fails the case.

`external_calls` is not taken on trust: a socket tripwire is installed for the duration of every
case, so any attempt to open a network connection is RECORDED as an external call and fails the
fixture that asserted none. Every fixture asserts none.
"""
from __future__ import annotations

import argparse
import json
import os
import socket
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from arena import operations  # noqa: E402
from arena.store import Store, StoreUnavailable  # noqa: E402

GOLDEN = ROOT / "eval" / "golden"
MANIFEST = ROOT / "eval" / "golden-manifest.json"
GOLDEN_STORE = ROOT / "var" / "arena.golden.db"


# ── the socket tripwire ───────────────────────────────────────────────────────
class _Tripwire:
    """Records every attempted outbound connection. The runtime must make zero."""

    def __init__(self):
        self.calls: list[dict] = []
        self._real = socket.socket.connect
        self._real_ex = socket.socket.connect_ex

    def __enter__(self):
        wire = self

        def connect(sock, address, *a, **kw):
            wire.calls.append({"type": "socket_connect", "address": repr(address)})
            raise OSError("external calls are not permitted on the serving path")

        def connect_ex(sock, address, *a, **kw):
            wire.calls.append({"type": "socket_connect_ex", "address": repr(address)})
            raise OSError("external calls are not permitted on the serving path")

        socket.socket.connect = connect
        socket.socket.connect_ex = connect_ex
        return self

    def __exit__(self, *exc):
        socket.socket.connect = self._real
        socket.socket.connect_ex = self._real_ex
        return False


# ── comparison ────────────────────────────────────────────────────────────────
def compare(expected, actual, path="") -> list[str]:
    if isinstance(expected, dict):
        if not isinstance(actual, dict):
            return [f"{path or '<root>'}: expected an object, got {type(actual).__name__}"]
        problems = []
        for key, want in expected.items():
            if key not in actual:
                problems.append(f"{path}.{key}: missing from the result")
                continue
            problems += compare(want, actual[key], f"{path}.{key}")
        return problems
    if isinstance(expected, list):
        if not isinstance(actual, list):
            return [f"{path}: expected a list, got {type(actual).__name__}"]
        if len(expected) != len(actual):
            return [f"{path}: expected {len(expected)} item(s), got {len(actual)} "
                    f"-> {json.dumps(actual, default=str)[:300]}"]
        problems = []
        for i, (want, got) in enumerate(zip(expected, actual)):
            problems += compare(want, got, f"{path}[{i}]")
        return problems
    if isinstance(expected, float) or isinstance(actual, float):
        if expected is None or actual is None or abs(float(expected) - float(actual)) > 1e-9:
            return [f"{path}: expected {expected!r}, got {actual!r}"]
        return []
    if expected != actual:
        return [f"{path}: expected {expected!r}, got {actual!r}"]
    return []


def _at(obj, dotted: str):
    node = obj
    for part in dotted.split("."):
        if isinstance(node, dict) and part in node:
            node = node[part]
        else:
            return None
    return node


def canonicalize(observation: dict, manifest: dict) -> dict:
    for rule in manifest.get("canonicalization", []):
        node = _at(observation, rule["path"])
        if isinstance(node, list):
            keys = rule["sort_by"]
            node.sort(key=lambda item: tuple(str(item.get(k)) for k in keys)
                      if isinstance(item, dict) else str(item))
    return observation


# ── properties ────────────────────────────────────────────────────────────────
_OPS = {
    "eq": lambda a, b: a == b,
    "ne": lambda a, b: a != b,
    "gt": lambda a, b: a > b,
    "gte": lambda a, b: a >= b,
    "lt": lambda a, b: a < b,
    "lte": lambda a, b: a <= b,
}


def _resolve(observation: dict, ref: str):
    node = observation
    for part in ref.split("."):
        if part.isdigit() and isinstance(node, list):
            node = node[int(part)]
        elif isinstance(node, dict):
            node = node.get(part)
        else:
            return None
    return node


def check_properties(fixture: dict, observation: dict) -> list[str]:
    problems = []
    for prop in fixture["expect"].get("properties") or []:
        op = _OPS.get(prop["operator"])
        if op is None:
            problems.append(f"property {prop['name']}: unsupported operator {prop['operator']}")
            continue
        left = _resolve(observation, prop["left"])
        right = prop["expected"] if "expected" in prop else _resolve(observation, prop["right"])
        if not op(left, right):
            problems.append(
                f"property {prop['name']}: {prop['left']}={left!r} "
                f"{prop['operator']} {right!r} is false — {prop.get('reason', '')}")
    return problems


# ── the run ───────────────────────────────────────────────────────────────────
def ensure_store(rebuild: bool = False) -> Store | None:
    """The golden store is deterministic: db/*.sql plus MY synthetic seed, no live ingest files.

    That keeps `test-golden` reproducible from a clean clone, where `db/arena*.db` may not exist.
    """
    if rebuild or not GOLDEN_STORE.exists():
        sys.path.insert(0, str(ROOT / "scripts"))
        from build_store import build
        build(GOLDEN_STORE, merge=False, seed=True, quiet=True)
    try:
        return Store(GOLDEN_STORE)
    except StoreUnavailable:
        return None


def run_fixture(fixture: dict, manifest: dict, store) -> tuple[bool, list[str]]:
    when = fixture["when"]
    repeat = when.get("repeat", 1)
    observations = []
    for _ in range(repeat):
        with _Tripwire() as wire:
            try:
                obs = operations.run(when["operation"], fixture["given"], store=store, when=when)
                envelope = obs.as_dict()
            except Exception as exc:  # noqa: BLE001 — a crash is a fixture failure, reported as one
                return False, [f"{when['operation']} raised {type(exc).__name__}: {exc}"]
            envelope["external_calls"] = envelope["external_calls"] + wire.calls
        observations.append(canonicalize(json.loads(json.dumps(envelope, default=str)), manifest))

    problems = []
    if repeat > 1 and any(o != observations[0] for o in observations[1:]):
        problems.append(f"not idempotent across {repeat} runs (B-014)")

    exact = fixture["expect"]["exact"]
    got = observations[0]
    for surface in ("result", "state_changes", "emitted_events", "external_calls"):
        problems += compare(exact.get(surface), got.get(surface), surface)
    problems += check_properties(fixture, got)
    return not problems, problems


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--only", help="run one fixture by id (e.g. G-022)")
    ap.add_argument("--rebuild-store", action="store_true")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    manifest = json.loads(MANIFEST.read_text())
    store = ensure_store(args.rebuild_store)
    if store is None:
        print("no golden store; run `make store`", file=sys.stderr)
        return 2

    files = sorted(GOLDEN.glob("*.json"))
    passed, failed = [], []
    for path in files:
        fixture = json.loads(path.read_text())
        if args.only and fixture["id"] != args.only:
            continue
        ok, problems = run_fixture(fixture, manifest, store)
        label = f"{fixture['id']} {fixture['name']} [{fixture['when']['operation']}]"
        if ok:
            passed.append(label)
            if args.verbose:
                print(f"  PASS  {label}")
        else:
            failed.append((label, problems))
            print(f"  FAIL  {label}")
            for p in problems:
                print(f"          {p}")

    print(f"\ntest-golden: {len(passed)} passed, {len(failed)} failed, "
          f"{len(passed) + len(failed)} fixtures driving the real implementation")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
