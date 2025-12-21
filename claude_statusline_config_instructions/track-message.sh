#!/bin/bash

# Track message timestamps for Pro account message counting
TRACKING_DIR="/Users/rob/.claude/message-tracking"

# Create tracking directory if it doesn't exist
mkdir -p "$TRACKING_DIR"

# Create a timestamp file for this message
touch "$TRACKING_DIR/msg-$(date +%s)"

# Clean up files older than 5 hours (18000 seconds)
find "$TRACKING_DIR" -type f -name "msg-*" -mtime +5h -delete 2>/dev/null || true
