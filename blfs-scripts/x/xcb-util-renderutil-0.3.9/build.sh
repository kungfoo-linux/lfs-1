#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-util-renderutil-0.3.9.tar.bz2
srcdir=xcb-util-renderutil-0.3.9
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
Description: Convenience functions for the Render extension
 The xcb-util-renderutil package provides additional extensions to the XCB
 library.
 .
 [libxcb-render-util.so]
 Provides convenience functions for the Render extension.
EOF
}

build
