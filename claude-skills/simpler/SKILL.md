---
name: simpler
description: Re-explains the assistant's previous answer in ASD-STE100-inspired simplified language. Only invoked manually by the user via /simpler when an explanation was not understood. An optional argument names the part that was unclear.
---

# Simpler

Re-explain your previous answer so a non-expert understands it on first read.
If an argument names a part, re-explain only that part. If this skill runs
twice on the same topic, the second attempt must be simpler than the first.

Rules, adapted from ASD-STE100:

- Lead with one sentence that states the core point.
- One idea per sentence. Max 20 words per sentence.
- Hard cap of 10 sentences total.
- End with one sentence on why it matters or what to do next.
- Active voice. Simple tenses only (no "would have been", no "having configured").
- One concept gets one term. Never switch to a synonym mid-explanation.
- Write complete sentences. Do not drop articles or verbs to save words.
- Define each unavoidable technical term in plain words in the same sentence.
- At most one everyday analogy, and only when the concept is genuinely
  abstract. Otherwise stay literal.
- Keep code, commands, file paths, and error text verbatim. Never simplify those.
- Answer in the language of the conversation.
- No filler, no hedging, no restating the original answer's structure. Do not
  mention this skill or the standard.
