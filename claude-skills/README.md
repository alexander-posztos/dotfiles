# Claude Code skills

A few custom [Claude Code](https://claude.com/claude-code) skills I use day to day.

| Skill | What it does |
|-------|--------------|
| `grill-me` | Interviews you relentlessly about a plan or design, walking each branch of the decision tree until you reach shared understanding. Good before you start building. |
| `handoff` | Generates a copy-pasteable prompt to continue the work in a fresh Claude Code session, so you can start clean instead of dragging a bloated context along. |
| `to-html` | Re-renders what the conversation already produced as one self-contained HTML page and opens it in the browser. The page is editable: you correct wording in place and leave comments per block, then hand the result back with one click. |
| `close-the-loop` | A bug-fix loop for web apps: reproduce the bug as a failing test (red), make the smallest fix, confirm it in a real browser with Playwright, watch the test go green, then graduate that test into the suite as a permanent regression guard. |
| `texten-at` | German copy without AI tells, in Austrian standard German. 27 patterns (English-shaped German, AI vocabulary, grammar and structure tells) plus a Germany-German to Austrian mapping. Audits or rewrites. See its own [README](texten-at/README.md). |
| `walkthrough` | Explains a file, PR, diff or topic one logical block at a time and waits for your "next" before continuing. You drive the pace, it never runs ahead. |
| `variants` | Builds N genuinely distinct design variants of a UI section inside the real app behind a floating switcher. You flip through them live, pick one, and it promotes the winner and deletes the scaffolding. |
| `strategy-debate` | Multi-turn strategy debate between Claude and GPT via the Codex CLI, with a synthesis of agreements, disputes and a joint recommendation at the end. |
| `simpler` | Re-explains the previous answer in ASD-STE100-inspired simplified language. For when an explanation didn't land. |
| `implement` | GitHub issue in, PR out, with proof: own worktree and dev server per issue, red/green tests, a browser click-through with screenshots, a cross-model review, a second model clicking through the UI, and an HTML report in chat that says where to click. A project skill with a config block. See its own [README](implement/README.md). |
| `cross-review` | Cross-model code review in T3 Code. Hands a commit, range or uncommitted changes to a Codex child via `delegate_task`, relays its report verbatim, and checks each blocker against the code. Ends with a CLEAN / PASS WITH NOTES / NEEDS FIXES verdict. |

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
`/texten-at`, `/walkthrough`, `/variants`, `/strategy-debate`, `/simpler`, `/implement 123`, `/cross-review main..HEAD` (or just ask in plain language).