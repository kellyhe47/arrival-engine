#!/usr/bin/env python3
"""Independently re-derive every golden fixture's domain arithmetic from `given`.

This deliberately re-implements the scoring model from docs/scoring-model.md rather than
importing anything, and never reads `expect` before computing. If this file and the fixtures
disagree, one of them is wrong and the disagreement is the point.

This validates the SPEC. It is not the product golden runner.
"""
import json, sys, glob, os
from datetime import date

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GOLDEN = os.path.join(ROOT, "eval", "golden")

BUCKET = {"SMALL": 1, "MID": 2, "LARGE": 3}
W = {"S1": 2, "S2": 2, "S3": 3, "S4": 3, "S5": 3, "S6": 1, "S7": 3, "S8": 1}
SUBSTRATE = {"S2", "S3", "S5", "S7"}
CEILING = W["S1"] + max(W["S2"], W["S3"]) + W["S4"] + W["S5"] + W["S6"] + W["S7"] + W["S8"]

errors, checks = [], 0

def err(fid, msg):
    errors.append(f"{fid}: {msg}")

def ctx_key(c):
    return (c.get("type"), c.get("value"))

def generic_topics(room, max_share, min_room=4):
    """Topics held by strictly more than max_share of the room, once the room is big enough.

    The floor matters: in a room of two, any shared topic is held by 100% of the room, so without
    it the gate would delete every match in a quiet room.
    """
    n = len(room)
    if n < min_room:
        return set()
    counts = {}
    for m in room:
        for t in set(m.get("topics_professional", [])) | set(m.get("topics_personal", [])):
            counts[t] = counts.get(t, 0) + 1
    return {t for t, c in counts.items() if c / n > max_share}

def score(a, b, excluded=frozenset()):
    """Return (score, [signal_ids]) for a -> b, derived only from member records."""
    fired = []
    ia, ib = set(a.get("industries", [])), set(b.get("industries", []))
    tpa = set(a.get("topics_professional", [])) - excluded
    tpb = set(b.get("topics_professional", [])) - excluded
    tsa = set(a.get("topics_personal", [])) - excluded
    tsb = set(b.get("topics_personal", [])) - excluded
    ca = {ctx_key(c) for c in a.get("contexts", [])}
    cb = {ctx_key(c) for c in b.get("contexts", [])}

    if a.get("seniority_tier") == b.get("seniority_tier") and \
       a.get("career_start_decade") == b.get("career_start_decade"):
        fired.append("S1")
    same_industry = bool(ia & ib)
    if same_industry:
        fired.append("S2")
    # S2 and S3 are mutually exclusive: S3 requires NO industry overlap.
    if not same_industry and (tpa & tpb):
        fired.append("S3")
    if ca & cb:
        fired.append("S4")
    if any(l.get("to") == b.get("id") for l in a.get("declared_links", [])):
        fired.append("S5")
    if tsa & tsb:
        fired.append("S6")
    if tpa & tpb:
        fired.append("S7")
    if b.get("prominence_tier", 0) > a.get("prominence_tier", 0) and \
       (set(fired) & SUBSTRATE):
        fired.append("S8")
    return sum(W[s] for s in fired), sorted(fired)

def expected_signals(node):
    return sorted(s["signal_id"] for s in node.get("fired_signals", []))

def check_weights(fid, node):
    global checks
    for s in node.get("fired_signals", []):
        checks += 1
        if s["weight"] != W[s["signal_id"]]:
            err(fid, f"{s['signal_id']} weight {s['weight']} != bucket weight {W[s['signal_id']]}")

def check_sum(fid, node, where):
    global checks
    checks += 1
    tot = sum(s["weight"] for s in node.get("fired_signals", []))
    if node.get("score") != tot:
        err(fid, f"{where}: score {node.get('score')} != sum of fired weights {tot}")
    if not (0 <= node.get("score", 0) <= CEILING):
        err(fid, f"{where}: score {node.get('score')} outside [0,{CEILING}]")

def check_exclusive(fid, node, where):
    global checks
    checks += 1
    sigs = set(expected_signals(node))
    if {"S2", "S3"} <= sigs:
        err(fid, f"{where}: S2 and S3 both fired; they are mutually exclusive")
    if "S8" in sigs and not (sigs & SUBSTRATE):
        err(fid, f"{where}: S8 fired with no substrate signal (S2/S3/S5/S7)")

def check_derived(fid, a, b, node, where, excluded=frozenset()):
    global checks
    checks += 1
    got_score, got_sigs = score(a, b, excluded)
    if got_sigs != expected_signals(node):
        err(fid, f"{where}: re-derived signals {got_sigs} != fixture {expected_signals(node)}")
    if got_score != node.get("score"):
        err(fid, f"{where}: re-derived score {got_score} != fixture {node.get('score')}")

def by_id(fid, members, mid):
    for m in members:
        if m.get("id") == mid:
            return m
    err(fid, f"member {mid} not present in given.inputs")
    return None

def main():
    global checks
    files = sorted(glob.glob(os.path.join(GOLDEN, "*.json")))
    if not files:
        print("no fixtures found", file=sys.stderr); return 1

    for path in files:
        d = json.load(open(path))
        fid, op = d["id"], d["when"]["operation"]
        gi, res = d["given"]["inputs"], d["expect"]["exact"]["result"] or {}
        cfg = d["given"]["configuration"]

        # --- config must not contradict the model ---
        if "bucket_weights" in cfg:
            checks += 1
            if cfg["bucket_weights"] != BUCKET:
                err(fid, f"bucket_weights {cfg['bucket_weights']} != {BUCKET}")

        # --- pairwise scoring ---
        if op == "score_pair_both_directions":
            a, b = gi["member_a"], gi["member_b"]
            for key, (x, y) in {"a_to_b": (a, b), "b_to_a": (b, a)}.items():
                node = res[key]
                check_weights(fid, node); check_sum(fid, node, key)
                check_exclusive(fid, node, key); check_derived(fid, x, y, node, key)

        elif op == "score_directed_pair":
            a, b = gi["member_a"], gi["member_b"]
            check_weights(fid, res); check_sum(fid, res, "result")
            check_exclusive(fid, res, "result"); check_derived(fid, a, b, res, "result")

        # --- room ranking ---
        elif op in ("rank_room", "generate_digest") and "ranked_matches" in res:
            a = gi.get("arriving_member")
            present = gi.get("present_members", [])
            if a and present and isinstance(present[0], dict):
                # genericity gate, re-derived from the room including the arriving member
                excluded = generic_topics([a] + present,
                                          cfg.get("generic_topic_max_share", 0.5),
                                          cfg.get("generic_topic_min_room", 4))
                checks += 1
                asserted_excl = sorted(e["topic"] for e in res.get("excluded_topics", []))
                if sorted(excluded) != asserted_excl:
                    err(fid, f"excluded_topics {asserted_excl} != re-derived {sorted(excluded)}")
                seen_scores = []
                for rm in res["ranked_matches"]:
                    b = by_id(fid, present, rm["member_id"])
                    if not b: continue
                    check_weights(fid, rm); check_sum(fid, rm, rm["member_id"])
                    check_exclusive(fid, rm, rm["member_id"])
                    check_derived(fid, a, b, rm, rm["member_id"], excluded)
                    seen_scores.append(rm["score"])

                    # surfacing rule, re-derived
                    checks += 1
                    mn = cfg.get("surface_min_score", 6)
                    req = set(cfg.get("surface_requires_any_of", ["S3", "S5", "S7"]))
                    want = rm["score"] >= mn and bool(set(expected_signals(rm)) & req)
                    if want != rm["surfaced"]:
                        err(fid, f"{rm['member_id']}: surfaced={rm['surfaced']} but rule gives {want} "
                                 f"(score {rm['score']} vs min {mn}, signals {expected_signals(rm)})")

                # rank ordering and ties
                checks += 1
                if [r["rank"] for r in res["ranked_matches"]] != list(range(1, len(res["ranked_matches"]) + 1)):
                    err(fid, "ranks are not 1..n in order")
                checks += 1
                if seen_scores != sorted(seen_scores, reverse=True):
                    err(fid, f"ranked_matches not sorted by score desc: {seen_scores}")
                for i in range(len(res["ranked_matches"]) - 1):
                    hi, lo = res["ranked_matches"][i], res["ranked_matches"][i + 1]
                    if hi["score"] == lo["score"]:
                        checks += 1
                        nh = sum(1 for s in hi["fired_signals"] if s["weight"] == 3)
                        nl = sum(1 for s in lo["fired_signals"] if s["weight"] == 3)
                        if nh < nl:
                            err(fid, f"tie {hi['member_id']}/{lo['member_id']} ordered against "
                                     f"large-signal-count rule ({nh} < {nl})")
                checks += 1
                if res.get("surfaced_count") != sum(1 for r in res["ranked_matches"] if r["surfaced"]):
                    err(fid, "surfaced_count disagrees with ranked_matches")

        # --- word budget ---
        if "card" in res and isinstance(res.get("card"), dict) and "word_count" in res["card"]:
            checks += 1
            lo, hi = cfg.get("word_band", [250, 350])
            wc = res["card"]["word_count"]
            if not (lo <= wc <= hi):
                err(fid, f"card word_count {wc} outside band [{lo},{hi}] but no gate failure asserted")
            checks += 1
            src = gi.get("narration", {}).get("word_count")
            if src is not None and src != wc:
                err(fid, f"card word_count {wc} != narration word_count {src}")

        if res.get("gate_failures"):
            for gf in res["gate_failures"]:
                if gf.get("gate") == "word_count_in_band":
                    checks += 1
                    lo, hi = cfg.get("word_band", [250, 350])
                    obs = gf.get("observed")
                    if lo <= obs <= hi:
                        err(fid, f"word_count_in_band failure asserted but {obs} is inside [{lo},{hi}]")

        # --- block structure ---
        if isinstance(res.get("card"), dict) and "blocks" in res["card"]:
            checks += 1
            labels = [b["label"] for b in sorted(res["card"]["blocks"], key=lambda x: x["order"])]
            want = cfg.get("required_blocks", ["Who", "Now", "Room", "Notice", "Say"])
            if labels != want:
                err(fid, f"card blocks {labels} != required {want}")
            checks += 1
            if res["card"].get("closing_block_kind") != "sayable":
                err(fid, "card does not close on a sayable line")

        # --- date arithmetic ---
        if op == "build_now_block" and "days_since_latest" in res:
            checks += 1
            asof = date.fromisoformat(d["given"]["clock"]["as_of"][:10])
            prof = gi.get("profile", {})
            if "latest_first_person_item" in prof:
                latest = date.fromisoformat(prof["latest_first_person_item"]["published_at"])
            else:
                excl = {e["item_id"] for e in res.get("excluded_items", [])}
                cand = [i for i in gi.get("items", []) if i["item_id"] not in excl]
                latest = max(date.fromisoformat(i["published_at"]) for i in cand)
            got = (asof - latest).days
            if got != res["days_since_latest"]:
                err(fid, f"days_since_latest {res['days_since_latest']} != re-derived {got}")
            checks += 1
            stale = cfg.get("stale_after_days", 365)
            want_state = "cold" if got >= stale else "warm"
            if res.get("recency_state") != want_state:
                err(fid, f"recency_state {res.get('recency_state')} != {want_state} at {got} days")

        # --- reason validation ---
        if op == "validate_reason":
            checks += 1
            fired = {s["signal_id"] for s in gi["scored_pair"]["fired_signals"]}
            cited = set(gi["narration"]["cited_signal_ids"])
            unfired = sorted(cited - fired)
            asserted = res.get("gate_failures", [{}])[0].get("unfired_cited", []) if res.get("gate_failures") else []
            if unfired != asserted:
                err(fid, f"unfired_cited {asserted} != re-derived {unfired}")
            checks += 1
            if res.get("valid") != (not unfired):
                err(fid, f"valid={res.get('valid')} inconsistent with unfired_cited={unfired}")

        # --- provenance selection ---
        if op == "select_renderable_facts":
            checks += 1
            ok, bad = [], []
            for f in gi["candidate_facts"]:
                if not f.get("source_url"):
                    bad.append((f["fact_id"], "missing_provenance"))
                elif f.get("provenance_class") == "inferred" and not f.get("composed_from"):
                    bad.append((f["fact_id"], "inferred_without_named_inputs"))
                else:
                    ok.append(f["fact_id"])
            if sorted(ok) != sorted(res["renderable_fact_ids"]):
                err(fid, f"renderable {res['renderable_fact_ids']} != re-derived {sorted(ok)}")
            checks += 1
            got_bad = sorted((r["fact_id"], r["reason"]) for r in res["rejected"])
            if sorted(bad) != got_bad:
                err(fid, f"rejected {got_bad} != re-derived {sorted(bad)}")

        # --- gate/grade precedence ---
        if op == "evaluate_digest":
            checks += 1
            gates = gi["evaluation"]["gates"]
            failed = sorted(g for g, v in gates.items() if not v)
            asserted = sorted(g["gate"] for g in res.get("gate_failures", []))
            if failed != asserted:
                err(fid, f"gate_failures {asserted} != re-derived {failed}")
            checks += 1
            want = "pass" if not failed else "fail"
            if res.get("verdict") != want:
                err(fid, f"verdict {res.get('verdict')} != {want} given gates {failed}")
            checks += 1
            gr = gi["evaluation"]["grades"]
            if res["content_grade"]["scored"] != sum(gr.values()) or \
               res["content_grade"]["possible"] != len(gr):
                err(fid, "content_grade disagrees with given grades")

        # --- blocked-source honesty ---
        if op == "run_ingestion":
            checks += 1
            for st in res["source_status"]:
                adap = cfg["adapters"].get(st["source_id"], {})
                if adap.get("measured_status") == "blocked":
                    if st["status"] != "unavailable" or st["facts"] != 0:
                        err(fid, f"{st['source_id']} measured blocked but reports {st}")

    print(f"checks run: {checks}")
    if errors:
        print(f"FAIL — {len(errors)} arithmetic/domain violation(s):")
        for e in errors: print("  -", e)
        return 1
    print(f"OK — {len(files)} fixtures re-derived from `given`")
    return 0

if __name__ == "__main__":
    sys.exit(main())
