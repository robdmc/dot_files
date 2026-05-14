# =============================================================================
# Portable bash/zsh prompt — drop-in block, safe to paste into ~/.bashrc or ~/.zshrc
# =============================================================================
#
# ----- INSTRUCTIONS FOR CLAUDE CODE -------------------------------------------
# If the user asks you to "install this prompt", follow these steps:
#
#   1. Detect the user's interactive shell from $SHELL (fall back to asking).
#         zsh  -> candidate files: ~/.zshrc, ~/.zprofile
#         bash -> candidate files: ~/.bashrc, ~/.bash_profile, ~/.profile
#
#   2. Pick the target file by following the user's existing convention rather
#      than imposing one. Inspect the candidate files that exist and choose:
#         a. If exactly one candidate exists, use it.
#         b. If multiple exist, prefer the file that already contains
#            interactive setup (PS1, aliases, shopt, HISTSIZE, etc.).
#            - Common bash convention A: heavy ~/.bashrc, thin ~/.bash_profile
#              that just sources ~/.bashrc. Install into ~/.bashrc.
#            - Common bash convention B: everything in ~/.bash_profile
#              (frequent on macOS since Terminal.app runs login shells).
#              Install into ~/.bash_profile.
#         c. If candidates exist but none contain interactive setup, ASK the
#            user which file to use; do not guess.
#         d. If no candidate exists, ASK before creating one.
#      Do NOT silently restructure the user's dotfiles (e.g. don't move their
#      setup from .bash_profile into a new .bashrc just to fit convention A).
#
#   3. Make a timestamped backup of the target file before modifying:
#         cp "$TARGET" "$TARGET.bak.$(date +%Y%m%d-%H%M%S)"
#
#   4. Check whether the target file already contains the marker line
#         "# >>> portable-prompt >>>"
#      - If yes: replace everything between the BEGIN and END markers.
#      - If no:  append the full block (markers + body) to the end of the file.
#
#   5. Do NOT remove or edit any prompt-setting code that lives outside the
#      markers without first confirming with the user. If you see an existing
#      PS1 assignment outside the markers, point it out and ask whether to
#      remove it (otherwise it may override this block depending on order).
#
#   6. After editing, tell the user to run `source <target-file>` (or open a
#      new shell) to see the change. Do not source it yourself.
#
# The block to insert/replace is everything between the BEGIN/END markers below.
# ------------------------------------------------------------------------------

# >>> portable-prompt >>> BEGIN  (do not edit this marker line)
# Portable prompt — works in bash and zsh. Reproduces:
#   [machine][HH:MM:SS]( branch )[ /cwd ]
#   λ

# Helper: print "( branch )" if inside a git repo, nothing otherwise.
# POSIX-compatible so the same function works in both shells.
parse_git_branch() {
    local b
    b=$(git symbolic-ref --short HEAD 2>/dev/null) || \
    b=$(git rev-parse --short HEAD 2>/dev/null)    || return 0
    printf '( %s )' "$b"
}

# Machine label shown at the left of the prompt.
# Defaults to $OS_TYPE if set, else `uname` lowercased. Override by exporting
# MACHINE_NAME before this block runs (e.g. MACHINE_NAME=laptop).
: "${MACHINE_NAME:=${OS_TYPE:-$(uname | tr '[:upper:]' '[:lower:]')}}"

# Build PS1 with the escape syntax appropriate to the current shell.
if [ -n "$ZSH_VERSION" ]; then
    # zsh: enable command substitution in prompts so $(parse_git_branch) re-runs
    # every redraw. %F{color}/%f = color on/off, %* = HH:MM:SS, %~ = cwd.
    setopt PROMPT_SUBST
    PS1='%F{black}[%F{green}'"$MACHINE_NAME"'%F{black}][%F{blue}%*%F{black}]$(parse_git_branch)[%F{cyan} %~ %F{black}]%f'$'\n''%F{magenta}λ%f '
elif [ -n "$BASH_VERSION" ]; then
    # bash: \[...\] wraps non-printing bytes so readline computes width
    # correctly; \t = HH:MM:SS, \w = cwd. Color codes are raw ANSI escapes.
    __pp_grey=$'\[\033[1;30m\]'
    __pp_green=$'\[\033[0;32m\]'
    __pp_blue=$'\[\033[1;34m\]'
    __pp_cyan=$'\[\033[0;36m\]'
    __pp_purple=$'\[\033[1;35m\]'
    __pp_nc=$'\[\033[0m\]'
    PS1="${__pp_grey}[${__pp_green}${MACHINE_NAME}${__pp_grey}][${__pp_blue}\t${__pp_grey}]\$(parse_git_branch)[${__pp_cyan} \w ${__pp_grey}]${__pp_nc}\n${__pp_purple}λ${__pp_nc} "
    unset __pp_grey __pp_green __pp_blue __pp_cyan __pp_purple __pp_nc
fi
# <<< portable-prompt <<< END    (do not edit this marker line)
