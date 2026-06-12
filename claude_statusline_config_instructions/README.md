# Claude Code Custom Status Line

A custom status line for Claude Code that provides at-a-glance session tracking.

## What This Does

This status line displays real-time information about your Claude Code session:

```
Opus 4.8 | high | [████████░░] 23% | dot_files/myproject |  main
```

**Features:**
- **Model name**: Which Claude model you're using
- **Effort level**: The model's effort/reasoning level (`low`/`medium`/`high`/`xhigh`/`max`) — hidden when the model doesn't support effort
- **Context battery**: Visual indicator of context window usage (10 segments)
- **Directory path**: Your current directory plus its parent (e.g. `dot_files/myproject`)
- **Git branch**: The current branch — shown only when you're inside a git repository

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
2. **Send messages** - Context battery fills as the conversation grows
3. **Watch it work** - The status line updates as your conversation progresses

## Example Status Line Evolution

**Fresh conversation:**
```
Opus 4.8 | high | [░░░░░░░░░░] 0% | dot_files/myproject |  main
```

**After a few messages:**
```
Opus 4.8 | high | [██░░░░░░░░] 8% | dot_files/myproject |  main
```

**Active development session:**
```
Opus 4.8 | high | [██████░░░░] 47% | code/backend |  feature-x
```

**Outside a git repo (branch segment hidden):**
```
Sonnet 4.5 | [█████████░] 89% | home/webapp
```

## Notes on Segments

**Effort level:**
- Reads `.effort.level` from the session JSON (`low`/`medium`/`high`/`xhigh`/`max`)
- Updates live if you change it mid-session (e.g. with `/effort`)
- Hidden entirely when the current model doesn't expose an effort level

**Context Battery:**
- **Technical limit**: Model's memory capacity (how much it can remember)
- **Token-based**: Long messages or large files fill it faster
- **Tells you when**: Conversation needs to be reset due to context limits
- **Visual indicator**: Easy to see at a glance how much capacity you've used

**Git branch:**
- Runs `git -C <cwd> rev-parse --abbrev-ref HEAD` against your current directory
- Shown only when that directory is inside a git repository; blank otherwise

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

**Context battery not updating?**
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

Custom status line for Claude Code showing model, effort level, context usage, directory, and git branch.
