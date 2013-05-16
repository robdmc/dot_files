#--- disable shell meanings of ctrl-s and ctrl-q
stty stop '' >& /dev/null
stty start '' >& /dev/null

HISTFILE=$HOME/.zsh_history    # enable history saving on shell exit
setopt APPEND_HISTORY          # append rather than overwrite history file.
HISTSIZE=1000000               # lines of history to maintain memory
SAVEHIST=1000000               # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information
setopt SHARE_HISTORY           #share history among shells
setopt HIST_IGNORE_SPACE       #ignore commands that start with a space

#--- alias hist-ignore commands to start with a space
alias clear=' clear'
alias pwd=' pwd'
alias history=' history'

#--- set editor preference
export EDITOR=vim

#--- set up autocompletion
autoload -U compinit
compinit
setopt completeinword
zstyle ':completion:*' menu select

#--- allow for opening command line in editor
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#--- set up zmv
autoload -U zmv

#I think this selects what is defined as a word for movement
autoload select-word-style
select-word-style bash

#--- make it so that cd issues a pushd
setopt AUTO_PUSHD

#--- allow interactive commenting
setopt INTERACTIVE_COMMENTS

#--- make dirs automatically show numbers
alias dirs='dirs -v'

#--- set prompt and ls colors based on type of system
macType="Darwin"
unameType=$(uname)
if [ "$unameType" = "$macType" ]; then 
  export PROMPT="<<%n@mac %1~]$ "
  alias ls=' gls --color=tty' #gls installed from macports coreutils
else
  export PROMPT="<<%n@%m %1~]$ "
  alias ls=' ls --color=tty'
fi

#--- set up extended globbing
setopt extended_glob

##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
##    I don't understand any of this, but it should get home/end keys working
##    Copied from: https://wiki.archlinux.org/index.php/Zsh#Key_bindings
#
## create a zkbd compatible hash;
## # to add other keys to this hash, see: man 5 terminfo
#typeset -A key
#
#key[Home]=${terminfo[khome]}
#
#key[End]=${terminfo[kend]}
#key[Insert]=${terminfo[kich1]}
#key[Delete]=${terminfo[kdch1]}
#key[Up]=${terminfo[kcuu1]}
#key[Down]=${terminfo[kcud1]}
#key[Left]=${terminfo[kcub1]}
#key[Right]=${terminfo[kcuf1]}
#key[PageUp]=${terminfo[kpp]}
#key[PageDown]=${terminfo[knp]}
#
## setup key accordingly
#[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
#[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
#[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
#[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
#[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
#[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
#[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
#[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
#
## Finally, make sure the terminal is in application mode, when zle is
## active. Only then are the values from $terminfo valid.
#if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
#    function zle-line-init () {
#        printf '%s' "${terminfo[smkx]}"
#    }
#    function zle-line-finish () {
#        printf '%s' "${terminfo[rmkx]}"
#    }
#    zle -N zle-line-init
#    zle -N zle-line-finish
#fi
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#--- allow for backward history search using up arrows
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

#--- allow for tab expansion undo by hitting shift tab
bindkey '^[[Z' undo



