# Docker Homework - Week 01

This repository contains my Docker homework and hands-on exercises covering the fundamental concepts of Docker, including images, containers, volumes, networks, Docker Compose, and a multi-container sample project.

---

## Repository Structure

```text
Alisadrsharif_Docker_01/
│
├── 01_docker_images/
├── 02_containers_1/
├── 03_containers_2/
├── 04_volumes_network_1/
├── 05_volumes_network_2/
├── 06_docker_compose/
├── 07_sample_project/
│
├── commands_history.txt
├── final_structure.txt
└── README.md
```

---

## Contents

### 01_docker_images

Introduction to Docker images.

Topics covered:

- Installing Docker
- Pulling Docker images
- Inspecting image metadata
- Viewing image layers
- Understanding image history
- Root filesystem inspection
- Image size analysis

Files include:

- Docker installation script
- Image operation scripts
- Layer inspection
- Image summaries
- Docker version and status outputs

---

### 02_containers_1

Basic container management.

Topics covered:

- Creating containers
- Running containers
- Executing commands inside containers
- Environment variables
- Port mapping
- Viewing container state
- Accessing container logs

Files include:

- Container management scripts
- Environment variable tests
- Port mapping verification
- Process inspection
- Execution examples

---

### 03_containers_2

Advanced container operations.

Topics covered:

- Container logs
- Restart policies
- Health checks
- Resource monitoring
- Docker statistics

Files include:

- Health check scripts
- Restart policy tests
- Resource monitoring
- Log collection
- Health status reports

---

### 04_volumes_network_1

Docker volumes and bind mounts.

Topics covered:

- Named volumes
- Bind mounts
- Persistent storage
- Backup and restore
- Volume inspection

Files include:

- Volume management scripts
- Backup scripts
- Restored data
- Bind mount examples
- Volume information

---

### 05_volumes_network_2

Docker networking.

Topics covered:

- Custom bridge networks
- Container communication
- Network isolation
- Ping tests
- Database connectivity

Files include:

- Network creation scripts
- Isolation tests
- Communication examples
- Network inspection outputs

---

### 06_docker_compose

Introduction to Docker Compose.

Topics covered:

- Multi-container applications
- Environment variables
- Service communication
- Volumes
- Networks
- Compose lifecycle

Files include:

- `docker-compose.yml`
- `.env`
- Compose scripts
- Flask application
- Static website
- Service logs
- Environment variable tests

---

### 07_sample_project

Complete multi-container application.

Architecture:

- Nginx
- Flask API
- Docker Compose

Topics covered:

- Building custom Docker images
- Reverse proxy configuration
- Multi-service networking
- Project deployment
- API testing
- Frontend testing

Files include:

- Dockerfile
- docker-compose.yml
- Flask application
- Nginx configuration
- Test results
- Project logs
- Architecture description

---

## Skills Practiced

- Docker installation
- Docker images
- Container lifecycle
- Docker CLI
- Executing commands inside containers
- Environment variables
- Port mapping
- Health checks
- Restart policies
- Docker logs
- Docker volumes
- Bind mounts
- Backup and restore
- Docker networking
- Bridge networks
- Network isolation
- Docker Compose
- Multi-container applications
- Custom Docker images
- Reverse proxy configuration

---

## Requirements

- Docker Engine
- Docker Compose
- Ubuntu/Linux environment
- Bash shell

---

## How to Run

Clone the repository:

```bash
git clone <repository-url>
cd Alisadrsharif_Docker_01
```

Run the scripts inside each directory according to the exercise.

Example:

```bash
cd 01_docker_images
bash install_docker.sh
```

For Docker Compose examples:

```bash
cd 06_docker_compose
docker compose up -d
```

For the sample project:

```bash
cd 07_sample_project
bash run_project.sh
```

---

## Learning Objectives

After completing this homework, the following Docker concepts have been practiced:

- Understanding Docker architecture
- Managing Docker images
- Running and managing containers
- Working with persistent storage
- Configuring Docker networks
- Deploying applications using Docker Compose
- Building custom Docker images
- Deploying multi-container applications

---

## Author

**Ali Sadrsharif**

Docker Homework — Week 01