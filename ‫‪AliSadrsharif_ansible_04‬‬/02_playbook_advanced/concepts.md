# Playbook Advanced – Concepts

## Handlers
**Handlers** are special tasks that only run when they are *notified* by
another task, and only if that task reported a **change**. They run once, at
the end of the play (after all tasks), even if notified multiple times. This
makes them ideal for actions like restarting/reloading a service after its
configuration file changed.

A task notifies a handler with the `notify:` keyword referencing the handler's
`name`.

## Templates
**Templates** are Jinja2 files (usually with a `.j2` extension) that are
rendered with the play's variables and facts before being copied to the target.
Key Jinja2 syntax used in templates:

- **Variables**: `{{ var }}`
- **Conditionals**: `{% if condition %} ... {% endif %}`
- **Loops**: `{% for item in list %} ... {% endfor %}`

The `template` module renders the `.j2` file and writes the result to `dest`.
