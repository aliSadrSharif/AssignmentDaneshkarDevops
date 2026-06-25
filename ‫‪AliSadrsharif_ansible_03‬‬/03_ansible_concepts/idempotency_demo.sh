#!/bin/bash
# Demonstrate idempotency with the file module (three identical runs)

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Save demo output: first run creates, second and third should show changed=false
{
  echo "=== First Run should create ==="
  ansible localhost -m file -a "path=/tmp/ansible_idempotency state=directory" -e ansible_become=false
  echo ""
  echo "=== Second Run should NOT create, changed=false ==="
  ansible localhost -m file -a "path=/tmp/ansible_idempotency state=directory" -e ansible_become=false
  echo ""
  echo "=== Third Run should NOT create, changed=false ==="
  ansible localhost -m file -a "path=/tmp/ansible_idempotency state=directory" -e ansible_become=false
} > idempotency_demo.txt
