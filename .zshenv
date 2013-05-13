
#--- get the uname type for this machine and define mac type
unameType=$(uname)
macType="Darwin"

#--- add pwd and home bin area to path
export PATH=$HOME/bin/:./:$PATH
export PATH=$PATH:$HOME/local/dataProductivityToolkit

#--- export the goroot directory
export GOROOT=/usr/local/go

#--- make sure the umask is set properly
# umask 027 (writable only by owner, readable/executable only by group)
# umask 002 (read-write by owner and group, read/execute by world)
# umask 007 (read-write by owner and group, no access to others)
umask 002

#--- define mac specific stuff
if [ "$unameType" = "$macType" ]; then 
  alias ipy='ipython qtconsole --pylab'
  alias ipyw='ipython notebook --pylab inline'
  export PATH=/opt/local/libexec/gnubin/:$PATH
  export PATH=.:/opt/local/bin:/opt/local/sbin:$PATH
  export PATH=$HOME/bin:$HOME/usr/bin:$PATH
  export PATH=$HOME/usr/python/bin:$PATH
  export PATH=$HOME/usr/node/bin:$PATH
#--- define linux specific stuff
else
  doNothing=""
fi
