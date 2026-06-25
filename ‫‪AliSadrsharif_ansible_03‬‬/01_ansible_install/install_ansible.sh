#!/bin/bash
# Install Ansible and verify the installation
set -e

# Add user-level pip binaries to PATH for the current session
export PATH=$PATH:~/.local/bin

# Install Python and pip if not already present
if sudo -n true 2>/dev/null; then
  sudo apt update
  sudo apt install -y python3 python3-pip python3-venv
else
  echo "Note: sudo requires a password. Skipping apt install."
fi

# Install Ansible via pip (recommended for newer versions; apt provides older releases)
if command -v pip3 >/dev/null 2>&1; then
  pip3 install --user ansible || pip3 install --user --break-system-packages ansible
else
  # Fallback: use a local virtual environment when pip3 is unavailable
  python3 -m venv ansible_venv
  # shellcheck disable=SC1091
  source ansible_venv/bin/activate
  pip install ansible
  export PATH="$(pwd)/ansible_venv/bin:$PATH"
fi

# Save Ansible version information and module list to ansible_version.txt
{
  echo "=== Ansible Version ==="
  ansible --version
  echo ""
  echo "=== First 30 Modules ==="
  ansible-doc -l | head -30 || true
  echo ""
  echo "=== Total Modules ==="
  echo "Total modules: $(ansible-doc -l | wc -l)"
} > ansible_version.txt

# Save command outputs required for ansible_status.txt
{
  echo "=== which ansible ==="
  which ansible
  echo ""
  echo "=== ansible --version ==="
  ansible --version
  echo ""
  echo "=== ansible-config dump | head -30 ==="
  ansible-config dump | head -30
  echo ""
  echo "=== python3 --version ==="
  python3 --version
  echo ""
  echo "=== pip3 show ansible ==="
  pip3 show ansible 2>&1
} > ansible_status.txt
