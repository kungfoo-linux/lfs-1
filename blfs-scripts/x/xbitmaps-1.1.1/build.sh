#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xbitmaps-1.1.1.tar.bz2
srcdir=xbitmaps-1.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: util-macros (>= 1.19.0)
Description: Base X bitmaps
 This package contains the base X bitmaps, which are used in many legacy X
 clients.
EOF
}

build
