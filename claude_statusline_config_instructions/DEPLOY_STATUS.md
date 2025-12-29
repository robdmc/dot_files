# Claude Code Status Line Deployment Guide

This directory contains a custom Claude Code status line setup that displays:
- Model name
- Context window battery (10-segment visual indicator)
- Theoretical session cost
- Current directory name

## Files Included

- `statusline.sh` - Main status line script
- `settings-fragment.json` - Settings configuration to add
- `DEPLOY_STATUS.md` - This deployment guide

## Installation Instructions for Claude

When deploying to a new computer, follow these steps:

### Step 1: Copy Script to Claude Directory

```bash
# Create the .claude directory if it doesn't exist
mkdir -p ~/.claude

# Copy the status line script
cp statusline.sh ~/.claude/statusline.sh

# Make the script executable
chmod +x ~/.claude/statusline.sh
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

Then merge the following configuration into the existing file:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

**Important Note:**
- If you already have a `statusLine` configuration, replace it with this one

### Step 3: Restart Claude Code

The status line configuration is loaded when Claude Code starts, so you must restart:

```bash
# Exit your current Claude Code session
# Then restart Claude Code
```

### Step 4: Verify Installation

After restarting, you should see a status line that looks like:

```
Sonnet 4.5 | [████████░░] 23% | $0.00 | tmp
```

Send a few messages and verify:
- The cost increases with usage
- The context battery fills as the conversation grows
- The model name and directory are displayed correctly

## Troubleshooting

**Status line not appearing:**
- Check that the script is executable: `ls -l ~/.claude/statusline.sh`
- Verify settings.json syntax is valid: `cat ~/.claude/settings.json | jq .`
- Restart Claude Code after making changes

**Context battery or cost not updating:**
- The status line updates automatically with each interaction
- Restart Claude Code if values seem frozen
- Check that the script has proper permissions

**Settings issues:**
- Verify your settings.json is valid JSON: `jq . ~/.claude/settings.json`
- Make sure the statusLine command path is correct

## Customization

### Customize Status Line Format

Edit line 38 of `statusline.sh` to rearrange or remove elements:

```bash
echo "$model | $battery | \$$formatted_cost | $short_cwd"
```

Available variables:
- `$model` - Model name
- `$battery` - Context battery indicator
- `$formatted_cost` - Theoretical cost
- `$short_cwd` - Directory name (basename)
- `$cwd` - Full directory path

## Example Status Line Outputs

**Light usage:**
```
Sonnet 4.5 | [██░░░░░░░░] 5% | $0.12 | myproject
```

**Moderate usage:**
```
Sonnet 4.5 | [██████░░░░] 45% | $1.47 | backend
```

**Heavy usage:**
```
Sonnet 4.5 | [█████████░] 85% | $3.28 | webapp
```

## Uninstallation

To remove this status line setup:

```bash
# Remove the script
rm ~/.claude/statusline.sh

# Edit ~/.claude/settings.json and remove the "statusLine" section

# Restart Claude Code
```
