# Claude Code Custom Status Line

A custom status line for Claude Code that provides comprehensive session tracking for Claude Pro accounts.

## What This Does

This status line displays real-time information about your Claude Code session:

```
Sonnet 4.5 | [████████░░] 23% | 18/45 msgs (2h 37m) | $0.47 | myproject
```

**Features:**
- **Model name**: Which Claude model you're using
- **Context battery**: Visual indicator of context window usage (10 segments)
- **Pro message tracking**: Message count against the 45-message limit
- **Rolling 5-hour window**: Shows time until next message slot frees up
- **Theoretical cost**: What your session would cost on API pricing (useful for understanding value)
- **Directory name**: Your current working directory

## Files in This Directory

- `README.md` - This file
- `DEPLOY_STATUS.md` - Detailed deployment instructions for Claude
- `statusline.sh` - Main status line script
- `track-message.sh` - Message tracking hook (runs on each user prompt)
- `settings-fragment.json` - Settings configuration reference

## Quick Deploy

### On a New Computer

1. Copy this entire directory to your new computer
2. Open Claude Code in this directory (or any directory containing these files)
3. Give Claude this instruction:

```
Read DEPLOY_STATUS.md and deploy the status line configuration
```

That's it! Claude will:
- Copy scripts to `~/.claude/`
- Update paths for your system
- Configure your settings.json
- Make everything executable
- Create necessary directories

### Manual Deploy

If you prefer to install manually, follow the step-by-step instructions in `DEPLOY_STATUS.md`.

## After Installation

1. **Restart Claude Code** - The hook and status line load on startup
2. **Send a message** - The counter will start at 1/45 and increment
3. **Watch it work** - Context battery fills, cost increases, time counts down

## Example Status Line Evolution

**Fresh conversation:**
```
Sonnet 4.5 | [░░░░░░░░░░] 0% | 0/45 msgs (5h 0m) | $0.00 | myproject
```

**After a few messages:**
```
Sonnet 4.5 | [██░░░░░░░░] 8% | 5/45 msgs (4h 47m) | $0.23 | myproject
```

**Active development session:**
```
Sonnet 4.5 | [██████░░░░] 47% | 28/45 msgs (1h 52m) | $2.15 | backend
```

**Approaching limits:**
```
Sonnet 4.5 | [█████████░] 89% | 43/45 msgs (0h 3m) | $4.87 | webapp
```

## How the Message Tracking Works

- **Each user prompt** triggers a hook that creates a timestamp file
- **Status line** counts files from the last 5 hours
- **Automatic cleanup** removes files older than 5 hours
- **Rolling window** means messages expire individually as they age out

## Why Both Context Battery AND Message Count?

They measure different things:

**Context Battery:**
- **Technical limit**: Model's memory capacity
- **Token-based**: Long messages fill it faster
- **Universal**: Applies to all account types
- **Tells you**: When conversation needs to be reset

**Message Count:**
- **Billing limit**: Pro account's usage cap
- **Message-based**: All messages count equally
- **Pro-specific**: Only relevant for Pro accounts
- **Tells you**: How close you are to hitting your limit

**Theoretical Cost:**
- **Value indicator**: What you'd pay on API pricing
- **Session tracking**: Cumulative for current conversation
- **Informational**: Not related to Pro billing
- **Tells you**: The "value" you're getting from your Pro subscription

## Customization

See `DEPLOY_STATUS.md` for customization options:
- Adjust the message limit (45 msgs)
- Change the time window (5 hours)
- Rearrange status line elements
- Modify the context battery visualization

## Requirements

- Claude Code CLI
- `jq` command-line JSON processor (usually pre-installed on macOS/Linux)
- Bash shell

## Troubleshooting

**Status line not showing?**
- Did you restart Claude Code after installation?
- Are scripts executable? (`ls -l ~/.claude/*.sh`)

**Message count stuck at 0?**
- Restart Claude Code for the hook to activate
- Check `~/.claude/message-tracking/` directory exists

**Path errors?**
- Make sure paths in scripts match your system
- The deployment process should handle this automatically

For more troubleshooting help, see `DEPLOY_STATUS.md`.

## Uninstalling

To remove this status line:

```
Read DEPLOY_STATUS.md and follow the uninstallation instructions
```

Or manually:
1. Delete `~/.claude/statusline.sh`
2. Delete `~/.claude/track-message.sh`
3. Remove `~/.claude/message-tracking/` directory
4. Edit `~/.claude/settings.json` to remove the statusLine and hook configuration
5. Restart Claude Code

## License

Free to use and modify. Share with other Claude Code users!

## Credits

Custom status line built to track Claude Pro account usage with rolling 5-hour message windows.
