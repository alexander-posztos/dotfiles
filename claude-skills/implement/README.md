# implement

Takes a GitHub issue and hands back a PR plus proof: a worktree with a running dev server, screenshots of the click-through, a cross-model code review, a second model clicking through the UI, and an HTML report in the chat that says where to click.

Files:

- `SKILL.md` the skill. Has a per-repo config block at the top.
- `implement.sh` worktree helper. Edit the config block at its top (server command, fixtures, deps).
- `codex-brief.md` the brief for the second-model click-through, with placeholders.
- `report-template.html` the report rendered in chat at the end.

This one is a project skill: drop the folder into `.claude/skills/implement/` of a project, fill in the two config blocks, then `/implement 123`.

The two review steps refer to things from my setup: the `cross-review` skill (a Codex child reviews the diff) and a Codex child with a built-in browser, both through T3 Code's `delegate_task`. Swap in whatever second-model path you have, or drop the step. The flow still works with just the tests and your own click-through.
