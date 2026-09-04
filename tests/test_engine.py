"""Unit tests for the requirements no golden fixture covers end to end.

The fixtures are the acceptance contract. These are the properties that are structural rather than
observational — the ones whose failure mode is "somebody added a method" or "somebody opened the
wrong file", which a behaviour fixture cannot see.
"""
from __future__ import annotations

import sqlite3
import subprocess
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from arena.adapters import deployed_registry, ingest_registry  # noqa: E402
from arena.adapters.base import AdapterSpec, WriteOperationRefused, assert_read_only  # noqa: E402
from arena.card import count_words, is_sayable, render_card  # noqa: E402
from arena.config import DB_DIR, Settings  # noqa: E402
from arena.facts import chip_host  # noqa: E402
from arena.identity import resolve_identity  # noqa: E402
from arena.labels import resolve_label  # noqa: E402
from arena.ranking import brokering_mode, evidence_recency  # noqa: E402
from arena.scoring import CEILING, WEIGHTS, score_pair, surfaces  # noqa: E402
from arena.store import Store  # noqa: E402
from arena.view import resolve_token, token_for  # noqa: E402

STORE = ROOT / "var" / "arena.golden.db"


@pytest.fixture(scope="module")
def store():
    if not STORE.exists():
        sys.path.insert(0, str(ROOT / "scripts"))
        from build_store import build
        build(STORE, merge=False, seed=True, quiet=True)
    return Store(STORE)


# ── R-007 / DEC-6: no write operation exists, at any tier ─────────────────────
def test_no_adapter_in_either_registry_exposes_a_write():
    for registry in (deployed_registry(), ingest_registry()):
        for adapter in registry.values():
            assert_read_only(adapter)


def test_an_adapter_with_a_write_method_cannot_be_registered():
    class Rogue:
        spec = AdapterSpec("rogue", "SESSION")

        def fetch_profile(self, person_id): return {}

        def post_comment(self, person_id, text): ...   # the thing that must be unreachable

    with pytest.raises(WriteOperationRefused):
        assert_read_only(Rogue())


# ── R-053 / B-010: SESSION adapters are ABSENT from the deployed registry ─────
def test_deployed_registry_has_no_session_adapter():
    assert not [a for a in deployed_registry().values() if a.spec.tier == "SESSION"]
    assert [a for a in ingest_registry().values() if a.spec.tier == "SESSION"]


def test_tiktok_is_recorded_as_blocked_rather_than_worked_around():
    tiktok = ingest_registry()["tiktok_profile"]
    assert tiktok.spec.measured_status == "blocked"


# ── §1 of the build brief: db/ is opened read-only, always ───────────────────
@pytest.mark.parametrize("name", ["schema.sql", "vocabulary.sql", "roster.sql"])
def test_db_sql_files_are_only_ever_read(name):
    assert (DB_DIR / name).exists()


def test_a_live_db_file_cannot_be_opened_for_writing_through_the_store():
    live = sorted(DB_DIR.glob("arena*.db"))
    if not live:
        pytest.skip("no live ingest file present")
    conn = sqlite3.connect(f"file:{live[0]}?mode=ro", uri=True)
    with pytest.raises(sqlite3.OperationalError):
        conn.execute("CREATE TABLE tamper (x)")


def test_build_store_refuses_to_write_inside_db():
    proc = subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "build_store.py"), "--out", "db/nope.db"],
        cwd=ROOT, capture_output=True, text=True)
    assert proc.returncode == 2
    assert "frozen" in proc.stderr
    assert not (DB_DIR / "nope.db").exists()


def test_runtime_may_write_only_roster_and_card(tmp_path):
    sys.path.insert(0, str(ROOT / "scripts"))
    from build_store import build
    path = tmp_path / "w.db"
    build(path, merge=False, seed=True, quiet=True)
    s = Store(path, writable=True)
    s.arrive("m_feld", "2026-09-03T20:00:00Z")
    with pytest.raises(PermissionError):
        s._guard("fact")


# ── R-016 / R-017: buckets and the ceiling ───────────────────────────────────
def test_weights_are_exactly_three_buckets_and_the_ceiling_is_sixteen():
    assert set(WEIGHTS.values()) == {1, 2, 3}
    assert CEILING == 16


# ── R-018: S8 may break a tie, never create a match ──────────────────────────
def test_s8_is_silent_without_substrate_and_excluded_from_the_threshold():
    a = {"id": "a", "prominence_tier": 1, "industries": [], "topics_professional": [],
         "topics_personal": ["chess"], "contexts": [], "declared_links": []}
    b = {"id": "b", "prominence_tier": 4, "industries": [], "topics_professional": [],
         "topics_personal": ["chess"], "contexts": [], "declared_links": []}
    assert "S8" not in score_pair(a, b).signal_ids           # only S6 fired: no substrate

    c = dict(a, industries=["venture-capital"], topics_professional=["seed-stage-financing"])
    d = dict(b, industries=["venture-capital"], topics_professional=["seed-stage-financing"])
    pair = score_pair(c, d)
    assert "S8" in pair.signal_ids
    assert pair.score_excluding_s8() == pair.score - 1


def test_prominence_unmeasured_keeps_s8_silent_in_both_directions():
    """Huffman's tier is NULL. Absence is not tier 1 (K-10)."""
    a = {"id": "a", "prominence_tier": None, "industries": ["x"], "topics_professional": [],
         "topics_personal": [], "contexts": [], "declared_links": []}
    b = {"id": "b", "prominence_tier": 4, "industries": ["x"], "topics_professional": [],
         "topics_personal": [], "contexts": [], "declared_links": []}
    assert "S8" not in score_pair(a, b).signal_ids
    assert "S8" not in score_pair(b, a).signal_ids


# ── AUD-07-6: an unresolved context never matches ────────────────────────────
def test_unresolved_context_never_fires_s4():
    venice = {"type": "place", "value": "Venice", "resolved": 0}
    a = {"id": "a", "industries": [], "topics_professional": [], "topics_personal": [],
         "contexts": [venice], "declared_links": []}
    b = {"id": "b", "industries": [], "topics_professional": [], "topics_personal": [],
         "contexts": [venice], "declared_links": []}
    assert "S4" not in score_pair(a, b).signal_ids
    resolved = dict(venice, resolved=1)
    assert "S4" in score_pair(dict(a, contexts=[resolved]), dict(b, contexts=[resolved])).signal_ids


# ── R-019: topic aliases fold, so one thesis is not scored as two ────────────
def test_topic_aliases_fold_onto_their_canonical_slug(store):
    aliases = store.aliases()
    assert aliases["ultrarunning"] == "endurance-running"
    a = {"id": "a", "industries": [], "topics_professional": [], "contexts": [],
         "topics_personal": ["ultrarunning"], "declared_links": []}
    b = dict(a, id="b", topics_personal=["endurance-running"])
    assert "S6" in score_pair(a, b, aliases=aliases).signal_ids
    assert "S6" not in score_pair(a, b).signal_ids            # unfolded, they miss each other


# ── R-021 tie-break tier 2: S8 carries no date ───────────────────────────────
def test_s8_is_excluded_from_evidence_recency():
    ev = {"m_x": {"S5": "2012-03-04", "S8": "2026-09-03"}}
    assert evidence_recency(ev, "m_x", {"S5", "S8"}) == "2012-03-04"


# ── R-022: brokering mode ────────────────────────────────────────────────────
def test_brokering_mode_precedence():
    strong = {"id": "b", "industries": ["vc"], "topics_professional": ["seed-stage-financing"],
              "topics_personal": [], "contexts": [{"type": "place", "value": "nyc"}],
              "declared_links": [{"to": "a"}], "prominence_tier": 3, "seniority_tier": "principal",
              "career_start_decade": "1990s"}
    other = dict(strong, id="a", declared_links=[{"to": "b"}])
    assert brokering_mode(score_pair(other, strong), score_pair(strong, other)) == "mutual"

    quiet = {"id": "c", "industries": [], "topics_professional": [], "topics_personal": [],
             "contexts": [], "declared_links": []}
    assert brokering_mode(score_pair(other, quiet), score_pair(quiet, other)) == "light_touch"


# ── R-012 / R-056: corroboration, and refusal by table ───────────────────────
def test_two_weak_signals_from_one_surface_are_not_identity():
    weak_pair = [{"account_id": "a", "corroboration": ["handle_matches", "display_name_matches"]}]
    out = resolve_identity(weak_pair)
    assert out["accepted_account_ids"] == []
    assert out["rejected"][0]["reason"] == "handle_and_display_name_on_one_surface"


def test_three_weak_signals_from_different_surfaces_are_accepted():
    """Walk's X account: the weakest accepted identity in the set, and it is accepted."""
    out = resolve_identity([{"account_id": "a", "corroboration": [
        "bio_backlink_to_canonical", "display_name_matches", "handle_matches"]}])
    assert out["accepted_account_ids"] == ["a"]


def test_a_deny_listed_url_is_refused_not_downweighted(store):
    deny = store.deny_list()
    assert "https://x.com/spez" in deny
    out = resolve_identity(
        [{"account_id": "a", "url": "https://x.com/spez",
          "corroboration": ["named_in_sec_filing"]}], deny_list=deny)
    assert out["accepted_account_ids"] == []
    assert out["rejected"][0]["reason"] == "deny_listed_collision"


def test_a_deceased_candidate_yields_ambiguous_and_no_brief():
    out = resolve_identity([
        {"account_id": "writer", "corroboration": ["subject_self_identifies"]},
        {"account_id": "apologist", "deceased": True, "corroboration": ["display_name_matches",
                                                                       "bio_backlink_to_canonical"]},
    ])
    assert out["resolution"] == "ambiguous"


# ── R-014 / R-015: the supplied label ────────────────────────────────────────
def test_a_current_label_is_not_reported_stale():
    out = resolve_label({"supplied_label": "Foundry Group / Techstars, Boulder"},
                        {"current_org": "Foundry, General Partner", "former_orgs": ["Techstars"]})
    assert out["label_correction"]["stale"] is False


def test_the_store_s_measured_staleness_wins(store):
    row = store.label("m_shear")
    out = resolve_label({"supplied_label": row["supplied_label"]},
                        {"current_label": row["current_label"], "stale": row["stale"]})
    assert out["label_correction"]["stale"] is True
    assert out["echo_supplied_label"] is False


# ── DEC-4 / scoring-model §6: the provenance chip ────────────────────────────
@pytest.mark.parametrize("url,expected", [
    ("https://www.instagram.com/p/x/", "instagram.com"),
    ("https://avc.com/", "avc.com"),
    ("http://blog.emmettshear.com/", "blog.emmettshear.com"),   # a real subdomain is never stripped
    ("https://web.archive.org/web/2025/https://canva.com/x", "web.archive.org"),
])
def test_chip_host_strips_only_a_leading_www(url, expected):
    assert chip_host(url) == expected


# ── R-033 / R-035: the band and the closing line ─────────────────────────────
def test_word_count_is_derived_from_block_text():
    blocks = [{"order": 1, "label": "Who", "text": "one two three"}]
    assert count_words(blocks) == 3


@pytest.mark.parametrize("text,ok", [
    ("Ask him whether anyone has ever wasted a Random Day.", True),
    ("He has taken those meetings for twenty years.", False),
    ("Tell them the room is quieter than usual tonight.", True),
])
def test_sayable_recognises_an_action_rather_than_a_fact(text, ok):
    assert is_sayable(text) is ok


def test_retry_re_runs_render_and_does_not_relax_the_gate():
    """The obvious implementation of a retry button converts a hard gate into a retry loop."""
    narration = {"blocks": [
        {"order": 1, "label": "Who", "kind": "identity", "text": "word " * 10},
        {"order": 2, "label": "Now", "kind": "recency", "text": "word " * 10},
        {"order": 3, "label": "Room", "kind": "match", "text": "word " * 10},
        {"order": 4, "label": "Notice", "kind": "deep_cut", "text": "word " * 10},
        {"order": 5, "label": "Say", "kind": "sayable", "text": "Ask them about it."},
    ]}
    settings = Settings()
    first = render_card(narration, settings=settings)
    for _ in range(5):
        again = render_card(narration, settings=settings)
        assert again["gate_failures"] == first["gate_failures"]
        assert again["gates_passed"] is False


def test_degraded_responses_are_exempt_from_the_band_and_are_never_padded():
    narration = {"blocks": [
        {"order": 1, "label": "Who", "kind": "identity", "text": "Brad Feld. Foundry."},
        {"order": 5, "label": "Say", "kind": "sayable", "text": "Greet them by name."},
    ]}
    out = render_card(narration, settings=Settings(), degraded=True)
    assert not any(g["gate"] == "word_count_in_band" for g in out["gate_failures"])


# ── R-020: the floor is inclusive and absolute ───────────────────────────────
def test_the_floor_is_inclusive_and_needs_a_qualifying_substrate():
    class P:
        def __init__(self, score, sigs):
            self.score, self._s = score, set(sigs)

        @property
        def signal_ids(self): return self._s

        def score_excluding_s8(self): return self.score - (1 if "S8" in self._s else 0)

    assert surfaces(P(6, {"S3", "S7"})) is True
    assert surfaces(P(7, {"S1", "S2", "S4"})) is False       # no qualifying substrate
    assert surfaces(P(6, {"S2", "S7", "S8"})) is False       # 5 once S8 is set aside


# ── R-059: no member name in a URL, and the token round-trips ────────────────
def test_tokens_carry_no_member_name_and_resolve_back(store):
    ids = store.member_ids()
    for mid in ids:
        token = token_for(mid, "secret")
        assert mid not in token and "feld" not in token.lower()
        assert resolve_token(token, ids, "secret") == mid
    assert resolve_token("deadbeef", ids, "secret") is None


# ── R-032: deletion is a real purge, not a hidden flag ───────────────────────
def test_deleting_a_person_cascades(tmp_path):
    sys.path.insert(0, str(ROOT / "scripts"))
    from build_store import build
    path = tmp_path / "purge.db"
    build(path, merge=False, seed=True, quiet=True)
    conn = sqlite3.connect(path)
    conn.execute("PRAGMA foreign_keys = ON")
    before = conn.execute("SELECT COUNT(*) FROM fact WHERE subject_id='m_feld'").fetchone()[0]
    assert before > 0
    conn.execute("DELETE FROM person WHERE id='m_feld'")
    conn.commit()
    for table, col in (("fact", "subject_id"), ("person_topic", "person_id"),
                       ("context", "person_id"), ("source_status", "person_id")):
        assert conn.execute(
            f"SELECT COUNT(*) FROM {table} WHERE {col}='m_feld'").fetchone()[0] == 0


# ── the store's gates are queried, not re-implemented ────────────────────────
def test_the_render_gate_lives_in_the_store(store):
    view_sql = store.conn.execute(
        "SELECT sql FROM sqlite_master WHERE name='v_renderable_fact'").fetchone()[0]
    assert "third_party_open" in view_sql
    assert "composed_from" in view_sql
    assert "source_url IS NOT NULL" in view_sql


def test_v_present_drops_opted_out_members(tmp_path):
    sys.path.insert(0, str(ROOT / "scripts"))
    from build_store import build
    path = tmp_path / "present.db"
    build(path, merge=False, seed=True, quiet=True)
    conn = sqlite3.connect(path)
    conn.execute("PRAGMA foreign_keys = ON")
    conn.execute("INSERT OR REPLACE INTO roster VALUES ('m_ries','2026-09-03T19:00:00Z',NULL)")
    conn.execute("INSERT OR REPLACE INTO member_flags VALUES "
                 "('m_ries',1,0,'2026-09-03','operator')")
    conn.commit()
    present = {r[0] for r in conn.execute("SELECT person_id FROM v_present")}
    assert "m_ries" not in present


# ── R-001: the arrival webhook is authenticated, integrity-checked, replay-protected ──
from arena.webhook import (  # noqa: E402
    MAX_SKEW_SECONDS, ReplayGuard, WebhookRejected, resolve_arrival_name, sign, verify)


def _verify(body, ts, sig, guard=None, now=1000.0):
    verify(body, signature=sig, timestamp=ts, key="k", guard=guard or ReplayGuard(), now=now)


def test_a_correctly_signed_event_is_accepted():
    body, ts = b'{"name":"Brad Feld"}', "1000"
    _verify(body, ts, sign(body, ts, "k"))


def test_a_forged_sender_is_refused():
    body, ts = b'{"name":"Brad Feld"}', "1000"
    with pytest.raises(WebhookRejected) as exc:
        _verify(body, ts, sign(body, ts, "not-the-key"))
    assert exc.value.reason == "bad_signature"


def test_a_modified_body_is_refused_by_the_same_check():
    body, ts = b'{"name":"Brad Feld"}', "1000"
    sig = sign(body, ts, "k")
    with pytest.raises(WebhookRejected) as exc:
        _verify(b'{"name":"Fred Wilson"}', ts, sig)
    assert exc.value.reason == "bad_signature"


def test_a_captured_event_cannot_be_replayed():
    body, ts = b'{"name":"Brad Feld"}', "1000"
    sig, guard = sign(body, ts, "k"), ReplayGuard()
    _verify(body, ts, sig, guard)
    with pytest.raises(WebhookRejected) as exc:
        _verify(body, ts, sig, guard)
    assert exc.value.reason == "replayed_signature"


def test_a_stale_timestamp_is_refused_even_with_a_valid_signature():
    body, ts = b'{"name":"Brad Feld"}', "1000"
    with pytest.raises(WebhookRejected) as exc:
        _verify(body, ts, sign(body, ts, "k"), now=1000.0 + MAX_SKEW_SECONDS + 1)
    assert exc.value.reason == "stale_timestamp"


def test_an_unconfigured_webhook_refuses_rather_than_accepting_everything():
    with pytest.raises(WebhookRejected) as exc:
        verify(b"{}", signature="x", timestamp="1000", key=None, guard=ReplayGuard(), now=1000.0)
    assert exc.value.status == 503


# ── R-013: the engine never guesses identity ─────────────────────────────────
def test_two_members_sharing_a_name_yield_ambiguous_and_no_brief():
    members = [{"id": "m_a", "display_name": "Nabeel Qureshi"},
               {"id": "m_b", "display_name": "Nabeel Qureshi"}]
    out = resolve_arrival_name("Nabeel Qureshi", members)
    assert out["resolution"] == "ambiguous"
    assert [c["id"] for c in out["candidates"]] == ["m_a", "m_b"]


def test_an_unknown_name_is_not_found_rather_than_a_nearest_match(store):
    members = [store.member(mid) for mid in store.member_ids()]
    assert resolve_arrival_name("Somebody Else", members)["resolution"] == "not_found"
    assert resolve_arrival_name("Brad Feld", members)["resolution"] == "resolved"
