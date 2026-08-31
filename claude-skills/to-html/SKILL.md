---
name: to-html
description: >-
  Turn the response, findings, or report already produced in this conversation into a
  polished single-file HTML page and open it in the browser immediately. Use whenever the
  user wants to read the output somewhere nicer than terminal markdown - "put this in an
  HTML file", "show me the findings as a page", "make this readable", "open this as
  HTML", "html report". The page is editable: the user corrects wording in place and
  leaves comments, then hands the result back. `/to-html plain` renders it read-only.
  Not for building app UI or components.
---

# To HTML

Terminal markdown is fine for a quick answer. It's a failure mode for anything the user
actually wants to sit down and read: a month of findings, a research report, a review
full of numbers and tables. This skill re-renders what the conversation already produced
as one self-contained HTML page and opens it in the browser. It is a rendering step, not
a writing step.

The page is also where the user answers. Every block of prose is editable in place and
can carry a comment, so a report goes out and comes back with corrections on it instead
of being read once and re-litigated in chat.

## Before you start: does this apply?

1. **The content already exists in this conversation.** This skill formats; it does not
   research, interview, or invent. If the user asks for an HTML page of findings that
   have not been produced yet, do that work first as its own task, then render.
2. **It's a document, not an app.** Prose, findings, tables, a few figures. Interactive
   UI, product mockups, and dashboards with live data are a different job.

## Process

### 1. Outline from the content, not from a template

Let the material dictate the sections. A research report, a code review, and a
chat-log analysis all have different natural shapes - never force them into a fixed
scaffold, and never pad with headings the content doesn't have. Two rules always hold:

- A **TLDR box at the top**: 3-6 bullets a reader could stop after.
- **Fidelity**: the page says what the conversation said, tightened for reading. Don't
  inflate thin sections to look substantial, and don't quietly add conclusions that were
  never reached.

### 2. Fill the shell

Read `assets/report-template.html` from this skill's directory and use it as the shell.
It carries the full house style as one `<style>` block: white paper, Charter serif body
with a steel-blue chrome layer, sticky table-of-contents with scroll-spy, dark mode,
print CSS.
Replace `__TITLE__`, `__KIND__` (a 1-2 word document type: Findings, Research, Review),
`__META__` (a short free-form line: scope, source counts, compiled date). One sidebar
`<li>` per section, section ids `s-<slug>`, and remove the fill-instructions comment
from the output.

When the document really is a list of discrete proposals - "here are 18 things I'd
change, pick the ones you want" - wrap each one in `<div class="proposal"
data-title="short stable label">`. That, and only that, turns on its accept/reject
control; a report with no `.proposal` gets no decision UI anywhere. Inside a proposal,
a before/after pair is `<p class="lbl">Before</p><pre class="before"><code>...`
followed by `<p class="lbl">After</p><pre class="after"><code>...`, where only the
"after" half is editable. Don't reach for this on an ordinary report.

The shell owns every visual decision. Add markup, never CSS: no new `<style>` rules, no
inline `style` attributes, no colors outside the CSS variables. If the content seems to
need a pattern the shell doesn't have, it almost always wants a `<div class="note">`, a
table, or plain prose.

Things that make a report read as machine-written, all of them avoidable here:

- **Numbered sections.** "1. Findings", "2. Methodology". Headings carry their own
  weight. Numbers belong in `<ol class="numbered">`, where rank is the point.
- **Emoji, checkmarks, and status glyphs** as an icon system, in headings or tables.
- **Uppercase letterspaced micro-labels** and pill badges sprinkled over the page. The
  shell has exactly two chrome labels, and they are enough.
- **Bullets doing prose's job.** Three bullets of half-sentences are worse than one
  paragraph. Lists are for things that are genuinely a list.
- **Padding to look thorough**: a "Conclusion" restating the TLDR, a "Next steps"
  section nobody asked for, a section heading over two sentences.

### 3. Visuals only where they earn their place

Prose is the default, not the fallback. Most reports need zero or one figure. Add one
only when a real relationship in the data beats reading it as text: a trend over time
(line), a comparison across categories (bar), a genuinely spatial structure like a flow
or timeline (diagram). If you're decorating rather than explaining, delete it.

- **Every plotted number must be traceable to the conversation.** The signature failure
  of AI-generated reports is charts with invented data. If the numbers aren't there,
  it stays prose or a table - never an illustrative fake.
- **Inline SVG only.** No charting library, no Mermaid, no canvas. Use the template's
  CSS variables (`var(--steel)`, `var(--muted)`, `var(--rule)`) for all chart colors so
  dark mode never half-breaks, give the `<svg>` an `aria-label`, and wrap it in the
  template's `figure.chart` with a `<figcaption>`.
- **Titles state the insight.** "Signups doubled after the pricing change" beats
  "Signups by month". Bar charts start at zero, always.
- **Images** only if they already exist on disk and genuinely help - embed them base64
  in the template's `figure.shot`. Never link a remote image.

### 4. Keep it self-contained

No CDN, no external CSS, fonts, scripts, or images. The template's system font stacks
cover everything. The test: the file renders identically from a USB stick with WiFi off.

### 5. The editor layer is already in the shell

`<style id="editor-style">` and `<script id="editor">` make every leaf text block
editable and commentable. You write no editor markup for this: the script discovers the
blocks itself. Leave both elements in place.

Two things follow from that. Keep real content in real block elements, because anything
you bury in a `<div>` of raw text can't be edited or commented on. And when the user
asks for **`/to-html plain`** - a page to forward, print, or hand to someone else -
delete those two elements from the output and change nothing else.

### 6. Write it, open it, and wait for it to come back

Write to `~/.claude/reports/<slugified-title>.html` (create the directory if needed),
then open it in the user's default browser immediately (`open` on macOS, `xdg-open` on
Linux). Don't ask first; the whole point is that the page just appears. The path is
stable, so reopening the same report later restores the edits the user left on it.

Then stop and let them read. When they come back, they'll paste a JSON block, small
because it carries only what they touched:

```json
{ "doc": "...", "saved": "...",
  "edits":     [{ "at": "s-slug#4", "was": "first 60 chars of the original", "now": "their rewrite" }],
  "comments":  [{ "at": "s-slug#4", "on": "first 60 chars", "text": "their note" }],
  "decisions": [{ "item": "data-title", "decision": "accept" }] }
```

`at` locates the block, `was`/`on` is a fingerprint of the original so you can confirm
you found the right one. `now` is plain text, so any bold, links, or inline code in the
original is missing from it - restore that markup when you apply the edit, and fix
obvious typos silently. Comments are instructions to you, not text to insert. Treat an
empty `edits`/`comments`/`decisions` array as "nothing to do there", and if all three
are empty, say so rather than inventing work.

## Closing summary

Keep it to three lines - the page is the deliverable, not the reply:

- **Page**: the file path, and that it's open in the browser and editable (or plain).
- **Sections**: the TOC as a one-line list.
- **Figures**: one line per visual on why it earned its place - or "none - prose
  covered it", which is a fine answer.
