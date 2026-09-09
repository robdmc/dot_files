 # Helper for putting git branch on bash prompt
 parse_git_branch () {
     export __parse_git_branch__=1
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/( \1 )/'
 }

 # Function to start marimo touching directory
 function mo() {
    dir_logger.py "$PWD"
    command marimo edit --watch "$@"  # 'command' bypasses functions/aliases
 }

 function ltd() {
     cd  "$(ltr.py | sed 's%/Users/rob%~%' | fzf --tac | awk '{print $3}'| sed 's%~%/Users/rob%')"
 }

 # function ltr() {
 #     ltr.py | sed 's%/Users/rob%~%' | fzf --tac 
 # }

 function lta() {
     dir_logger.py "$PWD"
 }

 # Function to fuzzyfind files to open with vim
 function vimf() (
     # declare shortcuts for vimf
     declare -A lookup
     lookup[animal]="/packages/django-animal"
     lookup[entity]="/packages/django-entity"
     lookup[ambition_score]="/packages/ambition_score"
     lookup[score]="/packages/ambition_score"
 
     # default search directory to current github root or current
     start_dir=`git rev-parse --show-toplevel 2>/dev/null || pwd`
 
     # override default with shortcut
     if [ -n "$1" ]; then
         start_dir=${lookup[${1}]}
     fi
 
     # if start directory not null then run vim
     if [ -n "$start_dir" ]; then
 
         cd $start_dir
         output=`ag -g '.*' | fzf`
         if [ -n "$output" ]; then
             vim "$output"
         fi
     # for unrecognized shortcuts, show options
     else
         echo
         echo Allowed shortcuts
         echo -----------------------------
         for key in "${!lookup[@]}"; do echo "$key -> ${lookup[$key]}"; done
     fi
 )

 # Function to log into a docker container
 function gdc () { 
     docker exec -it "$1" /bin/bash 
 }

 # Function to source a file if it exists
 function source_if_exists () { 
     if [ -f "$1" ]; then
        . "$1"
     fi
 }

 # Function to source all files in a directory
 function source_bash_hooks () { 
     set +o history
     if compgen -G "$HOME/bash_hooks/*.sh" > /dev/null; then
         for hook in `ls ~/bash_hooks/*.sh`
         do
             source_if_exists $hook
         done
     fi
     set -o history
 }

vicd()
{
    # No idea what this came from.  might want to delete it.
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

# This is copied from https://github.com/aykamko/tag
if hash rg 2>/dev/null; then
  export TAG_SEARCH_PROG=rg  # replace with rg for ripgrep
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null; }
  # alias rg=tag  # replace with rg for ripgrep
fi


 # Herdr session helpers
 #   H            attach to (or start) the default session
 #   H <name>     attach to (or create) a named session
 #   Hl           list sessions (status color-coded: green=running, red=stopped)
 #   Hs           stop ALL running sessions (asks first)
 #   Hs <name>    stop one session (asks first); errors if no session has that name
 #   Hk           stop ALL running sessions, then delete them (asks first)
 #   Hk <name>    stop one session, then delete it (asks first); errors if no session has that name
 function H() {
     if [ $# -eq 0 ]; then
         command herdr
     else
         command herdr --session "$@"
     fi
 }

 function Hl() {
     # Plain passthrough for --json, non-tty (pipes/redirects), or NO_COLOR.
     case " $* " in *" --json "*) command herdr session list "$@"; return ;; esac
     if [ ! -t 1 ] || [ -n "${NO_COLOR:-}" ]; then
         command herdr session list "$@"
         return
     fi
     command herdr session list "$@" | awk '
         BEGIN { grn="\033[32m"; red="\033[31m"; dim="\033[33m"; off="\033[0m" }
         NR == 1 { print; next }
         NF < 2  { print; next }
         {
             col = ($2 == "running") ? grn : (($2 == "stopped") ? red : dim)
             # Insert escapes around field 2 only, found after the end of field 1,
             # so a session literally named "running" cannot be recolored.
             p = index($0, $1) + length($1)
             rest = substr($0, p)
             q = index(rest, $2)
             printf "%s%s%s%s%s%s\n", substr($0, 1, p - 1), substr(rest, 1, q - 1), \
                 col, $2, off, substr(rest, q + length($2))
         }'
 }

 function Hs() {
     local targets n ans
     if [ $# -eq 0 ]; then
         targets=$(command herdr session list --json | jq -r '.sessions[] | select(.running) | .name') || return 1
         if [ -z "$targets" ]; then
             echo "Hs: no running herdr sessions" >&2
             return 1
         fi
     else
         targets=$(command herdr session list --json | jq -r '.sessions[].name') || return 1
         if ! printf '%s\n' "$targets" | grep -qx -- "$1"; then
             echo "Hs: no herdr session named '$1'" >&2
             return 1
         fi
         targets="$1"
     fi
     echo "This will stop these herdr sessions and every process in their panes:"
     printf '  %s\n' $targets
     read -r -p "Continue? [y/N] " ans
     case "$ans" in
         y|Y) ;;
         *) echo "Hs: aborted" >&2; return 1 ;;
     esac
     for n in $targets; do
         command herdr session stop "$n"
     done
 }

 function Hk() {
     local targets n ans
     if [ $# -eq 0 ]; then
         targets=$(command herdr session list --json | jq -r '.sessions[].name') || return 1
         if [ -z "$targets" ]; then
             echo "Hk: no herdr sessions" >&2
             return 1
         fi
     else
         targets=$(command herdr session list --json | jq -r '.sessions[].name') || return 1
         if ! printf '%s\n' "$targets" | grep -qx -- "$1"; then
             echo "Hk: no herdr session named '$1'" >&2
             return 1
         fi
         targets="$1"
     fi
     echo "This will stop AND DELETE these herdr sessions and every process in their panes:"
     printf '  %s\n' $targets
     read -r -p "Continue? [y/N] " ans
     case "$ans" in
         y|Y) ;;
         *) echo "Hk: aborted" >&2; return 1 ;;
     esac
     local running
     running=$(command herdr session list --json | jq -r '.sessions[] | select(.running) | .name') || return 1
     for n in $targets; do
         if printf '%s\n' "$running" | grep -qx -- "$n"; then
             command herdr session stop "$n"
         fi
         command herdr session delete "$n"
     done
 }
