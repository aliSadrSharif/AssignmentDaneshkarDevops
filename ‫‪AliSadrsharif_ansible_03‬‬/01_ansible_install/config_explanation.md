# Configuration Explanation — ansible.cfg (Section 1.2)

## [defaults]

| Directive | Explanation |
|-----------|-------------|
| `inventory = ./hosts.ini` | Sets the default inventory file path relative to `ansible.cfg`. Ansible reads host and group definitions from this file. |
| `host_key_checking = False` | Disables SSH host key verification. **Development only** — in production, use known_hosts or proper key management to prevent MITM attacks. |
| `remote_user = ubuntu` | Default SSH user for connecting to remote hosts. Matches common Ubuntu cloud images. |
| `private_key_file = ~/.ssh/id_rsa` | Default path to the SSH private key used for authentication. **In production**, use SSH keys with proper permissions (`chmod 600`). |
| `retry_files_enabled = False` | Disables creation of `.retry` files after failed playbook runs. Keeps the project directory cleaner. |
| `stdout_callback = yaml` | Formats task output as YAML for easier reading during development and debugging. |
| `deprecation_warnings = True` | Shows warnings when using deprecated features, helping you update playbooks before upgrades break them. |

## [privilege_escalation]

| Directive | Explanation |
|-----------|-------------|
| `become = True` | Enables privilege escalation by default (equivalent to `--become` on the CLI). Tasks can run as another user, typically root. |
| `become_method = sudo` | Uses `sudo` to escalate privileges on Linux hosts. |
| `become_user = root` | Target user after escalation. Most system administration tasks require root. |
| `become_ask_pass = False` | Does not prompt for the sudo password. Assumes passwordless sudo or NOPASSWD rules are configured. |

## [inventory]

| Directive | Explanation |
|-----------|-------------|
| `enable_plugins = host_list, script, auto, yaml, ini, toml` | Lists inventory plugins Ansible may use to parse inventory sources. Supports INI, YAML, TOML, scripts, and auto-discovery. |

## Inventory notes

- `ansible_connection=local` — Runs modules directly on the control machine without SSH. Used for `localhost` in local development.
- Commented hosts under `[webservers]` and `[dbservers]` — Placeholders for real remote VMs; uncomment and set `ansible_host` when you have remote targets.
