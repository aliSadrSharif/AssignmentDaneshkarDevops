# Docker Basic Concepts

## 1. Difference between VM and Container (at least 4 criteria)

| Criterion | Virtual Machine (VM) | Container |
|---|---|---|
| Isolation level | Full hardware-level virtualization, runs its own guest OS via a hypervisor | Process-level isolation, shares the host OS kernel (namespaces + cgroups) |
| Size | Heavy — typically gigabytes (includes a full OS) | Lightweight — typically megabytes (only app + dependencies) |
| Startup time | Slow — boots a full OS, can take minutes | Fast — starts almost instantly (seconds or less) since no OS boot is needed |
| Resource usage | High overhead — each VM needs its own OS, kernel, drivers | Low overhead — containers share the host kernel, so more containers fit per machine |
| Portability | Portable but heavier to move/copy between hosts | Highly portable — images can be built once and run anywhere Docker runs |
| Security boundary | Stronger isolation (separate kernel), generally considered more secure by default | Weaker isolation than a VM (shared kernel), though still strongly sandboxed |

## 2. Difference between Image and Container

- **Image**: A read-only, immutable template/blueprint that contains the application code, dependencies, libraries, and filesystem needed to run something. It is built once (e.g., with `docker build`) and can be reused to create many containers. Images are made of stacked, cached layers.
- **Container**: A running (or stopped) *instance* of an image. When you run `docker run <image>`, Docker adds a thin writable layer on top of the image's read-only layers. Any changes made while the container runs (new files, modified files) live in that writable layer and are lost when the container is removed (unless persisted via a volume).

In short: an image is like a class, and a container is like an object/instance created from that class.

## 3. Main Components of the Docker Engine

- **daemon (dockerd)**: The background service that does the actual work — building images, running containers, managing networks and volumes. It listens for API requests and manages the container lifecycle.
- **CLI (docker command)**: The command-line client the user interacts with (`docker run`, `docker build`, `docker ps`, etc.). It sends requests to the daemon over the Docker API (usually via a Unix socket or TCP).
- **container runtime**: The lower-level component (e.g., containerd / runc) that actually creates and runs containers using Linux kernel features (namespaces, cgroups). The daemon delegates the low-level execution work to the runtime.

Together: CLI → talks to → daemon (dockerd) → delegates to → container runtime (containerd/runc) → creates the actual container process.
