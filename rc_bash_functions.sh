 # Helper for putting git branch on bash prompt
 parse_git_branch () {
     export __parse_git_branch__=1
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/( \1 )/'
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
     if [ -d ~/bash_hooks ]; then
         for hook in `ls ~/bash_hooks/*.sh`
         do
             source_if_exists $hook
         done
     fi
     set -o history
 }
