#!/bin/bash
# Gather and filter Ansible facts from localhost

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Save filtered fact samples to facts_demo.txt
{
  echo "=== All Facts ==="
  ansible localhost -m setup -e ansible_become=false
  echo ""
  echo "=== Distribution Facts ==="
  ansible localhost -m setup -a "filter=ansible_distribution*" -e ansible_become=false
  echo ""
  echo "=== Network Facts ==="
  ansible localhost -m setup -a "filter=ansible_default_ipv4" -e ansible_become=false
  echo ""
  echo "=== Memory Facts ==="
  ansible localhost -m setup -a "filter=ansible_memtotal_mb" -e ansible_become=false
} > facts_demo.txt

# Save complete facts output to JSON-style file
ansible localhost -m setup -e ansible_become=false > facts_all.json
