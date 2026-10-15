#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
Usage: $(basename "$0") <name>

Stops the server of worktrees/<name>, removes the worktree, deletes its local
branch (the remote branch is kept) and drops the Postgres databases created
for it. <name> is the ticket or ad hoc slug given to setup_worktree.sh.
USAGE
  exit 1
}

[ $# -eq 1 ] || usage

NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"

if [[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: '$1' must be a ticket (FQF-123) or a slug (hubee-retry)" >&2
  exit 1
fi

PRIMARY_ROOT="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
WORKTREE_PATH="$PRIMARY_ROOT/worktrees/$NAME"
SLUG="${NAME//-/_}"

if [ "$(pwd -P)" = "$WORKTREE_PATH" ] || [[ "$(pwd -P)" == "$WORKTREE_PATH/"* ]]; then
  echo "Error: run this script from outside $WORKTREE_PATH" >&2
  exit 1
fi

stop_server() {
  local env_file="$1"
  local port pids

  [ -f "$env_file" ] || return 0
  port="$(sed -n 's/^PORT=//p' "$env_file")"
  [ -n "$port" ] || return 0
  pids="$(lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null || true)"
  [ -n "$pids" ] || return 0
  echo "$pids" | xargs kill
  echo "Stopped server on port $port"
}

if [ -d "$WORKTREE_PATH" ]; then
  stop_server "$WORKTREE_PATH/.env"
  (cd "$WORKTREE_PATH" && bin/spring stop) || true
  BRANCH="$(git -C "$WORKTREE_PATH" rev-parse --abbrev-ref HEAD)"
  git -C "$PRIMARY_ROOT" worktree remove "$WORKTREE_PATH"
  echo "Removed worktree $WORKTREE_PATH"
  if [ "$BRANCH" != "HEAD" ] && git -C "$PRIMARY_ROOT" branch -d "$BRANCH"; then
    echo "Deleted local branch $BRANCH"
  else
    echo "Warning: local branch $BRANCH kept (unmerged or detached); delete it with git branch -D $BRANCH" >&2
  fi
else
  echo "Warning: $WORKTREE_PATH not found, only dropping databases" >&2
fi

for env in development test; do
  db="quotient_familial_${env}_${SLUG}"
  if psql -X -Atc "SELECT 1 FROM pg_database WHERE datname = '$db'" postgres | grep -q 1; then
    dropdb "$db"
    echo "Dropped database $db"
  fi
done
