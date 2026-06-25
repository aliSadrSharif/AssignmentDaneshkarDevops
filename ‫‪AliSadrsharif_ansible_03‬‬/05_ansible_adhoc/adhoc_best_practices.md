# Ad-Hoc Best Practices (Section 5.1)

## 1. When to use ad-hoc commands

- **Quick checks:** ping, uptime, disk space, service status
- **One-time fixes:** restart a service, touch a config file, clear a cache
- **Exploration:** gather facts, test connectivity, validate inventory
- **Learning:** try a new module before adding it to a playbook

## 2. When to write a playbook instead

- Task will run **more than once** or on a schedule
- Multiple **ordered steps** with dependencies
- Need **handlers**, **roles**, or **variables** across environments
- Change must be **reviewed in Git** and applied consistently in production
- Compliance / audit requires documented, repeatable automation

## 3. Best practices for ad-hoc commands

| Practice | Why |
|----------|-----|
| Prefer **modules** over `command`/`shell` | Idempotency and structured output |
| Use `-i` and `ansible.cfg` consistently | Avoid targeting wrong hosts |
| Limit `--become` to tasks that need root | Reduces risk and sudo prompts |
| Quote arguments properly (`-a "key=value"`) | Prevents shell parsing errors |
| Test on `localhost` or a canary host first | Catch mistakes before wide rollout |
| Document one-off commands you run in prod | Or convert them to playbooks for repeatability |

**Assignment hints:** Ad-hoc is for fast, single tasks; playbooks are for complex, reusable workflows. Use `--become` for `apt`; use `-i` to specify inventory when not configured in `ansible.cfg`.
