# Claude Code skills

A few custom [Claude Code](https://claude.com/claude-code) skills I use day to day.

| Skill | What it does |
|-------|--------------|
| `grill-me` | Interviews you relentlessly about a plan or design, walking each branch of the decision tree until you reach shared understanding. Good before you start building. |
| `handoff` | Generates a copy-pasteable prompt to continue the work in a fresh Claude Code session, so you can start clean instead of dragging a bloated context along. |
| `to-html` | Re-renders what the conversation already produced as one self-contained HTML page and opens it in the browser. The page is editable: you correct wording in place and leave comments per block, then hand the result back with one click. |
| `close-the-loop` | A bug-fix loop for web apps: reproduce the bug as a failing test (red), make the smallest fix, confirm it in a real browser with Playwright, watch the test go green, then graduate that test into the suite as a permanent regression guard. |
| `excalidraw` | Turns a description into a real, editable Excalidraw diagram. You write a compact spec, a zero-dependency Python builder expands it into valid `.excalidraw` JSON (correct bindings, fonts, auto-layout), and it opens for you. See its own [README](excalidraw/README.md). |

## Install

Claude Code loads skills from `~/.claude/skills/` (available everywhere) or
`.claude/skills/` inside a project. Drop a skill folder into either one:

```bash
# user-level: available in every project
cp -R claude-skills/grill-me ~/.claude/skills/

# or symlink it so a git pull keeps it up to date
ln -s "$PWD/claude-skills/grill-me" ~/.claude/skills/grill-me
```

Then invoke it in a session: `/grill-me`, `/handoff`, `/to-html`, `/close-the-loop`,
`/excalidraw` (or just ask in plain language, e.g. "draw this as a graph in excalidraw").
