#!/bin/bash
set -e

# Check kubectl version
kubectl version --client > kubectl_version.txt 2>&1 || echo "kubectl not installed" > kubectl_version.txt

# Check cluster info
kubectl cluster-info >> kubectl_version.txt 2>&1 || true

# Check nodes
kubectl get nodes -o wide > nodes.txt 2>&1 || echo "no cluster available" > nodes.txt

kubectl get --raw='/readyz' > cluster_health.txt 2>&1 || true