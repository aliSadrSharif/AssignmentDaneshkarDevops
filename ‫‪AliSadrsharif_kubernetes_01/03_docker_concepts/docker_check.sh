#!/bin/bash
# docker_check.sh
# Purpose: verify that Docker is installed and check the current state
# of the Docker daemon/service on this machine. Every command is written
# to fail gracefully (with || fallback) so the script never aborts even
# if Docker is missing or not running.

set -e  # exit immediately if a command fails (fallbacks below prevent that for expected failures)

# 1) Check the installed Docker CLI version.
#    If the 'docker' command doesn't exist, write a clear message instead of crashing.
docker --version > docker_version.txt 2>&1 || echo "docker not installed" > docker_version.txt

# 2) Append general Docker daemon info (server version, storage driver, etc.).
#    'docker info' only works if the daemon is actually running, so we
#    fall back to a friendly message if it's not.
docker info 2>/dev/null | head -n 25 >> docker_version.txt || echo "docker daemon not running" >> docker_version.txt

# 3) List all containers (running + stopped) into docker_ps.txt.
docker ps -a > docker_ps.txt

# 4) Check whether the docker systemd service is active.
#    If systemctl isn't available or the service doesn't exist, write "n/a".
systemctl is-active docker 2>/dev/null > docker_service.txt || echo "n/a" > docker_service.txt
