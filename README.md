# docker-flask-app

A minimal Flask app in Docker, plus helper scripts that turn a fresh Ubuntu VM into a disposable Docker/Terraform/Ansible lab and tear it down again.

## Status

**Active, small by design.** It is a learning and CI-validation lab, not a production template. The helper scripts are deliberately insecure (see [SECURITY.md](SECURITY.md)).

## What it does

- Serves one page (`/`) that answers `Hello from Dockerized Flask App! Running on <container hostname>`.
- Builds and runs in Docker via `Dockerfile` and `docker-compose.yml`.
- Ships a GitHub Actions workflow that builds the image, runs the unit test inside it and smoke-tests the running container.
- Ships three Bash scripts for a throwaway Ubuntu VM: `bootstrap` (install tooling), `reset-lab` (soft reset) and `nuke-vm` (purge everything).

## How it works

```
app.py            entry point: create_app().run(0.0.0.0:5000)
app/__init__.py   application factory, registers the blueprint
app/routes.py     blueprint with the "/" route
Dockerfile        python:3.11-slim, installs requirements.txt, runs app.py
docker-compose.yml  one service "web", port 5000
```

The VM scripts are independent of the app: `scripts/bootstrap.sh` prepares the machine, you then clone this repository on it and run `docker-compose up --build` yourself.

## Quick start

Run the app (needs Docker):

```bash
docker compose up --build        # or: docker-compose up --build
# open http://localhost:5000
```

Run without Docker:

```bash
python -m pip install -r requirements.txt
python app.py
```

### Disposable VM lab (optional, Ubuntu only)

```bash
scp scripts/bootstrap.sh user@VM_IP:/tmp/bootstrap.sh
ssh user@VM_IP
sudo bash /tmp/bootstrap.sh      # installs Docker, docker-compose, Terraform, Ansible, AWS CLI, yq, lazygit, UFW rules
# reboot recommended, then clone this repo on the VM and run the app
```

Soft reset (keep tooling): `./scripts/reset-lab.sh`. Hard reset (purge Docker, Terraform, Ansible, AWS CLI, firewall): `sudo ./scripts/nuke-vm.sh`. Both are destructive and assume a VM you are happy to lose. Run them from the repository root.

`scripts/bootstrap.sh` exposes the Docker API on TCP 2375 without TLS, restricted by UFW to the SSH client IP. Do not use it on any machine that matters.

The scripts are also used, in a more hardened variant, by [terraform-localstack-s3](https://github.com/MSotoudeh/terraform-localstack-s3); see [docs/lab-scripts.md](docs/lab-scripts.md).

## Configuration

No environment file is needed. The scripts read these environment variables: `SUDO_USER` / `USER` (account that gets Docker access and the bare repo) and `SSH_CLIENT` (client IP allowed through the firewall). There is no `.env.example` because nothing else is configurable.

## Project layout

```
app/        Flask application package (factory + routes)
tests/      pytest unit test
scripts/    bootstrap.sh, reset-lab.sh, nuke-vm.sh (Ubuntu VM lab helpers)
docs/       history and notes on the shared lab scripts
.github/    CI workflow
```

## Testing

```bash
python -m pip install -r requirements.txt
python -m pytest
```

Syntax check of the scripts: `bash -n scripts/*.sh`. CI additionally builds the image and smoke-tests port 5000.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
