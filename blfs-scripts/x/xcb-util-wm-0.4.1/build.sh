#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-util-wm-0.4.1.tar.bz2
srcdir=xcb-util-wm-0.4.1
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
Description: Client and window-manager helper library on top of libxcb
 The xcb-util-wm package contains libraries which provide client and
 window-manager helpers for EWMH and ICCCM.
 .
 [libxcb-ewmh.so]
 provides the client and window-manager helpers for EWMH.
 .
 [libxcb-icccm.so]
 provides the client and window-manager helpers for ICCCM.
EOF
}

build
