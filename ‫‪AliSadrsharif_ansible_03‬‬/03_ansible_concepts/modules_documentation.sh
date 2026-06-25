#!/bin/bash
# Collect Ansible module documentation samples

# Use Ansible from the local virtual environment when available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_ACTIVATE="$SCRIPT_DIR/../01_ansible_install/ansible_venv/bin/activate"
if [ -f "$VENV_ACTIVATE" ]; then
  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE"
fi

cd "$SCRIPT_DIR"

# Save module list and documentation excerpts to modules_doc.txt
{
  echo "=== All Modules ==="
  ansible-doc -l | head -50 || true
  echo ""
  echo "=== apt Module Documentation ==="
  ansible-doc apt | head -100 || true
  echo ""
  echo "=== file Module Documentation ==="
  ansible-doc file | head -100 || true
  echo ""
  echo "=== copy Module Documentation ==="
  ansible-doc copy | head -100 || true
  echo ""
  echo "=== ping Module Examples ==="
  ansible-doc -t module ping | grep -A 20 "EXAMPLES" || true
} > modules_doc.txt
