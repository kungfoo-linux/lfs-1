#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

# /etc/profile   : System wide environment variables and startup programs.
# /etc/bashrc    : System wide aliases and functions.
# ~/.bash_profile: Personal environment variables and startup programs.
# ~/.bashrc      : Personal aliases and functions.

build_src() {
srcdir=scripts

mkdir -pv $BUILDDIR && cp -r $srcdir $BUILDDIR
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Priority: required
Essential: yes
Description: The Bash shell startup files
EOF
}

build
