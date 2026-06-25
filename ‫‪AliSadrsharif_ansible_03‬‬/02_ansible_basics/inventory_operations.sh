#!/bin/bash
# Run inventory inspection and connectivity commands

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Save all inventory operation outputs to inventory_operations.txt
{
  echo "=== Inventory as JSON ==="
  ansible-inventory -i inventory --list
  echo ""
  echo "=== Inventory as YAML ==="
  ansible-inventory -i inventory --list -y
  echo ""
  echo "=== Webservers Group ==="
  ansible webservers -i inventory --list-hosts
  echo ""
  echo "=== All Hosts ==="
  ansible all -i inventory --list-hosts
  echo ""
  echo "=== Production Group Children ==="
  ansible production -i inventory --list-hosts
  echo ""
  echo "=== Variables for web1 ==="
  ansible-inventory -i inventory --host web1
  echo ""
  echo "=== Ping All Hosts ==="
  ansible all -i inventory -m ping -e ansible_become=false
} > inventory_operations.txt
