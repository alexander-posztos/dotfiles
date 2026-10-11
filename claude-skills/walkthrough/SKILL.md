---
name: walkthrough
description: >-
  Paced, one-block-at-a-time walkthrough of any target or topic. Explains one
  logical chunk in a few sentences, then stops and waits for the user's "next"
  before continuing; explanation-only, the user drives the pace. Run with
  /walkthrough [target].
argument-hint: "[file | PR | topic]"
---

# Walkthrough

Explain something to the user **one logical block at a time**: explain a single
chunk, stop, and wait for their go-signal before the next. The user drives the
cursor. Your job is to pace, not to dump.

The whole point of this mode is to prevent the failure the user pushes back on
most: **over-explaining in one turn, or running ahead without waiting.** When in
doubt, say less and stop sooner.

## Before you start

This mode fits when the user wants to *understand* something incrementally, at
their pace - not when they want it built or fixed. Two quick checks:

- No chunk-able target (nothing concrete to walk, or it's a single trivial
  point)? Don't force a loop - just answer directly.
- The user actually wants edits or action, not understanding? Say so and offer
  to switch to normal work rather than silently starting to edit.

## Target

`/walkthrough <target>` - the target can be a file, PR, diff, function, dense
doc/proposal, plan, a list of items, pasted text, or a topic. The subject is
**arbitrary**: this is not just for code. The same loop fits prose, plans, DB
rows, citations, interview Q&A drills, and copy edits.

If no target is given, walk the most recent relevant thing in the conversation
(the last diff, file, or plan). Ask which one only if it's genuinely ambiguous -
don't make the user re-state what's obviously on the table.

## The loop

1. **Pick the next block (lazily).** Identify the next single coherent unit just
   in time - do not pre-list the whole thing. Chunk by *meaning*: one idea
   (prose), one function / loop / config section (code), one item (list), one
   question (drill). "Line by line, or logical block" - you choose the natural
   unit.
2. **Explain exactly one block.** Hard cap ~5 sentences; default tighter (2-3)
   for simple blocks. Plain language, no jargon dumps. Lead with a light cursor:
   `[Block 3/~7] <short label>` (the `~` signals it's an estimate - revise it as
   you go).
3. **Stop and yield.** End every turn with the resume contract, e.g.
   *"Say next to continue, or ask anything about this block."* Never pre-empt the
   next block or bundle two ideas into one turn.
4. **Wait for the user's signal**, then act on it (see below).
5. **Repeat** until the blocks are exhausted, then close out (see End).

## Reading the user's signal

- **Advance** to the next block on: `next`, `next one`, `continue`, `go on`,
  `go`, `ok`, `got it`, `makes sense`, or a bare verdict (`leave as is`,
  `no change`, `fine`). The user often appends a quick verdict - treat it as
  "understood, move on."
- **Deepen the same block** (do not advance) on: any question, `wait`,
  `slow down`, `I don't get it`, `huh?`. Re-explain from a different angle - an
  analogy, a smaller sub-step, or a concrete example. Stay on the block until
  the user signals to advance. Never move past something they didn't follow.

### Mid-loop controls

The user may say these instead of `next`:

- `go deeper` / `more` - expand the current block (lift the length cap this turn).
- `shorter` / `too much` - re-explain the current block more tersely.
- `skip` / `skip ahead` - advance without finishing the current explanation.
- `back` - return to the previous block.
- `jump to X` - move the cursor to block/topic X.
- `outline` / `what's left` - give a quick list of what's remaining, then resume.
- `stop` / `done` - end the walkthrough.

## What goes in a block

- **Code:** optionally quote the exact lines, then plain-English of what it does,
  then *why it matters*. Surface the reasoning (why this approach, not the
  obvious alternative) when it's relevant - the user wants the "why," not just
  the "what."
- **Examples:** only when they genuinely aid understanding - not by default
  (examples bloat blocks and fight the tight-length goal). For an unfamiliar
  language, sketch the equivalent in a language the user knows (e.g. Python).
- **Audience:** assume the user is smart but new to *this specific* material.
  Build on what they already know; don't re-cover the obvious.

## Posture

- **Explanation-only by default.** During a walkthrough, do not edit files,
  commit, push, or run ahead. The user is in charge and drives the cursor.
- If you spot a bug or improvement, note it in **one line** and keep walking.
  Apply nothing until the user exits the mode and asks for it.
- The comprehension gate is the user's, not yours - never quiz them. They decide
  when they understand and say so.

## State

Keep the cursor **in-conversation only** - no state files. To resume in a later
session, re-derive the position from context when re-invoked (the user may say
"restart the walkthrough" or "let's continue the block-by-block").

## End

When the blocks are exhausted, say it's the last one, then offer a short recap -
*"Want a 2-line recap tying it together?"* Keep any recap to 1-3 sentences.

If the user signals advance but nothing is left, come straight here - never
invent a block to keep the loop running.
