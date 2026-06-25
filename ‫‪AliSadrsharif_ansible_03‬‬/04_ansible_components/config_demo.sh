#!/bin/bash
# Inspect Ansible configuration with ansible-config dump

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Save configuration dump and filtered views to config_demo.txt
{
  echo "=== Current Configuration ==="
  ansible-config dump
  echo ""
  echo "=== Inventory Setting ==="
  ansible-config dump | grep inventory
  echo ""
  echo "=== SSH Settings ==="
  ansible-config dump | grep -i ssh
  echo ""
  echo "=== Privilege Escalation ==="
  ansible-config dump | grep become
} > config_demo.txt
