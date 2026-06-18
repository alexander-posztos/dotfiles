# Claude Code statusline

My custom [Claude Code](https://claude.com/claude-code) status line, styled after
[@marckrenn/pi-sub-bar](https://github.com/marckrenn/pi-sub-bar). It shows the
project, the model and effort level, and stretch-to-fit gauges for context usage
and (on Pro/Max) the 5-hour and weekly rate-limit windows:

```
facturo [Fable 5 · max] │ Ctx ━━━━━━──── 35% [70k/200k] │ 5h ━━──── 18% [3h39m] │ Week ━━──── 35% [4d2h]
```

The `Ctx` gauge reads Claude Code's pre-calculated `context_window.used_percentage`
(falling back to `current_usage`, then the transcript) so it stays correct for both
200k and 1M-context models, and prints the absolute token count next to the percent.
Bars and the `%`/timers turn yellow above 50% used and red above 75%.

It is a single self-contained script - no settings file or other dependency at
runtime. Needs `bash`, `jq`, `awk`, and a font that renders the heavy `━` glyph.

## Install

Point your Claude Code `statusLine` at it (`~/.claude/settings.json`):

```bash
cp claude-code/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

```json
{
  "statusLine": { "type": "command", "command": "~/.claude/statusline.sh", "padding": 0 }
}
```
