#!/bin/bash
# Test Ansible connection and inventory configuration

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/ansible_venv/bin/activate" ]; then
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/ansible_venv/bin/activate"
fi

cd "$SCRIPT_DIR/ansible_config"

# Test connection to localhost (override global become; ping does not need sudo)
echo "=== Connection Test ===" > connection_test.txt
ansible localhost -m ping -e ansible_become=false >> connection_test.txt

# Show inventory as JSON
echo -e "\n=== Inventory List ===" >> connection_test.txt
ansible-inventory --list >> connection_test.txt

# List all hosts
echo -e "\n=== All Hosts ===" >> connection_test.txt
ansible all --list-hosts >> connection_test.txt

# Show variables for localhost
echo -e "\n=== Host Variables ===" >> connection_test.txt
ansible-inventory --host localhost >> connection_test.txt
