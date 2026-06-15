# Docker Sample Project

A simple web application with Nginx as a reverse proxy and a Python API backend.

## Setup

```bash
cd 07_sample_project
docker-compose up -d --build
```

Or run the provided script:

```bash
chmod +x run_project.sh
./run_project.sh
```

To stop the services:

```bash
docker-compose down
```

## File Structure

| Path | Role |
|------|------|
| `docker-compose.yml` | Defines the nginx and python-app services |
| `nginx/nginx.conf` | Nginx config for static files and API proxy |
| `app/app.py` | Python HTTP server on port 8000 |
| `app/Dockerfile` | Builds the custom image for python-app |
| `web/index.html` | Frontend page |

## Service Access

| Service | URL | Port |
|---------|-----|------|
| Frontend (Nginx) | http://localhost:3000 | 3000 |
| API (via Nginx) | http://localhost:3000/api | 3000 (proxied to 8000) |
| Python app (internal) | http://python-app:8000 | 8000 (Docker network only) |
