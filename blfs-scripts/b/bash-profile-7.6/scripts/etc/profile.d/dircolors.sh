
# This script uses the ~/.dircolors and /etc/dircolors files to control the 
# colors of file names in a directory listing. They control colorized output 
# of things like ls --color. The explanation of how to initialize these 
# files is at the end of this section.

# Setup for /bin/ls and /bin/grep to support color, 
# the alias is in /etc/bashrc.

if [ -f "/etc/dircolors" ] ; then
    eval $(dircolors -b /etc/dircolors)

    if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
    fi
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
