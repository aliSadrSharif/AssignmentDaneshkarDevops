#!/bin/bash
set -e

cd "$(dirname "$0")"
WORKDIR="$(pwd)"

# Run docker commands (use sg docker if group is not active in session)
docker_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

# Clean up previous volumes and backup file
docker_cmd "docker volume rm backup-test restore-test 2>/dev/null || true"
rm -f volume_backup.tar.gz

# Create volume with sample data
docker_cmd "docker volume create backup-test"
docker_cmd "docker run --rm -v backup-test:/data alpine:latest sh -c 'echo \"Important data\" > /data/file.txt && echo \"More data\" > /data/file2.txt'"

# Backup volume
docker_cmd "docker run --rm -v backup-test:/data -v ${WORKDIR}:/backup alpine:latest tar czf /backup/volume_backup.tar.gz -C /data ."
ls -lh volume_backup.tar.gz > backup_info.txt

# Restore to new volume
docker_cmd "docker volume create restore-test"
docker_cmd "docker run --rm -v restore-test:/data -v ${WORKDIR}:/backup alpine:latest tar xzf /backup/volume_backup.tar.gz -C /data"
docker_cmd "docker run --rm -v restore-test:/data alpine:latest cat /data/file.txt > restored_data.txt"

echo "volume_backup.sh completed."
