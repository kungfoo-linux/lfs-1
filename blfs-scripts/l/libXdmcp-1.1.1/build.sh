#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libXdmcp-1.1.1.tar.bz2
srcdir=libXdmcp-1.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-proto (= 7.7)
Description: X11 Display Manager Control Protocol library
 The libXdmcp package contains a library implementing the X Display Manager
 Control Protocol. This is useful for allowing clients to interact with the X
 Display Manager.
 .
 [libXdmcp.so]
 is the X Display Manager Control Protocol library.
EOF
}

build
