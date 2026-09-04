# m_kopelman — Josh Kopelman

Store: `db/arena.m_kopelman.db`. Replay: `ingest/sql/m_kopelman-00-README.md`.

```text
Status:     complete (0 auth blockers)
Sources:    24 ok, 2 unavailable
Written:    35 facts, 23 edges, 12 contexts
Recency:    unknown — X and LinkedIn are visibly active (newest captured X post 2026-08-27), but
            FeedBurner is a valid 200 channel with zero items, Open Library could not connect, and
            one Internet Archive retry was unavailable. The long-form thinness is still a true
            finding: the complete 212-post Redeye corpus ends on 2014-11-12.
Deep cuts:  His firm bio preserves a second-place 2011 watermelon-eating ribbon: "I was robbed."
            https://www.firstround.com/team/investing/josh-kopelman
            He says Half.com interns put "Don't Piss Away All Your Money" urinal screens in Penn
            Station and that he had to explain the medium to Meg Whitman.
            https://redeye.firstround.com/2006/03/get_your_fouls.html
            He published the verbatim 2005 "slide a check" cold email when Aggregate Knowledge
            announced its $119M sale. https://redeye.firstround.com/2013/10/2904-days-ago.html
            The foundation he and his wife created funded and controlled the 2002 Jewish
            Encyclopedia digitization; the live site still credits it.
            https://www.jewishencyclopedia.com/
New denies: https://www.instagram.com/jkopelman/ — operator-confirmed wrong account
            https://www.instagram.com/joshk/ — verified Josh K / Kelly Media Inc.; different person
```

## Not established

- No reverse Kopelman → Wilson follow. Two session passes did not find it; only the confirmed
  Wilson → Kopelman `follows` edge was written. Their independent citation edges remain intact.
- No general claim that Kopelman and Tavel have never interacted. All 212 Redeye posts contain no
  Tavel mention, so the scoped Kopelman → Tavel `no_edge_confirmed` row remains. Although all 133
  Tavel blog posts contain no Kopelman mention, her separate ingest found two X replies to @joshk;
  that direction is therefore a real `co_mention`, not a no-edge.
- No present-day employment claim for every Form D related person. The edges mean they were named
  together as issuer Executive Officers in the dated VI/VII/IX/X filings.
- No claim that Kopelman personally digitized the Jewish Encyclopedia; the stored inference is
  about the foundation he and his wife created.
- No pronunciation or respelling. `name_respelling` remains NULL. The 2024 transcript says the
  first company began in 1991, while the official biography and Wikipedia say 1992; all support
  `career_start_decade='1990s'`.
- The Inquirer relationship is precise: board member from 2015, chair from 2016 through 2024, then
  chair emeritus--not a 2015-2024 chair term.
- No verified personal Instagram account. The operator manually rejected `@jkopelman`; all data
  collected from it was removed and the URL is now deny-listed to prevent re-attribution.

## Blockers

- None. LinkedIn and X were read successfully in existing read-only sessions. The two
  unavailable auxiliary open-web attempts are recorded in `source_status`, not misreported as auth
  failures.
