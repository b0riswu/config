#!/usr/bin/env bash
# Wrapper: calls tmux-agent-indicator's hook, then stamps @agent_state on the window
# so window-status-format can read it for color switching.

set -euo pipefail

EVENT="${1:-}"
INDICATOR_DIR="${TMUX_AGENT_INDICATOR_DIR:-$HOME/.tmux/plugins/tmux-agent-indicator}"

# Forward to original hook
"$INDICATOR_DIR/scripts/agent-state.sh" --agent claude --state "$EVENT" 2>/dev/null || true

# Map hook event to agent state
case "$EVENT" in
    running)      STATE="running" ;;
    needs-input)  STATE="needs-input" ;;
    done)         STATE="done" ;;
    off)          STATE="" ;;
    *)            STATE="" ;;
esac

# Stamp @pane_agent_state on the calling pane (not the focused one)
if command -v tmux >/dev/null 2>&1 && [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ]; then
    WINDOW_ID=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2>/dev/null) || true
    if [ -n "$STATE" ]; then
        tmux set-option -pt "$TMUX_PANE" @pane_agent_state "$STATE"
        [ -n "$WINDOW_ID" ] && tmux set-option -wt "$WINDOW_ID" @agent_state "$STATE"
    else
        tmux set-option -put "$TMUX_PANE" @pane_agent_state
        [ -n "$WINDOW_ID" ] && tmux set-option -wut "$WINDOW_ID" @agent_state
    fi
    tmux refresh-client -S 2>/dev/null || true
fi
