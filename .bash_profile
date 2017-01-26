if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# this was automatically added by iterm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
