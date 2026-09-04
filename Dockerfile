# THE ARRIVAL ENGINE — one container, no build step.
#
# The image carries the application and the SQL that defines the store. It does NOT carry the
# store itself: the serving file is built at start-up from db/*.sql plus whatever measured ingest
# output is mounted in, so the ingest/serve split (DEC-3, R-049) stays a file copy.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY arena/ ./arena/
COPY db/ ./db/
COPY seed/ ./seed/
COPY scripts/ ./scripts/
COPY eval/recorded/ ./eval/recorded/

# The runtime identity owns the store directory and nothing else.
RUN useradd --create-home --uid 10001 arena && mkdir -p /app/var && chown -R arena /app/var
USER arena

ENV ARENA_DB=/app/var/arena.serve.db
EXPOSE 8000

# Build the store, then serve it. `--merge` picks up any measured ingest files mounted at /app/db;
# `--seed` overlays the synthetic demo material, which the surfaces mark as such.
CMD python scripts/build_store.py --out "$ARENA_DB" --merge --seed \
 && exec uvicorn arena.web:app --host 0.0.0.0 --port 8000
