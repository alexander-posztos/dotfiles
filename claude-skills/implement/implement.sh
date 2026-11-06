#!/usr/bin/env bash
set -euo pipefail

# Per-issue worktree for the implement skill. Run from the main checkout.
#   implement.sh new <N>      worktree + branch gh-<N> under scratchpad/implement/gh-<N>/wt
#   implement.sh serve <N>    print the dev server command for that worktree (port PORT_BASE+N)
#   implement.sh done <N>     remove the worktree, keep branch and evidence
#   implement.sh list

# ---- per-repo config ------------------------------------------------------
PORT_BASE=8000
PY=python                                        # absolute path if your sandbox cannot activate envs
COPY_FILES=(.env db.sqlite3)                     # local files the worktree needs, copied if present
DEPS='(cd theme/static_src && npm install --silent)'   # or 'npm ci', or '' if none
FIXTURES='$PY manage.py create_test_user'        # test users / seed data; '' if none
SERVE='$PY manage.py runserver $PORT'            # must use $PORT
# ---------------------------------------------------------------------------

CMD="${1:?usage: implement.sh new|serve|done|list <issue>}"
ROOT="$(git rev-parse --show-toplevel)"

case "$CMD" in
new)
  N="${2:?issue number required}"
  DIR="$ROOT/scratchpad/implement/gh-$N"
  WT="$DIR/wt"
  [[ -e "$WT" ]] && { echo "$WT already exists"; exit 1; }
  mkdir -p "$DIR/evidence"
  if git show-ref --verify --quiet "refs/heads/gh-$N"; then
    git worktree add "$WT" "gh-$N"
  else
    git worktree add "$WT" -b "gh-$N" master
  fi
  for f in "${COPY_FILES[@]}"; do [[ -f "$ROOT/$f" ]] && cp "$ROOT/$f" "$WT/$f"; done
  mkdir -p "$WT/logs"
  [[ -n "$DEPS" ]] && (cd "$WT" && eval "$DEPS")
  [[ -n "$FIXTURES" ]] && (cd "$WT" && eval "$FIXTURES" >/dev/null)
  echo "worktree: $WT"
  echo "evidence: $DIR/evidence"
  echo "port:     $((PORT_BASE + N))"
  ;;

serve)
  N="${2:?issue number required}"
  WT="$ROOT/scratchpad/implement/gh-$N/wt"
  PORT=$((PORT_BASE + N))
  echo "cd $WT && $(eval echo "$SERVE")"
  ;;

done)
  N="${2:?issue number required}"
  WT="$ROOT/scratchpad/implement/gh-$N/wt"
  [[ -d "$WT" ]] || { echo "no worktree at $WT"; exit 1; }
  if [[ -n "$(git -C "$WT" status --porcelain --untracked-files=no)" ]]; then
    echo "REFUSING: uncommitted changes in $WT"
    exit 1
  fi
  git worktree remove --force "$WT"
  echo "removed $WT (branch gh-$N and evidence kept)"
  ;;

list)
  git worktree list
  ;;

*)
  echo "unknown command: $CMD"
  exit 1
  ;;
esac
