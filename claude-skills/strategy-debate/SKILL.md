---
name: strategy-debate
description: Multi-turn strategy debate between Claude and OpenAI's GPT-6 (via the Codex CLI). Use when the user runs "/strategy-debate", or explicitly asks to debate/discuss a strategic decision with GPT, ChatGPT, Codex, OpenAI, or "a second model" (e.g. marketing vs SEO vs features, pricing, growth priorities). NOT for code review and NOT for ordinary strategy chats that don't mention bringing in another model.
argument-hint: "<strategic question> [rounds=N] | smoke"
---

# Strategy Debate: Claude vs GPT-6

Hold a genuine multi-turn debate about a strategic/business question between Claude (this session) and GPT-6 (`gpt-6-astra`, `model=` arg overrides), using `codex exec` session resume so GPT remembers the whole thread. Ends with a synthesis: agreements, disagreements, and a joint recommendation.

## Dynamic Context

```
!`command -v codex || echo "CODEX_MISSING"`!
!`codex login status 2>&1 | head -1`!
!`codex --version`!
```

## Argument Parsing

- The literal word `smoke` (alone) -> run the Smoke Test section and stop.
- `rounds=N` anywhere in the args -> number of debate rounds (default 3, cap 5).
- `model=NAME` anywhere in the args -> codex model (default `gpt-6-astra`; `gpt-5.6-sol` still works).
- Everything else is the strategic question. If no question was given, ask for one and stop.

## Pre-flight Checks

Bail out on the first failure with a clear message.

1. **Codex installed?** If `CODEX_MISSING`: print `Codex CLI not found. Install: brew install codex` and stop.
2. **Logged in?** `codex login status` must report a login (e.g. "Logged in using ChatGPT"). Otherwise tell the user to run `! codex login` and stop.
3. **Version >= 0.153.** Older versions reject gpt-6-astra with "requires a newer version of Codex" (0.144 did, 2026-09-08). If older, run `brew upgrade codex` (it is a plain formula upgrade, safe to do unprompted) and re-check.
4. Create a working dir: `DEBATE_DIR=$(mktemp -d /tmp/strategy-debate.XXXXXX)`. All turn outputs and the transcript live there.
5. Set the model for every codex call in this debate: `MODEL=gpt-6-astra` (or the `model=` arg). Both the turn-1 command and every resume command below use `-m $MODEL`.

## Phase 1: Context Brief

Before involving GPT, gather real facts so neither side argues from vibes:

- If inside a project repo, pull the relevant business docs (business facts, pricing, marketing docs, anything the question touches). Include concrete numbers where cheaply available; do not launch a research project.
- Condense into a **context brief of max 300 words**: what the product is, current stage, relevant metrics/constraints, and the decision to be made.

## Phase 2: Claude's Opening Position

Write your own opening position FIRST (before hearing GPT): 3-5 numbered arguments plus a clear recommendation. Show it to the user under a `**Claude's opening position**` heading. This is your genuine view - do not hedge it to make the debate easier.

## Phase 3: The Debate Loop

### Turn 1 (opens the GPT session)

Build the turn-1 prompt:

```
You are a sharp, skeptical business strategist in a structured debate with another AI (Claude) about a strategic decision. The human (the founder) will read both sides and decide.

CONTEXT BRIEF:
{CONTEXT_BRIEF}

QUESTION UNDER DEBATE:
{QUESTION}

CLAUDE'S OPENING POSITION:
{CLAUDE_POSITION}

Your task this turn:
1. State your own position on the question (it may agree or disagree - be honest, not contrarian for sport).
2. Attack the weakest points in Claude's position with specific counterarguments.
3. You may read files in the current directory (read-only) to check facts.
Keep it under 500 words. Numbered arguments. No pleasantries.
```

Invoke codex. Three guards are NON-NEGOTIABLE (all verified): `< /dev/null` (exec merges piped stdin into the prompt and an open pipe can block), the perl alarm (macOS has no `timeout`; alarm guarantees death, exit 142), and `2>&1` (errors go to stderr).

```bash
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" && cat > "$DEBATE_DIR/turn1-prompt.txt" <<'DBEOF'
<TURN 1 PROMPT>
DBEOF
perl -e 'alarm shift @ARGV; exec @ARGV' 300 \
  codex exec --json --skip-git-repo-check -s read-only -m $MODEL \
  -o "$DEBATE_DIR/gpt-turn1.txt" "$(cat "$DEBATE_DIR/turn1-prompt.txt")" \
  < /dev/null 2>&1 | grep -E '"type":"(thread.started|error)"' ; echo "=== CODEX_EXIT: $? ==="
```

Bash tool parameter: `run_in_background: true` (turns take 1-3 minutes).

From the JSONL output, capture `thread_id` from the `thread.started` event - it is required for every later turn. If an `error` event appears or the `-o` file is missing, show the error and stop.

### Rounds 2..N (resume the session)

For each round:

1. Read `$DEBATE_DIR/gpt-turn<K>.txt` and relay GPT's arguments to the user under a `**GPT-6 (round K)**` heading (use the actual model name) - faithful summary or verbatim, never watered down.
2. Write your rebuttal under `**Claude (round K)**`: concede points that are actually right (say so explicitly), counter the rest, sharpen your recommendation. Show it to the user, then send it.
3. Send via resume. NOTE the flag differences, all verified: `resume` does NOT accept `-s` or `--json` the same way - sandbox goes through `-c`. ALWAYS pass `-m $MODEL` again: without it, resume falls back to the CLI's default model rather than the session's (2026-09-08 it silently tried a different model and errored, producing no output file).

```bash
perl -e 'alarm shift @ARGV; exec @ARGV' 300 \
  codex exec resume {THREAD_ID} --skip-git-repo-check -m $MODEL -c 'sandbox_mode="read-only"' \
  -o "$DEBATE_DIR/gpt-turn{K}.txt" "$(cat "$DEBATE_DIR/turn{K}-prompt.txt")" \
  < /dev/null 2>&1 | tail -2; echo "=== CODEX_EXIT: $? ==="
```

The rebuttal prompt for middle rounds is just your rebuttal text plus: `Respond: defend what survives, concede what doesn't, max 400 words.` For the FINAL round append instead: `This is the final round. Give your closing statement: your single recommendation, your strongest surviving argument, and what evidence would change your mind. Max 300 words.`

4. The user may interject between rounds - if they do, fold their input into the next rebuttal prompt as `FOUNDER INPUT: ...`.

## Phase 4: Synthesis

After the final GPT turn, write the synthesis yourself (do not ask GPT to write it):

- **Agreed:** points both models converged on.
- **Disputed:** remaining disagreements, one line each on who argues what and which argument you find stronger.
- **Joint recommendation:** the concrete next steps, flagged as unanimous or split (if split, say which model recommends what).
- **Evidence to collect:** what data would settle the disputed points.

Attribute every claim to Claude or GPT-6 honestly - do not launder GPT's arguments as your own or vice versa. Mention where the full transcript lives (`$DEBATE_DIR`).

## Smoke Test (`/strategy-debate smoke`)

Verifies the full transport without a real debate (~30s, two tiny GPT calls):

1. `DEBATE_DIR=$(mktemp -d /tmp/strategy-debate.XXXXXX)`
2. Turn 1 (exact same command shape as the real turn 1, prompt: `Remember the codeword SMOKE-DEBATE-77. Reply with exactly: stored`). Capture `thread_id`.
3. Turn 2 (exact same command shape as the real resume, prompt: `What is the codeword? Reply with just the codeword.`).
4. Report:
   - `PASS` if turn 1 produced a thread_id AND `$DEBATE_DIR/smoke2.txt` contains `SMOKE-DEBATE-77`.
   - `FAIL` otherwise, with which step broke and the raw output.

Run the smoke test after any codex upgrade or if a debate behaves strangely.

## Failure Handling

- `CODEX_EXIT: 142` -> the 5-minute alarm killed the turn. Say so, offer to retry that turn (the session survives; just resume again).
- Any `"type":"error"` event mentioning "requires a newer version of Codex" -> `brew upgrade codex`.
- Missing `-o` output file with exit 0 -> show the captured stdout/stderr; do not present an empty turn as a real reply.
- Each round is one metered call on the ChatGPT subscription - if the user asks for more than 5 rounds, push back once.
