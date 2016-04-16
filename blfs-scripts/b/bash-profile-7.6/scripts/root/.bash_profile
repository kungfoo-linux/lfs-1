# Begin ~/.bash_profile
# Personal environment variables and startup programs.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

PS1="\h# "
set -o ignoreeof

unset USERNAME

# End ~/.bash_profile
