#!/bin/bash

# Read JSON from stdin
json=$(cat)

# Extract values using jq
cwd=$(echo "$json" | jq -r '.cwd // .workspace.current_dir // "N/A"')
model=$(echo "$json" | jq -r '.model.display_name // "N/A"')

# Effort level: blank unless the model exposes one (e.g. "high", "max")
effort=$(echo "$json" | jq -r '.effort.level // empty')
if [ -n "$effort" ]; then
  effort_segment=" | $effort"
else
  effort_segment=""
fi

# Show the current directory plus its parent (last two path components)
parent_dir=$(dirname "$cwd")
if [ "$parent_dir" = "/" ] || [ "$parent_dir" = "." ]; then
  short_cwd=$(basename "$cwd")
else
  short_cwd="$(basename "$parent_dir")/$(basename "$cwd")"
fi

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


# Git branch: blank unless cwd is inside a git repo, then show current branch
branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  git_segment=" |  $branch"
else
  git_segment=""
fi

# Output the status line
echo "$model$effort_segment | $battery | $short_cwd$git_segment"
