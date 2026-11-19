# Lab helper scripts and their sibling copy

`scripts/bootstrap.sh`, `scripts/nuke-vm.sh` and `scripts/reset-lab.sh` exist in two repositories:

- this one (`docker-flask-app`), and
- [`terraform-localstack-s3`](https://github.com/MSotoudeh/terraform-localstack-s3), which has the same three scripts.

They are **not identical and not shared**. The terraform-localstack-s3 copies were derived from these on 2026-02-11 and then specialised. There is no dependency between the repositories: each one is self-contained and must stay that way. If you fix a bug in one, check whether the other needs the same fix by hand.

| Script | docker-flask-app (this repo) | terraform-localstack-s3 |
| --- | --- | --- |
| `bootstrap.sh` | Writes `/etc/docker/daemon.json` and a systemd override so Docker listens on `tcp://<guest-ip>:2375`; UFW opens 22, 2375 and 5000 for the SSH client IP. | No Docker TCP listener (socket only); UFW opens 22, 5000 and 4566 (LocalStack); trailing note that Terraform runs manually or in CI. |
| `nuke-vm.sh` | Purges Docker, Terraform, Ansible, AWS CLI, yq, lazygit, direnv, firewall rules and `~/repos`. | Same, plus stops the `localstack` container first, removes the Docker systemd override and deletes Terraform state/cache files in the working directory. |
| `reset-lab.sh` | Kills and removes every container, then `docker system prune -f --volumes`. | `docker compose down -v --remove-orphans`, `docker system prune -f` and removes Terraform state/cache. |

Both copies share the same base package list, Docker CE / Terraform / AWS CLI / yq / lazygit installation steps and the bare Git repository at `~/repos/docker-flask-app.git`. That repository name is a leftover in the terraform copy.

Why not extract a shared repository? The scripts are small, only used on throwaway VMs, and the divergence is intentional (this copy shows the insecure baseline, the other the hardened one). A shared dependency would couple two otherwise independent demos.
