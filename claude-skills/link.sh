#!/bin/sh
# Symlink every skill in this folder into ~/.claude/skills.
cd "$(dirname "$0")"
mkdir -p ~/.claude/skills
for d in */; do
  [ -f "$d/SKILL.md" ] || continue
  ln -sfn "$PWD/$d" ~/.claude/skills/"$(basename "$d")"
done
