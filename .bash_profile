if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# Let non-interactive bash (e.g. Claude Code) source this on startup
export BASH_ENV=~/dot_files/bash_env.sh
