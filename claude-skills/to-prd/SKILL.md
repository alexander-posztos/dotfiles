---
name: to-prd
description: Turn the current conversation context into a PRD and write it to a single-page HTML file for later review. Use when user wants to create a PRD from the current context.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Do NOT interview the user — just synthesize what you already know.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's vocabulary throughout the PRD.

2. Write the PRD and save it as a single-page HTML file at `prds/<slugified-title>.html` in the current project.

   Read `assets/prd-template.html` from this skill's directory and use it as the shell. It carries the full house style as a self-contained `<style>` block (capped line length for readability, serif body with sans-serif chrome, warm paper palette, dark mode, a sticky table-of-contents with scroll-spy, and a print stylesheet) plus a section + TOC scaffold that already matches the template below. To fill it:
   - Replace `__TITLE__`, `__STATUS__` (default `Draft`), and `__DATE__` (today's date) in the header.
   - Fill each `<section>` body where the comments mark it, mirroring the existing markup: `<p>` for prose, `<ol class="stories">` for the user-story list, `<code>` for module and interface names. Delete an optional section (and its sidebar `<li>`) if it has no content. Remove the fill-instructions comment from the output.

   Keep it a single self-contained file: do not link any external CSS, fonts, or CDN. A self-contained file renders identically offline and never breaks on a dead CDN link, which matters for a document meant to be reopened and reviewed later.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
