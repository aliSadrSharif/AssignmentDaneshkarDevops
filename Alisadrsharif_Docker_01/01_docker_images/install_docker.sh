#!/bin/bash
set -e

cd "$(dirname "$0")"

# Install Docker (Ubuntu/Debian)
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker

# Hint: add user to docker group to run Docker commands without sudo
sudo usermod -aG docker "$USER"

# Check version (use sg docker because the group is not active in this session yet)
sg docker -c "docker --version" > docker_version.txt
sg docker -c "docker info" | head -n 20 >> docker_version.txt

# Save service status and container list
{
    sudo systemctl status docker --no-pager | head -n 15
    echo ""
    sg docker -c "docker ps -a"
} > docker_status.txt

echo "Docker installation completed."
echo "User $USER was added to the docker group — after logout/login, docker commands work without sudo."
