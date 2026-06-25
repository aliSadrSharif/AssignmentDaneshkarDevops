# Ad-Hoc Commands Explanation (Section 5.1)

## 1. What is an Ad-Hoc Command?

An **ad-hoc command** is a one-liner that runs a single Ansible module against selected hosts **without** a playbook file.

```bash
ansible <hosts> -m <module> -a "<arguments>" [options]
```

### When to use ad-hoc

| Use case | Example |
|----------|---------|
| Quick one-off tasks | Restart a service on one server |
| Testing / troubleshooting | `ansible host -m ping` |
| Fast changes | Copy a file, check uptime, gather one fact |

### Ad-hoc vs playbook

| Aspect | Ad-hoc | Playbook |
|--------|--------|----------|
| Format | Single CLI command | YAML file with plays and tasks |
| Reusability | Low | High (version control, CI/CD) |
| Complexity | One module, one shot | Multiple tasks, handlers, roles |
| Best for | Quick ops and debugging | Production automation |

---

## 2. Ad-Hoc command structure

```bash
ansible <hosts> -m <module> -a "<arguments>" [options]
```

| Part | Description |
|------|-------------|
| `<hosts>` | `all`, a group (`webservers`), or a single host (`localhost`) |
| `-m <module>` | Module name (`ping`, `copy`, `apt`, `setup`, …) |
| `-a "<arguments>"` | Module parameters as `key=value` pairs |
| **Options** | `-i inventory` — inventory file; `-u user` — remote user; `--become` — sudo |

### Examples from this section

```bash
ansible localhost -m ping
ansible localhost -m setup -a "filter=ansible_distribution*"
ansible localhost -m file -a "path=/tmp/ansible_test state=directory mode=0755"
ansible localhost -m copy -a "src=/tmp/test_source.txt dest=/tmp/test_dest.txt"
```

**Hints:** Use `--become` for package install (`apt`); use `-i` when inventory is not in `ansible.cfg`.
