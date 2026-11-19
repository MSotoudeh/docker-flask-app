# History

## Why this exists

The project was started in February 2026 as a minimal, reproducible sandbox: a tiny Flask app packaged in Docker, validated in CI, and a set of scripts to build and destroy the Ubuntu VM it runs on. The point was to practise the loop "fresh VM, bootstrap, deploy, test, reset" without touching anything permanent.

## Phases

1. **2026-02-09, initial commit.** Everything arrived in one commit: app, Dockerfile, compose file, unit test, CI workflow, the three VM scripts and a README written as an authoritative execution model. It is the only commit before the cleanup; there are no other branches or tags.
2. **Sibling project (2026-02-11).** The VM scripts were copied into [terraform-localstack-s3](https://github.com/MSotoudeh/terraform-localstack-s3) and hardened there (no Docker TCP, LocalStack port, Terraform state cleanup). The copies have diverged; see [lab-scripts.md](lab-scripts.md).
3. **2026-11-19, public-ready cleanup.** Scripts moved to `scripts/` with kebab-case names, README and docs rewritten, contributing and security documents added, `.gitignore` extended.

## Previous state versus current state

Behaviour is unchanged. Only file locations (scripts), names (`nuke_vm.sh` to `nuke-vm.sh`, `reset_lab.sh` to `reset-lab.sh`) and documentation changed.

## Unmerged lines of work

None. There were no other branches.

## Known unfinished

- `bootstrap.sh` still enables Docker on TCP 2375 without TLS (documented as a lab-only risk). The hardened variant lives in terraform-localstack-s3.
- The scripts fall back to a hard-coded user name (`moha`) and host IP (`10.0.0.2`) when `SUDO_USER`/`USER`/`SSH_CLIENT` are unset.
- CI never exercises the VM scripts; only `bash -n` style checks are possible without a VM.
