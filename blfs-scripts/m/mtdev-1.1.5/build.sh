#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mtdev-1.1.5.tar.bz2
srcdir=mtdev-1.1.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Multitouch Protocol Translation Library
 The mtdev package contains Multitouch Protocol Translation Library which is
 used to transform all variants of kernel MT (Multitouch) events to the
 slotted type B protocol.
 .
 [libmtdev.so]
 contains Multitouch Protocol Translation API functions.
EOF
}

build
