# Claude Code skills

A few custom [Claude Code](https://claude.com/claude-code) skills I use day to day.

| Skill | What it does |
|-------|--------------|
| `grill-me` | Interviews you relentlessly about a plan or design, walking each branch of the decision tree until you reach shared understanding. Good before you start building. |
| `handoff` | Generates a copy-pasteable prompt to continue the work in a fresh Claude Code session, so you can start clean instead of dragging a bloated context along. |
| `to-prd` | Turns the current conversation into a self-contained single-page HTML PRD you can reopen and review later. |
| `close-the-loop` | A bug-fix loop for web apps: reproduce the bug as a failing test (red), make the smallest fix, confirm it in a real browser with Playwright, watch the test go green, then graduate that test into the suite as a permanent regression guard. |

## Install

Claude Code loads skills from `~/.claude/skills/` (available everywhere) or
`.claude/skills/` inside a project. Drop a skill folder into either one:

```bash
# user-level: available in every project
cp -R claude-skills/grill-me ~/.claude/skills/

# or symlink it so a git pull keeps it up to date
ln -s "$PWD/claude-skills/grill-me" ~/.claude/skills/grill-me
```

Then invoke it in a session: `/grill-me`, `/handoff`, `/to-prd`, `/close-the-loop`.
