"""Unit tests for the requirements no golden fixture covers end to end.

The fixtures are the acceptance contract. These are the properties that are structural rather than
observational — the ones whose failure mode is "somebody added a method" or "somebody opened the
wrong file", which a behaviour fixture cannot see.
"""
from __future__ import annotations

import json
import sqlite3
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from threading import Event

import pytest

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from arena.adapters import deployed_registry, ingest_registry  # noqa: E402
from arena.adapters.base import AdapterSpec, WriteOperationRefused, assert_read_only  # noqa: E402
from arena.card import count_words, generate_digest, is_sayable, render_card  # noqa: E402
from arena.config import DB_DIR, Settings  # noqa: E402
from arena.facts import chip_host  # noqa: E402
from arena.identity import resolve_identity  # noqa: E402
from arena.labels import resolve_label  # noqa: E402
from arena.narrator import (  # noqa: E402
    CardPlan, ModelNarrator, NarratorUnavailable, OpenAISayWriter, validate_say_line)
from arena.ranking import evidence_recency, mutuality  # noqa: E402
from arena.reason import say_context  # noqa: E402
from arena.scoring import CEILING, WEIGHTS, intent_class, score_pair, surfaces  # noqa: E402
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
    a = {"id": "a", "prominence_tier": 1, "industries": ["venture-capital"],
         "topics_professional": [], "topics_personal": [], "contexts": [], "declared_links": []}
    b = {"id": "b", "prominence_tier": 4, "industries": ["venture-capital"],
         "topics_professional": [], "topics_personal": [], "contexts": [], "declared_links": []}
    assert "S8" not in score_pair(a, b).signal_ids           # only demographic S1: no substrate

    c = dict(a, topics_professional=["seed-stage-financing"])
    d = dict(b, topics_professional=["seed-stage-financing"])
    pair = score_pair(c, d)                                  # S5 is substrate, so S8 may fire
    assert "S8" in pair.signal_ids
    assert pair.score_excluding_s8() == pair.score - 1


def test_a_shared_hobby_is_substrate_now():
    """S6 joined the qualifying set: a real shared pursuit is a reason to talk, unlike a tier."""
    a = {"id": "a", "prominence_tier": 1, "industries": [], "topics_professional": [],
         "topics_personal": ["chess"], "contexts": [], "declared_links": []}
    b = {"id": "b", "prominence_tier": 4, "industries": [], "topics_professional": [],
         "topics_personal": ["chess"], "contexts": [], "declared_links": []}
    pair = score_pair(a, b)
    assert {"S6", "S8"} <= pair.signal_ids


def test_prominence_unmeasured_keeps_s8_silent_in_both_directions():
    """Huffman's tier is NULL. Absence is not tier 1 (K-10)."""
    a = {"id": "a", "prominence_tier": None, "industries": ["x"], "topics_professional": [],
         "topics_personal": [], "contexts": [], "declared_links": []}
    b = {"id": "b", "prominence_tier": 4, "industries": ["x"], "topics_professional": [],
         "topics_personal": [], "contexts": [], "declared_links": []}
    assert "S8" not in score_pair(a, b).signal_ids
    assert "S8" not in score_pair(b, a).signal_ids


# ── AUD-07-6: an unresolved context never matches ────────────────────────────
def test_unresolved_context_never_fires_s3():
    venice = {"type": "place", "value": "Venice", "resolved": 0}
    a = {"id": "a", "industries": [], "topics_professional": [], "topics_personal": [],
         "contexts": [venice], "declared_links": []}
    b = {"id": "b", "industries": [], "topics_professional": [], "topics_personal": [],
         "contexts": [venice], "declared_links": []}
    assert "S3" not in score_pair(a, b).signal_ids
    resolved = dict(venice, resolved=1)
    assert "S3" in score_pair(dict(a, contexts=[resolved]), dict(b, contexts=[resolved])).signal_ids


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


# ── R-022a: mutuality replaces the retired brokering machinery ───────────────
def test_mutuality_states():
    strong = {"id": "b", "industries": ["vc"], "topics_professional": ["seed-stage-financing"],
              "topics_personal": [], "contexts": [{"type": "place", "value": "nyc"}],
              "declared_links": [{"to": "a"}], "prominence_tier": 3, "seniority_tier": "principal",
              "career_start_decade": "1990s"}
    other = dict(strong, id="a", declared_links=[{"to": "b"}])
    assert mutuality(score_pair(other, strong), score_pair(strong, other)) == "mutual"

    # Only the directed link separates the directions: 7 forward, 4 back.
    thin = {"id": "a", "industries": ["vc"], "topics_professional": [], "topics_personal": [],
            "contexts": [], "prominence_tier": 3, "seniority_tier": "principal",
            "career_start_decade": "1990s", "declared_links": [{"to": "d"}]}
    peer = dict(thin, id="d", declared_links=[])
    assert mutuality(score_pair(thin, peer), score_pair(peer, thin)) == "one_way"

    quiet = {"id": "c", "industries": [], "topics_professional": [], "topics_personal": [],
             "contexts": [], "declared_links": []}
    assert mutuality(score_pair(other, quiet), score_pair(quiet, other)) == "neither"


# ── R-022 / R-022a.5: intent classes and the display-only S9 ─────────────────
def test_intent_class_precedence():
    assert intent_class(None, "I1") == "unknown"
    assert intent_class("I0", "I1") == "unknown"
    assert intent_class("I8", "I7") == "open"
    assert intent_class("I2", "I1") == "complement"
    assert intent_class("I1", "I2") != "complement"          # the map is directed
    assert intent_class("I2", "I7") == "guarded"
    assert intent_class("I7", "I5") == "guarded"
    assert intent_class("I1", "I1") == "parallel"
    assert intent_class("I1", "I4") == "neutral"


def test_s9_is_displayed_but_never_reaches_the_floor():
    a = {"id": "a", "intent": "I2", "industries": ["climate"], "topics_professional": ["grid"],
         "topics_personal": [], "contexts": [], "declared_links": []}
    b = {"id": "b", "intent": "I1", "industries": ["climate"], "topics_professional": ["grid"],
         "topics_personal": [], "contexts": [], "declared_links": []}
    pair = score_pair(a, b)
    assert pair.intent_class == "complement"
    assert pair.display_score() == pair.score + 3            # S1 + S5 = 5, displayed 8
    assert pair.floor_score() == 5
    # No default points floor (operator, 2026-09-04): S5 is substance, so the pair surfaces —
    # but a CONFIGURED floor still never reads S9: 8 on the card, 5 at the comparison.
    assert surfaces(pair) is True
    assert surfaces(pair, minimum=6) is False
    assert [s.signal_id for s in pair.display_fired()] == ["S1", "S5", "S9"]
    assert pair.as_dict()["intent_class"] == "complement"


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
    ("Fred Wilson is here, and you’ve written about his work before.", True),
    ("He has taken those meetings for twenty years.", False),
    ("Tell them the room is quieter than usual tonight.", True),
    # No addressee supplied: a vocative reads as any other bare fact, as it always has.
    ("Brad, Fred Wilson is here this evening.", False),
])
def test_sayable_recognises_an_action_rather_than_a_fact(text, ok):
    assert is_sayable(text) is ok


@pytest.mark.parametrize("text,ok", [
    ("Brad, Fred Wilson is here this evening.", True),
    ("Brad Feld — Fred Wilson is here this evening.", True),
    ("He has taken those meetings for twenty years.", False),
    ("Fred Wilson is here this evening.", False),
])
def test_sayable_accepts_a_vocative_when_it_knows_who_is_addressed(text, ok):
    """The gate and `narrator.validate_say_line` are one rule; they must not disagree.

    They did: the narrator is instructed to write a declarative name-drop that does not route the
    member, and on a thin fact it answers with a vocative — which both checks rejected, withholding
    the whole brief over a missing pronoun.
    """
    assert is_sayable(text, "Brad Feld") is ok


def test_match_say_context_carries_the_strongest_useful_fact_without_writing_the_line():
    signals = [
        {"signal_id": "S5", "detail": {"topic": "venture-investing-craft"}},
        {"signal_id": "S7", "detail": {"kind": "cited_in_own_writing"}},
    ]

    assert say_context(signals, "Fred Wilson", arriving_name="Brad Feld") == {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
        # 2026-09-04: the model receives every measured clause, not just the strongest —
        # one clause produced lines too generic to earn the slot.
        "measured_reasons": ["Brad Feld has cited Fred Wilson in print",
                             "both keep returning to venture investing craft"],
    }


def test_model_narrator_stitches_scaffold_and_suggestion_and_names_the_match():
    """The 2026-09-04 Say format: engine-written opening (which names the match) + the model's
    one relating sentence. The writer sees the opening; the card gets the assembled line."""
    class SayWriter:
        def __init__(self):
            self.context = None

        def write_say(self, context):
            self.context = context
            return ("I have to say, his twenty years of writing on how startup communities "
                    "are built is some of my favorite reading.")

    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "person_does": "Union Square Ventures · New York",
        "present_count": 8,
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
    }
    writer = SayWriter()
    plan = CardPlan(member_id="m_feld", display_name="Brad Feld", label="Foundry",
                    room={"kind": "match", "say_context": context}, word_band=(0, 350))

    blocks = ModelNarrator(writer).compose(plan)

    assert blocks[-1]["text"] == (
        "We have an exciting schedule lined up and a full house tonight. I was so excited to "
        "see Fred Wilson — Union Square Ventures · New York. I have to say, his twenty years "
        "of writing on how startup communities are built is some of my favorite reading.")
    assert "Fred Wilson" in blocks[-1]["text"]       # the operator's eval, at the seam
    assert writer.context["opening"].startswith("We have an exciting schedule")
    assert writer.context["person_here"] == "Fred Wilson"


def test_model_narrator_never_substitutes_a_template_for_a_match_say_line():
    plan = CardPlan(member_id="m_feld", display_name="Brad Feld", room={
        "kind": "match",
        "say_context": {
            "arriving_member": "Brad Feld",
            "person_here": "Fred Wilson",
            "useful_fact": "Brad Feld has cited Fred Wilson in print",
        },
    })

    with pytest.raises(NarratorUnavailable):
        ModelNarrator().compose(plan)


def test_template_narrator_is_not_a_match_say_fallback(store):
    digest = generate_digest(
        {"arrival": {"member_id": "m_feld"}, "present_members": ["m_wilson"]},
        settings=Settings(), clock="2026-09-03T21:00:00Z", store=store)

    assert digest["card_state"] == "withheld"
    assert digest["gate_failures"] == [{"gate": "narrator_available", "observed": False}]


def test_writer_failure_withholds_the_whole_match_card(store):
    class FailingWriter:
        def write_say(self, _context):
            raise ValueError("bad model output")

    digest = generate_digest(
        {"arrival": {"member_id": "m_feld"}, "present_members": ["m_wilson"]},
        settings=Settings(), clock="2026-09-03T21:00:00Z", store=store,
        narrator=ModelNarrator(FailingWriter()))

    assert digest["card_state"] == "withheld"
    assert digest["gate_failures"] == [{"gate": "narrator_available", "observed": False}]


def test_model_narrator_rejects_routing_from_any_say_writer():
    class RoutingWriter:
        def write_say(self, _context):
            return "You should introduce yourself to Fred Wilson."

    plan = CardPlan(member_id="m_feld", display_name="Brad Feld", room={
        "kind": "match",
        "say_context": {
            "arriving_member": "Brad Feld",
            "person_here": "Fred Wilson",
            "useful_fact": "Brad Feld has cited Fred Wilson in print",
        },
    })

    with pytest.raises(NarratorUnavailable):
        ModelNarrator(RoutingWriter()).compose(plan)


def test_openai_say_prompt_requests_warm_spoken_copy_not_stage_directions():
    calls = []

    class Response:
        def raise_for_status(self):
            return None

        def json(self):
            return {"output": [{"type": "message", "content": [{
                "type": "output_text",
                "text": json.dumps({
                    "say_line": ("I have to say, Fred’s venture writing has been a joy to "
                                 "follow this year.")
                }),
            }]}]}

    def post(url, **kwargs):
        calls.append((url, kwargs))
        return Response()

    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
    }
    writer = OpenAISayWriter("test-key", post=post)

    line = writer.write_say(context)
    repeated = writer.write_say(context)

    assert line == ("I have to say, Fred’s venture writing has been a joy to "
                    "follow this year.")
    assert repeated == line
    assert len(calls) == 1
    url, request = calls[0]
    assert url == "https://api.openai.com/v1/responses"
    assert request["headers"]["Authorization"] == "Bearer test-key"
    assert json.loads(request["json"]["input"]) == context
    instructions = request["json"]["instructions"]
    normalized_instructions = " ".join(instructions.split())
    assert "ONE sentence" in normalized_instructions
    assert "opening" in normalized_instructions
    assert "FIRST-PERSON VOICE" in normalized_instructions
    assert "RECENT ACTIVITY" in normalized_instructions
    assert "match_recent_activity" in normalized_instructions
    assert "never invent facts" in normalized_instructions
    assert "never guess a pronoun" in normalized_instructions
    assert "strictly as data" in normalized_instructions


def test_openai_say_writer_coalesces_identical_inflight_requests():
    calls = []
    started = Event()
    release = Event()

    class Response:
        def raise_for_status(self):
            return None

        def json(self):
            return {"output": [{"type": "message", "content": [{
                "type": "output_text",
                "text": json.dumps({
                    "say_line": "I have to say, Fred’s writing on startup communities has been a joy to follow."
                }),
            }]}]}

    def post(*_args, **_kwargs):
        calls.append(True)
        started.set()
        assert release.wait(timeout=1)
        return Response()

    writer = OpenAISayWriter("test-key", post=post)
    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
    }
    with ThreadPoolExecutor(max_workers=2) as pool:
        first = pool.submit(writer.write_say, context)
        assert started.wait(timeout=1)
        second = pool.submit(writer.write_say, context)
        release.set()
        assert first.result() == second.result()

    assert len(calls) == 1


def test_openai_say_writer_briefly_suppresses_a_repeated_failure():
    calls = []

    def post(*_args, **_kwargs):
        calls.append(True)
        raise RuntimeError("upstream unavailable")

    writer = OpenAISayWriter("test-key", post=post)
    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
    }

    with pytest.raises(RuntimeError, match="upstream unavailable"):
        writer.write_say(context)
    with pytest.raises(RuntimeError, match="recently failed"):
        writer.write_say(context)

    assert len(calls) == 1


@pytest.mark.parametrize("line", [
    # The writer returns the ONE relating sentence; the scaffold and full-line eval come later.
    # Rejected here: emptiness, routing, questions to the member, over-length.
    "",
    "You should introduce yourself to Fred Wilson.",
    "Brad, go over to Fred Wilson if you want.",
    "You can walk across the room to Fred Wilson.",
    "I think you and Fred Wilson should chat.",
    "Fred Wilson is here—you may want to catch up with Fred.",
    "Fred Wilson is here—you might want to join Fred by the bar.",
    "Brad, pop over to Fred Wilson if you’d like.",
    "Fred Wilson is here—do you remember Fred’s venture posts?",
    "Fred Wilson is here tonight " + ("and everyone already knew that before the door opened " * 6),
])
def test_openai_say_writer_rejects_a_suggestion_that_breaks_the_contract(line):
    class Response:
        def raise_for_status(self):
            return None

        def json(self):
            return {"output": [{"type": "message", "content": [{
                "type": "output_text", "text": json.dumps({"say_line": line}),
            }]}]}

    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has cited Fred Wilson in print",
    }

    with pytest.raises(ValueError):
        OpenAISayWriter("test-key", post=lambda *_args, **_kwargs: Response()).write_say(context)


@pytest.mark.parametrize("line", [
    "Brad, Fred Wilson is here this evening.",
    "Brad — Fred Wilson is here this evening.",
    "Brad Feld, Fred Wilson is here this evening.",
    "Fred Wilson is here, and you have cited him in print.",
    # Coaching the HOST in the imperative is not routing the member — but even coaching must
    # name the match (operator, 2026-09-04).
    "Ask him whether he and Fred Wilson ever compared notes on seed pricing.",
    "Tell them Fred Wilson is in tonight, and let the citation come up on its own.",
    # The 2026-09-04 scaffold register: the host speaking in the first person plural.
    "We have an exciting schedule lined up and a full house tonight. I was so excited to see "
    "Fred Wilson — Union Square Ventures, New York. Both of them keep returning to how startup "
    "communities are built.",
])
def test_say_validator_accepts_direct_address_coaching_and_the_scaffold(line):
    context = {"arriving_member": "Brad Feld", "person_here": "Fred Wilson",
               "useful_fact": "Brad Feld follows Fred Wilson"}
    assert validate_say_line(line, context) == line


@pytest.mark.parametrize("line", [
    # The operator's eval: the matched member's name ABSOLUTELY must appear in the line.
    "Ask him whether anyone has ever booked a Random Day and wasted it.",
    "We have an exciting schedule lined up tonight. I was so excited to see an old friend.",
    "Brad, someone you have cited is here this evening.",
])
def test_say_validator_rejects_a_line_that_does_not_name_the_match(line):
    context = {"arriving_member": "Brad Feld", "person_here": "Fred Wilson",
               "useful_fact": "Brad Feld follows Fred Wilson"}
    with pytest.raises(ValueError):
        validate_say_line(line, context)


def test_say_scaffold_names_the_match_and_reads_the_room():
    from arena.narrator import say_scaffold
    full = say_scaffold({"person_here": "Fred Wilson",
                         "person_does": "Union Square Ventures · New York",
                         "present_count": 8})
    assert full == ("We have an exciting schedule lined up and a full house tonight. "
                    "I was so excited to see Fred Wilson — Union Square Ventures · New York.")
    quiet = say_scaffold({"person_here": "Fred Wilson", "present_count": 2})
    assert quiet == ("We have an exciting schedule lined up tonight. "
                     "I was so excited to see Fred Wilson.")


def test_say_validator_allows_connection_words_used_as_factual_nouns():
    class Response:
        def raise_for_status(self):
            return None

        def json(self):
            return {"output": [{"type": "message", "content": [{
                "type": "output_text",
                "text": json.dumps({
                    "say_line": ("I’ve long admired Fred’s approach to venture investing, "
                                 "and I suspect Brad has too.")
                }),
            }]}]}

    context = {
        "arriving_member": "Brad Feld",
        "person_here": "Fred Wilson",
        "useful_fact": "Brad Feld has praised Fred Wilson's approach to venture investing",
    }

    assert OpenAISayWriter(
        "test-key", post=lambda *_args, **_kwargs: Response()).write_say(context).startswith("I’ve")


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


# ── R-020: surfacing needs substance; a numeric floor is configuration only ──
def test_surfacing_needs_substance_and_a_configured_floor_is_inclusive():
    class P:
        def __init__(self, score, sigs):
            self.score, self._s = score, set(sigs)

        @property
        def signal_ids(self): return self._s

        def score_excluding_s8(self): return self.score - (1 if "S8" in self._s else 0)

        def floor_score(self): return self.score_excluding_s8()

    assert surfaces(P(5, {"S2", "S7"})) is True              # substance at any score
    assert surfaces(P(7, {"S1", "S2", "S4"})) is False       # demographics never surface
    assert surfaces(P(6, {"S3", "S7"}), minimum=6) is True   # a configured floor is inclusive
    assert surfaces(P(5, {"S2", "S7"}), minimum=6) is False
    assert surfaces(P(6, {"S2", "S7", "S8"}), minimum=6) is False  # 5 once S8 is set aside


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


def test_v_present_has_no_opt_out_filter(tmp_path):
    """DEC-15. The opt-out is withdrawn, so presence is presence.

    Members are never told this service exists; a column recording their preference about it
    recorded nothing, and a card explaining that one had "opted out of recognition" described
    something that had never happened. `member_flags` keeps `do_not_traverse`, which is the
    operator restraining the ingest walk — a different mechanism, and not a member's choice.
    """
    sys.path.insert(0, str(ROOT / "scripts"))
    from build_store import build
    path = tmp_path / "present.db"
    build(path, merge=False, seed=True, quiet=True)
    conn = sqlite3.connect(path)
    conn.execute("PRAGMA foreign_keys = ON")

    columns = {r[1] for r in conn.execute("PRAGMA table_info(member_flags)")}
    assert "do_not_brief" not in columns
    assert "do_not_traverse" in columns

    view_sql = conn.execute(
        "SELECT sql FROM sqlite_master WHERE name = 'v_present'").fetchone()[0]
    assert "do_not_brief" not in view_sql

    conn.execute("INSERT OR REPLACE INTO roster VALUES ('m_ries','2026-09-03T19:00:00Z',NULL)")
    conn.commit()
    present = {r[0] for r in conn.execute("SELECT person_id FROM v_present")}
    assert "m_ries" in present


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


# ── DEC-14: the surfaces answer at the root, and the switch still works ──────
def test_the_surfaces_answer_at_the_root_and_under_the_path():
    from fastapi.testclient import TestClient
    import arena.web as web
    client = TestClient(web.app)
    token = token_for("m_walk", web.SECRET)
    for path in ("/", f"/{web.SECRET}/", f"/card/{token}", f"/{web.SECRET}/card/{token}"):
        assert client.get(path).status_code == 200, path


def test_a_page_reached_at_the_root_links_within_the_root_mount():
    """Both mounts are the same handlers, so a link must stay on the mount it was reached through.

    The room is arranged here rather than assumed: DEC-15 removed the seeded roster, so the app
    now starts with nobody present and a Room page carries no card links until somebody arrives.
    """
    from fastapi.testclient import TestClient
    import arena.web as web
    client = TestClient(web.app)
    client.post("/arrive", data={"person_id": "m_walk"}, follow_redirects=False)
    try:
        root_html = client.get("/").text
        assert f'href="/{web.SECRET}/card/' not in root_html
        assert 'href="/card/' in root_html
        secret_html = client.get(f"/{web.SECRET}/").text
        assert f'href="/{web.SECRET}/card/' in secret_html
    finally:
        client.post("/depart", data={"person_id": "m_walk"}, follow_redirects=False)


def test_no_member_name_reaches_a_url_or_a_title_either_way():
    """The one R-059 mitigation DEC-14 did not touch: it never depended on the path."""
    from fastapi.testclient import TestClient
    import arena.web as web
    client = TestClient(web.app)
    response = client.get(f"/card/{token_for('m_wilson', web.SECRET)}")
    assert "<title>Arrival</title>" in response.text
    assert "wilson" not in str(response.url).lower()
    assert response.headers["X-Robots-Tag"].startswith("noindex")
    assert response.headers["Referrer-Policy"] == "no-referrer"
    assert "Disallow: /" in client.get("/robots.txt").text


def test_the_render_gate_survives_being_called_from_several_threads():
    """The web layer runs sync handlers on a threadpool, so the scratch db must be per-thread.

    Regression: a single cached `sqlite3.Connection` worked until the pool handed a request to a
    different worker, and then raised out of `select_renderable_facts` — a 500 on a card, in
    production, from inside the render gate.
    """
    import concurrent.futures

    from arena.facts import select_renderable_facts

    candidates = [{"fact_id": "f", "provenance_class": "self_published",
                   "trust_class": "subject_authored", "source_url": "https://feld.com/"}]
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        results = [f.result() for f in
                   [pool.submit(select_renderable_facts, candidates, settings=Settings())
                    for _ in range(12)]]
    assert all(r["renderable_fact_ids"] == ["f"] for r in results)
