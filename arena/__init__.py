"""THE ARRIVAL ENGINE.

A staff-facing arrival brief for a private members club. A webhook fires with a name; within
ninety seconds a host reads a card telling them who arrived, who present they should meet and why,
and one thing they can say out loud.

Layering, and the reason for it:

    arena.store        read-only SQLite access. The gates that live in the store are QUERIED
                       (v_renderable_fact, v_present, v_recency_state, v_collectable_source,
                       v_assertable_absence, v_traversable_person), never re-implemented here.
    arena.scoring      signals, buckets, the S8 rule, the surfacing floor. Deterministic.
    arena.ranking      ordering and the three tie-break tiers. Deterministic.
    arena.identity     corroboration-gated resolution. Deterministic.
    arena.labels       supplied-vs-measured label. Deterministic.
    arena.facts        the render gate, read through the store's own view. Deterministic.
    arena.recency      active / quiet / unknown. Deterministic.
    arena.reason       the reason names only fired signals. Deterministic.
    arena.narrator     the ONLY probabilistic seam at compose time. Writes prose, decides nothing.
    arena.card         block assembly, gates, the digest.
    arena.adapters     the fetch boundary. Read operations only, structurally.
    arena.operations   the eleven named operations the golden fixtures dispatch on.
    arena.web          three surfaces: Card, Why-this-score, Room.

The invariant every module serves: the engine must never assert what it merely failed to observe.
"""

__all__ = ["operations"]
