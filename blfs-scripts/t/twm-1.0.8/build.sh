#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=twm-1.0.8.tar.bz2
srcdir=twm-1.0.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in

./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-Server (>= 1.16.0)
Description: Tab Window Manager for the X Window System
 The twm package contains a very minimal window manager. This package is not a
 part of the Xorg katamari and is provided only as a dependency to other
 packages or for testing the completed Xorg installation.
 .
 [twm]
 is the Tab Window Manager for the X Window System.
EOF
}

build
