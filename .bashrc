export HISTCONTROL="ignoreboth:erasedups"
 # This entire file indented one line so history ignores it

 # Determine the way this shell is being run
 if [[ -n $PS1 ]]; then
     : # These are executed only for interactive shells
     SHELL_IS_INTERACTIVE=1
 else
     : # Only for NON-interactive shells
     SHELL_IS_INTERACTIVE=0
 fi
 
 if shopt -q login_shell ; then
     : # These are executed only when it is a login shell
     SHELL_IS_LOGIN=1
 else
     : # Only when it is NOT a login shell
     SHELL_IS_LOGIN=0
 fi


 # Determine the type of os being run 
 # uname_type=$(uname)  DELETE DELETE
 # mac_type="Darwin" DELETE DELETE
 if [ "$(uname)" == "Darwin" ]; then 
     export OS_TYPE="mac"
 else
     # This indicates running on some type of linux
     export OS_TYPE="linux"
 fi

 # Source the functions file.
 # If you see a command in below that you don't recognize, look in
 # the function definition file.
 source ~/dot_files/rc_bash_functions.sh

 # Set up the path
 source_if_exists ~/dot_files/rc_bash_path.sh

 # Set up aliases
 source_if_exists ~/dot_files/rc_bash_aliases.sh

 # Set up prompt
 source_if_exists ~/dot_files/rc_bash_prompt.sh

 # Set up default conda env
 source_if_exists ~/dot_files/rc_conda_default.sh

 # Determine if brew is installd
 if [ -x "$(command -v brew)" ]; then
     export HAS_BREW=1
 else
     export HAS_BREW=0
 fi

 
 # Make sure the vim backup directory exists
 mkdir -p ~/.vim_backups
 
 # Disable shell meanings of ctrl-s and ctrl-q
 stty stop '' >& /dev/null
 stty start '' >& /dev/null
 
 # Set up utf8 console
 export LC_ALL=en_US.UTF-8
 export LANG=en_US.UTF-8
 export LANGUAGE=en_US.UTF-8
 
 # Make sure the umask is set properly
 # umask 027 (writable only by owner, readable/executable only by group)
 # umask 002 (read-write by owner and group, read/execute by world)
 # umask 007 (read-write by owner and group, no access to others)
 umask 002
 
 # Set up terminal working preferences
 shopt -s histappend
 shopt -s extglob
 export EDITOR=vim
 export HISTFILE="$HOME/.bash_history"
 export HISTFILESIZE=20000
 export HISTSIZE=20000
 export HISTIGNORE="clear:ls:pwd:history:hig:say"
 export HISTTIMEFORMAT='%F %T '
 set -o vi
 
 # Save history after each command, but only if this an interactive shell
 if [ $SHELL_IS_INTERACTIVE -eq 1 ]; then 
     export PROMPT_COMMAND="history -a; history -c; history -r;"
 fi
 
 # Default to making nose test be less chatty 
 export NOSE_NOLOGCAPTURE=1
 
 # --- print any existing reminders to the console
 if [ -f ~/reminders.txt ]
 then
     cat ~/reminders.txt
 fi
 
 # Setup bash completion (for git)
 if [ "$OS_TYPE" == "mac" ]; then 
     if [ "$HAS_BREW" -eq 1 ]; then 
         if [ -f $(brew --prefix)/etc/bash_completion ]; then
             . $(brew --prefix)/etc/bash_completion
         fi
     fi
 fi
 
 # If history file doesn't exist, create it
 touch "$HISTFILE"

 # Source all existig bash hooks defined by ~/bash_hooks/*.sh
 source_bash_hooks

 # This is needed to run jax on mac gpu
 export ENABLE_PJRT_COMPATIBILITY=1

 # Make compiling default to the homebrew compiler
 # If you get weird compile errors maybe unset these
 export CC=/opt/homebrew/opt/gcc/bin/gcc-15
 export CXX=/opt/homebrew/opt/gcc/bin/g++-15


 # # Override default terminal behavior for working with ugrep
 # stty dsusp undef
 # stty status undef

 
 
