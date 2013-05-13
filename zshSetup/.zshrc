#--- disable shell meanings of ctrl-s and ctrl-q
stty stop '' >& /dev/null
stty start '' >& /dev/null

#--- make sure autolist is set
#set autolist


#--- set up terminal working preferences
#shopt -s histappend
#shopt -s extglob

#export HISTFILE="$HOME/.zsh_history"
#export HISTFILESIZE=200000
#export HISTSIZE=200000
#export HISTIGNORE="clear:ls:pwd:history:hig"
#export HISTTIMEFORMAT='%F %T '

HISTFILE=$HOME/.zsh_history    # enable history saving on shell exit
setopt APPEND_HISTORY          # append rather than overwrite history file.
HISTSIZE=100000                # lines of history to maintain memory
SAVEHIST=100000                # lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST  # allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY        # save timestamp and runtime information








export EDITOR=vim

autoload -U compinit
compinit
setopt completeinword

autoload select-word-style
select-word-style shell

alias ls='ls -G'
export PROMPT="<<%n@%m %1~]$ "


set -o vi
#set -o history


#export PROMPT_COMMAND="history -a; history -c; history -r;"

##--- set the appropriate prompt for the system you're on
#if [ "$unameType" == "$macType" ]; then 
#  PS1='<\u@mac \W]\$ '
#else
#  PS1='<\h \W]\$ '
#fi

#alias ls='ls --color=tty'

#alias higa="history | grep "
#alias hig="history | grep $(date +%F)  | grep "
#alias less='less -R'
#alias dirs='dirs -v'


##--- clear out .bashrc commands from history
#history -c
##--- if history file doesn't exist, create it
#[ -f $HOME/.bash_history ] || history -w
#
##--- reload history file into buffer
#history -r





  



