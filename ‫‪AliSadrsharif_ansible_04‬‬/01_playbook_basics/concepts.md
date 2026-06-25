# Playbook Basics – Concepts

## Playbook
A **Playbook** is a YAML file used to describe automation in a way that is
complex, reusable and self-documenting. Instead of running ad-hoc commands,
the whole desired state of a system is written down and applied repeatedly
(idempotently).

## Main structure of a play
Every play inside a playbook is built from a few core keywords:

- **name**: A human readable description of the play/task.
- **hosts**: Which hosts (or groups from the inventory) the play targets.
- **become**: Whether to run tasks with privilege escalation (e.g. `sudo`).
- **vars**: Variables defined for the play.
- **tasks**: The ordered list of actions (modules) to execute.

## Variables
Variables let us parameterize playbooks. They can come from several sources:

- **playbook vars**: Defined directly under the `vars:` key of a play.
- **inventory vars**: Defined per-host or per-group inside the inventory.
- **command line (`-e`)**: Passed at run time, e.g.
  `ansible-playbook play.yml -e "app_port=9090"`. These have the highest
  precedence and override the others.
- **facts**: Information automatically discovered from the target host
  (gathered when `gather_facts: yes`), e.g. `ansible_hostname`,
  `ansible_distribution`, `ansible_memtotal_mb`.

## Jinja2 syntax
Ansible uses the **Jinja2** templating engine. To use the value of a variable
inside a string we wrap its name in double curly braces:

```jinja
{{ variable_name }}
```

For example: `"Running {{ app_name }} on {{ ansible_hostname }}"`.
