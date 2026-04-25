#!/usr/bin/env bash
# Stop hook for Claude Code.
#
# When the agent tries to end its turn while we are inside an autoresearch
# run (branch matches autoresearch/*), block the stop and inject a message
# telling the agent to continue per program.md. The user can still interrupt
# manually with ESC / Ctrl-C, switch branch, or run /clear.
#
# Two safeguards prevent runaway recursion:
#   1. Only blocks on autoresearch/* branches.
#   2. The hook input includes `stop_hook_active` — if true, the agent is
#      already running again because of a previous block, so we let it stop
#      to avoid an infinite ping-pong.

set -euo pipefail

input="$(cat)"

# If the agent is already in a stop-hook-induced continuation, allow the stop.
if printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

branch="$(git branch --show-current 2>/dev/null || true)"
case "$branch" in
  autoresearch/*) ;;
  *) exit 0 ;;
esac

cat <<'JSON'
{"decision": "block", "reason": "Loop autoresearch attivo (branch autoresearch/*). Non fermarti: prosegui col prossimo esperimento secondo la sezione 'The experiment loop' di program.md. Se hai appena loggato un risultato, scegli la prossima idea e modifica train.py. NEVER STOP."}
JSON
