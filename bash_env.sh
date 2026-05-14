# Sourced by non-interactive bash via BASH_ENV
# Prevents Claude Code from polluting history
if [ -n "$CLAUDECODE" ]; then
    unset HISTFILE
fi
