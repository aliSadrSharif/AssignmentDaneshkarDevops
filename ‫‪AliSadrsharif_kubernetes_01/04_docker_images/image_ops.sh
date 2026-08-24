#!/bin/bash
# image_ops.sh
# Purpose: practice pulling, tagging, inspecting, and removing Docker images,
# and understand how images relate to their layers.

set -e  # stop the script if any command fails (no expected failures here)

# 1) Pull the nginx:alpine image from Docker Hub.
docker pull nginx:alpine

# 2) List local images, filter for nginx, and save to image_list.txt.
docker images | grep nginx > image_list.txt

# 3) Create a new tag "my-nginx:v1" pointing to the same image (no re-download,
#    just a new reference/name for the same image ID).
docker tag nginx:alpine my-nginx:v1

# 4) Append both nginx and my-nginx entries to confirm the new tag exists.
docker images | grep -E 'nginx|my-nginx' >> image_list.txt

# 5) Inspect low-level image metadata — here just architecture and OS —
#    and save the result.
docker inspect nginx:alpine --format '{{.Architecture}} {{.Os}}' > image_inspect.txt

# 6) Show the build history (layers) of the image, with full (non-truncated)
#    commands, and keep only the first 15 lines.
docker history nginx:alpine --no-trunc | head -n 15 > image_history.txt

# 7) Remove the extra tag we created (my-nginx:v1). Ignore errors if it's
#    already gone (e.g., script re-run).
docker rmi my-nginx:v1 2>/dev/null || true

# Deliver all generated output files (image_list.txt, image_inspect.txt,
# image_history.txt) together with this folder.
