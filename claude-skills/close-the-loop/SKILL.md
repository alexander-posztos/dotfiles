---
name: close-the-loop
description: >-
  A bug-fix loop for web apps. Reproduce the bug with a failing test (red),
  make the smallest fix, confirm it in a real browser with Playwright, watch the test go
  green, then graduate that test into the suite as a permanent regression guard. Use this
  whenever the user is fixing a bug, debugging, or reports that something is "broken",
  "not working", "throwing an error", "returns the wrong thing", or "used to work" in a
  web app - even if they never mention tests. The whole point is to prove a fix works in
  more than one way instead of claiming "done" off a code-read.
---

# Close the loop

## Before you start: does this apply?

This skill assumes three things. Check them first and say so plainly if any are missing,
rather than charging ahead with a workflow that doesn't fit the situation:

1. You're fixing a bug - something that used to work, or should work, but doesn't.
   Not greenfield feature work: a new feature has no existing "red" to reproduce, so the
   loop below doesn't map onto it cleanly.
2. The project has a working test suite you can run, and it's currently green. If
   there's no suite, or it's already failing, stop and tell the user - you can't trust a
   green you were never able to first see as red against a clean baseline.
3. It's a web app with Playwright available for the browser-confirm step (e.g. via the
   `playwright-cli` skill or the project's own E2E harness). No browser path to drive? Tell
   the user, and substitute the closest real exercise you have - hit the endpoint, run the
   CLI, call the function with real input - so step 3 still produces a second witness.

If a precondition doesn't hold, name it and ask how the user wants to proceed. Don't
silently downgrade to "I read the code and it looks fixed."

## The loop

### 1. Reproduce - make it red

Write a test that fails *because of the bug* - one that asserts on observable behavior
through the public interface, not internals (a regression test coupled to implementation
guards nothing and breaks on the next refactor). Then **run it and read the failure.**

Confirm the failure is the real one: the symptom the user actually reported, not an import
error, a typo, a missing fixture, or a different failure that happens to be nearby - wrong
repro, wrong fix. And if the test is green
*before* you've changed any code, it doesn't capture the bug yet - tighten the test, don't
move on. When you're done here you have a precise, repeatable definition of "fixed."

### 2. Fix - minimal and at the root

Write the smallest change that removes the bug at its source. No refactors, no "while I'm
here" cleanups, no bonus features.

**Fix the code, not the test.** If it still fails the code is wrong - don't weaken the
assertion or loosen it toward `assert True` to force green.

### 3. Confirm in the browser - the second witness

Drive the actual path a user would take with Playwright and **watch the bug be gone** -
navigate, click, submit, read the page, the same steps that surfaced it in the first place.

### 4. Green - confirm the test passes

Run the test again and read the pass. Red in step 1, green now, same test untouched.

### 5. Graduate it into the suite

Move the reproduction test into the permanent suite so this bug can never quietly come
back. 

## Closing summary

**Evidence over claims: paste the real run output - never report "fixed" from a code-read.**

When the loop closes, hand the user the evidence, briefly:

- **Bug** - one line: what was broken.
- **Root cause** - one line: why.
- **Red** - the failing-test output (before).
- **Fix** - the diff, minimal.
- **Browser** - what you drove, and what you saw.
- **Green** - the passing-test output (after), plus the suite still green.
