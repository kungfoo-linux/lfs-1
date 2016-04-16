# This script sets up the default inputrc configuration file. If the user 
# does not have individual settings, it uses the global file.

# Setup the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
    INPUTRC=/etc/inputrc
fi
export INPUTRC
