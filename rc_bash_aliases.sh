 # set up aliases
 alias less='less -R'
 alias dirs='dirs -v'
 alias ltr='ls -ltr'

 # Only alias the ls command if it doesn't fail
 ls --color=tty >&/dev/null
 if [ $? -eq 0 ]; then
     alias ls=' ls --color=tty' 
 else
     export CLICOLOR=1
     export LSCOLORS=GxFxCxDxBxegedabagaced
 fi

 # Add a tmux alias
 alias robmux='tmux new-session -A -s robmux'
 alias richmux='tmux new-session -A -s richmux'
 alias vandamux='tmux new-session -A -s vandamux'
 alias lilymux='tmux new-session -A -s lilymux'
 alias alecmux='tmux new-session -A -s alecmux'

 # export GOLD_AMBITION_HOME="/Users/rob/rob/gold_repos/ambition" 
 # export GOLD_HISTORY_DIR="$GOLD_AMBITION_HOME/docker_bash_history"
 ## Specific to my day job
 alias gbb='cd /Users/rob/rob/repos/blueberry-monorepo'
 alias gbbetl='cd ~/rob/repos/blueberry_etl/code/airflow/dags/bbetl'
 alias ga='cd /Users/rob/rob/repos/blueberry_analysis'
 alias gw='cd /Users/rob/rob/repos/workbench'
 #alias gp='cd /Users/rob/packages'
 ##alias gadp='lamb.docker shell -p'
 ##alias gad='lamb.docker shell'
 #alias gad='docker-compose -f /Users/rob/ambition/docker-compose.yml run --rm   shell'
 #alias gadp='docker-compose -f /Users/rob/ambition/docker-compose.yml run --rm  --service-ports shell'
 #alias gadpg='(AMBITION_HOME="$GOLD_AMBITION_HOME" lamb.docker shell -p)'
 #alias gadg='(AMBITION_HOME="$GOLD_AMBITION_HOME" lamb.docker shell)'
 ## alias dad='(cp /Users/rob/ambition/docker_bash_history/.bash_history `date +"/Users/rob/docker_history_files/docker_bash_history_%FT%H-%M-%S"`);  cd $AMBITION_HOME && docker-compose down'
 #alias dad='(cp /Users/rob/ambition/.lamb/config/container_bash_history `date +"/Users/rob/docker_history_files/docker_bash_history_%FT%H-%M-%S"`);  cd $AMBITION_HOME && docker-compose down'
 #alias dadg='(cp "$GOLD_HISTORY_DIR/.bash_history" `date +"$GOLD_HISTORY_DIR/docker_bash_history_%FT%H-%M-%S"`); AMBITION_HOME="$GOLD_AMBITION_HOME"  lamb.docker down'
 #alias ldc='docker ps --format "{{.ID}} {{.Names}}"'

 # Specific to machines I frequent
 # alias gm1='ssh -Y rob@miner1'
 # alias gm2='ssh -Y rob@miner2'
 # alias gm1p='ssh -L 8888:localhost:8888 rob@miner1'
 # alias gm2p='ssh -L 8888:localhost:8888 rob@miner2'
 # alias gm1='ssh -Y rob@miner1'
 # alias gm1l='ssh -Y rob@miner1local'
 # alias gm1p='ssh -L 8888:localhost:8888 rob@miner1'
 # alias gm1pl='ssh -L 8888:localhost:8888 rob@miner1local'

 # Jupyter related stuff
 # alias ipywi='BROWSER=open jupyter notebook --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 # alias jup='BROWSER=open jupyter notebook --ip=0.0.0.0 --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 # alias jupl='BROWSER=open jupyter notebook --port=8888 --NotebookApp.iopub_data_rate_limit=10000000000'
 alias jl='(touch .) && ((touch .. >& /dev/null) || true ) && BROWSER=open jupyter-lab --NotebookApp.iopub_data_rate_limit=10000000000'

 alias mo='(touch .) && ((touch .. >& /dev/null) || true ) && marimo edit --watch'


 # Adding aliases to see if I can get python packages to compile
 # If you get weird compile errors maybe comment these out
 alias gcc=gcc-15
 alias g++=g++-15

 # Alias for opening macvim
 # alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

 # Alias for gcalcli
 # alias gc='gcalcli agenda --refresh'
 # alias gcw='gcalcli calw --refresh'
 # alias gcm='gcalcli calm --refresh'
