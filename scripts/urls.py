#!/usr/bin/env python3
"""Print the unguessable path and the card URLs, for the operator's own terminal.

`/` is deliberately a 404: the path IS the discovery mitigation (R-059), so nothing served by the
app ever advertises it — no root page, no index, no link. That makes the running app mildly
inconvenient to find your way into, which is the point. This prints it locally instead.
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from arena.card import generate_digest  # noqa: E402
from arena.config import Settings, card_path_secret  # noqa: E402
from arena.store import Store, StoreUnavailable  # noqa: E402
from arena.view import card_state, token_for  # noqa: E402


def main() -> int:
    base = os.environ.get("ARENA_BASE", f"http://localhost:{os.environ.get('PORT', '8000')}")
    secret = card_path_secret()
    from arena.config import public_root
    if public_root():
        print(f"\n  Room   {base}/")
        print(f"  Also   {base}/{secret}/   (the same handlers; ARENA_PUBLIC_ROOT=0 leaves only this)")
        print("  Note   there is no access control and no path obscurity — DEC-14\n")
    else:
        print(f"\n  Room   {base}/{secret}/")
        print(f"  Root   {base}/  ->  404; ARENA_PUBLIC_ROOT=0 is set\n")
    try:
        store = Store()
    except StoreUnavailable as exc:
        print(f"  no store yet: {exc}\n")
        return 0
    present = store.present_ids()
    # Deliberately WITHOUT the model narrator: this listing runs on every `make serve`, and
    # buying ten Say lines to print a table is not what the key is for. So a member whose card
    # needs a narrator shows `withheld (no narrator)` here and still renders in the app.
    print("  states are computed without the narrator — see the note in scripts/urls.py\n")
    print(f"  {'member':13} {'state':21} {'words':>5}  card")
    for mid in store.member_ids():
        others = [p for p in present if p != mid]
        digest = generate_digest(
            {"arrival": {"member_id": mid}, "present_members": others},
            settings=Settings(), clock="2026-09-03T21:00:00Z", store=store)
        state = card_state(digest, present_count=len(others),
                           renderable_count=len(digest.get("renderable_fact_ids") or []))
        words = digest["card"]["word_count"] if digest.get("card") else "-"
        if any(g["gate"] == "narrator_available" for g in digest.get("gate_failures") or []):
            state = "withheld (no narrator)"
        name = (store.member(mid) or {}).get("display_name", mid)
        print(f"  {name:13} {state:21} {str(words):>5}  "
              f"{base}/{secret}/card/{token_for(mid, secret)}")
    print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
