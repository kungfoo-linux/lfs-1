#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

# The shells file contains a list of login shells on the system. 
# Applications use this file to determine whether a shell is valid. 
# For each shell a single line should be present, consisting of the 
# shell's path, relative to the root of the directory structure (/).

# It is a requirement for applications such as GDM which does not 
# populate the face browser if it can't find /etc/shells, or FTP daemons 
# which traditionally disallow access to users with shells not included 
# in this file.

build_src() {
mkdir -pv $BUILDDIR
}

configure() {
mkdir -pv $BUILDDIR/etc
cat > $BUILDDIR/etc/shells << "EOF"
# list shell at here

/bin/sh
/bin/bash
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Priority: required
Essential: yes
Description: Show all support shells on system.
EOF
}

build
