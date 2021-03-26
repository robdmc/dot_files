 # Requires OS_TYPE 

 # If on mac, update paths with mac-specific locations
 if [ "$OS_TYPE" == "mac" ]; then 
   # Update paths to installed brew tools
   binpaths=$(gls -d /usr/local/opt/*/libexec/gnubin/)
   for binpath in $binpaths; do
      export PATH="$binpath:$PATH"
   done

   # Update man paths to brew tools
   manpaths=$(gls -d /usr/local/opt/*/libexec/gnuman/)
   for manpath in $manpaths; do
      export MANPATH="$manpath:$MANPATH"
   done
 
   #  Homebrew directories
   export PATH=/usr/local/bin:$PATH
 
   ## The next couple of lines are for google cli
   ## The google tools should be expanded to the following path on osx /Users/rob/bin/google-cloud-sdk 
   # The next line updates PATH for the Google Cloud SDK.
   if [ -f '/Users/rob/bin/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rob/bin/google-cloud-sdk/path.bash.inc'; fi
   # The next line enables shell command completion for gcloud.
   if [ -f '/Users/rob/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rob/bin/google-cloud-sdk/completion.bash.inc'; fi
 fi

 #  add pwd and home bin area to path
 # export PATH=$HOME/usr/node/bin:$PATH
 # export PATH=$HOME/$GOPATH/bin:$PATH
 export PATH=$HOME/envs/base/bin:$PATH
 export PATH=$HOME/bin:$PATH
 export PATH=./:$PATH


