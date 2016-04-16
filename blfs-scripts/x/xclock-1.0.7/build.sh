#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xclock-1.0.7.tar.bz2
srcdir=xclock-1.0.7
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
Depends: Xorg-lib (>= 7.7)
Description: a simple clock application for X
 The xclock package contains a simple clock application which is used in the
 default xinit configuration. This package is not a part of the Xorg katamari
 and is provided only as a dependency to other packages or for testing the
 completed Xorg installation.
 .
 [xclock]
 is an analog/digital clock for X.
EOF
}

build
