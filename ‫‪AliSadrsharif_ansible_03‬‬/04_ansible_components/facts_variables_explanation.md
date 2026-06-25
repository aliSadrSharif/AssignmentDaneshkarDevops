# Facts and Variables (Section 4.1)

## 1. What are Facts?

**Facts** are system information automatically collected from managed nodes. Ansible gathers them (usually at the start of a playbook) and exposes them as variables for use in tasks, templates, and conditionals.

### What does `gather_facts: yes` collect?

| Category | Examples |
|----------|----------|
| **System** | `ansible_hostname`, `ansible_distribution`, `ansible_architecture`, `ansible_kernel` |
| **Network** | `ansible_default_ipv4`, interfaces, IP addresses, MAC addresses |
| **Hardware** | `ansible_processor_*`, `ansible_memtotal_mb`, disks, mounts |

### How to view facts

```bash
ansible localhost -m setup
ansible localhost -m setup -a "filter=ansible_distribution*"
```

The `setup` module is the standard way to gather and display facts.

### `ansible_facts` vs `ansible_*` variables

| Form | Description |
|------|-------------|
| `ansible_*` | Flat facts at the top level (e.g. `ansible_os_family`, `ansible_memtotal_mb`) |
| `ansible_facts` | Dictionary containing **all** facts for a host; access via `ansible_facts['key']` or dot notation in Jinja2 |

In playbooks, both styles are common: `{{ ansible_distribution }}` or `{{ ansible_facts.ansible_distribution }}`.

---

## 2. Variables in Ansible

### How variables are defined

| Source | Example |
|--------|---------|
| Playbook `vars:` | `vars: http_port: 80` |
| Inventory `[group:vars]` | `[webservers:vars] http_port=80` |
| Command line `-e` | `ansible host -m ping -e "env=prod"` |
| Files `vars_files:` | `vars_files: - vars/main.yml` |
| Facts | Auto-populated by `setup` module |
| Registered results | `register: result` from a task |

### Variable precedence (highest wins, simplified)

1. Command-line extra vars (`-e`)
2. Task vars / `include_vars`
3. Block / role / play vars
4. `host_vars` / `group_vars`
5. Inventory `host` / `group` vars
6. Role defaults
7. `ansible_facts`

*(Full precedence has more steps; see Ansible docs for the complete list.)*

### Using variables

In playbooks and templates, reference with Jinja2:

```yaml
- debug: msg="OS is {{ ansible_distribution }} on port {{ http_port }}"
```

### Jinja2 templating

**Jinja2** is the template language Ansible uses for `{{ }}` expressions, `{% %}` control flow, and filters (`{{ name \| upper }}`). Files processed by the `template` module are rendered with variables and facts at deploy time.
