#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcb-proto-1.11.tar.bz2
srcdir=xcb-proto-1.11
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
Depends: Xorg-buildenv (= 7.7), Python2 (>= 2.7.8)
Description: XCB protocol descriptions
 The xcb-proto package provides the XML-XCB protocol descriptions that libxcb
 uses to generate the majority of its code and API.
EOF
}

build
