# ============================================================
# ENVIRONMENT — runs for ALL shells (interactive and non-interactive)
# ============================================================

# Determine the type of OS
if [ "$(uname)" == "Darwin" ]; then
    export OS_TYPE="mac"
else
    export OS_TYPE="linux"
fi

# Source the functions file (needed by source_if_exists below)
source ~/dot_files/rc_bash_functions.sh

# Set up the path
source_if_exists ~/dot_files/rc_bash_path.sh

# Set up default conda/uv env variables
source_if_exists ~/dot_files/rc_conda_default.sh

# UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Umask: read-write by owner and group, read/execute by world
umask 002

# Editor
export EDITOR=vim

# Compiler defaults (homebrew gcc)
# If you get weird compile errors, unset these
export CC=/opt/homebrew/opt/gcc/bin/gcc-15
export CXX=/opt/homebrew/opt/gcc/bin/g++-15

# JAX on mac GPU
export ENABLE_PJRT_COMPATIBILITY=1

# Nose test logging
export NOSE_NOLOGCAPTURE=1

# Determine if brew is installed
if [ -x "$(command -v brew)" ]; then
    export HAS_BREW=1
else
    export HAS_BREW=0
fi

# ============================================================
# EARLY EXIT — everything below is interactive-only
# ============================================================
[[ $- != *i* ]] && return

# Wrap interactive setup in a function so nothing leaks into history
_bashrc_interactive_setup() {
    # Prevent Claude Code bash sessions from polluting history
    if [ -n "$CLAUDECODE" ]; then
        unset HISTFILE
    fi

    # History
    export HISTCONTROL="ignoreboth:erasedups"
    shopt -s histappend
    export HISTFILE="$HOME/.bash_history"
    export HISTFILESIZE=20000
    export HISTSIZE=20000
    HISTIGNORE="clear:ls:pwd:history:hig:say:set -*:shopt -*:alias --*:if ! command -v*:export *:# *"
    export HISTTIMEFORMAT='%F %T '

    # Save/reload history after each command (skip for Claude Code)
    if [ -z "$CLAUDECODE" ]; then
        export PROMPT_COMMAND="history -a; history -c; history -r;"
    fi

    # If history file doesn't exist, create it
    [ -n "$HISTFILE" ] && touch "$HISTFILE"

    # Shell options
    shopt -s extglob
    set -o vi

    # Aliases
    source_if_exists ~/dot_files/rc_bash_aliases.sh

    # Prompt
    source_if_exists ~/dot_files/rc_bash_prompt.sh

    # Disable shell meanings of ctrl-s and ctrl-q
    stty stop '' 2>/dev/null
    stty start '' 2>/dev/null

    # Make sure the vim backup directory exists
    mkdir -p ~/.vim_backups

    # Bash completion (for git, etc.)
    if [ "$OS_TYPE" == "mac" ] && [ "$HAS_BREW" -eq 1 ]; then
        _brew_prefix="$(brew --prefix)"
        if [ -f "${_brew_prefix}/etc/bash_completion" ]; then
            . "${_brew_prefix}/etc/bash_completion"
        fi
        unset _brew_prefix
    fi

    # Zoxide (replaces cd)
    eval "$(zoxide init --cmd cd bash)"

    # Source all existing bash hooks defined by ~/bash_hooks/*.sh
    source_bash_hooks

    # Print any existing reminders
    if [ -f ~/reminders.txt ]; then
        cat ~/reminders.txt
    fi
}
_bashrc_interactive_setup
unset -f _bashrc_interactive_setup
history -c
history -r
