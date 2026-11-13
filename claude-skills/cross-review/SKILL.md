---
name: cross-review
description: Cross-model code review of a commit, range, or uncommitted changes by a Codex reviewer. Use when the user wants a second opinion on code, or another skill needs a cross-model verdict.
argument-hint: "[<git-ref>|uncommitted] [in <path>] [\"focus\"]"
---

# Cross-review

Arguments, all optional, any order: a target (`uncommitted`, a ref, or a range; default `HEAD`), `in <path>` for the repo (default the current toplevel), and free text as focus.

1. Call `delegate_task` with `role: "review"`, `title: "review <target>"`, `target: { providerInstanceId: "codex", model: "gpt-6-astra", options: { reasoningEffort: "high" } }`, and this brief:

   ```
   Review <TARGET> in <REPO_PATH>. For uncommitted changes, include untracked files.
   Judge the change against its intent: <commit messages, or for uncommitted
   changes one line on what the change is meant to do>.
   Focus: <FOCUS, line omitted if none>

   This is a read-only review. The report is your only output.
   Read every hunk. For each finding give severity, file:line, and the
   concrete failure. If nothing is wrong, name what you inspected.
   End with exactly one line:
   VERDICT: CLEAN | VERDICT: PASS WITH NOTES (N) | VERDICT: NEEDS FIXES (N)
   ```

2. When the result arrives, relay the report verbatim. Without a `VERDICT:` line, append `VERDICT: UNKNOWN (no verdict emitted)`.
3. For each NEEDS FIXES blocker, check the code and add one line marking it `confirmed` or `not confirmed`, with the reason.
4. Run `git status --short` in the repo and report any change the reviewer made.

The caller sets the number of rounds, three at most.
