---
name: cross-review
description: Cross-model code review of a commit, range, or uncommitted changes by a Codex reviewer. Use when the user wants a second opinion on code, or another skill needs a cross-model verdict.
argument-hint: "[<git-ref>|uncommitted] [in <path>] [\"focus\"]"
---

# Cross-review

Arguments, all optional, any order: a target (`uncommitted`, a ref, or a range; default `HEAD`), `in <path>` for the repo (default the current toplevel), and free text as focus.

## Grades

A finding is graded against the intent of the change.

- `blocker`: the intended case is wrong.
- `should`: a real bug that callers will hit, inside the intent.
- `nit`: everything else. Style, other code paths, rare cases, small performance costs, extra compatibility, missing tests and guards the intent does not need.

## Steps

1. Call `delegate_task` with `role: "review"`, `title: "review <target>"`, `target: { providerInstanceId: "codex", model: "gpt-6-astra", options: { reasoningEffort: "high", serviceTier: "priority" } }`, and this brief:

   ```
   Review <TARGET> in <REPO_PATH>. For uncommitted changes, include untracked files.
   Intent: <commit messages, or for uncommitted changes one line on what the
   change is meant to do>
   Out of scope: <what the change deliberately leaves alone>
   Focus: <FOCUS, line omitted if none>

   This is a read-only review. The report is your only output.
   Read every hunk and the code around it. Look for bugs, broken callers and
   mismatch with the intent. Hold the change to its smallest size and flag
   code, tests or guards the intent does not need.
   Grade each finding:
   <the three grade lines from Grades, verbatim>
   One line per finding, with ids that stay stable across rounds:
   S1 [blocker|should|nit] <file>:<line> <the concrete failure>. Fix: <suggestion>
   If nothing is wrong, name what you inspected.
   End with exactly one line. N counts blockers and shoulds, and nits alone are APPROVE:
   VERDICT: APPROVE | VERDICT: CHANGES (N)
   ```

2. When the result arrives, relay the report verbatim. Without a `VERDICT:` line, append `VERDICT: UNKNOWN (no verdict emitted)`.
3. Regrade every finding against the code and the Grades above, whatever grade it arrived with. Under the report, add one line per id with its outcome and the reason:
   - `fix`: a blocker or should you confirmed in the code.
   - `disagree`: the claim is wrong, with the evidence (file:line, test, output).
   - `declined`: a nit, or out of scope.
4. Run `git status --short` in the repo and report any change the reviewer made.

## Fixes and rounds

When fixes follow the review, they cover the `fix` ids, each with the smallest change that corrects the case that happened (delete or narrow before adding a helper, option or guard). `declined` ids stay a list for the user to pick from.

The caller sets the number of rounds, three at most. A further round runs when a fix changed behaviour. Its brief adds the outcome lines from step 3 and asks the reviewer to mark each old id `resolved` or `still open: <reason>` and to read only the code changed since the last round.
