# UI states, navigation and actions — what the sketch cannot carry

Surfaces: **Card** (primary), **Why-this-score** (secondary, tap from Room), **Room** (demo control).
There is no login, no settings, no member-facing view. These are staff-intended surfaces. An
open URL: since DEC-14 there is no unguessable path either, and `noindex` plus the robots disallow
control search visibility rather than access. That limitation is the accepted P0-5 risk in the PRD. The Battery's charter already forbids members using presence features
to watch each other.

## Navigation
Room --(simulate arrival / webhook fires)--> Card --(tap score)--> Why-this-score --(back)--> Card
Card --(ambiguous name)--> Resolution prompt --(host picks)--> Card
Card --(gate failure)--> Withheld card + failure list --(retry)--> Card

## States per surface

### Card
The card banner never names the state. It carries the measured affiliation, the member's name and
a subtitle derived from stored vocabulary — see `docs/design-additions.md` A-6. The state below
decides what the BODY renders.

| State | Trigger | What it shows |
|---|---|---|
| Ready | profile cached, room scored | Two layers (PRD R-034): Who they are · Who's here · Say this, then the collapsed rest of the brief (The match · Sources · Recent activity · Personal detail). 250–350 words over the whole brief. Ends with the R-060 outcome capture. |
| No strong match | no present member clears score>=6 AND one of S3/S5/S6/S7 | Room block gives the anonymous top score and why it missed. No candidate name; never a recommendation. |
| Cold trail | no first-person item inside 365 days | Now block states the gap in days and the last date. Never dresses old material as current. |
| Unknown coverage | one or more expected sources was unreachable | Names the unread sources with their failure codes, counts coverage ("Reached 2 of 3"), and makes no silence claim in either direction. The Say line is unaffected. |
| Empty room | roster empty | A state of the ROOM surface, not an error - a normal early evening. |
| First arrival | exactly one present, nobody else to score | Full card. Who’s-here says they are first; The match reads "nobody present to score / no pairs"; nobody outside the roster is offered. |
| Ingesting | live re-run triggered | Per-adapter progress, including unavailable ones |
| Withheld | any hard gate failed | Who block only, plus the failed gate. Degrades to a greeting, never to a guess. |
| Ambiguous | resolver has >1 corroborated candidate | Host picks. The engine never guesses identity. |
| Not found | resolver has 0 corroborated candidates | "No profile. Greet and log." Card still renders the Say block generically. |
| Thin profile | identity resolved but fewer facts are available | Attempts a full card without invention; if the evidence cannot support 250 words, shows a withheld greeting with no Notice block. |

### Why-this-score
The pair's intent class in one sentence; fired signals with weights and evidence; signals that
did NOT fire and why (S9's miss is explained in intent terms); excluded generic topics with their
share of the stored member base; the reverse-direction score with its own fired rows. Room membership never changes
genericity. This is the whole answer to "expose the reasoning"
and it is one tap away, never on the card.

### Room
Current-presence list ordered by arrival time (tap a name for the card), with simulate-arrival
and mark-departed controls, the R-062 table-seating tool (size 2-6, arrival-order partition,
singleton merged back, one measured line per table), the DEC-3 live re-run, and a footer link to
the How-the-score-works reference screen. This stands in for the webhook, which the brief says is solved. Physical
position is not tracked — a scope fact for the README, no longer printed on the surface.

## Actions and their outcomes
| Action | Outcome |
|---|---|
| Simulate arrival | Fires the webhook path for that member against the current roster |
| Tap score | Opens Why-this-score for that pair |
| Retry (withheld) | Re-runs render only. Does NOT re-ingest and does NOT relax a gate. |
| Show what failed | Expands the gate list. Read-only. |
| Pick candidate | Binds identity for this arrival only; does not write to the profile store |
| Mark departed | Removes from roster; already-rendered cards are not retro-edited |

## The five blocks: id, and the title the host reads
The ids are the domain vocabulary and the gate contract; the titles are render-time only
(`view.BLOCK_TITLES`, docs/design-additions.md A-6).

| Block id | Rendered title |
|---|---|
| `Who` | Who they are |
| `Now` | Recent activity |
| `Room` | Who's here |
| `Notice` | Personal detail |
| `Say` | Your opening line |

## Where a decision is shown to the user, and in what words
- The score: an integer out of 16, small, right-set on its own hairline row under the reason.
  Never the headline. [DEC-2 / A-3]
- Provenance: a chip per fact — source host and date. Every rendered fact has one. [DEC-4]
- A stale supplied label: directly below the identity line in Who, in the form “the door said
  [supplied]; it is [current] now.” Omitted when the label is current.
- Suppression: directly below Notice when nonzero, as one class-and-count line. Suppressed text never
  appears.
- A miss: stated explicitly ("top score 5, needs 6") without naming the candidate, never hidden as
  an empty section.
- An unavailable source: named on the ingesting screen with its reason, and on the card as a
  bronze-gutter coverage block with a count ("reached 19 of 20") naming the source that was not
  read. `quiet` gets no gutter, because it is an ordinary answer. Not hidden. [DEC-1 / A-4]

## Primary journey, walked
Host is at the door. Phone buzzes: someone arrived. The banner says who they are before it says
anything else — affiliation, name, one derived line. Card opens on **Who they are** — a name and
one line the host could repeat verbatim. Eye drops to **Recent activity**: is this person
mid-something, or quiet? Then **Who's here**: one sentence naming who to introduce and why, with a
small number the host ignores unless challenged. **Personal detail** gives the one thing that makes
the greeting feel personal rather than transactional, with its source visible so the host knows how
it is known. **Your opening line** is the line they actually deliver — and it is held in a rail at
the bottom of the viewport the whole way down, so it is never more than a glance away. Total read:
under ninety seconds, standing, watching a door.

Two things this walk surfaced that were not in the sketch, and are now requirements:
1. **The host needs to know how a fact is known, not just what it is** — because they will be asked
   "how do you know that?" by the member, out loud, in the lobby. Hence the provenance chip is on
   the card, not behind it.
2. **Retry must not relax a gate.** The obvious implementation of a retry button is to re-render
   until it passes, which converts a hard gate into a retry loop. Stated explicitly above.
