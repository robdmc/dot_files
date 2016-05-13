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
export HISTFILESIZE=200000
export HISTSIZE=200000
export HISTIGNORE="clear:ls:pwd:history:hig"
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL="ignoredups:erasedups"
set -o vi
set -o history

# --- save history after each command
export PROMPT_COMMAND="history -a; history -c; history -r;"

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

  PS1='<mac \W]\$ '
else
  PS1='<\h \W]\$ '
fi

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
alias downvagrant='(cd /Users/rob/rob/vagrant_boxes/ambition-vagrant && vagrant halt)'

# --- define mac specific stuff
if [ "$unameType" == "$macType" ]; then 
  # --- ipython notebook aliases
  alias ipyw='jupyter notebook'
  alias ipywi='jupyter notebook'

  # --- macports directories (in case they exists)
  export PATH=/opt/local/libexec/gnubin/:$PATH
  export PATH=.:/opt/local/bin:/opt/local/sbin:$PATH

  # --- homebrew directories (in case they exist)
  export PATH=/usr/local/bin:$PATH

  # --- add path element to use proper version of postgres
  export PGDATA="/Users/rob/Library/Application Support/Postgres/var-9.4/"
  export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

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

# --- KEEP THESE HISTORY COMMANDS AT END OF FILE
# --- clear out .bashrc commands from history
history -c

# --- if history file doesn't exist, create it
[ -f $HOME/.bash_history ] || history -w

# --- reload history file into buffer
history -r

# --- make useful iterm2 commands
tab_name() { echo -e "\033];${1}\007"; }
task_done() { echo __task_done__ ${1};}  # Set iterm2 trigger to cath this 
