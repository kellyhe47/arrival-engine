#!/usr/bin/env python3
"""Validate product-inception golden fixtures and their behavior manifest.

This is deliberately structural. Project-specific arithmetic and product behavior
belong in eval/verify_fixtures.py and the implementation's golden runner.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any


SCHEMA_VERSION = 1
FIXTURE_ID = re.compile(r"^G-[0-9]{3,}$")
BEHAVIOR_ID = re.compile(r"^B-[0-9]{3,}$")
KEBAB_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
CASE_TYPES = {
    "happy",
    "negative_control",
    "boundary",
    "failure",
    "degenerate",
    "idempotency",
    "precedence",
}
PROPERTY_OPERATORS = {
    "eq",
    "ne",
    "gt",
    "gte",
    "lt",
    "lte",
    "in_unit_interval",
    "all_equal",
    "unique",
    "within_pct",
}
FIXTURE_KEYS = {
    "schema_version",
    "id",
    "name",
    "why",
    "covers",
    "case_type",
    "traces_to",
    "defends_against",
    "time_sensitive",
    "given",
    "when",
    "expect",
}
GIVEN_KEYS = {"inputs", "preexisting_state", "configuration", "clock"}
EXACT_KEYS = {"result", "state_changes", "emitted_events", "external_calls"}
LEGACY_EXPECT_KEYS = {
    "result_type",
    "must_include",
    "must_exclude",
    "counts",
    "must_not_contain",
    "within_tolerance",
}


class Validation:
    def __init__(self) -> None:
        self.errors: list[str] = []

    def check(self, condition: bool, where: str, message: str) -> None:
        if not condition:
            self.errors.append(f"{where}: {message}")


def load_json(path: Path, validation: Validation) -> Any | None:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        validation.errors.append(f"{path}: cannot load JSON: {exc}")
        return None


def is_nonempty_string(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def string_list(value: Any) -> bool:
    return (
        isinstance(value, list)
        and bool(value)
        and all(is_nonempty_string(item) for item in value)
    )


def validate_iso_datetime(value: Any) -> bool:
    if not is_nonempty_string(value):
        return False
    try:
        datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return False
    return "T" in value and (value.endswith("Z") or "+" in value[10:] or "-" in value[10:])


def validate_property(item: Any, where: str, validation: Validation) -> None:
    validation.check(isinstance(item, dict), where, "property must be an object")
    if not isinstance(item, dict):
        return

    name = item.get("name")
    operator = item.get("operator")
    validation.check(is_nonempty_string(name), where, "property.name is required")
    validation.check(operator in PROPERTY_OPERATORS, where, f"unknown operator {operator!r}")
    validation.check(is_nonempty_string(item.get("reason")), where, "property.reason is required")

    if operator in {"eq", "ne", "gt", "gte", "lt", "lte"}:
        validation.check(is_nonempty_string(item.get("left")), where, f"{operator} requires left")
        validation.check(
            is_nonempty_string(item.get("right")) or "expected" in item,
            where,
            f"{operator} requires right or expected",
        )
    elif operator in {"in_unit_interval", "all_equal", "unique"}:
        validation.check(is_nonempty_string(item.get("path")), where, f"{operator} requires path")
    elif operator == "within_pct":
        validation.check(is_nonempty_string(item.get("path")), where, "within_pct requires path")
        validation.check("expected" in item, where, "within_pct requires expected")
        pct = item.get("pct")
        validation.check(
            isinstance(pct, (int, float)) and not isinstance(pct, bool) and pct >= 0,
            where,
            "within_pct.pct must be a non-negative number",
        )


def validate_fixture(path: Path, data: Any, validation: Validation) -> dict[str, Any] | None:
    where = str(path)
    validation.check(isinstance(data, dict), where, "fixture root must be an object")
    if not isinstance(data, dict):
        return None

    missing = FIXTURE_KEYS - data.keys()
    extra = data.keys() - FIXTURE_KEYS
    validation.check(not missing, where, f"missing keys: {sorted(missing)}")
    validation.check(not extra, where, f"unknown keys for schema v1: {sorted(extra)}")
    if missing:
        expect = data.get("expect")
        if isinstance(expect, dict):
            found_legacy = LEGACY_EXPECT_KEYS & expect.keys()
            validation.check(
                not found_legacy,
                where,
                f"legacy prose assertion keys are forbidden: {sorted(found_legacy)}",
            )
        return None

    validation.check(data.get("schema_version") == SCHEMA_VERSION, where, "schema_version must be 1")
    validation.check(bool(FIXTURE_ID.fullmatch(str(data.get("id", "")))), where, "id must match G-001")
    validation.check(bool(KEBAB_NAME.fullmatch(str(data.get("name", "")))), where, "name must be kebab-case")
    validation.check(is_nonempty_string(data.get("why")), where, "why is required")
    validation.check(is_nonempty_string(data.get("defends_against")), where, "defends_against is required")
    validation.check(data.get("case_type") in CASE_TYPES, where, f"case_type must be one of {sorted(CASE_TYPES)}")
    validation.check(string_list(data.get("covers")), where, "covers must be a non-empty string list")
    validation.check(string_list(data.get("traces_to")), where, "traces_to must be a non-empty string list")
    for behavior in data.get("covers", []) if isinstance(data.get("covers"), list) else []:
        validation.check(bool(BEHAVIOR_ID.fullmatch(str(behavior))), where, f"invalid behavior id {behavior!r}")

    time_sensitive = data.get("time_sensitive")
    validation.check(isinstance(time_sensitive, bool), where, "time_sensitive must be boolean")

    given = data.get("given")
    validation.check(isinstance(given, dict), where, "given must be an object")
    if isinstance(given, dict):
        given_shape_ok = set(given) == GIVEN_KEYS
        validation.check(given_shape_ok, where, f"given keys must be exactly {sorted(GIVEN_KEYS)}")
        if given_shape_ok:
            for key in GIVEN_KEYS:
                validation.check(isinstance(given.get(key), dict), where, f"given.{key} must be an object")
            clock = given.get("clock")
            if time_sensitive is True and isinstance(clock, dict):
                validation.check(validate_iso_datetime(clock.get("as_of")), where, "time-sensitive fixture needs ISO given.clock.as_of")

    when = data.get("when")
    validation.check(isinstance(when, dict), where, "when must be an object")
    if isinstance(when, dict):
        validation.check(is_nonempty_string(when.get("operation")), where, "when.operation is required")
        if "input_refs" in when:
            refs = when.get("input_refs")
            validation.check(
                isinstance(refs, list) and all(is_nonempty_string(ref) for ref in refs),
                where,
                "when.input_refs must be a string list",
            )

    expect = data.get("expect")
    validation.check(isinstance(expect, dict), where, "expect must be an object")
    if isinstance(expect, dict):
        found_legacy = LEGACY_EXPECT_KEYS & expect.keys()
        validation.check(not found_legacy, where, f"legacy prose assertion keys are forbidden: {sorted(found_legacy)}")
        expect_shape_ok = set(expect) == {"exact", "properties"}
        validation.check(expect_shape_ok, where, "expect keys must be exact and properties")
        if expect_shape_ok:
            exact = expect.get("exact")
            validation.check(isinstance(exact, dict), where, "expect.exact must be an object")
            if isinstance(exact, dict):
                exact_shape_ok = set(exact) == EXACT_KEYS
                validation.check(exact_shape_ok, where, f"expect.exact keys must be exactly {sorted(EXACT_KEYS)}")
                if exact_shape_ok:
                    validation.check(isinstance(exact.get("result"), dict), where, "expect.exact.result must be an object")
                    for key in EXACT_KEYS - {"result"}:
                        validation.check(isinstance(exact.get(key), list), where, f"expect.exact.{key} must be an array")
            properties = expect.get("properties")
            validation.check(isinstance(properties, list), where, "expect.properties must be an array")
            if isinstance(properties, list):
                for index, item in enumerate(properties):
                    validate_property(item, f"{where}: property[{index}]", validation)

    return data


def validate_manifest(path: Path, data: Any, validation: Validation) -> dict[str, dict[str, Any]]:
    where = str(path)
    validation.check(isinstance(data, dict), where, "manifest root must be an object")
    if not isinstance(data, dict):
        return {}
    validation.check(
        set(data) == {"schema_version", "comparison", "canonicalization", "behaviors"},
        where,
        "manifest keys must be schema_version, comparison, canonicalization, behaviors",
    )
    validation.check(data.get("schema_version") == SCHEMA_VERSION, where, "schema_version must be 1")
    validation.check(
        data.get("comparison") == "deep_equal_after_canonicalization",
        where,
        "comparison must be deep_equal_after_canonicalization",
    )
    canonicalization = data.get("canonicalization")
    validation.check(isinstance(canonicalization, list), where, "canonicalization must be an array")
    if isinstance(canonicalization, list):
        for index, rule in enumerate(canonicalization):
            rule_where = f"{where}: canonicalization[{index}]"
            validation.check(isinstance(rule, dict), rule_where, "rule must be an object")
            if isinstance(rule, dict):
                validation.check(is_nonempty_string(rule.get("path")), rule_where, "path is required")
                validation.check(string_list(rule.get("sort_by")), rule_where, "sort_by must be a non-empty string list")

    behaviors = data.get("behaviors")
    validation.check(isinstance(behaviors, list) and bool(behaviors), where, "behaviors must be a non-empty array")
    by_id: dict[str, dict[str, Any]] = {}
    if not isinstance(behaviors, list):
        return by_id
    for index, behavior in enumerate(behaviors):
        behavior_where = f"{where}: behavior[{index}]"
        validation.check(isinstance(behavior, dict), behavior_where, "behavior must be an object")
        if not isinstance(behavior, dict):
            continue
        validation.check(
            set(behavior) == {"id", "statement", "traces_to", "required_case_types"},
            behavior_where,
            "behavior keys must be id, statement, traces_to, required_case_types",
        )
        behavior_id = behavior.get("id")
        validation.check(bool(BEHAVIOR_ID.fullmatch(str(behavior_id or ""))), behavior_where, "id must match B-001")
        validation.check(behavior_id not in by_id, behavior_where, f"duplicate behavior id {behavior_id!r}")
        validation.check(is_nonempty_string(behavior.get("statement")), behavior_where, "statement is required")
        validation.check(string_list(behavior.get("traces_to")), behavior_where, "traces_to must be a non-empty string list")
        roles = behavior.get("required_case_types")
        validation.check(isinstance(roles, list) and bool(roles), behavior_where, "required_case_types must be non-empty")
        if isinstance(roles, list):
            validation.check(len(roles) == len(set(roles)), behavior_where, "required_case_types contains duplicates")
            for role in roles:
                validation.check(role in CASE_TYPES, behavior_where, f"unknown case type {role!r}")
        if isinstance(behavior_id, str) and behavior_id not in by_id:
            by_id[behavior_id] = behavior
    return by_id


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("fixture_dir", type=Path, help="Directory containing golden fixture JSON files")
    parser.add_argument(
        "--manifest",
        type=Path,
        help="Behavior manifest; defaults to <fixture_dir>/../golden-manifest.json",
    )
    args = parser.parse_args()

    validation = Validation()
    fixture_dir = args.fixture_dir.resolve()
    validation.check(fixture_dir.is_dir(), str(fixture_dir), "fixture directory does not exist")
    manifest_path = (args.manifest or fixture_dir.parent / "golden-manifest.json").resolve()
    manifest_data = load_json(manifest_path, validation)
    behaviors = validate_manifest(manifest_path, manifest_data, validation) if manifest_data is not None else {}

    paths = sorted(fixture_dir.glob("*.json")) if fixture_dir.is_dir() else []
    validation.check(bool(paths), str(fixture_dir), "no fixture JSON files found")
    fixtures: list[dict[str, Any]] = []
    ids: set[str] = set()
    names: set[str] = set()
    for path in paths:
        data = load_json(path, validation)
        if data is None:
            continue
        fixture = validate_fixture(path, data, validation)
        if fixture is None:
            continue
        fixture_id = fixture.get("id")
        name = fixture.get("name")
        validation.check(fixture_id not in ids, str(path), f"duplicate fixture id {fixture_id!r}")
        validation.check(name not in names, str(path), f"duplicate fixture name {name!r}")
        if isinstance(fixture_id, str):
            ids.add(fixture_id)
        if isinstance(name, str):
            names.add(name)
        fixtures.append(fixture)

    coverage: dict[str, set[str]] = defaultdict(set)
    for fixture in fixtures:
        fixture_where = f"fixture {fixture.get('id', '<unknown>')}"
        fixture_traces = set(fixture.get("traces_to", []))
        for behavior_id in fixture.get("covers", []):
            validation.check(behavior_id in behaviors, fixture_where, f"covers unknown behavior {behavior_id!r}")
            if behavior_id not in behaviors:
                continue
            coverage[behavior_id].add(fixture.get("case_type"))
            behavior_traces = set(behaviors[behavior_id].get("traces_to", []))
            validation.check(
                behavior_traces <= fixture_traces,
                fixture_where,
                f"missing behavior provenance: {sorted(behavior_traces - fixture_traces)}",
            )

    for behavior_id, behavior in behaviors.items():
        required = set(behavior.get("required_case_types", []))
        missing_roles = required - coverage.get(behavior_id, set())
        validation.check(not missing_roles, f"behavior {behavior_id}", f"missing required case types: {sorted(missing_roles)}")

    if validation.errors:
        print(f"FAIL — {len(validation.errors)} golden contract violation(s):")
        for error in validation.errors:
            print(f"  - {error}")
        return 1

    print(f"OK — {len(fixtures)} fixtures cover {len(behaviors)} behaviors under schema v{SCHEMA_VERSION}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
