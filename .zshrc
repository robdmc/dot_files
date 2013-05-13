#--- disable shell meanings of ctrl-s and ctrl-q
stty stop '' >& /dev/null
stty start '' >& /dev/null

HISTFILE=$HOME/.zsh_history    # enable history saving on shell exit
setopt APPEND_HISTORY          # append rather than overwrite history file.
HISTSIZE=100000                # lines of history to maintain memory
SAVEHIST=100000                # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information

#--- set editor preference
export EDITOR=vim

#--- set up autocompletion
autoload -U compinit
compinit
setopt completeinword

#I think this is for emacs mode so you can delete it if you want??
#autoload select-word-style
#select-word-style shell

#--- make it so that cd issues a pushd
setopt AUTO_PUSHD

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
