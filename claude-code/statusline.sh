#!/bin/bash
# Claude Code status line, styled after pi's pi-sub-bar usage widget:
#   facturo [Fable 5 · max] │ Ctx ━━━━━━──── 35% │ 5h ━━──── 21% [3h39m] │ Week ━━──── 28% [4d2h]
#
# Gauge look ported from @marckrenn/pi-sub-bar with the settings in
# ~/.pi/agent/pi-sub-bar-settings.json: heavy ━ for filled and unfilled (unfilled
# dim), bold gauge titles, usage color applied to title/bar/%/timer - default fg
# at <= 50% used, yellow > 50, red > 75 (pi's base-warning-error scheme) - relative
# reset time in [] after the %, dim │ dividers, bars stretch to fill the width.
#
# Context usage is sourced in priority order (see code.claude.com/docs/en/statusline):
#   1. context_window.used_percentage  - pre-calculated by Claude Code (input-only
#      formula, correct for 200k AND 1M-context models). This is the canonical value.
#   2. context_window.current_usage    - compute the same input-only ratio ourselves
#      if the pre-calculated field isn't present yet.
#   3. the transcript's last usage record - so resumed sessions and the window right
#      after /compact show the real number instead of 0.
#
# Rate limits (Pro/Max subscriptions): rate_limits.five_hour / .seven_day carry
# used_percentage and resets_at (epoch seconds). They are absent before the session's
# first API response (and on API-key auth), and a known bug can put an epoch timestamp
# in used_percentage - any value outside 0-100 hides that gauge instead of rendering
# garbage. jq emits "-" for missing fields because empty TSV fields collapse under
# bash's tab-IFS read and would shift every following field left.
#
# Width: Claude Code >= 2.1.172 passes the real terminal width in COLUMNS, but its
# statusline area is a few columns narrower than the pty - filling to COLUMNS-1 gets
# ellipsis-truncated on the right - so keep a 5-column margin. Sessions in stub ptys
# (e.g. older versions) report a bogus tiny COLUMNS; anything under 60 is ignored in
# favor of TARGET_WIDTH, and overlong lines just truncate.

export LC_ALL=en_US.UTF-8

TARGET_WIDTH=120
WIDTH=$(( TARGET_WIDTH - 1 ))
case "${COLUMNS:-}" in ''|*[!0-9]*) ;; *) [ "$COLUMNS" -ge 60 ] && WIDTH=$(( COLUMNS - 5 )) ;; esac

input=$(cat)

BOLD=$'\033[1m'; DIM=$'\033[2m'; RESET=$'\033[0m'

# pi's base-warning-error scheme mapped onto used%: <= 50 base (no code, default
# fg), > 50 yellow, > 75 red.
ucolor() {
    if   [ "$1" -gt 75 ]; then printf '\033[31m'
    elif [ "$1" -gt 50 ]; then printf '\033[33m'
    fi
}

# pi-sub-core formatReset: "now" / Xm / XhYm / XdYh - floor, zero units dropped.
fmt_reset() {
    local diff=$(( $1 - NOW )) mins hours days rem
    if [ "$diff" -lt 0 ]; then echo "now"; return; fi
    mins=$(( diff / 60 ))
    if [ "$mins" -lt 60 ]; then echo "${mins}m"; return; fi
    hours=$(( mins / 60 )); rem=$(( mins % 60 ))
    if [ "$hours" -lt 24 ]; then
        if [ "$rem" -gt 0 ]; then echo "${hours}h${rem}m"; else echo "${hours}h"; fi
        return
    fi
    days=$(( hours / 24 )); rem=$(( hours % 24 ))
    if [ "$rem" -gt 0 ]; then echo "${days}d${rem}h"; else echo "${days}d"; fi
}

# One jq pass: model, dir, window size, best-available context percentage, effort.
IFS=$'\t' read -r MODEL DIR CTX_SIZE PCT EFFORT < <(echo "$input" | jq -r '
  (.context_window.context_window_size // 200000) as $size
  | [ (.model.display_name // "Claude"),
      (.workspace.current_dir // .cwd // "."),
      ($size | tostring),
      ( ( .context_window.used_percentage )
        // ( .context_window.current_usage
             | if . == null then null
               else ((.input_tokens // 0)
                     + (.cache_creation_input_tokens // 0)
                     + (.cache_read_input_tokens // 0)) * 100 / $size
               end )
        // "-" | tostring ),
      (.effort.level // "")
    ] | @tsv')

PROJECT=$(basename "$DIR")
case "$CTX_SIZE" in ''|*[!0-9]*|0) CTX_SIZE=200000 ;; esac
[ "$PCT" = "-" ] && PCT=""

# Fallback: derive % from the last usage record in the transcript.
if [ -z "$PCT" ]; then
    TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // empty')
    if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
        PCT=$(jq -r --argjson size "$CTX_SIZE" '
            .message.usage // empty
            | select(. != null)
            | ((.input_tokens // 0)
               + (.cache_creation_input_tokens // 0)
               + (.cache_read_input_tokens // 0)) * 100 / $size
        ' "$TRANSCRIPT" 2>/dev/null | tail -1)
    fi
fi

# Round to nearest int and clamp to [0, 100].
PCT=$(awk -v p="$PCT" 'BEGIN { p=p+0; p=int(p+0.5); if(p<0)p=0; if(p>100)p=100; print p }')

# Absolute context tokens for the Ctx gauge, derived from the same PCT/size the
# bar uses so the count always matches the percentage shown. Quantized to 1%
# (~2k at 200k), which is invisible at whole-k display.
fmt_k() { awk -v n="$1" 'BEGIN { n+=0; if (n>=1000000) printf "%.1fM", n/1000000; else printf "%dk", n/1000+0.5 }'; }
CTX_USED_TOK=$(awk -v p="$PCT" -v s="$CTX_SIZE" 'BEGIN { printf "%d", p/100*s+0.5 }')
CTX_LABEL="$(fmt_k "$CTX_USED_TOK")/$(fmt_k "$CTX_SIZE")"

# Rate limits.
IFS=$'\t' read -r FH_PCT FH_RST SD_PCT SD_RST < <(echo "$input" | jq -r '
  [ (.rate_limits.five_hour.used_percentage // "-"),
    (.rate_limits.five_hour.resets_at       // "-"),
    (.rate_limits.seven_day.used_percentage // "-"),
    (.rate_limits.seven_day.resets_at       // "-")
  ] | @tsv')

NOW=$(date +%s)

# Gauges as parallel arrays: label / used% / reset text ("" = no timer).
# The Ctx gauge has no reset timer, so its slot carries the absolute token count.
GL=("Ctx"); GP=("$PCT"); GR=("$CTX_LABEL")

add_limit() { # label used% resets_at-epoch
    local pct=$2 rst=""
    case "$pct" in ''|-|*[!0-9.]*) return ;; esac
    pct=$(awk -v p="$pct" 'BEGIN { print int(p + 0.5) }')
    [ "$pct" -gt 100 ] && return
    case "$3" in ''|*[!0-9]*) ;; *) rst=$(fmt_reset "$3") ;; esac
    GL+=("$1"); GP+=("$pct"); GR+=("$rst")
}
add_limit "5h"   "$FH_PCT" "$FH_RST"
add_limit "Week" "$SD_PCT" "$SD_RST"

# First cell, plain for width math and styled for output.
PLAIN0="$PROJECT [$MODEL"
[ -n "$EFFORT" ] && PLAIN0+=" · $EFFORT"
PLAIN0+="]"
CELL0="$PROJECT [$MODEL"
[ -n "$EFFORT" ] && CELL0+=" ${DIM}·${RESET} $EFFORT"
CELL0+="]"

# Fixed (non-bar) visible width, then split the leftover across the gauges
# pi-style: equal shares, remainder left to right, minimum 3 cols each.
N=${#GL[@]}
FIXED=${#PLAIN0}
for ((i=0; i<N; i++)); do
    FIXED=$(( FIXED + 3 + ${#GL[i]} + 1 + 1 + ${#GP[i]} + 1 ))
    [ -n "${GR[i]}" ] && FIXED=$(( FIXED + 3 + ${#GR[i]} ))
done
LEFT=$(( WIDTH - FIXED ))
[ "$LEFT" -lt $(( 3 * N )) ] && LEFT=$(( 3 * N ))
BASE_W=$(( LEFT / N )); REM=$(( LEFT % N ))

SEP=" ${DIM}│${RESET} "
LINE="$CELL0"
for ((i=0; i<N; i++)); do
    BW=$(( BASE_W + (i < REM ? 1 : 0) ))
    P=${GP[i]}
    C=$(ucolor "$P")
    F=$(( P * BW / 100 )); [ "$F" -gt "$BW" ] && F=$BW
    bar=""; for ((j=0; j<F; j++));  do bar+="━";  done
    ebar=""; for ((j=F; j<BW; j++)); do ebar+="━"; done
    seg="${BOLD}${C}${GL[i]}${RESET} ${C}${bar}${RESET}${DIM}${ebar}${RESET} ${C}${P}%${RESET}"
    [ -n "${GR[i]}" ] && seg+=" ${C}[${GR[i]}]${RESET}"
    LINE+="$SEP$seg"
done

echo "$LINE"
