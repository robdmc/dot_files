# Claude Code Custom Status Line

A custom status line for Claude Code that provides comprehensive session tracking for Claude Pro accounts.

## What This Does

This status line displays real-time information about your Claude Code session:

```
Sonnet 4.5 | [████████░░] 23% | $0.47 | myproject
```

**Features:**
- **Model name**: Which Claude model you're using
- **Context battery**: Visual indicator of context window usage (10 segments)
- **Theoretical cost**: What your session would cost on API pricing (useful for understanding value)
- **Directory name**: Your current working directory

## Files in This Directory

- `README.md` - This file
- `DEPLOY_STATUS.md` - Detailed deployment instructions for Claude
- `statusline.sh` - Main status line script
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

1. **Restart Claude Code** - The status line loads on startup
2. **Send messages** - Context battery fills, cost increases with each message
3. **Watch it work** - The status line updates as your conversation progresses

## Example Status Line Evolution

**Fresh conversation:**
```
Sonnet 4.5 | [░░░░░░░░░░] 0% | $0.00 | myproject
```

**After a few messages:**
```
Sonnet 4.5 | [██░░░░░░░░] 8% | $0.23 | myproject
```

**Active development session:**
```
Sonnet 4.5 | [██████░░░░] 47% | $2.15 | backend
```

**Approaching limits:**
```
Sonnet 4.5 | [█████████░] 89% | $4.87 | webapp
```

## Why Context Battery AND Cost?

They measure different things and provide complementary insights:

**Context Battery:**
- **Technical limit**: Model's memory capacity (how much it can remember)
- **Token-based**: Long messages or large files fill it faster
- **Tells you when**: Conversation needs to be reset due to context limits
- **Visual indicator**: Easy to see at a glance how much capacity you've used

**Theoretical Cost:**
- **Value indicator**: What this conversation would cost at API pricing
- **Session tracking**: Cumulative for the current conversation
- **Understanding value**: Shows the "value" you're getting from your Claude Pro subscription
- **Budget awareness**: Helps you understand the computational resources being used

## Customization

See `DEPLOY_STATUS.md` for customization options:
- Rearrange status line elements
- Modify the context battery visualization
- Adjust display formatting

## Requirements

- Claude Code CLI
- `jq` command-line JSON processor (usually pre-installed on macOS/Linux)
- Bash shell

## Troubleshooting

**Status line not showing?**
- Did you restart Claude Code after installation?
- Are scripts executable? (`ls -l ~/.claude/statusline.sh`)
- Check settings.json is valid: `jq . ~/.claude/settings.json`

**Context battery or cost not updating?**
- The status line updates automatically with each interaction
- Restart Claude Code if values seem frozen

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
2. Edit `~/.claude/settings.json` to remove the statusLine configuration
3. Restart Claude Code

## License

Free to use and modify. Share with other Claude Code users!

## Credits

Custom status line built to track Claude Pro account usage with rolling 5-hour message windows.
