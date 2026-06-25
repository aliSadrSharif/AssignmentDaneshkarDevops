# Conditionals, Loops and Register

- **when**: Used for conditionals. Supports comparison operators such as
  `==`, `!=`, `>`, `<`. When a list of conditions is given, they are combined
  with a logical AND (all must be true).
- **loop**: Iterates over a list. Inside the task, `{{ item }}` refers to the
  current element. When looping over a list of dictionaries, access fields with
  `{{ item.<key> }}` (e.g. `{{ item.name }}`).
- **register**: Stores the result (stdout, rc, changed, stat, ...) of a task in
  a variable so that following tasks can make decisions based on it
  (e.g. `when: not dir_check.stat.exists`).
