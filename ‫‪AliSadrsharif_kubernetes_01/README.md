# AliSadrsharif_kubernetes_01

DevOps homework **HW_L5_01 — Kubernetes 1** (40 points).

This repository covers two main topics:

1. **Part A — Kubernetes introduction:** why orchestration matters and how a cluster is structured.
2. **Part B — Docker fundamentals:** core concepts and hands-on practice before deeper Kubernetes work.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **OS** | Ubuntu 22.04, Debian, or WSL/VM with `sudo` access |
| **Shell** | Basic Linux command-line familiarity |
| **Docker** | Installed and running (`docker.io` or Docker Engine) |
| **kubectl** | Client installed; a local cluster is recommended for section 02 |
| **curl** | Used by several lab scripts for HTTP checks |
| **Optional cluster** | [minikube](https://minikube.sigs.k8s.io/docs/start/) or [kind](https://kind.sigs.k8s.io/) for section 02 |

### Install Docker (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker "$USER"
# Log out and back in so group membership applies
```

### Install kubectl

```bash
sudo apt update
sudo apt install -y kubectl
```

### Local Kubernetes cluster (recommended for section 02)

```bash
# minikube
minikube start

# or kind
kind create cluster
```

This project was tested with **Docker 29.x**, **kubectl v1.36.x**, and a **minikube** cluster.

---

## Repository structure

```
AliSadrsharif_kubernetes_01/
├── README.md
├── final_structure.txt          # tree/find output of the homework folders
├── commands_history.txt         # important docker & kubectl commands used
├── 01_kubernetes_why/           # Why orchestration? (theory)
├── 02_kubernetes_architecture/  # Cluster components & env check
├── 03_docker_concepts/          # Docker concepts & installation check
├── 04_docker_images/            # pull, tag, inspect, history
├── 05_docker_containers/        # run, logs, env vars, ports, exec
├── 06_docker_dockerfile/        # custom image build (Python HTTP server)
├── 07_docker_volumes_networks/  # named volumes, bind mounts, custom network
└── 08_docker_compose/           # multi-service stack with Compose
```

### Section overview

| Folder | Topic | Points | Key deliverables |
|--------|-------|--------|------------------|
| `01_kubernetes_why` | Why orchestration | 5 | `problems_before_orchestration.md`, `orchestrators_comparison.md` |
| `02_kubernetes_architecture` | K8s architecture | 5 | `components.md`, `request_flow.txt`, `k8s_env_check.sh` + outputs |
| `03_docker_concepts` | Docker basics | 5 | `concepts.md`, `docker_check.sh` + outputs |
| `04_docker_images` | Images & layers | 5 | `image_ops.sh`, `layers_summary.txt` |
| `05_docker_containers` | Containers | 5 | `container_basics.sh`, `port_and_exec.sh`, `exec_vs_attach.txt` |
| `06_docker_dockerfile` | Dockerfile | 5 | `Dockerfile`, `app/server.py`, `build_and_run.sh` |
| `07_docker_volumes_networks` | Volumes & networks | 5 | `volume_demo.sh`, `network_demo.sh`, `summary.txt` |
| `08_docker_compose` | Docker Compose | 5 | `docker-compose.yml`, `compose_demo.sh`, `compose_summary.txt` |

---

## Quick start

Clone or extract the project, enter the root directory, and make all shell scripts executable:

```bash
cd AliSadrsharif_kubernetes_01
find . -name '*.sh' -exec chmod +x {} \;
```

Ensure Docker is running before sections 03–08:

```bash
sudo systemctl start docker    # if needed
docker info
```

---

## Running the scripts

Run scripts from their own directory (or use the paths below from the repo root). Each script writes output files into the same folder.

### 02 — Kubernetes environment check

```bash
cd 02_kubernetes_architecture
./k8s_env_check.sh
```

**Generates:** `kubectl_version.txt`, `nodes.txt`, `cluster_health.txt`

Requires a reachable cluster for full output. Without a cluster, the script still records the kubectl client version and notes that no cluster is available.

### 03 — Docker installation check

```bash
cd 03_docker_concepts
./docker_check.sh
```

**Generates:** `docker_version.txt`, `docker_ps.txt`, `docker_service.txt`

After running, update `status_summary.txt` (max 5 lines) using those outputs.

### 04 — Image operations

```bash
cd 04_docker_images
./image_ops.sh
```

**Generates:** `image_list.txt`, `image_inspect.txt`, `image_history.txt`

Pulls `nginx:alpine`, tags it as `my-nginx:v1`, inspects layer history, then removes the local tag.

### 05 — Container basics

```bash
cd 05_docker_containers
./container_basics.sh
./port_and_exec.sh
```

**Generates:** `container_ps.txt`, `container_logs.txt`, `env_vars.txt`, `curl_status.txt`, `curl_body.txt`, `exec_result.txt`

**Ports used:** host `9080` → container `80`. If `9080` is busy, edit `port_and_exec.sh` and note the change in `curl_status.txt`.

### 06 — Dockerfile build & run

```bash
cd 06_docker_dockerfile
./build_and_run.sh
```

**Generates:** `build_log.txt`, `built_images.txt`, `curl_app.txt`, `layers_after_build.txt`

Builds `lab-python-server:1.0` and tests it on host port **8000**.

### 07 — Volumes & networks

```bash
cd 07_docker_volumes_networks
./volume_demo.sh
./network_demo.sh
```

**Generates:** `volume_persist.txt`, `volume_inspect.txt`, `bind_mount_curl.txt`, `ping_by_name.txt`, `network_inspect.txt`

**Ports used:** host **9090** for the bind-mount nginx demo.

### 08 — Docker Compose

```bash
cd 08_docker_compose
./compose_demo.sh
```

**Generates:** `compose_up.txt`, `compose_ps.txt`, `compose_web.txt`, `compose_ping.txt`, `compose_networks.txt`, `compose_down.txt`

Starts `web` (nginx on host **8088**) and `api` (alpine) services, verifies inter-service DNS, then tears the stack down.

---

## Run all practical sections at once

From the repository root:

```bash
find . -name '*.sh' -exec chmod +x {} \;

./02_kubernetes_architecture/k8s_env_check.sh
./03_docker_concepts/docker_check.sh
./04_docker_images/image_ops.sh
./05_docker_containers/container_basics.sh
./05_docker_containers/port_and_exec.sh
./06_docker_dockerfile/build_and_run.sh
./07_docker_volumes_networks/volume_demo.sh
./07_docker_volumes_networks/network_demo.sh
./08_docker_compose/compose_demo.sh
```

Theory files (`*.md`, `*.txt` summaries) in sections 01–08 are filled in separately and do not require script execution.

---

## Port reference

| Port | Section | Purpose |
|------|---------|---------|
| 8000 | 06 | Custom Python HTTP server |
| 8088 | 08 | Compose `web` service (nginx) |
| 9080 | 05 | nginx container port mapping |
| 9090 | 07 | Bind-mount nginx demo |

Lab containers use the `lab-` prefix to avoid naming conflicts with other workloads.

---

## Submission

Per assignment instructions, deliver a compressed archive named:

```
AliSadrsharif_kubernetes_01.zip
```

Include:

- All eight section folders with scripts, configs, and command outputs
- `README.md` (this file)
- `final_structure.txt`
- `commands_history.txt`

Generate the structure listing:

```bash
tree . > final_structure.txt
# or
find . | sort > final_structure.txt
```

Create the archive:

```bash
cd ..
zip -r AliSadrsharif_kubernetes_01.zip AliSadrsharif_kubernetes_01/
```

---

## Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Docker Documentation](https://docs.docker.com/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

## Author

**Ali Sadrsharif** — DevOps HW_L5_01 Kubernetes 1
