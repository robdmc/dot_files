 # Helper for putting git branch on bash prompt
 parse_git_branch () {
     export __parse_git_branch__=1
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/( \1 )/'
 }

