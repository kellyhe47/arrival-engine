# Design additions — the 2026-09-03 pass

What changed in the rendered surfaces after the 390-wide design handback, why, and what was
deliberately **not** taken. Every item is referenced from `arena/static/arena.css` by its id.

Nothing here changes a score, a gate, a state machine, or a stored value. The `A-6` entry is the
one that touches Python, and it touches only the render layer.

---

## A-1 · Two Garamonds, and the deviation moves

**Was:** one family, Cormorant Garamond, with a stated deviation — "card prose is never below 19px
and never below weight 400, because Cormorant is hard to read small".

**Now:** Cormorant Garamond 300 keeps every **display** role it earns — the arriving name, the
block headings, the two aloud lines. **EB Garamond 400/20px/1.58 carries the prose.**

Raising the weight fixed the wrong variable. Cormorant at any weight is a display cut: its stroke
contrast is drawn for 40px and its x-height is small, which is precisely wrong at arm's length in
low light — the exact reading condition R-033 is built around. EB Garamond is the same old-style
Garamond class, so the club's voice is unchanged, but it is a face cut for text. Inter still
carries everything dense or numeric.

## A-2 · Provenance is a footnote, not a tag

Five blocks of prose each closed by a bordered, filled, uppercase chip reads as a log file. The
chip loses its border, its fill and its uppercase and sits on a short hairline under the block —
present enough to answer "how do you know that?", quiet enough to read past. DEC-4 is unchanged:
every rendered fact still carries one.

## A-3 · The score leaves the prose

"Reason first, score small" (R-036 / DEC-2) is a layout instruction as much as a copy one. The
integer is now right-set on its own hairline row (`.match`), tabular, so a sentence is never
interrupted by a number. The `why` link rides the same row.

The no-strong-match row obeys R-038 exactly as before: one anonymous figure — `Top score, no
candidate named · 5 · needs 6` — and nobody is named, not even as a backup.

## A-4 · `unknown` gets a gutter that `quiet` does not

The single visual difference this product exists to protect. A profile where a source could not be
read gets a bronze gutter rule, a counted heading (`REACHED 19 OF 20`) and the **unreached** source
named. A profile that is genuinely `quiet` gets none of that and renders as ordinary prose, because
it is an ordinary answer.

The count's denominator is every distinct source attempted on the last run. Only the gap is named:
listing the nineteen sources that *were* read buries the one line that matters on a phone.

## A-5 · The Say rail

The line the host actually delivers sits ~250 words below the fold. It is repeated in a hairline
rail pinned to the bottom of the viewport, and it leaves the moment the real block scrolls into
view. Paper and a hairline, never a card. It is the opening line, so it competes with nothing.

## A-6 · Titles and subtitles — what the host reads

**This is the change with the most surface area, and it is entirely render-layer.**

### Block titles

The five bare nouns are the **domain vocabulary**, and they are unchanged everywhere it matters:
`config.REQUIRED_BLOCKS`, the `required_blocks_present_and_ordered` gate, every golden fixture,
`arena.card`, `arena.narrator`, and the stored `card.body` all still say `Who`, `Now`, `Room`,
`Notice`, `Say`.

What changed is the **rendered heading**, via `view.BLOCK_TITLES` and the `block_title` template
helper:

| Block id | Rendered title |
|---|---|
| `Who` | Who they are |
| `Now` | Recent activity |
| `Room` | Who's here |
| `Notice` | Personal detail |
| `Say` | Your opening line |

A bare noun is a good name for a slot in a schema and a bad name for a heading on a phone. "Now"
and "Notice" tell a host standing at a door nothing about what is under them, and "Room" reads as a
place when what it means is the people in it. The titles say what each block is *for*, in the
host's words.

### The card banner: eyebrow, name, subtitle

**Was** — the banner printed the *card state*:

```
READY
Brad Feld
Five blocks, under ninety seconds.
```

Both outer lines described the software. `READY` tells a host that a render succeeded, which they
can see; `UNKNOWN COVERAGE` announces a retrieval fact before it announces a person. **Those two
entries are gone from `view.STATE_COPY`.** The states themselves still exist and still change what
the card renders — `card_state()` is untouched — they are simply no longer the words stamped over
somebody's name.

**Now** — the banner is about the person, derived by `view.card_banner()`:

```
FOUNDRY · GENERAL PARTNER
Brad Feld
Venture capital in Boulder. Reading and books · Building startup communities
```

**Eyebrow — `affiliation_line(member_label.current_label)`.** The measured label already *is* "where
they are and what they do there". The function splits it on `, ; / | — –` and rejoins with the
club's middot. It does not title-case, expand an abbreviation, or infer a role from an
organisation. R-014 still holds: the **supplied** door label is never the eyebrow — that is the hint
this engine exists to verify, not to print. Fallback order: measured label → `industry.label` →
`Arena Hall · Austin, Texas`.

**Subtitle — `subject_subtitle(member)`.** Two parts, both of them lookups against stored,
controlled vocabulary. Nothing is composed by a model and nothing is inferred:

1. `industry.label` + the resolved canonical place tag → *"Venture capital in Boulder."*
   Only the canonical geo slugs (`boulder-co`, `new-york-ny`, `sydney-au`) qualify. Free-text and
   unresolved place contexts — `Venice (Venice CA vs Venice Italy — UNRESOLVED)` — never reach the
   banner, per S4.
2. up to two `topic.label`s, **discriminating ones first**. Genericity is already measured over the
   member base and stored (`topic.discriminating`), so a topic 40% of the club shares is the last
   thing that should be used to tell one member from another.

A member with no industry and no topic gets a shorter line, not an invented one; if both parts come
back empty the state sentence fills in.

**Degraded states keep the person's banner.** A withheld card still opens on `FOUNDRY · GENERAL
PARTNER / Brad Feld`. The reason it is withheld belongs in the body, next to the gate that failed,
not stamped across someone's name. `not_found` is the only card with no member, and only there does
the state supply both lines.

### Room

The banner lost its third sentence. "Physical position is not tracked" is true, and it is scope
documentation for whoever reads the README — not something a host needs above a list of who is
here. The same reasoning removed the paragraph explaining that simulate-arrival stands in for the
webhook.

## A-7 · Why-this-score: the weight is a bar as well as a number

The weight column is the point of that screen, so it is drawn. Both tables share one fixed grid
(`table.signals`) — `table-layout: fixed` takes its columns from the first row, and only the fired
table has a `<th>` row, so without matching widths on the `th` the two tables would not line up.

## A-8 · The per-adapter record is rows, not a table

Five 13px Inter columns do not fit 390 minus a 20px gutter, and the column that gets clipped is
Reason — exactly the content DEC-1 says must not be hidden, on the screen the brief calls half the
argument. A horizontal scroller hides it just as effectively. So each source is two stacked lines:
id and its counted status on the first, the reason full-width on the second, rendered only when
there is one.

## A-9 · NOT TAKEN — the underlined block label

The handback underlines every block label with a full-measure hairline. **Our section headers are
unchanged**: the label alone, on its own line, nothing beneath it.

The blocks are already separated by `.blk`'s top hairline. A second rule 14px under the first turns
one ruled section into a two-line letterhead, and repeated five times down a card it reads as five
stacked cards — which is the thing rule 2 of the visual language exists to prevent.

## Not taken — deleting Live re-run

The 390 Room mock shows two sections. The third, Live re-run, is kept: DEC-3 requires one live
ingestion run on stage. Removing it would be a feature deletion, not a design change.
