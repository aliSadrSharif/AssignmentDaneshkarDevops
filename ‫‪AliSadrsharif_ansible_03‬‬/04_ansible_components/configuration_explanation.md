# Configuration and Settings (Section 4.2)

## 1. What is `ansible.cfg`?

`ansible.cfg` is Ansible’s **main configuration file**. It sets defaults for inventory path, SSH behavior, privilege escalation, callbacks, and more so you do not repeat flags on every command.

### Configuration file precedence (highest first)

1. `ANSIBLE_CONFIG` environment variable (path to a config file)
2. `ansible.cfg` in the **current directory**
3. `~/.ansible.cfg` in the user home directory
4. `/etc/ansible/ansible.cfg` system-wide

### Important sections

| Section | Purpose |
|---------|---------|
| `[defaults]` | Core settings: inventory, remote user, callbacks, forks |
| `[privilege_escalation]` | `become`, `become_method`, `become_user` |
| `[inventory]` | Inventory plugin enablement and behavior |

---

## 2. Important configuration options

| Option | Description |
|--------|-------------|
| `inventory` | Path to default inventory file (e.g. `./hosts.ini`) |
| `host_key_checking` | When `False`, skips SSH host key verification (dev only) |
| `remote_user` | Default SSH username for connections |
| `become` | Enable privilege escalation (`sudo`) by default |
| `gathering` | Controls fact gathering (`implicit`, `explicit`, or `disabled`) |

Running `ansible-config dump` shows effective values and whether each comes from the config file, environment, or default.

---

## Hints (from assignment)

- Use `ansible-config dump` to inspect all effective settings.
- Filter with `grep` for SSH, inventory, or `become` related options.
- In production, prefer explicit SSH keys and avoid `host_key_checking = False`.
