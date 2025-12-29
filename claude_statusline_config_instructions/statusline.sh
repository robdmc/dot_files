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


# Format cost with 2 decimal places
formatted_cost=$(printf "%.2f" "$cost")

# Output the status line
echo "$model | $battery | \$$formatted_cost | $short_cwd"
