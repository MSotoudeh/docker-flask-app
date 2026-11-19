# Contributing

## Setup

```bash
python -m pip install -r requirements.txt
python -m pytest        # must pass
bash -n scripts/*.sh    # syntax check of the VM scripts
docker compose config   # validate compose file (needs Docker)
```

To run the app: `docker compose up --build` and open http://localhost:5000.

## Rules

- Do not run the scripts in `scripts/` on a machine you care about; they install and purge system packages and change the firewall. Test them on a disposable VM.
- Keep `scripts/` in mind as a sibling of the ones in terraform-localstack-s3 (see [docs/lab-scripts.md](docs/lab-scripts.md)); there is no shared code, so mention in your PR if the other copy needs the same change.
- Add a test in `tests/` for any new route.

## Branches and commits

Branch from `main` using `feat/...`, `fix/...`, `docs/...` or `chore/...`. Use [Conventional Commits](https://www.conventionalcommits.org/), for example `fix(app): return JSON on /health`. CI (build image, run tests, smoke test) must be green.
