# Requirements coverage — R-001 … R-059 (plus R-027a)

Where each PRD requirement is met, and — for the six that this build could not fully close — what is
actually true instead. Nothing is marked met on the strength of an intention.

Legend: **✔** met in this build · **◐** partially met, with the residual stated · **⊘** out of this
build's scope (ingest-side collection, run by separate agents), with the runtime-side half named.

## 1. Thesis

| R | | where |
|---|---|---|
| R-001 | ✔ | `arena/webhook.py` — HMAC-SHA256 over `timestamp.body`, constant-time compare, ±300s window, single-use signatures; malformed or unknown identities refused before any profile or Room read. Tests: forged sender, modified body, replay, stale timestamp, unconfigured secret |
| R-002 | ✔ | the disclosure gates, the suppression counter, and the leak-test ordering in `arena/card.py` |
| R-003 | ✔ | the shippable test is the reason the borrowed line, the deep cut and the Say line are all sourced and all attributable |
| R-004 | ✔ | `v_renderable_fact` queried not re-implemented; `quiet` vs `unknown`; `fact.quote`; no pronoun guessed anywhere |

## 2. Sourcing

| R | | where |
|---|---|---|
| R-005 | ◐ | tiers are modelled and enforced (`arena/adapters/registry.py`); GREEN/METERED/SESSION carried on every `AdapterSpec`. Collection itself is ingest-side. No credential is read, written or logged by the runtime |
| R-006 | ✔ | the relational layer is queried: `edge`, `context`, `via_edge_type`/`via_person_id`, one-hop only |
| R-007 | ✔ | `assert_read_only` runs at registry construction; a write method cannot be registered. Test: `test_an_adapter_with_a_write_method_cannot_be_registered` |
| R-008 | ✔ | `measured_status = "blocked"` yields `unavailable` with zero facts; TikTok ships that way. Nothing evades a wall |
| R-009 | ✔ | `arena/adapters/session.py` — closed whitelist, `operator_data_stored` counted, G-029 |
| R-010 | ⊘ | evidence precedence on contradiction is an ingest-time resolution rule; the runtime renders what the store holds and never merges conflicting sources |
| R-011 | ✔ | `arena/ingest.py` — unavailable returns empty and is never backfilled; partial profiles are marked. G-027 |

## 3. Identity and staleness

| R | | where |
|---|---|---|
| R-012 | ✔ | `arena/identity.py` — ≥1 STRONG or ≥2 WEAK from different surfaces; handle-plus-display-name on one surface refused |
| R-013 | ✔ | `resolve_arrival_name` + `/resolve` chooser; deceased candidate ⇒ `ambiguous`, no brief |
| R-014 | ✔ | `arena/labels.py`; the store's measured `member_label.stale` wins over derivation |
| R-015 | ✔ | `label_correction` emitted; the Who block shows *"the door said Twitch; it is Softmax — CEO now"* |

## 4. Scoring

| R | | where |
|---|---|---|
| R-016 | ✔ | `arena/scoring.py` — three buckets, full weight or zero |
| R-017 | ✔ | S2/S3 mutually exclusive by construction; `CEILING == 16` asserted |
| R-018 | ✔ | S8 gated on substrate **and** excluded from the threshold; `score_excluding_s8()` |
| R-019 | ✔ | `topic.discriminating`, read from the vocabulary, never recomputed from the room |
| R-020 | ✔ | `surfaces()` — inclusive `>= 6` plus one of S3/S5/S7; below it nobody is named |
| R-021 | ✔ | `arena/ranking.py` — three tiers; S8 excluded from evidence recency |
| R-022 | ✔ | `brokering_mode()` on S8-excluded scores; shown on the card and on Why-this-score |
| R-023 | ✔ | every `Signal` carries `evidence` (the table) and `detail` (the sentence) |

## 5. Disclosure

| R | | where |
|---|---|---|
| R-024 | ✔ | the chip is mandatory and never sufficient: the view gates first |
| R-025 | ✔ | enforced by `v_renderable_fact`, loaded from `db/schema.sql` and queried |
| R-026 | ✔ | `third_party_open` never renders and never reaches narrator context. G-034 |
| R-027 | ◐ | by DEC-9 there is no structural rule. The judgement is made deterministically: `_leak_risk` sinks household-naming lines to the bottom of the pool. Residual is DEC-9's, unchanged — a card *may* still carry a family fact |
| R-027a | ✔ | traversed facts render on their own merits, labelled `via_edge_type` on the chip; the edge never scores (`DIRECTED_LINK_TYPES` excludes it) and is never named |
| R-028 | ✔ | class and count only; a leak is a red-first mutation that kills G-022 |
| R-029 | ✔ | the worked example ships suppressed in `seed/synthetic.sql` (`f_syn_huffman_form4`) |
| R-030 | ✔ | the narrator receives only render-eligible facts and adds none; `TemplateNarrator` cannot |
| R-031 | ⊘ | ingest-side. The runtime stores no image and no signed CDN URL, and there is no code path that could |
| R-032 | ◐ | rewritten by DEC-15: the opt-out half is withdrawn (members are never told the service exists, so none of them could ever have declined it) and the column is gone from the scratch schema. What remains is the purge, and **it is blocked by `db/schema.sql`'s missing `ON DELETE` actions** — measured, written up, patched in the scratch store only |

## 6. The card

| R | | where |
|---|---|---|
| R-033 | ✔ | derived word count, hard gate, degraded states exempt and never padded |
| R-034 | ✔ | five ordered bare-noun blocks; respelling when present; the borrowed line comes from `fact.quote` or is omitted |
| R-035 | ✔ | `closing_block_is_sayable` gate, with an imperative/second-person test |
| R-036 | ✔ | reason in prose, score as a small Inter link beside it |
| R-037 | ✔ | `validate_reason` is a hard gate on the digest. G-020 |
| R-038 | ✔ | one primary, one backup, everyone else collapses; below the floor the miss is stated without a name |
| R-039 | ✔ | `say_context()` selects a fired fact; the Say prompt turns it into warm words the host can speak verbatim, never stage directions or member routing |
| R-040 | ✔ | `arena/recency.py` — three states; only `quiet` may state silence; reruns dated by recording |
| R-041 | ✔ | thin profile: fewer facts, `deep_cut_fact_id: null`, no Notice block, nothing invented |
| R-042 | ◐ | never linked from a member-facing surface. Since **DEC-14** there is no unguessable path either; `noindex` + robots disallow are search-visibility control only. P0-5 is REOPENED and stated in the README |

## 7. Surfaces

| R | | where |
|---|---|---|
| R-043 | ◐ | mobile-first, three surfaces, no login, served at the root. Same P0-5 residual, now larger |
| R-044 | ✔ | Room: presence by `arrived_at`, name and time, simulate-arrival, mark-departed |
| R-045 | ✔ | all ten states in `arena/view.py::STATE_COPY` with rule-chosen triggers |
| R-046 | ✔ | fired signals with weights, signals that did not fire **and why**, excluded topics with their share, the reverse-direction score, brokering mode |
| R-047 | ✔ | retry re-runs render only; tested to return identical failures five times |

## 8. Architecture and storage

| R | | where |
|---|---|---|
| R-048 | ✔ | ingest → SQLite → read-only serve; narrator is the only external seam and its absence degrades to a withheld greeting; logs carry identifiers and statuses only |
| R-049 | ✔ | one hop, point lookups, the file is the cache |
| R-050 | ✔ | deterministic selection through `say_context`; the deployed `ModelNarrator` may rewrite only the final Say line from the two names and one fired fact, with no tools or stored response |
| R-051 | ✔ | append-only; every row names its run; emitted cards recorded under `run_serving` |

## 9. Demo and deliverables

| R | | where |
|---|---|---|
| R-052 | ◐ | repo ✔, next-month paragraph ✔, container builds and runs ✔. **Not deployed to a public host** — that needs a hosting target and credentials, and publishing a page carrying ten real named people is not a call to make unasked |
| R-053 | ✔ | ten cached, one live GREEN re-run from Room; `deployed_registry()` cannot return a SESSION adapter |
| R-054 | ✔ | `docs/HOURS.md`, with the cut line and an honest measurement basis |

## 11. Implementation contract

| R | | where |
|---|---|---|
| R-055 | ✔ | `is_member = 1` is the membership; `rank_room` drops `is_member = 0` before scoring |
| R-056 | ✔ | `v_collectable_source` queried; deny-listed values refused, not down-weighted |
| R-057 | ⊘ | the walk is ingest-side. The runtime performs no traversal: `via_edge_type` is read off facts already written onto the member |
| R-058 | ✔ | `source_status` read through `v_recency_state`; a 200 with zero items is not silence |
| R-059 | ✔ | as **rewritten by DEC-14**: opaque tokens, generic `<title>`, `noindex`, `no-referrer`, robots disallow, and a README that says in one plain sentence that this is a staff instrument on an open URL carrying ten real named people. The unguessable-path clause was struck at the operator's instruction; `ARENA_PUBLIC_ROOT=0` restores it as a deployment **option**, which is how R-059 now describes it |

---

**Summary (R-059 rewritten by DEC-14 on 2026-09-04): 48 met, 6 partial with the residual stated, 3 ingest-side with the runtime half named,
and 3 more (R-005, R-032, R-052) partial for reasons written up above.** The three that would most
change the answer are the same three named in the README: a session behind the card, the `ON DELETE`
schema request, and a hosting target.
