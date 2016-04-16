#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-util-0.3.9.tar.bz2
srcdir=xcb-util-0.3.9
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
Depends: libxcb (>= 1.11)
Description: utility libraries for X C Binding
 The xcb-util package provides additional extensions to the XCB library, many
 that were previously found in Xlib, but are not part of core X protocol.
 .
 [libxcb-util.so]
 Provides utility functions for other XCB utilities.
EOF
}

build
