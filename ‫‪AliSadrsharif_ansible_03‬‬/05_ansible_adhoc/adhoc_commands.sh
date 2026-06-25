#!/bin/bash
# Run ad-hoc Ansible commands and save output

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Prepare source file for copy module demo
echo "Test content from ad-hoc" > /tmp/test_source.txt

# Save all ad-hoc command outputs to adhoc_output.txt
{
  echo "=== Ping Test ==="
  ansible localhost -m ping -e ansible_become=false

  echo ""
  echo "=== Gather Facts ==="
  ansible localhost -m setup -a "filter=ansible_distribution*" -e ansible_become=false

  echo ""
  echo "=== File Operations ==="
  ansible localhost -m file -a "path=/tmp/ansible_test state=directory mode=0755" -e ansible_become=false
  ansible localhost -m stat -a "path=/tmp/ansible_test" -e ansible_become=false

  echo ""
  echo "=== Command Execution ==="
  ansible localhost -m command -a "uptime" -e ansible_become=false
  ansible localhost -m shell -a "echo \$HOME && whoami" -e ansible_become=false

  echo ""
  echo "=== Copy File ==="
  ansible localhost -m copy -a "src=/tmp/test_source.txt dest=/tmp/test_dest.txt" -e ansible_become=false

  echo ""
  echo "=== Get URL ==="
  ansible localhost -m get_url -a "url=https://www.google.com dest=/tmp/google.html" -e ansible_become=false

  echo ""
  echo "=== Package Management ==="
  ansible localhost -m apt -a "name=curl state=present update_cache=yes" --become 2>&1 || echo "Skipped no sudo access"
} > adhoc_output.txt
