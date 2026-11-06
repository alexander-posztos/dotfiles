You are checking a change to {APP_ONE_LINER}. Nothing in this conversation is visible to you, so everything you need is here.

The change implements GitHub issue #{N}: {TITLE}

{ISSUE_BODY_AND_ACCEPTANCE_CRITERIA}

What was changed, in one paragraph: {CHANGE_SUMMARY}

The app runs at http://localhost:{PORT}. The dev server is already up. Log in with {LOGIN}. {LANGUAGE_NOTE}

Use the preview browser tools: `preview_open` on that URL with `reuseExistingTab=false`, then `preview_snapshot` to see the page and `preview_act` to click, type and navigate. Snapshot after every action and read what actually happened. Do not read or edit source files, do not run commands, do not commit. This is a behaviour check through the UI only.

Check:
1. The path from the issue, step by step, exactly as a user would do it: {HAPPY_PATH}
2. The nearest things that must still work: {ADJACENT_PATHS}
3. Anything on the touched pages that looks broken, inconsistent with the rest of the app, or wrong in the wording ({WORDING_RULES}).

Check at 1280px wide and once more at 390px wide (`preview_resize`) for the touched pages.

Report format, follow exactly:
- One finding per line: [blocker|should-fix|nit] <area>: <finding>
  where <area> is one of: behaviour | visual | wording | mobile
- Say which step produced the finding and what you saw instead of what was expected.
- If a dimension has no findings, write one line: [none] <area>: nothing found
- After the findings, one line: VIEWPORTS CHECKED: <list>
- Last line: TOTALS: <X> blockers / <Y> should-fix / <Z> nits

No praise, no summary prose, no redesign proposals. If you could not complete a step, say which one and what blocked you.
