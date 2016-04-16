# This script adds some useful paths to the PATH and can be used to 
# customize other PATH related environment variables (e.g. LD_LIBRARY_PATH, 
# etc) that may be needed for all users.

if [ -d /usr/local/lib/pkgconfig ] ; then
    pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi

if [ -d /usr/local/bin ]; then
    pathprepend /usr/local/bin
fi

if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
    pathprepend /usr/local/sbin
fi
