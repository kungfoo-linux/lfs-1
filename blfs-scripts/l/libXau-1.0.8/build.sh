#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libXau-1.0.8.tar.bz2
srcdir=libXau-1.0.8
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
Description: X11 authorisation library
 The libXau package contains a library implementing the X11 Authorization
 Protocol. This is useful for restricting client access to the display.
 .
 [libXau.so]
 is the library of X authority database routines.
EOF
}

build
