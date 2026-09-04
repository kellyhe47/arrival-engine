# THE ARRIVAL ENGINE
#
# db/ is FROZEN. No target here writes to it. The serving store is built in var/.

PY := .venv/bin/python
PORT ?= 8000

.PHONY: help install store store-real store-empty store-golden validate-spec test-golden red test run serve dev urls docker clean

help:
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | sed 's/:.*## /\t/' | column -t -s "$$(printf '\t')"

install:  ## create .venv (python 3.12) and install dependencies
	uv venv --python 3.12 .venv
	uv pip install --python $(PY) -r requirements.txt

store:  ## build the demo serving store: db/*.sql + measured ingest + synthetic seed
	$(PY) scripts/build_store.py --out var/arena.serve.db --merge --seed

store-real:  ## measured rows only — no synthetic seed. Thin until ingest lands, and honest about it
	$(PY) scripts/build_store.py --out var/arena.serve.db --merge

store-empty:  ## schema + vocabulary + roster only. Proves the app degrades on an empty store
	$(PY) scripts/build_store.py --out var/arena.serve.db

store-golden:  ## the deterministic store test-golden runs against (no live ingest files)
	$(PY) scripts/build_store.py --out var/arena.golden.db --seed

validate-spec:  ## fixtures are well-formed and arithmetically self-consistent. Executes no product code
	$(PY) scripts/validate_golden.py eval/golden
	$(PY) eval/verify_fixtures.py

test-golden:  ## drive the REAL implementation against every fixture, four observation surfaces each
	$(PY) eval/golden_runner.py

red:  ## prove every fixture is load-bearing by breaking the rule it defends
	$(PY) eval/red_first.py

test: validate-spec test-golden red  ## everything
	$(PY) -m pytest tests -q

run: store serve  ## rebuild the store from db/, then serve on :$(PORT)

serve: urls  ## serve the store that already exists — no rebuild
	@ARENA_DB=var/arena.serve.db $(PY) -m uvicorn arena.web:app --host 0.0.0.0 --port $(PORT)

dev: urls  ## serve with auto-reload on code changes — no rebuild
	@ARENA_DB=var/arena.serve.db $(PY) -m uvicorn arena.web:app --host 0.0.0.0 --port $(PORT) --reload

urls:  ## print the unguessable path and every card URL (operator's terminal only)
	@ARENA_DB=var/arena.serve.db PORT=$(PORT) $(PY) scripts/urls.py

docker:  ## build the container
	docker build -t arena-hall-arrival-engine .

clean:
	rm -rf var/*.db
