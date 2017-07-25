# dont record bashrc in history
set +o history

# make sure the vim backup directory exists
mkdir -p ~/.vim_backups

# ---  SEE THE FOLLOWING REFERENCE FOR HOW TO CHANGE BASH PROMPT
#http://news.softpedia.com/news/How-to-Customize-the-Shell-Prompt-40033.shtml

# --- disable shell meanings of ctrl-s and ctrl-q
stty stop '' >& /dev/null
stty start '' >& /dev/null

# --- make sure autolist is set
#set autolist

# --- set up utf8 console
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# --- get the uname type for this machine and define mac type
unameType=$(uname)
macType="Darwin"

# --- add pwd and home bin area to path
export PATH=$HOME/bin/:./:$PATH

# --- increase ulimit so mongodb doesn't complain
ulimit -n 2048

# --- example code for testing if this is a mac or not
#if [ "$unameType" == "$macType" ]; then 
#   echo this is a mac
#   echo yes it is
#else 
#   echo this is not a mac
#fi
#echo $unameType
#echo $macType

# --- make sure the umask is set properly
# umask 027 (writable only by owner, readable/executable only by group)
# umask 002 (read-write by owner and group, read/execute by world)
# umask 007 (read-write by owner and group, no access to others)
umask 002

# --- set up terminal working preferences
shopt -s histappend
shopt -s extglob
export EDITOR=vim
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=20000
export HISTSIZE=20000
export HISTIGNORE="clear:ls:pwd:history:hig"
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL="ignoredups:erasedups"
set -o vi

# --- save history after each command
export PROMPT_COMMAND="history -a; history -c; history -r;"

# --- define some color escape codes
grey='\[\033[1;30m\]'
red='\[\033[0;31m\]'
RED='\[\033[1;31m\]'
green='\[\033[0;32m\]'
GREEN='\[\033[1;32m\]'
yellow='\[\033[0;33m\]'
YELLOW='\[\033[1;33m\]'
purple='\[\033[0;35m\]'
PURPLE='\[\033[1;35m\]'
white='\[\033[0;37m\]'
WHITE='\[\033[1;37m\]'
blue='\[\033[0;34m\]'
BLUE='\[\033[1;34m\]'
cyan='\[\033[0;36m\]'
CYAN='\[\033[1;36m\]'
NC='\[\033[0m\]'

# --- this function aides the prompt to show the current git branch
parse_git_branch () {
       git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/( \1 )/'
}

# --- set the appropriate prompt for the system you're on
if [ "$unameType" == "$macType" ]; then 

  # --- update path for homebrew packages
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

  # --- update manpath for homebrew gnu packages
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
  export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
  prompt_host="mac"

  # original
  #PS1='<mac \W]\$ '
else

  # original
  #PS1='<\h \W]\$ '

  prompt_host="linux"

fi

PS1="$grey[${green}${prompt_host}${grey}][$BLUE\t$grey]\$(parse_git_branch)[$cyan \w $grey$grey]$NC\n${PURPLE}λ$NC "


# --- initialize boot2docker environment vars if docker is running
if  type boot2docker >& /dev/null; then
    if [ `boot2docker status` = "running" ]; then
        eval "$(boot2docker shellinit)"
    fi
fi

# --- set up aliases
alias ls=' ls --color=tty' 
alias less='less -R'
alias dirs='dirs -v'
alias pdb='python -m pdb '
alias pdbrc='vim .pdbrc'
alias govagrant='(cd /Users/rob/rob/vagrant_boxes/ambition-vagrant; vagrant ssh -- -A)'
alias upvagrant='(cd /Users/rob/rob/vagrant_boxes/ambition-vagrant && git pull upstream master && vagrant up)'
alias downvagrant='(cp /Users/rob/rob/vagrant_boxes/ambition-vagrant/shared_ambition_vagrant/.bash_history `date +"/Users/rob/vagrant_history_files/vagrant_bash_history_%FT%H-%M-%S"`);  (cd /Users/rob/rob/vagrant_boxes/ambition-vagrant && vagrant halt)'
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

# gad=(go ambition docker)   dad=(down ambition docker) ldc=(list docker containers) gdc=(go docker container)
alias ga='cd /Users/rob/ambition'
alias gp='cd /Users/rob/packages'
alias gadp='(cd /Users/rob/ambition; docker-compose run --rm  --service-ports shell)'
alias gad='(cd /Users/rob/ambition; docker-compose run --rm shell)'
alias dad='(cp /Users/rob/ambition/docker_bash_history/.bash_history `date +"/Users/rob/docker_history_files/docker_bash_history_%FT%H-%M-%S"`);  (cd /Users/rob/ambition; docker-compose down)'
alias ldc='docker ps --format "{{.ID}} {{.Names}}"'
function gdc() { 
    docker exec -it "$1" /bin/bash 
}

# --- define mac specific stuff
if [ "$unameType" == "$macType" ]; then 
  # --- ipython notebook aliases
  alias ipywi='BROWSER=open jupyter notebook --NotebookApp.iopub_data_rate_limit=10000000000'

  # --- macports directories (in case they exists)
  export PATH=/opt/local/libexec/gnubin/:$PATH
  export PATH=.:/opt/local/bin:/opt/local/sbin:$PATH

  # --- homebrew directories (in case they exist)
  export PATH=/usr/local/bin:$PATH

  # --- add path element to use proper version of postgres
  export PGDATA="/Users/rob/Library/Application Support/Postgres/var-9.4/"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

  # --- export the goroot directory
  export GOROOT=/usr/local/go

# --- define linux specific stuff
else
  doNothing=""
fi

# --- add my personal stuff to the path
export PATH=$HOME/bin:$HOME/usr/bin:$PATH
export PATH=$HOME/usr/python/bin:$PATH
export PATH=$HOME/usr/node/bin:$PATH

# --- default to making nose test be less chatty 
export NOSE_NOLOGCAPTURE=1

# --- print any existing reminders to the console
if [ -f ~/reminders.txt ]
then
    cat ~/reminders.txt
fi

# --- setup bash completion (for git)
if [ "$unameType" == "$macType" ]; then 
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# --- make useful iterm2 commands
tab_name() { echo -e "\033];${1}\007"; }
task_done() { echo __task_done__ ${1};}  # Set iterm2 trigger to cath this 


# --- if history file doesn't exist, create it
touch .bash_history

# I don't actually like fuzzyfinder's bash shortcuts, but uncomment this to activate them
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# this was automatically added by iterm2 shell integration to .bash_profile.  I'm adding it here.
# shell integration does funny things to vim search mode, so commentint it out
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# turn on history
set -o history


