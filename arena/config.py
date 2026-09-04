"""Configuration. Defaults are the spec's defaults; a fixture's `given.configuration` overrides."""
from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent

#: db/ is FROZEN. Everything under it is opened read-only, always, by every code path.
DB_DIR = REPO / "db"
SCHEMA_SQL = DB_DIR / "schema.sql"
VOCABULARY_SQL = DB_DIR / "vocabulary.sql"
ROSTER_SQL = DB_DIR / "roster.sql"
#: Load order is not negotiable: schema -> vocabulary -> roster, with PRAGMA foreign_keys = ON.
LOAD_ORDER = (SCHEMA_SQL, VOCABULARY_SQL, ROSTER_SQL)

#: The synthetic seed is MINE and lives outside db/. Every row it writes names run_synthetic_demo,
#: so synthetic material is separable from measured material by a single predicate.
SEED_SQL = REPO / "seed" / "synthetic.sql"
SYNTHETIC_RUN_ID = "run_synthetic_demo"

#: The serving store. Built outside db/, disposable, rebuildable, gitignored.
VAR = REPO / "var"
DEFAULT_STORE = VAR / "arena.serve.db"


def store_path() -> Path:
    return Path(os.environ.get("ARENA_DB", str(DEFAULT_STORE)))


#: R-059 / P0-5. Discovery mitigation, NOT access control. The README says so in plain words.
def card_path_secret() -> str:
    return os.environ.get("ARENA_PATH_SECRET", "d3f0-arrival-9c1a")


WORD_BAND = (250, 350)
REQUIRED_BLOCKS = ("Who", "Now", "Room", "Notice", "Say")
SURFACE_MIN_SCORE = 6
SURFACE_REQUIRES_ANY_OF = ("S3", "S5", "S7")
TIE_BREAK = ("large_signal_count_desc", "evidence_recency_desc", "member_id_asc")
STALE_AFTER_DAYS = 365
RENDER_TRUST_CLASSES = ("subject_authored", "publisher")
GENERIC_TOPIC_SHARE = 0.40


@dataclass(frozen=True)
class Settings:
    """Per-operation configuration, merged from defaults and a fixture's `given.configuration`."""

    word_band: tuple[int, int] = WORD_BAND
    required_blocks: tuple[str, ...] = REQUIRED_BLOCKS
    surface_min_score: int = SURFACE_MIN_SCORE
    surface_requires_any_of: tuple[str, ...] = SURFACE_REQUIRES_ANY_OF
    tie_break: tuple[str, ...] = TIE_BREAK
    stale_after_days: int = STALE_AFTER_DAYS
    render_trust_classes: tuple[str, ...] | None = RENDER_TRUST_CLASSES
    narrator_temperature: int = 0
    s8_requires_substrate: bool = True
    require_corroboration: bool = True
    vocabulary: dict = field(default_factory=dict)
    raw: dict = field(default_factory=dict)

    @classmethod
    def from_fixture(cls, cfg: dict | None) -> "Settings":
        cfg = dict(cfg or {})
        return cls(
            word_band=tuple(cfg.get("word_band", WORD_BAND)),
            required_blocks=tuple(cfg.get("required_blocks", REQUIRED_BLOCKS)),
            surface_min_score=cfg.get("surface_min_score", SURFACE_MIN_SCORE),
            surface_requires_any_of=tuple(cfg.get("surface_requires_any_of", SURFACE_REQUIRES_ANY_OF)),
            tie_break=tuple(cfg.get("tie_break", TIE_BREAK)),
            stale_after_days=cfg.get("stale_after_days", STALE_AFTER_DAYS),
            # `render_trust_classes` absent means "the store's own view decides alone".
            render_trust_classes=(
                tuple(cfg["render_trust_classes"]) if "render_trust_classes" in cfg else None
            ),
            narrator_temperature=cfg.get("narrator_temperature", 0),
            s8_requires_substrate=cfg.get("s8_requires_substrate", True),
            require_corroboration=cfg.get("require_corroboration", True),
            vocabulary=cfg.get("vocabulary") or {},
            raw=cfg,
        )
