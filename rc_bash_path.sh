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
 
   # I USED TO DO THIS EXPLICITELY, BUT HAVE MOVED TO GENERAL
   # SOLUTION ABOVE.
   # # Update path for homebrew packages
   # export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
   # export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
   # export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
 
   # # Update manpath for homebrew gnu packages
   # export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
   # export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
   # export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

   #  Homebrew directories
   export PATH=/usr/local/bin:$PATH
 
   ##  add path element to use proper version of postgres
   # export PGDATA="/Users/rob/Library/Application Support/Postgres/var-9.4/"
   # export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
 
   ##  export the goroot directory
   # export GOROOT=/usr/local/go
   # export GOPATH=$HOME/go
 fi

 #  add pwd and home bin area to path
 # export PATH=$HOME/usr/node/bin:$PATH
 # export PATH=$HOME/$GOPATH/bin:$PATH
 export PATH=$HOME/envs/base/bin:$PATH
 export PATH=$HOME/bin:$PATH
 export PATH=./:$PATH

