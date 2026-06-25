# Playbook Complex – Concepts

- **Multi-play**: A single playbook can contain several `plays`, each targeting
  different hosts/groups. This is useful for orchestration, e.g. first do common
  setup on all servers, then configure web servers, then database servers.
- **Import** (`import_tasks`, `import_playbook`): **static**. The referenced
  file is processed at **parse time** (before execution starts). Tags and
  conditionals applied to the import are copied to every imported task.
- **Include** (`include_tasks`): **dynamic**. The referenced file is processed
  at **execution time**, which means it can use variables and loops that are
  only known while the play is running.
