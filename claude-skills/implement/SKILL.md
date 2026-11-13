---
name: implement
description: Implement one or more GitHub issues end to end, each in its own worktree and branch, and prove the change instead of describing it. Use when the user runs /implement, says "implement #N", "do issue N", or hands over a list of issue numbers to work through unattended. Covers tests, a browser click-through with screenshots, a cross-model code review, a second-model click-through, one commit and one PR per branch, and an HTML report in chat with the link and the steps to test. Never merges.
argument-hint: "<issue> [<issue>...]"
---

# Implement a GitHub issue, with proof

One issue = one branch `gh-N` = one worktree = one commit = one PR. The user reviews and merges the PR by hand. "Done" means the tests, the screenshots, the review verdict and the second-model report all say so, not that the code reads right. The deliverable is a running dev server plus a report telling the user where to click.

## Per-repo config

Fill this in once per project. Everything below refers to these names.

```
PYTHON        interpreter to use (absolute path if the sandbox cannot activate envs)
SERVE         command that starts the dev server on port $PORT from the worktree
FIXTURES      command that creates the test users / seed data in the worktree
TEST          fast test suite command (e.g. pytest tests -n auto -q)
LINT          linter on changed files (e.g. ruff check)
LOGIN         a test account and password the click-through can use
PORT_BASE     8000; the issue's server runs on PORT_BASE + N so runs never collide
GENERATED     files that get rebuilt locally and must never be committed (compiled CSS etc.)
```

## Layout

```
scratchpad/implement/gh-N/
  wt/            worktree on branch gh-N (own .env, db copy, node_modules). Stays until the user says "merged" or "drop".
  evidence/      screenshots from the click-through, review reports
  report.html    the final report, rendered in chat
```

The dev server for the issue keeps running after the run, so the report's link works. The main checkout on PORT_BASE is never touched.

Helper (run from the main checkout, edit the config block at its top first):

```bash
.claude/skills/implement/implement.sh new <N>     # worktree, env, db, deps, fixtures
.claude/skills/implement/implement.sh serve <N>   # prints the dev server command for the worktree
.claude/skills/implement/implement.sh done <N>    # after "merged"/"drop": removes wt/, keeps branch and evidence
```

## Fan-out

One issue: run the per-issue flow below in this session. Several issues: one full session (thread) per issue, each told to run `/implement N`, started in the project checkout so the flow makes its own worktree. Each thread runs the whole flow itself, including the second-model click-through and the report. Subagents inside one session are not enough for this: they usually cannot spawn the second model or render a report. Issues that touch the same files run serially instead. Wait for all threads, then reply with the links and the PR URLs.

## Per-issue flow

### 1. Read the issue

```bash
gh issue view N --comments
```

Restate the title and the acceptance criteria in two lines. The user's comments on the issue count as part of the spec. If the issue is ambiguous in a way that changes the implementation, stop and ask before touching code. Otherwise proceed under a stated assumption.

### 2. Worktree

`implement.sh new N`, then `cd wt/`. Build GENERATED files once locally so the app renders, never commit them, restore them before the commit. Start the dev server in the background with the command from `implement.sh serve N`.

### 3. Implement

Follow the shape in the issue label.

- `bug`: red test first, the failure must be the reported one, then the smallest fix, then green. (The `close-the-loop` skill, if you have it.)
- `enhancement` / `refactor` / `chore`: write the tests alongside the change, in the file that owns the feature.

While working, run the single test file. The fast suite (TEST) runs once at the end of this step, then LINT on the changed files. Project rules (AGENTS.md / CLAUDE.md) apply as usual: analytics events, i18n, admin registration, whatever the repo demands.

### 4. Click through it yourself

A browser automation CLI (I use `playwright-cli` with Firefox) against `http://localhost:PORT`, its own session (`-s=gh-N`). Drive the exact path from the issue the way a user would, plus the nearest thing that must still work. Screenshot every state that matters into `evidence/` with names that say what they show (`01-open-tab-after-search.png`). An accessibility snapshot after each step is the ground truth, the screenshot is for the human.

Write `evidence/clickthrough.md`: the steps, what was seen, the screenshot names. If the click-through finds a problem, go back to step 3. Close the session when done.

### 5. Cross-model code review

One round of a review by a different model on `master..HEAD` with the worktree as the repo (I use the `cross-review` skill, `master..HEAD in <worktree>`, which delegates to a Codex child on gpt-6-astra and ends with a CLEAN / PASS WITH NOTES / NEEDS FIXES verdict). Save the report as `evidence/review-round-1.md`. Fix what is real, rerun the touched tests, and do not run it again. Everything left over, and everything judged not real, goes into the report's Open box with one line of why. Review findings are evidence, not orders. Verify against the code before changing anything.

One round on purpose. A loop that chases every finding to CLEAN found a new htmx race on each of six rounds on one issue; the time is better spent in the human's review.

### 6. Second-model click-through

Launch a child agent on a different model (I use Codex via the T3 Code `delegate_task` tool, with the built-in preview browser) with the brief in `codex-brief.md` next to this file, placeholders filled in. It checks behaviour through the UI only, never code, at desktop and phone width, and reports as `[blocker|should-fix|nit] <area>: <finding>` ending in `TOTALS:`.

Save the report as `evidence/codex-report.md`. Verify every blocker and should-fix against the live page or the code before changing anything (the external reviewer can be wrong). Fix what survives, rerun the touched tests. No second round; leftovers go into the Open box.

### 7. Commit, push, PR

One commit per branch, amended if there already is one on `gh-N`. Message is one lowercase line ending in `(gh #N)`. Confirm no GENERATED file is in the diff.

```bash
git add -A && git commit -q -m "<line> (gh #N)"
git log --oneline master..HEAD    # exactly one line
git push -u origin gh-N           # force-with-lease after an amend
gh pr create --base master --head gh-N --title "<line> (gh #N)" --body-file -
```

PR body: `Closes #N`, then a **Bug.** paragraph (what the user saw, where, how it was reproduced), then a **Fix.** paragraph (what changed and why that shape, named files only where the reviewer has to go), then the numbered test steps with expected results, one line each for tests, review and second-model totals, and the Open items. Pushing the branch is the one push this skill makes; never merge, never touch master.

### 8. Report

Copy `report-template.html` (next to this file) to `scratchpad/implement/gh-N/report.html` and fill it in:

- Title line, a **Bug.** sentence or two and a **Fix.** sentence or two, plain words.
- Test it: the URL on the issue's port landing on the page where the path starts, the login, and three to five numbered steps the way a user would do them, each with the expected result.
- Meta: branch and file count, tests, review verdict, second-model totals.
- Screenshots: two to four from `evidence/` with absolute paths, the ones that show the fix, captions that say what to look at.
- Open: what is left, or "nothing".
- Review: the PR URL and its Files changed link.

Render it inline in the chat if the client can (T3 Code: `html_preview`, then `html_render`); otherwise link the file. The chat reply under it adds only what the report does not say. The user merges the PR, then says "merged" (or "drop"), and only then `implement.sh done N` and stop the server.

## Hard rules

- Push only `gh-N`. No merge, no `gh issue close`, nothing on master. The PR closes the issue when the user merges it.
- No production access, no outgoing emails, no payment-provider writes. If an issue needs any of those to verify, say so in Open and verify what can be verified locally.
- A failing step is reported as failing, with output. A skipped step is reported as skipped. Nothing is reported as done off a code-read.
