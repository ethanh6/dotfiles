#!/bin/bash

input=$(cat)

# Model
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Workspace directory (basename only)
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"' | xargs basename)

# Context usage
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
CURRENT_TOKENS=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
CONTEXT_PCT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))

# Cost and duration
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' | xargs printf "%.2f")
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
DURATION_S=$((DURATION_MS / 1000))

# Format duration as mm:ss if over 60s
if [ "$DURATION_S" -ge 60 ]; then
    MINS=$((DURATION_S / 60))
    SECS=$((DURATION_S % 60))
    DURATION_FMT="${MINS}m${SECS}s"
else
    DURATION_FMT="${DURATION_S}s"
fi

# Output: [Model] dir | ctx% | $cost | duration
printf '\033[38;5;75m[%s]\033[0m %s | \033[38;5;6m%d%%\033[0m | \033[38;5;2m$%s\033[0m | %s' \
    "$MODEL" "$DIR" "$CONTEXT_PCT" "$COST" "$DURATION_FMT"
