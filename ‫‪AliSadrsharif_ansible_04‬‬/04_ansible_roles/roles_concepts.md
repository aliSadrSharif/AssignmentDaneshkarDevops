# Ansible Roles – Concepts

A **Role** is the standard way Ansible organizes related content (tasks,
handlers, variables, templates, files, ...) so it can be reused and shared.

## Standard structure
```
role_name/
├── tasks/main.yml       # required: the role's tasks
├── handlers/main.yml    # handlers used by the role
├── templates/           # Jinja2 templates (.j2)
├── files/               # static files to copy
├── vars/main.yml        # high-precedence variables
├── defaults/main.yml    # default (low-precedence) variables
└── meta/main.yml        # metadata and role dependencies
```

## Creating roles
Roles are usually scaffolded with `ansible-galaxy`:
```
cd 04_ansible_roles
mkdir -p roles
ansible-galaxy init roles/common
ansible-galaxy init roles/webserver
ansible-galaxy init roles/monitoring
```

## Key points
- **defaults/main.yml** holds variables that are easy to override (e.g.
  `webserver_port`).
- **vars/main.yml** holds variables with higher precedence.
- **meta/main.yml** declares **dependencies**: other roles that must run before
  this one (e.g. `monitoring` depends on `common`).
- Roles are used in a play under the `roles:` key, or dynamically via
  `include_role` / `import_role`.
