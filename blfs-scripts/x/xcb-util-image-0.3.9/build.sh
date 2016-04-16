#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-util-image-0.3.9.tar.bz2
srcdir=xcb-util-image-0.3.9
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
Depends: xcb-util (= 0.3.9)
Description: Port of Xlib's XImage and XShmImage functions on top of libxcb
 The xcb-util-image package provides additional extensions to the XCB library.
 .
 [libxcb-image.so]
 Is a port of Xlib's XImage and XShmImage functions.
EOF
}

build
