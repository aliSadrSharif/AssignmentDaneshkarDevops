# Ansible Complete Explanation (Section 2.1)

## 1. What is Ansible and why is it used?

**Ansible** is an open-source **IT automation platform** used to configure systems, deploy applications, orchestrate workflows, and manage infrastructure. It uses simple, human-readable YAML playbooks and a large library of modules to automate repetitive tasks across many servers.

### Brief history

Ansible was created by **Michael DeHaan** and released in **2012**. It was later acquired by Red Hat and became one of the most widely used configuration management and automation tools in DevOps.

### Key advantages

| Advantage | Description |
|-----------|-------------|
| **Idempotency** | Running the same playbook multiple times produces the same desired state. If a change is already applied, Ansible reports `changed: false` and does not repeat unnecessary work. |
| **Agentless** | No permanent agent daemon is required on managed nodes. Ansible connects over SSH (Linux) or WinRM (Windows). |
| **Simplicity** | Playbooks are written in YAML; modules are typically written in Python. The learning curve is lower than many alternatives. |
| **Powerful** | Thousands of built-in and collection modules cover cloud, networking, databases, containers, and more. |

### Comparison with other tools

| Tool | Model / style | Notes |
|------|----------------|-------|
| **Ansible vs Puppet** | Puppet uses a **pull** model (agents pull config from server); Ansible uses a **push** model (control node pushes tasks). | Ansible is often faster to adopt for ad-hoc and playbook-based automation. |
| **Ansible vs Chef** | Chef uses Ruby-based recipes and a heavier setup. | Ansible is generally simpler for teams that prefer YAML over Ruby DSL. |
| **Ansible vs SaltStack** | SaltStack can be faster at very large scale with its event bus. | SaltStack is more complex to operate; Ansible trades some speed for simplicity. |

---

## 2. Ansible architecture

### Core components

| Component | Role |
|-----------|------|
| **Control Node** | Machine where Ansible is installed. You run `ansible`, `ansible-playbook`, and `ansible-inventory` from here. |
| **Managed Nodes** | Target systems (servers, VMs, containers) that Ansible configures. |
| **Inventory** | File or plugin source listing managed nodes, organized into groups and variables. |
| **Modules** | Units of code that perform specific tasks (e.g. `apt`, `file`, `service`, `copy`). |
| **Plugins** | Extensions that enhance Ansible (callbacks, connection types, inventory plugins, lookup plugins). |
| **Playbooks** | YAML files defining ordered plays, tasks, handlers, and variables. |

### Architecture diagram (ASCII)

```
                    +---------------------------+
                    |      CONTROL NODE         |
                    |  (Ansible installed)      |
                    |                           |
                    |  ansible / ansible-playbook|
                    |  inventory, playbooks,    |
                    |  modules, plugins         |
                    +-------------+-------------+
                                  |
                    Push tasks via SSH / WinRM
                                  |
          +-----------------------+-----------------------+
          |                       |                       |
          v                       v                       v
   +-------------+        +-------------+        +-------------+
   | MANAGED     |        | MANAGED     |        | MANAGED     |
   | NODE 1      |        | NODE 2      |        | NODE N      |
   | (webserver) |        | (dbserver)  |        | (appserver) |
   +-------------+        +-------------+        +-------------+
```

**Flow:** The control node reads inventory and playbooks, selects modules for each task, connects to managed nodes, copies module code, executes it, and collects JSON results.

---

## 3. Agentless architecture

Ansible does **not** require installing a persistent agent on managed nodes.

### How Ansible communicates

- **Linux / Unix:** SSH (default connection plugin)
- **Windows:** WinRM
- **Local testing:** `ansible_connection=local` runs modules on the control machine

Ansible pushes a small Python module (or PowerShell on Windows) to the target, executes it, and returns structured output. No long-running agent process listens on the managed host.

### Advantages of agentless

- **Simpler deployment** — no agent install, upgrade, or patching on every node
- **Better security posture** — no extra open ports for agent listeners
- **Faster onboarding** — add a host to inventory and connect with SSH keys

### Disadvantages of agentless

- **Requires SSH or WinRM** — connectivity and credentials must be configured
- **Python on target** — most Linux modules expect Python on the managed node (or use `raw` when it is missing)

---

## 4. Push vs pull model

### Push model (Ansible)

The **control node initiates** connections and sends tasks to managed nodes when you run a command or playbook.

**Pros:** Central control, immediate execution, easy ad-hoc runs, no agent on targets.  
**Cons:** Control node must reach all targets; scheduling is external (cron, CI/CD, AWX/Tower).

### Pull model (e.g. Puppet)

**Managed nodes** periodically connect to a central server and pull their desired configuration.

**Pros:** Nodes can recover after outages by pulling latest state; works when inbound connections to nodes are restricted.  
**Cons:** Requires agent installation and maintenance; changes apply on the agent’s schedule, not instantly.

### Why Ansible uses push

Ansible is designed for **orchestration and on-demand automation**: deploy now, patch now, run one task across a group. Push fits ad-hoc commands, CI/CD pipelines, and operator-driven workflows without maintaining agents on every host.
