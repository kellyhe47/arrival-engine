# Deploying to Railway

The container already exists and is the deploy unit. Railway builds `Dockerfile`, and
`railway.json` pins the builder, the start command and the health check so nothing depends on
Railway's autodetection.

Nothing in `arena/`, `db/`, `scripts/` or the `Dockerfile` was changed for this. The one thing
Railway needs that the `Dockerfile` does not do is bind the port Railway injects, and
`railway.json`'s `startCommand` supplies it — `${PORT:-8000}`, so a local `make docker` run with
no `PORT` still lands on 8000.

## Read this before you press deploy

The README's "what this is *not*" section applies in full and gets sharper the moment there is a
public URL: **no auth, no accounts, ten real named people, and every card one tap from the Room.**
A Railway domain is reachable by anyone who has the string. `X-Robots-Tag`, `robots.txt` and the
opaque card tokens keep it out of search indexes and out of referrer logs; none of them keep a
person out.

`ARENA_PUBLIC_ROOT=0` puts the surfaces back behind `/<ARENA_PATH_SECRET>/`. That is obscurity,
not a credential — but on a public host it is strictly better than serving the Room at `/`, so
set it, and set a real secret alongside it. The honest fix remains a session behind the door.

## 1. Pick the branch

`main` is what Railway offers by default. This repo's work is currently on feature branches, so
either merge first or point the service at the branch you want in **Settings → Source → Branch**.
Deploying a branch that is mid-ingest ships whatever `db/*.db` that branch has.

## 2. Create the service

Railway → **New Project** → **Deploy from GitHub repo** → `kellyhe47/arrival-engine`.

It will find `railway.json` and `Dockerfile` on its own. No build command, no start command, and
no port to configure in the UI — all three are in `railway.json`.

## 3. Set the variables

**Settings → Variables.** `.env` is gitignored and never enters an image layer, so the key has to
be set here or the narrator degrades every match card to the withheld greeting — which reads as a
product bug rather than a missing credential.

| Variable | Set it? | What it does |
|---|---|---|
| `OPENAI_API_KEY` | **required** | The Say line. Without it, `NarratorUnavailable` and the withheld greeting. |
| `ARENA_PUBLIC_ROOT` | **set to `0`** | Takes the surfaces off `/` and back behind the path segment. |
| `ARENA_PATH_SECRET` | **set it** | The path segment. Leaving the default `d3f0-arrival-9c1a` is the same as not setting one — it is in the source. |
| `ARENA_WEBHOOK_SECRET` | if you use the webhook | HMAC on `POST /webhook/arrival`. Unset means the webhook path is unauthenticated. |
| `ARENA_NARRATOR_MODEL` | optional | Overrides the model pinned in `arena/narrator.py`. |
| `ARENA_DB` | **leave it** | The `Dockerfile` already sets `/app/var/arena.serve.db`, the one writable path the runtime user owns. |
| `PORT` | **leave it** | Railway injects it. |

## 4. Get the URL

**Settings → Networking → Generate Domain.** Target-port detection works because the process binds
`0.0.0.0:$PORT`. With `ARENA_PUBLIC_ROOT=0` the Room is at
`https://<domain>/<ARENA_PATH_SECRET>/` — `/` returns 404 by design, and the health check still
passes because it hits `/robots.txt`, which is registered on both postures.

`make urls` prints every card URL; set `ARENA_BASE=https://<domain>` to print them against the
deployment instead of localhost.

## What the deployment does *not* keep

`scripts/build_store.py` unlinks and rebuilds the serving store on every boot, from `db/*.sql`
plus the committed `db/*.db` ingest output plus `seed/synthetic.sql`. That keeps the ingest/serve
split a file copy (DEC-3, R-049) and means the image carries no store of its own.

It also means **arrivals, departures and outcome taps do not survive a redeploy or a restart.**
That is fine for a demo and wrong for the feedback loop the README names as the next month's
work. A Railway Volume alone will not fix it — the rebuild would wipe the volume on every boot.
Persisting outcomes needs both a volume at `/app/var` and a start command that rebuilds only when
the store is absent, which is a real design change, not a deploy setting.

Keep `numReplicas` at 1. The store is a per-instance SQLite file, so a second replica would serve
a divergent roster.

## Verifying

```
curl -sI https://<domain>/robots.txt          # 200, X-Robots-Tag: noindex
curl -so /dev/null -w '%{http_code}\n' https://<domain>/<ARENA_PATH_SECRET>/   # 200
```

Build and deploy logs are under the service's **Deployments** tab; the store build prints its
per-file merge counts and a final `person=… fact=… edge=…` line, which is the fastest check that
the deployed store carries the measured rows and not just the schema.
