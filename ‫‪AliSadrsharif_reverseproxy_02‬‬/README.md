# AliSadrsharif Reverse Proxy Homework

DevOps assignment covering Docker, Nginx reverse proxy, HTTPS, mTLS, HAProxy load balancing, and Traefik.

## Quick Start

Run scripts from each section directory:

```bash
# Section 01 - Docker setup
cd 01_docker_setup && bash check_docker.sh && bash pull_images.sh

# Section 02 - Nginx basics
cd 02_nginx_basics && bash basic_nginx.sh && bash static_test.sh && bash proxy_test.sh

# Section 03 - HTTPS
cd 03_nginx_certs && bash generate_certs.sh && bash https_test.sh

# Section 04 - Nginx admin
cd 04_nginx_admin && bash status_test.sh && bash log_monitoring.sh

# Section 05 - mTLS
cd 05_nginx_mtls && bash generate_certs.sh && bash mtls_test.sh

# Section 06 - HAProxy (Docker Compose)
cd 06_haproxy && bash setup_backends.sh && bash haproxy_test.sh

# Section 07 - Traefik (Docker Compose)
cd 07_traefik && bash run_traefik.sh && bash advanced_test.sh
```

## Docker Compose Stacks

| Section | File | Services |
|---------|------|----------|
| 02 | `docker-compose.yml` | backend-api, nginx-proxy |
| 06 | `docker-compose.yml` | backend1, backend2, haproxy-lb |
| 07 | `docker-compose.yml` | traefik, whoami |
| 07 | `docker-compose-advanced.yml` | traefik, web1, web2 |

## Service URLs and Ports

| Service | URL / Port |
|---------|------------|
| Nginx static/proxy | http://localhost:8080 |
| Nginx HTTPS | https://localhost:8443/status |
| Nginx status | http://localhost:8090/basic_status |
| Nginx logs demo | http://localhost:8091 |
| mTLS Nginx | https://localhost:9443 |
| HAProxy LB | http://localhost:9000 |
| Backend 1 / 2 | http://localhost:8080 / http://localhost:8081 |
| Traefik whoami | http://localhost:8080 |
| Traefik dashboard | http://localhost:8081 |
| Traefik web1/web2 | `curl -H "Host: web1.localhost" http://localhost:8080` |

## Project Structure

```
01_docker_setup/     Docker environment check and image pulls
02_nginx_basics/     Basic Nginx, static site, reverse proxy
03_nginx_certs/      SSL certificates and HTTPS
04_nginx_admin/      Status module and log monitoring
05_nginx_mtls/       Mutual TLS with client certificates
06_haproxy/          HAProxy load balancing (Compose)
07_traefik/          Traefik dynamic routing (Compose)
```

## Note on Traefik Image

The assignment specifies `traefik:v3.0`. On Docker hosts with API version 1.44+, Traefik v3.0–v3.3 cannot talk to the Docker socket. This project uses `traefik:v3.7` in compose files for compatibility. Change back to `v3.0` if your Docker version is older.
