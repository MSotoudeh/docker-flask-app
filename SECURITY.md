# Security

## Reporting a vulnerability

Please report issues privately through GitHub ("Report a vulnerability" under the Security tab). Do not publish details in a public issue.

## Known, intentional weaknesses

This is a disposable lab, not a hardened system:

- `scripts/bootstrap.sh` makes the Docker daemon listen on TCP 2375 **without TLS**. Anyone who can reach that port controls the machine. UFW limits it to the SSH client IP, which is not authentication. Never run the script on a shared or internet-reachable host.
- The Flask app listens on `0.0.0.0:5000` with no authentication and the Flask development server.
- `scripts/nuke-vm.sh` and `scripts/reset-lab.sh` delete data without confirmation.

## Secrets

No secrets are needed or stored in this repository. If you add any, keep them only in a git-ignored `secrets/` folder or `.env` file (both are in `.gitignore`).
