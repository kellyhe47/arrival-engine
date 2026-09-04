"""Card assembly, the hard gates, and the digest.

Five ordered bare-noun blocks — Who, Now, Room, Notice, Say — no summary, no transitions,
250–350 words, ending on a sayable line rather than a fact. Reason first, score small. Every
rendered fact carries a provenance chip, because the host will be asked "how do you know that?"
out loud, in a lobby.

Retry re-runs THIS module only. It does not re-ingest and it does not lower a threshold (R-047).
"""
from __future__ import annotations

import re

from .facts import chip_host, select_renderable_facts, suppression_notice
from .narrator import CardPlan, Line, NarratorUnavailable, SuppliedNarrator, TemplateNarrator
from .ranking import mutuality, rank_room
from .reason import cited_signal_ids, reason_sentence, say_context, validate_reason
from .recency import build_now_block
from .scoring import score_pair

#: DEC-5. Structure gates hard-fail the digest; content is graded with partial credit.
GATE_BLOCKS = "required_blocks_present_and_ordered"
GATE_WORDS = "word_count_in_band"
GATE_SAYABLE = "closing_block_is_sayable"
GATE_PROVENANCE = "every_rendered_fact_carries_provenance"
GATE_REASON = "reason_cites_only_fired_signals"

_IMPERATIVES = {
    "ask", "tell", "say", "open", "greet", "mention", "lead", "start", "try", "offer",
    "bring", "congratulate", "invite", "keep", "let", "walk", "point", "introduce", "steer",
}


def count_words(blocks) -> int:
    """DERIVED, never supplied. A card asserting a count it cannot derive from its own text is an
    error (P0-7); the fixtures hand in block text and this is the only source of the number."""
    return sum(len((b.get("text") or "").split()) for b in blocks)


def is_sayable(text: str, addressee: str | None = None) -> bool:
    """SBAR's Recommendation slot: spoken to somebody, present tense, not a bare fact.

    Three forms qualify. An imperative opener ("Ask him whether…"). A second-person pronoun ("you've
    written about his work"). And, when the caller says who is being spoken to, a VOCATIVE —
    "Emmett, Nabeel Qureshi is here this evening."

    The vocative had to be added because this gate and `narrator.validate_say_line` were two
    separate spellings of one rule, and they disagreed. The narrator's own instructions demand a
    declarative name-drop that does not route the member; on a thin fact the model answers with a
    vocative, which both checks then rejected — and rejecting the closing line withholds the entire
    brief. `addressee` defaults to None, so a caller that cannot say who is being addressed gets
    the old, stricter test unchanged.

    A line that addresses nobody — "He has taken those meetings for twenty years." — is still not
    sayable, which is the whole point of the gate.
    """
    words = (text or "").strip().split()
    if not words:
        return False
    if words[0].strip('“"').lower() in _IMPERATIVES:
        return True
    if re.search(r"\byou(?:r(?:s|self)?|['’](?:re|ve|ll|d))?\b", text, re.IGNORECASE):
        return True
    return _opens_with_vocative(text, addressee)


def _opens_with_vocative(text: str, addressee: str | None) -> bool:
    """"Emmett, …" / "Brad — …". Direct address by name, then a break, then the line."""
    addressee = (addressee or "").strip()
    if not addressee:
        return False
    names = {addressee, addressee.split()[0]}
    pattern = "|".join(re.escape(n) for n in sorted(names, key=len, reverse=True))
    return re.match(rf"[“\"']?\s*(?:{pattern})\s*[,—–-]\s*\S", text or "",
                    re.IGNORECASE) is not None


def render_card(narration: dict, *, settings, facts: list[dict] | None = None,
                scored_pair: dict | None = None, degraded: bool = False,
                addressee: str | None = None) -> dict:
    """Run every hard gate over a composed card. On any failure the card is withheld, not trimmed.

    `degraded` marks the non-card responses R-033 exempts from the word band — `not_found`,
    ambiguous, and the withheld greeting. They are never padded to reach it.
    """
    blocks = sorted(narration.get("blocks") or [], key=lambda b: b.get("order", 0))
    failures: list[dict] = []

    labels = [b.get("label") for b in blocks]
    if labels != list(settings.required_blocks):
        failures.append({"gate": GATE_BLOCKS, "observed": labels,
                         "allowed": list(settings.required_blocks)})

    words = count_words(blocks)
    lo, hi = settings.word_band
    if not degraded and not (lo <= words <= hi):
        failures.append({"gate": GATE_WORDS, "observed": words, "allowed": [lo, hi]})

    closing = blocks[-1] if blocks else {}
    closing_kind = closing.get("kind")
    if closing_kind != "sayable" or not is_sayable(closing.get("text") or "", addressee):
        failures.append({"gate": GATE_SAYABLE, "observed": closing_kind})

    if facts is not None:
        chips = {f.get("fact_id") or f.get("id"): f for f in facts}
        missing = []
        for b in blocks:
            for fid in ([b["fact_id"]] if b.get("fact_id") else []) + list(b.get("fact_ids") or []):
                f = chips.get(fid)
                if not f or not f.get("source_url"):
                    missing.append(fid)
        if missing:
            failures.append({"gate": GATE_PROVENANCE, "observed": sorted(missing)})

    cited = []
    for b in blocks:
        cited.extend(b.get("cited_signal_ids") or [])
    if scored_pair is not None and cited:
        check = validate_reason(scored_pair, {"cited_signal_ids": cited})
        failures.extend(check["gate_failures"])

    failures.sort(key=lambda g: g["gate"])
    passed = not failures
    card = None
    if passed:
        card = {
            "blocks": [
                {k: v for k, v in b.items() if k in
                 ("order", "label", "kind", "text", "fact_id", "fact_ids", "cited_signal_ids")}
                for b in blocks
            ],
            "word_count": words,
            "closing_block_kind": closing_kind,
        }
    return {"card": card, "gate_failures": failures, "gates_passed": passed,
            "observed_word_count": words}


# ── digest ────────────────────────────────────────────────────────────────────

def _room_plan(ranked: dict, *, settings, names: dict, pairs: dict,
               labels: dict | None = None, arriving_name: str = "They") -> dict:
    surfaced = [m for m in ranked["ranked_matches"] if m["surfaced"]]
    if not ranked["ranked_matches"]:
        return {"kind": "empty", "cited_signal_ids": []}
    if not surfaced:
        top = ranked["ranked_matches"][0]
        return {"kind": "no_strong_match", "cited_signal_ids": [],
                "top_score": top["score"], "floor": settings.surface_min_score}

    # R-038: exactly one candidate is named. Everyone else collapses into what is true about
    # them — the template narrator says so, and nobody below the floor is ever a "backup".
    primary = surfaced[0]
    primary_name = names.get(primary["member_id"], primary["member_id"])
    plan = {
        "kind": "match",
        "primary_member_id": primary["member_id"],
        "primary_sentence": reason_sentence(
            primary["fired_signals"], primary_name, labels, arriving_name),
        "cited_signal_ids": cited_signal_ids(primary["fired_signals"]),
        "score": primary["score"],
        "intent_class": primary.get("intent_class"),
    }
    # What the host physically does, in words backed by edges (R-022a). The retired
    # mutual/broker machinery lives on only as this one sentence.
    mode = pairs.get(primary["member_id"])
    if mode:
        plan["mutuality"] = mode
        plan["hosting_sentence"] = {
            "mutual": "The pull runs both ways, so make the introduction and leave them to it.",
            "one_way": "The pull runs one way, so stay a moment and carry the reason across.",
            "neither": "",
        }[mode]
    if primary.get("intent_class") == "guarded":
        plan["hosting_sentence"] = (
            "Worth knowing: the interest here runs one way — one of them wants something the "
            "other has set down. Make it brief and social, not a pitch.")
    # R-034: the block covers the whole room, in one or two short sentences — never a roll call.
    # Other above-floor pairings are counted, not named (R-038: exactly one candidate is named);
    # everyone else is answered in aggregate, with the honest zero called out when there is one.
    others = [m for m in ranked["ranked_matches"] if m["member_id"] != primary["member_id"]]
    extra_surfaced = [m for m in others if m["surfaced"]]
    below = [m for m in others if not m["surfaced"]]
    sentences = []
    if extra_surfaced:
        n = len(extra_surfaced)
        words = {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five",
                 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"}
        sentences.append(
            f"{words.get(n, n)} other pairing{'s' if n != 1 else ''} also "
            f"clear{'' if n != 1 else 's'} the bar; {primary_name} is the strongest tonight.")
    if below:
        zero = below[-1] if below[-1]["score"] == 0 else None
        if len(below) == 1:
            other_name = names.get(below[0]["member_id"], below[0]["member_id"])
            sentences.append(
                f"{other_name} is also present; nothing is measured between them." if zero else
                f"{other_name} is also present; nothing there clears the bar.")
        elif zero:
            zero_name = names.get(zero["member_id"], zero["member_id"])
            sentences.append(
                f"On the other {len(below)} present, nothing clears the bar — "
                f"{zero_name} shares nothing measured at all.")
        else:
            sentences.append(f"Nothing on the other {len(below)} present clears the bar.")
    if sentences:
        plan["others_sentence"] = " ".join(sentences)
    plan["say_context"] = say_context(
        primary["fired_signals"], primary_name, labels, arriving_name)
    return plan


def generate_digest(inputs: dict, *, settings, clock: str, store=None, narrator=None) -> dict:
    """The whole product in one call: a name arrives, the room is scored, one match is surfaced
    with a reason built only from fired signals, a sourced deep cut is chosen, suppressions are
    disclosed without leaking their text, and the card closes on a line the host can say."""
    arrival = inputs.get("arrival") or {}
    arriving = inputs.get("arriving_member")
    member_id = (arriving or {}).get("id") or arrival.get("member_id")

    aliases = store.aliases() if store else None
    if arriving is None and store is not None:
        arriving = store.member(member_id)
    arriving = arriving or {"id": member_id}

    present_in = inputs.get("present_members")
    if present_in is None and store is not None:
        present_in = [p for p in store.present_ids() if p != member_id]
    present: list[dict] = []
    for p in present_in or []:
        if isinstance(p, dict):
            present.append(p)
        elif store is not None:
            rec = store.member(p)
            if rec:
                present.append(rec)
        else:
            present.append({"id": p})

    signal_evidence = inputs.get("signal_evidence")
    if signal_evidence is None and store is not None:
        signal_evidence = store.signal_evidence(member_id, [p["id"] for p in present])

    ranked = rank_room(arriving, present, settings=settings,
                       signal_evidence=signal_evidence, aliases=aliases)

    names = {}
    for p in present:
        names[p["id"]] = p.get("display_name") or (
            store.member(p["id"]) or {}).get("display_name") if store else p["id"]
        names[p["id"]] = names[p["id"]] or p["id"]

    pairs = {}
    for m in ranked["_matches"]:
        b = next(p for p in present if p["id"] == m["member_id"])
        reverse = score_pair(b, arriving, aliases=aliases,
                             s8_requires_substrate=settings.s8_requires_substrate)
        pairs[m["member_id"]] = mutuality(
            m["_pair"], reverse, minimum=settings.surface_min_score,
            requires_any_of=settings.surface_requires_any_of)

    vocab_labels = {slug: v.get("label") for slug, v in (store.vocabulary() if store else {}).items()}
    if store is not None:
        vocab_labels.update({r["slug"]: r["label"] for r in store.conn.execute(
            "SELECT slug, label FROM industry")})
    arriving_name = ((store.member(member_id) or {}).get("display_name") if store else None) \
        or arriving.get("display_name") or member_id
    room = _room_plan(ranked, settings=settings, names=names, pairs=pairs, labels=vocab_labels,
                      arriving_name=arriving_name)

    # ── material ──────────────────────────────────────────────────────────────
    candidates = inputs.get("facts")
    if candidates is None and store is not None:
        candidates = store.candidate_facts(member_id)
    selection = select_renderable_facts(candidates or [], settings=settings)
    renderable = {f.get("fact_id") or f.get("id"): f for f in (candidates or [])
                  if (f.get("fact_id") or f.get("id")) in selection["renderable_fact_ids"]}
    chips = {c["fact_id"]: c for c in selection["provenance_chips"]}

    suppressed = inputs.get("suppressed_facts")
    if suppressed is None and store is not None:
        suppressed = store.suppressed_facts(member_id)
    suppression = suppression_notice(suppressed or [])

    now_inputs = dict(inputs)
    if store is not None and "items" not in now_inputs and "source_status" not in now_inputs:
        now_inputs = {"items": store.items(member_id),
                      "source_status": store.source_status(member_id),
                      "store_recency": store.recency_state(member_id)}
    recency = build_now_block(now_inputs, settings=settings, as_of=clock)

    plan = _build_plan(member_id, arriving, store, renderable, chips, recency, room,
                       suppression, settings)

    narration = inputs.get("narration")
    if narration and narration.get("blocks"):
        active_narrator = SuppliedNarrator(narration["blocks"])
    else:
        active_narrator = narrator or TemplateNarrator()
    try:
        blocks = active_narrator.compose(plan)
    except NarratorUnavailable:
        return _withheld(member_id, plan, ranked, room, suppression, settings,
                         selection=selection, recency=recency)

    scored_pair = None
    if room.get("kind") == "match":
        top = next(m for m in ranked["ranked_matches"]
                   if m["member_id"] == room["primary_member_id"])
        scored_pair = {"fired_signals": top["fired_signals"]}

    gated = render_card({"blocks": blocks}, settings=settings,
                        facts=candidates if candidates is not None else None,
                        scored_pair=scored_pair, addressee=plan.display_name)

    deep_cut_fact_id = None
    for b in blocks:
        if b.get("label") == "Notice":
            deep_cut_fact_id = b.get("fact_id")
    if deep_cut_fact_id is None and plan.deep_cut:
        deep_cut_fact_id = plan.deep_cut.fact_id

    grade = _grade(deep_cut_fact_id, renderable, chips, blocks, plan.display_name)

    result = {
        "card": gated["card"],
        "ranked_matches": ranked["ranked_matches"],
        "surfaced_count": ranked["surfaced_count"],
        "excluded_topics": ranked["excluded_topics"],
        "pairs_scored": ranked["pairs_scored"],
        "room_block_kind": ranked["room_block_kind"],
        "tie_broken_by": ranked["tie_broken_by"],
        "deep_cut_fact_id": deep_cut_fact_id,
        "renderable_fact_ids": selection["renderable_fact_ids"],
        "provenance_chips": selection["provenance_chips"],
        "recency": recency,
        "mutuality": pairs.get(room.get("primary_member_id")),
        "intent_class": room.get("intent_class"),
        "gate_failures": gated["gate_failures"],
        "gates_passed": gated["gates_passed"],
        "verdict": "pass" if gated["gates_passed"] else "fail",
        "content_grade": grade,
    }
    result.update(suppression)
    return result


def _build_plan(member_id, arriving, store, renderable, chips, recency, room, suppression,
                settings) -> CardPlan:
    person = store.member(member_id) if store else None
    label_row = store.label(member_id) if store else None
    correction = None
    if label_row and label_row.get("stale"):
        correction = (f"the door said {label_row['supplied_label']}; "
                      f"it is {label_row['current_label']} now")

    def line(fid) -> Line:
        f = renderable[fid]
        return Line(text=(f.get("text") or "").strip(), chip=chips.get(fid), fact_id=fid)

    ordered = sorted(
        renderable,
        key=lambda fid: (renderable[fid].get("source_date") or "", fid),
        reverse=True,
    )
    # R-034: Who carries "one borrowed attributed line". A line is only BORROWED if the member
    # actually said it, so a fact must carry a quotation to qualify. An analyst-voice summary
    # presented as "in their own words" is a false attribution, which is the class of error the
    # whole engine exists to prevent.
    borrowed = None
    for fid in ordered:
        f = renderable[fid]
        if f.get("provenance_class") not in ("self_published", "on_record"):
            continue
        span = (f.get("quote") or "").strip()
        if span:
            borrowed = Line(text=span, chip=chips.get(fid), fact_id=fid)
            break

    # The deep cut is the least search-visible sourced fact available, oldest first — a deep cut
    # is by definition the thing that is not on the first page of a search. R-041 keeps it honest:
    # a thin profile emits fewer facts and sets this to None rather than reaching for something.
    deep_pool = sorted(
        (fid for fid in ordered
         if not renderable[fid].get("search_first_page")
         and (borrowed is None or fid != borrowed.fact_id)),
        key=lambda fid: (renderable[fid].get("source_date") or "9999", fid),
    )
    deep_cut = line(deep_pool[0]) if deep_pool else None

    used = {l.fact_id for l in (borrowed, deep_cut) if l}
    rest = [fid for fid in ordered if fid not in used]
    # DEC-9 / the leak test. There is no structural family rule — the user decided that
    # explicitly — so this is the compose-time JUDGEMENT the decision asks for, made
    # deterministically: a line that names somebody's household sinks to the bottom of the pool
    # and is used only when nothing else can carry the card. It is never excluded, because by
    # decision there is no rule to violate; it is simply never the first thing a host reads.
    rest.sort(key=lambda fid: (_leak_risk(renderable[fid].get("text") or ""),
                               -_recency_rank(renderable[fid])))
    recent = [line(fid) for fid in rest[:2]]
    used |= {l.fact_id for l in recent}
    supporting = [line(fid) for fid in rest if fid not in used]

    return CardPlan(
        member_id=member_id,
        display_name=(person or {}).get("display_name") or arriving.get("display_name") or member_id,
        name_respelling=(person or {}).get("name_respelling"),
        label=(label_row or {}).get("current_label", ""),
        correction_line=correction,
        borrowed=borrowed,
        recency=recency,
        recent=recent,
        room=room,
        deep_cut=deep_cut,
        supporting=supporting,
        suppression=suppression,
        word_band=tuple(settings.word_band),
    )


#: The leak test, in words a template can apply. Not a gate (DEC-9) — an ordering.
_HOUSEHOLD = ("wife", "husband", "spouse", "partner ", "daughter", "son ", "children", "kids",
              "family home", "his home", "her home", "their home")


def _leak_risk(text: str) -> int:
    """0 = ordinary, 1 = names a household. Sorted ascending, so households sink."""
    low = text.lower()
    return 1 if any(word in low for word in _HOUSEHOLD) else 0


def _recency_rank(fact: dict) -> int:
    date = (fact.get("source_date") or "0000-00-00")[:10].replace("-", "")
    return int(date) if date.isdigit() else 0


def _grade(deep_cut_fact_id, renderable, chips, blocks, addressee=None) -> dict:
    """DEC-5's graded half. Partial credit, reported as a score and a failure list."""
    checks = {
        "deep_cut_found": deep_cut_fact_id is not None,
        "deep_cut_non_obvious": bool(
            deep_cut_fact_id and not (renderable.get(deep_cut_fact_id) or {}).get("search_first_page")),
        "reason_cites_resolvable_source": all(
            c.get("source_host") for c in chips.values()) if chips else bool(deep_cut_fact_id),
        "talk_track_is_sayable": bool(blocks) and is_sayable(blocks[-1].get("text") or "",
                                                            addressee),
    }
    scored = sum(1 for v in checks.values() if v)
    return {"scored": scored, "possible": len(checks),
            "ratio": round(scored / len(checks), 4),
            "failed": sorted(k for k, v in checks.items() if not v)}


def _withheld(member_id, plan, ranked, room, suppression, settings, *,
              selection: dict | None = None, recency: dict | None = None) -> dict:
    """R-048: the narrator is the only permitted external dependency, and when it is unavailable
    the card degrades to a deterministic greeting rather than to a guess.

    A withheld digest is still a DIGEST, and it carries the same keys a passing one does. The
    selection and the recency verdict were both computed before the narrator was ever called, so
    dropping them here made the withheld path a different shape from the happy path — and any
    caller that read `digest["renderable_fact_ids"]` by subscript (scripts/urls.py, which `make
    run` and `make serve` both depend on) died with a KeyError on the one path that is supposed to
    be the safe degradation.
    """
    selection = selection or {}
    blocks = [{"order": 1, "label": "Who", "kind": "identity",
               "text": f"{plan.display_name}. {plan.label}".strip()},
              {"order": 5, "label": "Say", "kind": "sayable",
               "text": "Greet them by name and log the arrival. The brief is withheld."}]
    result = {
        "card": None,
        "card_state": "withheld",
        "blocks": blocks,
        "ranked_matches": ranked["ranked_matches"],
        "surfaced_count": ranked["surfaced_count"],
        "excluded_topics": ranked["excluded_topics"],
        "room_block_kind": ranked["room_block_kind"],
        "gate_failures": [{"gate": "narrator_available", "observed": False}],
        "gates_passed": False,
        "verdict": "fail",
        "content_grade": {"scored": 0, "possible": 4, "ratio": 0.0, "failed": []},
        "deep_cut_fact_id": None,
        "renderable_fact_ids": selection.get("renderable_fact_ids", []),
        "provenance_chips": selection.get("provenance_chips", []),
        "recency": recency or {},
    }
    result.update(suppression)
    return result
