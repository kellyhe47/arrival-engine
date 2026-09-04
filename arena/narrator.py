"""The narrator seam. It writes prose and makes no decisions.

The determinism boundary runs through this file and nowhere else at render time. Everything above
it — resolution, scoring, buckets, ranking, the floor, disclosure, the gates — is deterministic.
The narrator may only REPHRASE retrieved facts; it may never add one (R-030). No golden fixture
asserts model prose, and no narrator output changes a score.

Three implementations:

  SuppliedNarrator   the fixture-backed fake. Returns the blocks it was handed, verbatim.
  TemplateNarrator   deterministic prose assembled from the plan's own sourced material.
                     This is the DEFAULT in the deployed app, which is why `external_calls` is
                     genuinely empty rather than merely unasserted.
  ModelNarrator      the injected seam, temperature 0. It receives render-eligible structured facts
                     and nothing else: no tools, no network authority, no untrusted text. When the
                     client is absent the card degrades to a deterministic withheld greeting
                     (R-048), never to a guess.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Protocol

BLOCK_KINDS = {"Who": "identity", "Now": "recency", "Room": "match",
               "Notice": "deep_cut", "Say": "sayable"}


class NarratorUnavailable(RuntimeError):
    """The narrator could not be reached. The caller degrades to the withheld greeting."""


@dataclass
class Line:
    """One sourced sentence and the chip that lets a host answer 'how do you know that?'."""

    text: str
    chip: dict | None = None
    fact_id: str | None = None


@dataclass
class CardPlan:
    """Everything the narrator is allowed to see. Assembled by `arena.card`, never by a model."""

    member_id: str
    display_name: str
    name_respelling: str | None = None
    label: str = ""
    correction_line: str | None = None
    borrowed: Line | None = None
    recency: dict = field(default_factory=dict)
    recent: list[Line] = field(default_factory=list)
    room: dict = field(default_factory=dict)
    deep_cut: Line | None = None
    supporting: list[Line] = field(default_factory=list)
    suppression: dict = field(default_factory=dict)
    word_band: tuple[int, int] = (250, 350)


class Narrator(Protocol):
    temperature: int

    def compose(self, plan: CardPlan) -> list[dict]:
        ...


class SuppliedNarrator:
    """The fixture-backed fake. Prose comes in with the case; nothing is generated."""

    temperature = 0

    def __init__(self, blocks: list[dict]):
        self._blocks = [dict(b) for b in sorted(blocks, key=lambda b: b.get("order", 0))]

    def compose(self, plan: CardPlan) -> list[dict]:
        out = []
        for b in self._blocks:
            block = dict(b)
            block.setdefault("kind", BLOCK_KINDS.get(block.get("label"), "prose"))
            out.append(block)
        return out


def _count(blocks) -> int:
    return sum(len((b.get("text") or "").split()) for b in blocks)


class TemplateNarrator:
    """Deterministic prose. Same plan in, same words out, forever, with no network call.

    Length is reached by including MORE SOURCED MATERIAL, never by padding: if the required
    sentences fall short of the band, supporting facts are added one at a time in a fixed order
    until the band is reached. If the available sourced material cannot carry the band, the card
    is short and `arena.card` fails the word-count gate honestly rather than inventing a sentence.
    """

    temperature = 0

    def compose(self, plan: CardPlan) -> list[dict]:
        """Fit the band by choosing how much SOURCED material to include, never by padding.

        The core — name, label, the recency verdict, the room, the deep cut, the sayable line — is
        always present and is short. Optional sourced lines are then added greedily in a fixed
        order, skipping any that would push the card over the ceiling, until the floor is reached.
        If the available material cannot reach the floor, the card comes out short and
        `arena.card` fails the word-count gate honestly: that is a thin profile, not a defect.
        """
        low, high = plan.word_band
        # R-034 makes the borrowed attributed line part of Who, not an optional extra, so it is in
        # the core rather than in the fill pool — otherwise a card whose core already reaches the
        # floor silently drops the one line the host was meant to be able to repeat verbatim.
        chosen_who: list[Line] = [plan.borrowed] if plan.borrowed else []
        chosen_now: list[Line] = []
        pool = list(plan.recent) + list(plan.supporting)

        def build(who_lines, now_lines):
            return [
                {"order": 1, "label": "Who", "kind": "identity",
                 "text": self._who(plan, extra=who_lines)},
                {"order": 2, "label": "Now", "kind": "recency",
                 "text": self._now(plan, extra=now_lines)},
                {"order": 3, "label": "Room", "kind": "match", "text": self._room(plan),
                 "cited_signal_ids": plan.room.get("cited_signal_ids", [])},
                {"order": 4, "label": "Notice", "kind": "deep_cut", "text": self._notice(plan),
                 "fact_id": plan.deep_cut.fact_id if plan.deep_cut else None},
                {"order": 5, "label": "Say", "kind": "sayable", "text": self._say(plan)},
            ]

        blocks = build(chosen_who, chosen_now)
        total = _count(blocks)
        for line in pool:
            if total >= low:
                break
            words = len(line.text.split()) + 8      # allowing for the sentence that carries it
            if total + words > high:
                continue                            # too long for what is left; try the next one
            chosen_now.append(line)
            blocks = build(chosen_who, chosen_now)
            total = _count(blocks)

        blocks[1]["fact_ids"] = [l.fact_id for l in chosen_now if l.fact_id]
        if chosen_who:
            blocks[0]["fact_ids"] = [l.fact_id for l in chosen_who if l.fact_id]
        return blocks

    # ── blocks ────────────────────────────────────────────────────────────────
    def _who(self, plan: CardPlan, extra: list[Line] | None = None) -> str:
        name = plan.display_name
        if plan.name_respelling:
            name = f"{name} [{plan.name_respelling}]"
        parts = [f"{name}. {plan.label}." if plan.label else f"{name}."]
        if plan.correction_line:
            parts.append(f"Worth knowing before you open: {plan.correction_line}.")
        for line in extra or []:
            parts.append(f"In their own words: “{line.text}”")
        return " ".join(parts)

    def _now(self, plan: CardPlan, extra: list[Line] | None = None) -> str:
        r = plan.recency or {}
        kind = r.get("block_kind")
        if kind == "coverage_gap":
            ids = list(r.get("unavailable_source_ids") or [])
            # The host is standing at a door. Three names and a count reads; ten names does not.
            # The full list is on the card below this block, so nothing is hidden by shortening it.
            if len(ids) > 3:
                names = f"{', '.join(ids[:3])} and {len(ids) - 3} others"
            else:
                names = ", ".join(ids) or "one source"
            head = (f"Coverage is incomplete — {names} could not be read on the last run — so "
                    f"there is no claim to make in either direction about what they have been "
                    f"doing lately. What follows is what was reached, not what exists.")
        elif kind == "honest_absence" and r.get("days_since_latest") is not None:
            head = (f"The trail is cold. The freshest thing read on them is dated "
                    f"{r.get('latest_effective_date')}, {r['days_since_latest']} days ago. "
                    f"Old material is not dressed up as current here.")
        elif kind == "honest_absence":
            head = ("Every source was reached and nothing first-person came back. That is genuine "
                    "quiet, not a gap in our reading.")
        else:
            # Deliberately "read", not "published". `fact.source_date` is the date of the SOURCE
            # DOCUMENT, and for a profile page that is the day we looked — so the newest date in
            # the store is not evidence that anything new was published. See the
            # `fact.item_published_at` request in docs/schema-requests.md.
            head = (f"The freshest thing read on them is dated {r.get('latest_effective_date')}, "
                    f"{r.get('days_since_latest')} days ago.")
        lines = [head]
        for line in extra or []:
            lines.append(line.text)
        return " ".join(lines)

    def _room(self, plan: CardPlan) -> str:
        room = plan.room or {}
        if room.get("kind") == "empty":
            return ("First one here. There is nobody to introduce yet, and inventing a reason to "
                    "wait for someone would be worse than saying so.")
        if room.get("kind") == "no_strong_match":
            return (f"Nobody in the room clears the bar tonight. The closest pairing scored "
                    f"{room.get('top_score')} against a floor of {room.get('floor')}, so no name "
                    f"is offered — a weak introduction spends credibility a strong one will need.")
        parts = [room.get("primary_sentence", "")]
        if room.get("backup_sentence"):
            parts.append(room["backup_sentence"])
        if room.get("brokering_sentence"):
            parts.append(room["brokering_sentence"])
        return " ".join(p for p in parts if p)

    def _notice(self, plan: CardPlan) -> str:
        if not plan.deep_cut:
            return ("Nothing here rises to a deep cut that is both sourced and worth saying out "
                    "loud, so this block stays empty rather than reaching for something thin.")
        chip = plan.deep_cut.chip or {}
        return (f"{plan.deep_cut.text} "
                f"That is his own {chip.get('source_host', 'record')}, dated "
                f"{chip.get('source_date', 'undated')}.")

    def _say(self, plan: CardPlan) -> str:
        room = plan.room or {}
        if room.get("say_line"):
            return room["say_line"]
        if plan.deep_cut:
            chip = plan.deep_cut.chip or {}
            return (f"Ask him about it directly rather than around it — he wrote it himself on "
                    f"{chip.get('source_host', 'the record')}, so the question reads as interest "
                    f"rather than research, and he will have the answer ready.")
        return ("Greet him by name, tell him what is happening in the room tonight, and let him "
                "choose what he wants to talk about.")


class ModelNarrator:
    """The injected seam. Temperature 0, no tools, no network authority, structured facts only.

    Deliberately not wired up in the deployed app: every fixture asserts `external_calls: []`, and
    the deterministic template above is what keeps that assertion true. This class is the place a
    model goes when one is wanted, and the contract it must honour is in its own signature — a
    CardPlan in, block text out, no store handle, no fetcher, no untrusted text.
    """

    temperature = 0

    def __init__(self, client=None, *, fallback: Narrator | None = None):
        self.client = client
        self.fallback = fallback

    def compose(self, plan: CardPlan) -> list[dict]:
        if self.client is None:
            if self.fallback is not None:
                return self.fallback.compose(plan)
            raise NarratorUnavailable("no narrator client injected")
        blocks = self.client.compose(plan=plan, temperature=self.temperature)
        for b in blocks:
            b.setdefault("kind", BLOCK_KINDS.get(b.get("label"), "prose"))
        return blocks
