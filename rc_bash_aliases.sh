 # set up aliases
 alias less='less -R'
 alias dirs='dirs -v'

 # Only alias the ls command if it doesn't fail
 ls --color=tty >&/dev/null
 if [ $? -eq 0 ]; then
     alias ls=' ls --color=tty' 
 else
     export CLICOLOR=1
     export LSCOLORS=GxFxCxDxBxegedabagaced
 fi

 export GOLD_AMBITION_HOME="/Users/rob/rob/gold_repos/ambition" 
 export GOLD_HISTORY_DIR="$GOLD_AMBITION_HOME/docker_bash_history"
 # Specific to my day job
 alias ga='cd /Users/rob/ambition'
 alias gp='cd /Users/rob/packages'
 #alias gadp='lamb.docker shell -p'
 #alias gad='lamb.docker shell'
 alias gad='docker-compose -f /Users/rob/rob/ambition_projects/projects/ambition/docker-compose.yml run --rm   shell'
 alias gadp='docker-compose -f /Users/rob/rob/ambition_projects/projects/ambition/docker-compose.yml run --rm  --service-ports shell'
 alias gadpg='(AMBITION_HOME="$GOLD_AMBITION_HOME" lamb.docker shell -p)'
 alias gadg='(AMBITION_HOME="$GOLD_AMBITION_HOME" lamb.docker shell)'
 alias dad='(cp /Users/rob/ambition/docker_bash_history/.bash_history `date +"/Users/rob/docker_history_files/docker_bash_history_%FT%H-%M-%S"`);  cd $AMBITION_HOME && docker-compose down'
 alias dadg='(cp "$GOLD_HISTORY_DIR/.bash_history" `date +"$GOLD_HISTORY_DIR/docker_bash_history_%FT%H-%M-%S"`); AMBITION_HOME="$GOLD_AMBITION_HOME"  lamb.docker down'
 alias ldc='docker ps --format "{{.ID}} {{.Names}}"'

 # Specific to machines I frequent
 alias gm1='ssh -Y rob@miner1'
 alias gm1l='ssh -Y rob@miner1local'
 alias gm1p='ssh -L 8888:localhost:8888 rob@miner1'
 alias gm1pl='ssh -L 8888:localhost:8888 rob@miner1local'

 # Jupyter related stuff
 alias ipywi='BROWSER=open jupyter notebook --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 alias jup='BROWSER=open jupyter notebook --ip=0.0.0.0 --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 alias jupl='BROWSER=open jupyter notebook --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 alias jl='BROWSER=open jupyter lab --NotebookApp.iopub_data_rate_limit=10000000000'

 # Alias for opening macvim
 alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

 # Alias for gcalcli
 alias gc='gcalcli agenda --refresh'
 alias gcw='gcalcli calw --refresh'
 alias gcm='gcalcli calm --refresh'

