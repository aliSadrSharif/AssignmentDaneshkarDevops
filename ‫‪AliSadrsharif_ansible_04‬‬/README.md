# Ansible Playbooks & Roles

Homework solution for the Ansible assignment (DevOps – HW_L3_04).
All playbooks are written for **Ubuntu 22.04 / WSL / local VM** and target
`localhost`.

## Project structure
- **01_playbook_basics**: variables, conditionals, loops
- **02_playbook_advanced**: handlers, templates, error handling
- **03_playbook_complex**: multi-play, import/include, tags
- **04_ansible_roles**: roles with dependencies

```
.
├── ansible.cfg
├── 01_playbook_basics/
│   ├── concepts.md
│   ├── first_playbook.yml
│   ├── conditionals_loops.yml
│   └── loops_explanation.md
├── 02_playbook_advanced/
│   ├── concepts.md
│   ├── handlers_templates.yml
│   ├── error_handling.yml
│   └── templates/
│       ├── nginx.conf.j2
│       └── app.conf.j2
├── 03_playbook_complex/
│   ├── concepts.md
│   ├── inventory
│   ├── multi_play.yml
│   ├── tags_demo.yml
│   └── tasks/
│       ├── install.yml
│       └── configure.yml
├── 04_ansible_roles/
│   ├── roles_concepts.md
│   ├── deploy.yml
│   ├── conditional_roles.yml
│   └── roles/
│       ├── common/
│       ├── webserver/
│       └── monitoring/
├── final_structure.txt
└── playbook_runs.txt
```

## Running

```bash
# Section 1 – basics
ansible-playbook 01_playbook_basics/first_playbook.yml
ansible-playbook 01_playbook_basics/first_playbook.yml --syntax-check
ansible-playbook 01_playbook_basics/first_playbook.yml -e "app_port=9090 app_version=2.0.0"
ansible-playbook 01_playbook_basics/conditionals_loops.yml

# Section 2 – advanced
ansible-playbook 02_playbook_advanced/handlers_templates.yml
ansible-playbook 02_playbook_advanced/error_handling.yml

# Section 3 – complex
ansible-playbook -i 03_playbook_complex/inventory 03_playbook_complex/multi_play.yml
ansible-playbook 03_playbook_complex/tags_demo.yml --tags install
ansible-playbook 03_playbook_complex/tags_demo.yml --tags webserver
ansible-playbook 03_playbook_complex/tags_demo.yml --skip-tags configure
ansible-playbook 03_playbook_complex/tags_demo.yml --list-tags

# Section 4 – roles
ansible-playbook 04_ansible_roles/deploy.yml
ansible-playbook 04_ansible_roles/deploy.yml --tags webserver
ansible-playbook 04_ansible_roles/conditional_roles.yml
```

> **Note:** `ansible.cfg` redirects Ansible's temporary directories inside the
> project (`.ansible_tmp/`) so everything runs without extra permissions. Tasks
> that install system packages or restart services use `become: yes` together
> with `ignore_errors: yes`, so the playbooks complete cleanly even without
> root privileges or network access.

## Key concepts
- **Playbook structure**: name, hosts, tasks
- **Variables**: vars, facts, set_fact
- **Conditionals**: when, and, or
- **Loops**: loop with item
- **Handlers**: notify for restart/reload
- **Templates**: Jinja2 with `{{ }}` and `{% %}`
- **Roles**: modular, reusable structure
- **Tags**: control which tasks run

## Output files
- **final_structure.txt**: output of `tree` / `find` for the whole project
- **playbook_runs.txt**: every command that was executed, with its output
