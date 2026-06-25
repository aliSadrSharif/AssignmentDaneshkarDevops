# Modules Explanation (Section 3.2)

## 1. What is a Module?

A **module** is a unit of code that performs one specific task on managed nodes (install a package, copy a file, manage a user, etc.).

| Question | Answer |
|----------|--------|
| Where do modules run? | On **target machines** (managed nodes), not on the control node. |
| How are modules transferred? | Ansible pushes module code over the connection (SSH/WinRM/local), executes it, and collects JSON results. |
| Built-in vs custom | **Built-in** modules ship with Ansible; **custom** modules can be written in Python (or other languages) and placed in `library/` or a collection. |

---

## 2. Types of modules (with two examples each)

### System modules
Manage OS-level resources.

| Module | Use case |
|--------|----------|
| `apt` | Install/remove `.deb` packages on Debian/Ubuntu (`name=nginx state=present`). |
| `service` | Ensure a daemon is started/stopped (`name=nginx state=started enabled=yes`). |

### File modules
Manage files and content.

| Module | Use case |
|--------|----------|
| `copy` | Copy a file from control node to target (`src=... dest=...`). |
| `template` | Deploy a Jinja2 template with variables (`src=nginx.conf.j2 dest=...`). |

### Command modules
Run arbitrary commands.

| Module | Use case |
|--------|----------|
| `command` | Run a command without shell (`command: uptime`). |
| `shell` | Run via shell for pipes/redirects (`shell: cat /var/log/syslog \| tail -5`). |

### Cloud modules
Integrate with public clouds.

| Module | Use case |
|--------|----------|
| `amazon.aws.ec2_instance` | Create/manage EC2 instances. |
| `azure.azcollection.azure_rm_virtualmachine` | Manage Azure VMs. |

### Network modules
HTTP and network operations.

| Module | Use case |
|--------|----------|
| `uri` | Interact with HTTP APIs (GET/POST with headers and body). |
| `get_url` | Download files from URLs to the target. |

### Database modules
Manage databases.

| Module | Use case |
|--------|----------|
| `community.mysql.mysql_db` | Create or drop MySQL databases. |
| `community.postgresql.postgresql_db` | Manage PostgreSQL databases. |

---

## 3. Difference: `command`, `shell`, and `raw`

| Module | Behavior | Idempotent? | When to use |
|--------|----------|-------------|-------------|
| `command` | Runs command **without** shell; no pipes/redirects | No | Simple, safe one-off commands |
| `shell` | Runs through `/bin/sh`; supports pipes, `>`, `&&` | No | When shell features are required |
| `raw` | Executes directly over SSH **without** Python on target | No | Bootstrap Python or manage hosts without Python |

**Prefer dedicated modules** (`apt`, `file`, `copy`) when possible — they are idempotent and return structured results.
