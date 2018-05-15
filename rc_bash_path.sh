 # Requires OS_TYPE 

 # If on mac, update paths with mac-specific locations
 if [ "$OS_TYPE" == "mac" ]; then 
 
   # Update path for homebrew packages
   export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
   export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
   export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
 
   # Update manpath for homebrew gnu packages
   export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
   export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
   export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

   # --- Homebrew directories
   export PATH=/usr/local/bin:$PATH
 
   # --- Locally running python env
   export PATH=/env/base/bin:$PATH
 
   ## --- add path element to use proper version of postgres
   # export PGDATA="/Users/rob/Library/Application Support/Postgres/var-9.4/"
   # export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
 
   ## --- export the goroot directory
   # export GOROOT=/usr/local/go
   # export GOPATH=$HOME/go
 fi

 # --- add pwd and home bin area to path
 export PATH=$HOME/usr/python/bin:$PATH
 export PATH=$HOME/usr/node/bin:$PATH
 export PATH=$HOME/$GOPATH/bin:$PATH
 export PATH=$HOME/bin:$HOME/usr/bin:$PATH
 export PATH=./:$PATH

