# Docker Flask Lab (Bootstrap-Aligned)

This repository contains a **minimal Flask application** designed to be run inside Docker,
with a **VM bootstrap script** that prepares a disposable lab environment.

This project intentionally separates:

- **Infrastructure bootstrapping**
- **Application build & runtime**
- **Lab reset and teardown**

No assumptions. No magic.

---

## Repository Contents

```text
.
├── bootstrap.sh
├── nuke_vm.sh
├── reset_lab.sh
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── app.py
├── LICENSE
├── app/
│   ├── __init__.py
│   └── routes.py
├── tests/
│   └── test_health.py
├── .github/workflows/ci.yml
└── README.md
```

---

## Execution Model (Authoritative)

This repository is intended to be used on a **fresh Linux VM**.

The workflow is:

1. Provision a raw VM
2. SSH into the VM
3. Copy and execute `bootstrap.sh`
4. Manually deploy and test the application
5. Reset or destroy the lab

The VM is disposable by design.

---

## Bootstrap Script (`bootstrap.sh`)

The bootstrap script performs **environment preparation only**.

### What it does

- Installs Docker CE
- Installs docker-compose (standalone)
- Enables Docker TCP on `GUEST_IP:2375`
- Configures UFW to allow:

  - SSH (22)
  - Docker TCP (2375)
  - Flask app (5000)
  - **Only from the SSH client IP**
- Installs:

  - Terraform
  - Ansible
  - AWS CLI
  - yq
  - lazygit
- Creates a **bare Git repository** on the VM:

```text
/home/<user>/repos/docker-flask-app.git
```

### What it does NOT do

- Does NOT clone this repository
- Does NOT run `docker compose`
- Does NOT deploy the application

This is intentional.

---

## Running the Bootstrap

From your local machine:

```bash
scp bootstrap.sh user@VM_IP:/tmp/bootstrap.sh
ssh user@VM_IP
chmod +x /tmp/bootstrap.sh
sudo /tmp/bootstrap.sh
```

A reboot after completion is recommended.

---

## Application Deployment (Manual)

After bootstrap, clone or copy this repository onto the VM:

```bash
git clone <this-repo-url>
cd <repo>
```

Build and start the app:

```bash
docker-compose up --build
```

The Flask app will be available on:

```text
http://VM_IP:5000
```

---

## Testing

### Local container status

```bash
docker ps
```

### Run tests inside the container (example)

```bash
docker-compose exec web pytest
```

---

## Resetting the Lab (Soft Reset)

To remove containers, images, volumes, and cached state:

```bash
./reset_lab.sh
```

This keeps Docker and tooling installed.

---

## Destroying the Lab (Hard Reset)

To purge Docker, Terraform, Ansible, AWS CLI, firewall rules, and all lab artifacts:

```bash
sudo ./nuke_vm.sh
```

The VM is expected to be discarded afterward.

---

## Notes and Constraints

- Docker TCP (`2375`) is enabled **without TLS**
- Firewall access is restricted to the SSH client IP
- No security hardening is applied
- This setup is **not production-safe**

This repository is intended strictly for:

- Learning
- Testing
- CI validation
- Disposable lab environments
