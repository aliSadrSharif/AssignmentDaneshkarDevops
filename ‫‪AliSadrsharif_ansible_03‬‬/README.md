# AliSadrsharif — Ansible Homework (HW_L3_03)

DevOps Level 3 assignment covering Ansible installation, configuration, inventory, core concepts, components, and ad-hoc commands. All scenarios run on Ubuntu 22.04+ / WSL with `localhost` and `ansible_connection=local` for local testing.

---

## Setup and installation

### 1. Install Ansible

```bash
cd 01_ansible_install
bash install_ansible.sh
```

This script:
- Installs Python/pip via `apt` (when sudo is available)
- Installs Ansible with `pip` (or creates `ansible_venv` as fallback)
- Generates `ansible_version.txt` and `ansible_status.txt`

### 2. Activate the virtual environment (if used)

```bash
source 01_ansible_install/ansible_venv/bin/activate
```

### 3. Initial configuration (Section 1.2)

```bash
cd 01_ansible_install
bash test_connection.sh
```

Configuration lives in `01_ansible_install/ansible_config/`:
- `ansible.cfg` — defaults, privilege escalation, inventory plugins
- `hosts.ini` — localhost and commented remote host placeholders

---

## Project structure

| Directory | Purpose |
|-----------|---------|
| `01_ansible_install/` | Ansible install script, status output, `ansible.cfg`, `hosts.ini`, connection tests |
| `02_ansible_basics/` | Architecture notes, inventory examples, inventory operations |
| `03_ansible_concepts/` | Idempotency demo, modules documentation |
| `04_ansible_components/` | Facts gathering, `ansible-config` inspection |
| `05_ansible_adhoc/` | Ad-hoc command examples and output |

### Key scripts

| Script | Output |
|--------|--------|
| `01_ansible_install/install_ansible.sh` | `ansible_version.txt`, `ansible_status.txt` |
| `01_ansible_install/test_connection.sh` | `ansible_config/connection_test.txt` |
| `02_ansible_basics/inventory_operations.sh` | `inventory_operations.txt` |
| `03_ansible_concepts/idempotency_demo.sh` | `idempotency_demo.txt` |
| `03_ansible_concepts/modules_documentation.sh` | `modules_doc.txt` |
| `04_ansible_components/facts_demo.sh` | `facts_demo.txt`, `facts_all.json` |
| `04_ansible_components/config_demo.sh` | `config_demo.txt` |
| `05_ansible_adhoc/adhoc_commands.sh` | `adhoc_output.txt` |

---

## Running ad-hoc commands

Activate Ansible, then run modules directly:

```bash
source 01_ansible_install/ansible_venv/bin/activate

# Basic connectivity
ansible localhost -m ping -e ansible_become=false

# With inventory file
ansible all -i 02_ansible_basics/inventory -m ping -e ansible_become=false

# With project config
cd 01_ansible_install/ansible_config
ansible localhost -m ping -e ansible_become=false

# Run all ad-hoc demos
cd 05_ansible_adhoc
bash adhoc_commands.sh
```

**Syntax:** `ansible <hosts> -m <module> -a "<arguments>" [-i inventory] [--become]`

---

## Concepts covered

1. **Installation** — `pip install --user` vs `apt`; verifying with `ansible --version` and `ansible-doc`
2. **Configuration** — `ansible.cfg` sections, inventory path, SSH/become settings
3. **Architecture** — control node, managed nodes, modules, agentless push model
4. **Inventory** — INI groups, parent groups (`:children`), group/host variables
5. **Idempotency** — state-based tasks; `changed: true/false` behavior
6. **Modules** — system, file, command, cloud, network, database; `ansible-doc`
7. **Facts & variables** — `setup` module, filters, Jinja2, variable precedence
8. **Ad-hoc vs playbooks** — quick one-off tasks vs reusable YAML automation

---

## Author

Ali Sadrsharif — HW_L3_03_Ansible
