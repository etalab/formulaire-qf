## Worktrees

- `bin/setup_worktree.sh [-p port] <name> [branch]`: create `worktrees/<name>` with its own databases and port.
- `bin/remove_worktree.sh <name>`: stop its server, remove the worktree and its local branch, drop its databases.
