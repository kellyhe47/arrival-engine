# UI states, navigation and actions — what the sketch cannot carry

Surfaces: **Card** (primary), **Why-this-score** (secondary, tap from Room), **Room** (demo control).
There is no login, no settings, no member-facing view. The card is a staff instrument only —
AUD-LINE-22: The Battery's charter already forbids members using presence features to watch each
other, so the moment this becomes member-visible it violates a rule members were given.

## Navigation
Room --(simulate arrival / webhook fires)--> Card --(tap score)--> Why-this-score --(back)--> Card
Card --(ambiguous name)--> Resolution prompt --(host picks)--> Card
Card --(gate failure)--> Withheld card + failure list --(retry)--> Card

## States per surface

### Card
| State | Trigger | What it shows |
|---|---|---|
| Ready | profile cached, room scored | Five blocks, 250-350 words |
| No strong match | no present member clears score>=6 AND S3/S5/S7 | Room block says so, names the top score and why it missed. Never a recommendation. |
| Cold trail | no first-person item inside 365 days | Now block states the gap in days and the last date. Never dresses old material as current. |
| Empty room | roster empty | Room block says "first one here". Not an error. |
| Ingesting | live re-run triggered | Per-adapter progress, including unavailable ones |
| Withheld | any hard gate failed | Who block only, plus the failed gate. Degrades to a greeting, never to a guess. |
| Ambiguous | resolver has >1 corroborated candidate | Host picks. The engine never guesses identity. |
| Unknown | resolver has 0 candidates | "No profile. Greet and log." Card still renders the Say block generically. |

### Why-this-score
Fired signals with weights; signals that did NOT fire and why; excluded generic topics with their
share of the room; the reverse-direction score. This is the whole answer to "expose the reasoning"
and it is one tap away, never on the card.

### Room
Present list with arrival times; simulate-arrival and mark-departed controls. Stands in for the
webhook, which the brief says is solved.

## Actions and their outcomes
| Action | Outcome |
|---|---|
| Simulate arrival | Fires the webhook path for that member against the current roster |
| Tap score | Opens Why-this-score for that pair |
| Retry (withheld) | Re-runs render only. Does NOT re-ingest and does NOT relax a gate. |
| Show what failed | Expands the gate list. Read-only. |
| Pick candidate | Binds identity for this arrival only; does not write to the profile store |
| Mark departed | Removes from roster; already-rendered cards are not retro-edited |

## Where a decision is shown to the user, and in what words
- The score: an integer out of 16, small, beside the reason. Never the headline. [DEC-2]
- Provenance: a chip per fact — source host and date. Every rendered fact has one. [DEC-4]
- A miss: named explicitly ("top score 5, needs 6"), never hidden as an empty section.
- An unavailable source: named on the ingesting screen with its reason. Not hidden. [DEC-1]

## Primary journey, walked
Host is at the door. Phone buzzes: someone arrived. Card opens on **Who** — a name and one line the
host could repeat verbatim. Eye drops to **Now**: is this person mid-something, or quiet? Then
**Room**: one sentence naming who to introduce and why, with a small number the host ignores unless
challenged. **Notice** gives the one thing that makes the greeting feel personal rather than
transactional, with its source visible so the host knows how it is known. **Say** is the line they
actually deliver. Total read: under ninety seconds, standing, watching a door.

Two things this walk surfaced that were not in the sketch, and are now requirements:
1. **The host needs to know how a fact is known, not just what it is** — because they will be asked
   "how do you know that?" by the member, out loud, in the lobby. Hence the provenance chip is on
   the card, not behind it.
2. **Retry must not relax a gate.** The obvious implementation of a retry button is to re-render
   until it passes, which converts a hard gate into a retry loop. Stated explicitly above.
