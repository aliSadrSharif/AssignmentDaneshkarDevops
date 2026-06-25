# Module Usage Guide — ansible-doc (Section 3.2)

## 1. How to use `ansible-doc`

| Command | Purpose |
|---------|---------|
| `ansible-doc -l` | List all available modules (and plugins with `-t`). |
| `ansible-doc <module_name>` | Show full documentation for one module. |
| `ansible-doc -s apt` | Show argument/spec snippet only (useful for playbooks). |
| `ansible-doc -t module ping` | Filter by plugin type (`module`, `become`, `lookup`, etc.). |

Run from any directory after Ansible is installed. Use the project venv if needed:

```bash
source ../01_ansible_install/ansible_venv/bin/activate
ansible-doc file
```

## 2. How to find examples

Examples appear in the **EXAMPLES** section of each module’s docs:

```bash
ansible-doc apt
ansible-doc -t module ping | grep -A 20 "EXAMPLES"
```

In the output, look for the `EXAMPLES` heading — it contains copy-paste YAML and ad-hoc samples maintained by module authors.

## 3. How to understand parameters

Each module doc includes:

| Section | What it tells you |
|---------|-------------------|
| **OPTIONS** | Parameter names, types, defaults, and whether required |
| **NOTES** | Caveats, platform support, idempotency notes |
| **RETURN** | Keys returned in the JSON result (`changed`, `msg`, etc.) |
| **EXAMPLES** | Practical usage patterns |

Read **OPTIONS** carefully: required vs optional fields, allowed `state` values (`present`, `absent`, `directory`), and mutual exclusivity between parameters.

**Tip:** Start with `ansible-doc -s <module>` for a quick parameter cheat sheet, then read full docs before using a module in production.
