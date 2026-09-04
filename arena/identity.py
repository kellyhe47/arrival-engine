"""Identity resolution. A handle match is not identity.

`spez` on Reddit is Huffman; `@spez` on X is a stranger with 103 followers. An implementation that
matches on handle string alone will attribute a stranger's words to a member and read them aloud in
a lobby (G-016). This module is the reason that cannot happen.
"""
from __future__ import annotations

#: Seeded in `corroboration_kind` (db/roster.sql). Mirrored here only as a fallback for callers
#: with no store; `resolve_identity` prefers the table when one is passed in.
DEFAULT_STRENGTHS = {
    "named_in_sec_filing": "STRONG",
    "api_name_field_matches": "STRONG",
    "linked_from_own_canonical": "STRONG",
    "subject_self_identifies": "STRONG",
    "bio_backlink_to_canonical": "WEAK",
    "display_name_matches": "WEAK",
    "handle_matches": "WEAK",
}

#: Two WEAK signals that a single platform page produces together are one observation wearing two
#: hats — the handle and the display name on the same profile. Explicitly not sufficient.
SAME_SURFACE_WEAK_PAIR = frozenset({"handle_matches", "display_name_matches"})


def _accept(kinds, strengths) -> tuple[bool, str | None]:
    if not kinds:
        return False, "handle_match_without_corroboration"
    distinct = set(kinds)
    strong = {k for k in distinct if strengths.get(k) == "STRONG"}
    weak = {k for k in distinct if strengths.get(k) == "WEAK"}
    unknown = distinct - strong - weak
    if strong:
        return True, None
    if unknown:
        return False, "unrecognised_corroboration_kind"
    if len(weak) < 2:
        return False, "insufficient_corroboration"
    if weak == SAME_SURFACE_WEAK_PAIR:
        return False, "handle_and_display_name_on_one_surface"
    return True, None


def resolve_identity(
    candidate_accounts: list[dict],
    *,
    require_corroboration: bool = True,
    strengths: dict | None = None,
    deny_list: set[str] | None = None,
) -> dict:
    """Accept an account on >=1 STRONG, or >=2 WEAK from different surfaces. Never on handle alone.

    Returns accepted ids, rejections with a reason each, and the R-013 resolution status. A
    deny-listed value is REFUSED, never down-weighted: every deny-list row is a measured fetch that
    reached the wrong person.
    """
    strengths = strengths or DEFAULT_STRENGTHS
    deny_list = deny_list or set()

    accepted, rejected = [], []
    for acct in candidate_accounts or []:
        aid = acct.get("account_id")
        collides = {acct.get("url"), acct.get("handle")} & deny_list
        if collides:
            rejected.append({"account_id": aid, "reason": "deny_listed_collision"})
            continue
        if acct.get("deceased"):
            # R-013. Briefing on a dead man is the worst available failure.
            rejected.append({"account_id": aid, "reason": "candidate_deceased"})
            continue
        if not require_corroboration:
            accepted.append(aid)
            continue
        ok, reason = _accept(acct.get("corroboration") or [], strengths)
        if ok:
            accepted.append(aid)
        else:
            rejected.append({"account_id": aid, "reason": reason})

    deceased_present = any(a.get("deceased") for a in candidate_accounts or [])
    subjects = {a.get("subject_id") for a in (candidate_accounts or []) if a.get("account_id") in accepted}
    subjects.discard(None)
    if deceased_present:
        # A deceased homonym is never auto-resolved away; the host picks.
        status = "ambiguous"
    elif not accepted:
        status = "not_found"
    elif len(subjects) > 1:
        status = "ambiguous"
    else:
        status = "resolved"

    return {
        "accepted_account_ids": sorted(accepted),
        "rejected": sorted(rejected, key=lambda r: r["account_id"]),
        "resolution": status,
        "corroborated_candidate_count": len(accepted),
    }
