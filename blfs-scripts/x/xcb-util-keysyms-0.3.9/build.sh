#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-util-keysyms-0.3.9.tar.bz2
srcdir=xcb-util-keysyms-0.3.9
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
Description: Standard X key constants and keycodes conversion on top of libxcb
 The xcb-util-keysyms package contains a library for handling standard X key
 constants and conversion to/from keycodes.
 .
 [libxcb-keysyms.so]
 provides the standard X key constants and API functions for conversion
 to/from keycodes.
EOF
}

build
