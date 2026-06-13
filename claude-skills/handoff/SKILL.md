---
name: handoff
description: Generate a copy-pasteable prompt to start a fresh Claude Code session that continues this work. Use when the user types /handoff, says "write a prompt for the next session", "create a handoff prompt", "starting prompt for a new claude code session", "wrap this up for a new chat", or wants to end the current session cleanly without compaction.
---

Write a self-contained prompt the user will copy-paste into a fresh Claude Code session. The new session has no memory of this conversation. Write so it lands cold.

## Repo context (preprocessed)

```!
echo "Branch: $(git branch --show-current 2>/dev/null || echo '(not a git repo)')"
echo
echo "Recent commits:"
git log --oneline -5 2>/dev/null || echo "(no commits or not a git repo)"
echo
echo "Working tree:"
git status -s 2>/dev/null || echo "(clean)"
```

## What to do

1. **Check scope.** If "what's next" is ambiguous from the conversation (multiple threads, exploration with no clear target), ask ONE targeted question first ("next session is finishing X, or starting Y?") and wait. Skip if scope is already clear.

2. **Generate the prompt.** Target 250-400 words. Write in the user's voice as if they wrote it themselves ("we're doing X", "I run the dev server - don't start it"), not as a neutral AI handover.

3. **Print only the prompt.** No preamble, no trailing summary, no "Here's your handoff:". Wrap it in a fenced code block so it copies cleanly.

## Required sections (in this order)

1. **Framing** - 1-2 sentences: what we're doing in this project and why. Anchors the next session.
2. **What's done / what's next** - current branch, what's committed, and the specific scope for the next session.
3. **Files to read first, in order** - explicit list of docs/specs/code paths to read before doing anything. Do NOT include CLAUDE.md, Claude Code loads it automatically.
4. **Working agreement** - the testing/iteration protocol used this session (e.g. "after each change: tests + tell me what to verify + wait for go-ahead + then commit"). Infer from conversation; if none established, write a brief default.

## Optional sections (include only when the conversation produced them)

- **Decisions made + why** - when this session made design calls the next session shouldn't re-litigate.
- **What didn't work** - when approaches were tried and abandoned. Saves the next session from retrying.
- **Open questions** - when something specific needs the user's input next.

## Style rules

- User's voice. No AI fluff ("I'll help...", "Let me know..."). No emdashes, use regular hyphens.
- Concise. Trim adjectives. Cut anything trivially derivable from the repo.
- If you overrun 400 words, drop optional sections first, then trim the working agreement.
- No emoji unless the user already uses them.
