---
name: arena
description: Cross-model debate on a non-obvious decision. Three models from three providers answer blind, rebut each other once, and the moderator reports agreements, disputes and new angles.
argument-hint: "<decision to debate> [roster or effort changes in plain words]"
disable-model-invocation: true
---

# Arena

You are the moderator. You brief the seats, carry their answers between rounds and write the final reply. Your own view stays out until the Recommendation at the end, because you are anchored on the conversation and the seats are there to escape that.

Arena runs in T3 Code, where `delegate_task` reaches other providers. Anywhere else, say that it can't run here and stop.

## Seats

| Seat | `providerInstanceId` | `model` | `options` |
| --- | --- | --- | --- |
| A | `claudeAgent` | `claude-opus-5-5` | `{ effort: "high" }` |
| B | `codex` | `gpt-6.1-sol` | `{ reasoningEffort: "high" }` |
| C | `antigravity` | `gemini-3.8-flash` | `{ thinking_level: "high" }` |

Roster or effort changes the user writes into the call replace the matching rows for that run. A seat keeps its letter and its model through both rounds.

## Steps

1. Write the brief from the conversation and, when the decision is about a codebase, from the repo. It holds four things: the question in one or two sentences, the hard constraints, the known facts (with paths the seats can open), and the options raised so far. Leave out which option you or the user lean towards. If you cannot name the decision or its constraints, ask the user one question and stop.

2. Round 1, blind openings. Call `orchestrator_capabilities`, then start all three seats in one message with `delegate_task`, `role: "research"`, `title: "arena <letter> opening"`, and this task:

   ```
   You are one of three independent advisors on a decision. Nobody has seen
   another advisor's answer yet. This is read-only work and your reply is your
   only output.

   Question: <QUESTION>
   Constraints: <CONSTRAINTS>
   Known facts: <FACTS>
   Options raised so far (not exhaustive): <OPTIONS>

   Give your own honest view. You may reject the framing or propose an option
   that is not listed. Check facts in the repo or on the web where the answer
   depends on them, and mark every claim you did not check as an assumption.
   Roughly cover your recommendation, the arguments for it, the assumptions it
   rests on and the biggest risk of your own recommendation. 400 words at most.
   ```

3. Read the three openings. When all seats recommend the same thing and their assumptions are compatible, skip to step 5 and say in the final reply that the rebuttal was skipped. Otherwise continue.

4. Round 2, one rebuttal. Start a fresh `delegate_task` per seat, same target as in round 1, `title: "arena <letter> rebuttal"`, with this task. The other openings go in verbatim under their letters, without model names.

   ```
   Question: <QUESTION>
   Constraints: <CONSTRAINTS>
   Known facts: <FACTS>
   Options raised so far (not exhaustive): <OPTIONS>

   This is the rebuttal round of a three-seat debate and your last word. You
   are seat <X>. This is read-only work and your reply is your only output.

   Your opening:
   <OPENING X>

   Seat <Y>'s opening:
   <OPENING Y>

   Seat <Z>'s opening:
   <OPENING Z>

   Judge the arguments on their merits. State what you concede, what you still
   dispute and why, your updated recommendation, and what evidence would
   change your mind. 300 words at most.
   ```

5. Check the claims a remaining dispute hinges on, when one file read or one doc lookup settles them. Label every other unchecked claim as unverified in the final reply.

6. Write the final reply under these four headings, naming the model behind each point and linking each seat's thread.

   - **Agreed** holds what every seat ended on.
   - **Disputed** holds each open disagreement with the strongest case per side.
   - **New angles** holds points that were absent from the conversation before the debate, including rejected framings and unlisted options.
   - **Recommendation** is your own call and the reason, with the one piece of evidence that would flip it.

## A seat fails

Retry an errored delegate once. A seat that is still missing, or whose model the provider does not offer, stays empty for the run, and the final reply names it. Two seats are a debate. With one seat left, report what happened and stop.
