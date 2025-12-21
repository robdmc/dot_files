#!/bin/bash

# Read JSON from stdin
json=$(cat)

# Extract values using jq
cwd=$(echo "$json" | jq -r '.cwd // .workspace.current_dir // "N/A"')
model=$(echo "$json" | jq -r '.model.display_name // "N/A"')
cost=$(echo "$json" | jq -r '.cost.total_cost_usd // 0')

# Shorten the cwd to just the last directory name for brevity
short_cwd=$(basename "$cwd")

# Calculate context usage percentage
usage=$(echo "$json" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
  current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  size=$(echo "$json" | jq '.context_window.context_window_size')
  pct=$((current * 100 / size))

  # Create battery indicator with bars (10 segments)
  filled=$((pct / 10))
  empty=$((10 - filled))
  bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done

  battery="[${bar}] ${pct}%"
else
  battery="[░░░░░░░░░░] 0%"
fi

# Calculate Pro message count (rolling 5-hour window)
TRACKING_DIR="/Users/rob/.claude/message-tracking"
if [ -d "$TRACKING_DIR" ]; then
  # Count files modified in the last 5 hours (18000 seconds)
  CURRENT_TIME=$(date +%s)
  FIVE_HOURS_AGO=$((CURRENT_TIME - 18000))

  # Count messages in the window
  MSG_COUNT=0
  OLDEST_TIME=$CURRENT_TIME

  for file in "$TRACKING_DIR"/msg-*; do
    if [ -f "$file" ]; then
      # Try GNU stat first (common on macOS with Homebrew), then BSD stat
      FILE_TIME=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null)
      if [ "$FILE_TIME" -ge "$FIVE_HOURS_AGO" ] 2>/dev/null; then
        MSG_COUNT=$((MSG_COUNT + 1))
        if [ "$FILE_TIME" -lt "$OLDEST_TIME" ]; then
          OLDEST_TIME=$FILE_TIME
        fi
      fi
    fi
  done

  # Calculate time remaining until oldest message expires
  if [ "$MSG_COUNT" -gt 0 ] && [ "$OLDEST_TIME" -lt "$CURRENT_TIME" ]; then
    RESET_TIME=$((OLDEST_TIME + 18000))
    TIME_LEFT=$((RESET_TIME - CURRENT_TIME))

    if [ "$TIME_LEFT" -gt 0 ]; then
      HOURS=$((TIME_LEFT / 3600))
      MINUTES=$(((TIME_LEFT % 3600) / 60))
      TIME_STR="${HOURS}h ${MINUTES}m"
    else
      TIME_STR="resetting"
    fi
  else
    TIME_STR="5h 0m"
  fi

  message_info="$MSG_COUNT/45 msgs ($TIME_STR)"
else
  message_info="0/45 msgs (5h 0m)"
fi

# Format cost with 2 decimal places
formatted_cost=$(printf "%.2f" "$cost")

# Output the status line
echo "$model | $battery | $message_info | \$$formatted_cost | $short_cwd"
