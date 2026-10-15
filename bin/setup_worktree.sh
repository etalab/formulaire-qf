#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
Usage: $(basename "$0") [-p port] <name> [branch]

Creates the git worktree worktrees/<name> with its own Postgres databases
(quotient_familial_{development,test}_<suffix>, suffix derived from the name)
and its own server port, written to config/settings/{development,test}.local.yml
and .env.

<name> is either a ticket (FQF-123) or an ad hoc slug for work that has no
ticket (hubee-retry).

The port defaults to 1NNNN, NNNN being the ticket number zero-padded to four
digits (FQF-123 -> 10123) or, for an ad hoc name, four digits derived from a
hash of the name. -p overrides it.

Branch resolution, in order:
  1. [branch] when given
  2. the one existing local or remote branch named <name>, or with a
     segment starting with <name>- (feature/fqf-123-hubee-retry)
  3. a new feature/<name> branch created from origin/main

The branch must already contain per-worktree databases (merge origin/main
into an older branch first). remove_worktree.sh deletes the branch only if
this script created it.
USAGE
  exit 1
}

PORT=""
while getopts "p:h" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

[ $# -ge 1 ] && [ $# -le 2 ] || usage

NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
BRANCH="${2:-}"

if [[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Error: '$1' must be a ticket (FQF-123) or a slug (hubee-retry)" >&2
  exit 1
fi

if [[ "$NAME" =~ ^[a-z]+-([0-9]+)$ ]]; then
  PORT_SEED="${BASH_REMATCH[1]}"
else
  PORT_SEED="$(printf '%s' "$NAME" | cksum | cut -d' ' -f1)"
fi

if [ -n "$PORT" ] && { [[ ! "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; }; then
  echo "Error: invalid port '$PORT' (expected 1024-65535)" >&2
  exit 1
fi

PORT="${PORT:-$((10000 + PORT_SEED % 10000))}"

PRIMARY_ROOT="$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"
WORKTREES_DIR="$PRIMARY_ROOT/worktrees"
WORKTREE_PATH="$WORKTREES_DIR/$NAME"
SLUG="${NAME//-/_}"

if [ -e "$WORKTREE_PATH" ]; then
  echo "Error: $WORKTREE_PATH already exists" >&2
  exit 1
fi

if lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Error: port $PORT is already in use, pick another one with -p" >&2
  exit 1
fi

PORT_OWNER="$(grep -lx "PORT=$PORT" "$WORKTREES_DIR"/*/.env 2>/dev/null | head -n 1 || true)"
if [ -n "$PORT_OWNER" ]; then
  echo "Error: port $PORT is already assigned to $(dirname "$PORT_OWNER"), pick another one with -p" >&2
  exit 1
fi

git -C "$PRIMARY_ROOT" fetch --quiet origin || echo "Warning: could not fetch origin, using local refs only" >&2

find_branches_by_name() {
  git -C "$PRIMARY_ROOT" for-each-ref --format='%(refname)' refs/heads refs/remotes/origin \
    | sed -e 's#^refs/heads/##' -e 's#^refs/remotes/origin/##' \
    | grep -vx 'HEAD' \
    | grep -iE -- "(^|/)${NAME}(-|$)" \
    | sort -u
}

if [ -z "$BRANCH" ]; then
  MATCHES="$(find_branches_by_name || true)"
  if [ "$(printf '%s' "$MATCHES" | grep -c .)" -gt 1 ]; then
    echo "Error: several branches match $NAME, pass the one to use as [branch]:" >&2
    echo "$MATCHES" | sed 's/^/  /' >&2
    exit 1
  fi
  BRANCH="$MATCHES"
fi

CREATED_BRANCH=""
if [ -n "$BRANCH" ] && git -C "$PRIMARY_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Using local branch $BRANCH"
  git -C "$PRIMARY_ROOT" worktree add "$WORKTREE_PATH" "$BRANCH"
elif [ -n "$BRANCH" ] && git -C "$PRIMARY_ROOT" show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
  echo "Tracking remote branch origin/$BRANCH"
  git -C "$PRIMARY_ROOT" worktree add --track -b "$BRANCH" "$WORKTREE_PATH" "origin/$BRANCH"
  CREATED_BRANCH="$BRANCH"
else
  BRANCH="${BRANCH:-feature/$NAME}"
  echo "No branch found for $NAME, creating $BRANCH from origin/main"
  git -C "$PRIMARY_ROOT" worktree add --no-track -b "$BRANCH" "$WORKTREE_PATH" origin/main
  CREATED_BRANCH="$BRANCH"
fi

if ! grep -q 'database_suffix' "$WORKTREE_PATH/config/database.yml"; then
  git -C "$PRIMARY_ROOT" worktree remove --force "$WORKTREE_PATH"
  [ -n "$CREATED_BRANCH" ] && git -C "$PRIMARY_ROOT" branch -D "$CREATED_BRANCH" >/dev/null
  echo "Error: $BRANCH predates per-worktree databases, its config/database.yml would use the main databases." >&2
  echo "Merge or rebase origin/main into $BRANCH first, then run this script again." >&2
  exit 1
fi

if [ -n "$CREATED_BRANCH" ]; then
  git -C "$PRIMARY_ROOT" config "branch.$CREATED_BRANCH.createdByWorktreeScript" true
fi

for key_file in config/master.key config/credentials/development.key config/credentials/test.key; do
  [ -e "$PRIMARY_ROOT/$key_file" ] && cp "$PRIMARY_ROOT/$key_file" "$WORKTREE_PATH/$key_file"
done

cat > "$WORKTREE_PATH/config/settings/development.local.yml" <<YML
database_suffix: _${SLUG}
port: ${PORT}
YML
cat > "$WORKTREE_PATH/config/settings/test.local.yml" <<YML
database_suffix: _${SLUG}
YML
echo "PORT=${PORT}" > "$WORKTREE_PATH/.env"
echo "Wrote config/settings/development.local.yml, config/settings/test.local.yml and .env"

echo
echo "==> Bootstrapping"
(
  cd "$WORKTREE_PATH" &&
    (bundle check >/dev/null || bundle install) &&
    SKIP_TEST_DATABASE=true bin/rails db:prepare &&
    RAILS_ENV=test bin/rails db:prepare
)

echo
echo "Worktree ready: $WORKTREE_PATH"
echo "Branch:         $BRANCH"
echo "Databases:      quotient_familial_{development,test}_${SLUG}"
echo "App:            http://localhost:${PORT}"
