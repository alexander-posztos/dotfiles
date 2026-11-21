#!/bin/bash
# Deletes agent scratch output nobody has touched for $DAYS days.
# Run once a day by local.scratch-cleanup.plist (copied to ~/Library/LaunchAgents).
# Without --delete it only prints what it would remove (dry run).
#
# A "unit" is deleted whole once no file inside it changed for $DAYS days:
#   ~/projects/*/scratchpad/<entry>  one file or folder
#   ~/.t3/scratch/<entry>            one T3 thread's scratch dir
# A .keep file in a unit protects it. A folder with a pinned child (like
# ui-climb/, whose anchors/ holds .keep) is split, so its runs expire one by one.

DAYS=7
DELETE=0
[ "$1" = "--delete" ] && DELETE=1
shopt -s nullglob dotglob

# True if nothing under $1 (including $1 itself) changed in the last $DAYS days.
stale() {
  [ -z "$(find "$1" -mtime -"$DAYS" -print -quit 2>/dev/null)" ]
}

expire() {
  local unit=$1
  [ -e "$unit/.keep" ] && return
  stale "$unit" || return
  if [ $DELETE = 1 ]; then
    rm -rf "$unit" && echo "deleted $unit"
  else
    echo "would delete $(du -sh "$unit" 2>/dev/null | cut -f1) $unit"
  fi
}

echo "----- $(date) $([ $DELETE = 1 ] && echo delete || echo dry-run)"

for root in "$HOME"/projects/*/scratchpad; do
  for entry in "$root"/*; do
    pinned=("$entry"/*/.keep)
    if [ ! -L "$entry" ] && [ ${#pinned[@]} -gt 0 ]; then
      for unit in "$entry"/*; do expire "$unit"; done
    else
      expire "$entry"
    fi
  done
done

for unit in "$HOME"/.t3/scratch/*; do expire "$unit"; done
