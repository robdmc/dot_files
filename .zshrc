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
  alias ls='gls --color=tty' #gls installed from macports coreutils
else
  export PROMPT="<<%n@%m %1~]$ "
  alias ls='ls --color=tty'
fi

#--- allow for backward history search using up arrows
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

##--- make home and end keys work
#bindkey "e[1~" beginning-of-line
#bindkey "e[4~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

#--- allow for tab expansion undo by hitting shift tab
bindkey '^[[Z' undo

#--- set up extended globbing
setopt extended_glob
