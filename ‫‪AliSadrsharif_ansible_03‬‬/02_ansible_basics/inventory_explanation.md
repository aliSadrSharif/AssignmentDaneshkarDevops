# Inventory Explanation (Section 2.2)

## 1. What is Inventory and what role does it play?

**Inventory** is Ansible’s source of truth for **which machines to manage** and **how to reach them**. It defines host names, IP addresses or `ansible_host`, groups, group hierarchy, and variables. Every `ansible` and `ansible-playbook` run starts by loading inventory to know the target hosts.

## 2. INI format vs YAML format

| Aspect | INI format | YAML format |
|--------|------------|-------------|
| Syntax | Sections `[group]`, `host var=value` | Nested YAML structure under `all.children` |
| Readability | Familiar for simple inventories | Better for complex hierarchies and inline vars |
| Example | `[webservers]` with hosts listed below | `all: children: webservers: hosts: web1: ...` |

Both are supported via inventory plugins (`ini`, `yaml`). Use INI for small static files; YAML scales better for large or generated inventories.

## 3. Groups and parent groups

- **Groups** organize hosts with a common purpose (e.g. `webservers`, `dbservers`).
- **Parent groups** aggregate child groups using the `:children` suffix.

Example from this project:

```ini
[production:children]
webservers
dbservers
```

The `production` group includes all hosts from `webservers` and `dbservers`. Commands like `ansible production -m ping` target every host in those child groups.

## 4. How are variables defined in inventory?

Variables can be set at several levels:

| Level | Syntax | Example |
|-------|--------|---------|
| Host inline | on the same line as host | `web1 ansible_host=localhost` |
| Group vars | `[groupname:vars]` | `[webservers:vars] http_port=80` |
| All hosts | `[all:vars]` | `ansible_user=ubuntu` |

**Precedence:** More specific scopes (host) override group vars; group vars override `[all:vars]` (full precedence also involves playbook and command-line `-e`).

## 5. What does `ansible_connection=local` do?

`ansible_connection=local` tells Ansible to run modules **on the control machine** without SSH. The host entry (e.g. `web1`) is treated as a logical name, but execution happens locally. This is ideal for labs, WSL, and testing when all hosts point to `localhost`.

**Hint from assignment:** `ansible-inventory --list` shows the full parsed structure including groups, children, and merged variables.
