 # set up aliases
 alias less='less -R'
 alias dirs='dirs -v'

 # Only alias the ls command if it doesn't fail
 ls --color=tty > /dev/null
 if [ $? -eq 0 ]; then
     alias ls=' ls --color=tty' 
 fi

 # Specific to my day job
 alias ga='cd /Users/rob/ambition'
 alias gp='cd /Users/rob/packages'
 alias gadp='lamb.docker shell -p'
 alias gad='lamb.docker shell'
 alias dad='(cp /Users/rob/ambition/docker_bash_history/.bash_history `date +"/Users/rob/docker_history_files/docker_bash_history_%FT%H-%M-%S"`);  lamb.docker down'
 alias ldc='docker ps --format "{{.ID}} {{.Names}}"'

 # Specific to machines I frequent
 alias gm1='ssh -p 2221 rob@miner1'
 alias gm2='ssh -p 2222 rob@miner2'
 alias gm1r='ssh -p 2221 rob@minerr'
 alias gm2r='ssh -p 2222 rob@minerr'

 # Jupyter related stuff
 alias ipywi='BROWSER=open jupyter notebook --NotebookApp.iopub_data_rate_limit=10000000000'

