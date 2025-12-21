# Claude Code Status Line Deployment Guide

This directory contains a custom Claude Code status line setup that displays:
- Model name
- Context window battery (10-segment visual indicator)
- Pro account message count with rolling 5-hour window
- Time until next message slot frees up
- Theoretical session cost
- Current directory name

## Files Included

- `statusline.sh` - Main status line script
- `track-message.sh` - Message tracking hook script
- `settings-fragment.json` - Settings configuration to add
- `DEPLOY_STATUS.md` - This deployment guide

## Installation Instructions for Claude

When deploying to a new computer, follow these steps:

### Step 1: Copy Scripts to Claude Directory

```bash
# Create the .claude directory if it doesn't exist
mkdir -p ~/.claude

# Copy the status line script
cp statusline.sh ~/.claude/statusline.sh

# Copy the message tracking hook script
cp track-message.sh ~/.claude/track-message.sh

# Make both scripts executable
chmod +x ~/.claude/statusline.sh
chmod +x ~/.claude/track-message.sh

# Create the message tracking directory
mkdir -p ~/.claude/message-tracking
```

### Step 2: Update Claude Settings

You need to add the configuration from `settings-fragment.json` to your `~/.claude/settings.json` file.

**If `~/.claude/settings.json` doesn't exist yet:**
```bash
cp settings-fragment.json ~/.claude/settings.json
```

**If `~/.claude/settings.json` already exists:**

Read the current settings:
```bash
cat ~/.claude/settings.json
```

Then merge the following sections into the existing file:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  },
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/track-message.sh"
          }
        ]
      }
    ]
  }
}
```

**Important Notes:**
- If you already have a `statusLine` configuration, replace it with this one
- If you already have `hooks`, add the `UserPromptSubmit` hook to the existing hooks object
- If you already have `UserPromptSubmit` hooks, add this hook to the array

### Step 3: Update Path References (if needed)

Both scripts use hardcoded paths for the user `rob`. You need to update these paths for the new computer.

**In `statusline.sh` and `track-message.sh`:**

Find and replace:
```bash
/Users/rob/.claude/message-tracking
```

With the appropriate path for the new system:
- **macOS/Linux**: `~/.claude/message-tracking` or `$HOME/.claude/message-tracking`
- **Windows**: Use the appropriate Windows path

You can use sed to do this automatically:
```bash
# Update statusline.sh
sed -i.bak 's|/Users/rob/.claude/message-tracking|'"$HOME"'/.claude/message-tracking|g' ~/.claude/statusline.sh

# Update track-message.sh
sed -i.bak 's|/Users/rob/.claude/message-tracking|'"$HOME"'/.claude/message-tracking|g' ~/.claude/track-message.sh

# Remove backup files
rm ~/.claude/statusline.sh.bak ~/.claude/track-message.sh.bak
```

### Step 4: Restart Claude Code

The hooks and status line configuration are loaded when Claude Code starts, so you must restart:

```bash
# Exit your current Claude Code session
# Then restart Claude Code
```

### Step 5: Verify Installation

After restarting, you should see a status line that looks like:

```
Sonnet 4.5 | [████████░░] 23% | 0/45 msgs (5h 0m) | $0.00 | tmp
```

Send a few messages and verify:
- The message count increments (1/45, 2/45, etc.)
- The time remaining updates
- The cost increases with usage
- The context battery fills as the conversation grows

## Troubleshooting

**Status line not appearing:**
- Check that both scripts are executable: `ls -l ~/.claude/*.sh`
- Verify settings.json syntax is valid: `cat ~/.claude/settings.json | jq .`

**Message count stuck at 0:**
- Ensure you restarted Claude Code after installation
- Check that the hook script is executable: `ls -l ~/.claude/track-message.sh`
- Verify the tracking directory exists: `ls -ld ~/.claude/message-tracking`

**Path errors:**
- Check that all paths in the scripts match your system
- Use absolute paths or `$HOME` instead of `~` in scripts

**Hook not running:**
- Check the settings.json configuration
- Verify the hook script path is correct and absolute

## Customization

### Adjust Pro Message Limit

The default is 45 messages per 5-hour window. To change this, edit `statusline.sh` line 72:

```bash
message_info="$MSG_COUNT/45 msgs ($TIME_STR)"
#                      ^^
#                      Change this number
```

### Change Time Window

The default is 5 hours (18000 seconds). To change this, edit both scripts:

**In `statusline.sh`**, line 38:
```bash
FIVE_HOURS_AGO=$((CURRENT_TIME - 18000))
#                                ^^^^^ seconds
```

**In `track-message.sh`**, the cleanup line:
```bash
find "$TRACKING_DIR" -type f -name "msg-*" -mtime +5h -delete
#                                                  ^^ hours
```

### Customize Status Line Format

Edit line 81 of `statusline.sh` to rearrange or remove elements:

```bash
echo "$model | $battery | $message_info | \$$formatted_cost | $short_cwd"
```

Available variables:
- `$model` - Model name
- `$battery` - Context battery indicator
- `$message_info` - Message count with time
- `$formatted_cost` - Theoretical cost
- `$short_cwd` - Directory name
- `$cwd` - Full directory path

## Example Status Line Outputs

**Light usage:**
```
Sonnet 4.5 | [██░░░░░░░░] 5% | 3/45 msgs (4h 52m) | $0.12 | myproject
```

**Moderate usage:**
```
Sonnet 4.5 | [██████░░░░] 45% | 22/45 msgs (2h 15m) | $1.47 | backend
```

**Heavy usage:**
```
Sonnet 4.5 | [█████████░] 85% | 41/45 msgs (0h 8m) | $3.28 | webapp
```

## Uninstallation

To remove this status line setup:

```bash
# Remove scripts
rm ~/.claude/statusline.sh
rm ~/.claude/track-message.sh

# Remove tracking directory
rm -rf ~/.claude/message-tracking

# Edit ~/.claude/settings.json and remove:
# - The "statusLine" section
# - The "UserPromptSubmit" hook

# Restart Claude Code
```
