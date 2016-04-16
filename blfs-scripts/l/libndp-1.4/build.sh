#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libndp-1.4.tar.gz
srcdir=libndp-1.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc    \
	--localstatedir=/var \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for Neighbor Discovery Protocol
 The libndp package provides a wrapper for IPv6 Neighbor Discovery Protocol.
 It also provides a tool named ndptool for sending and receiving NDP messages.
 .
 [ndptool]
 tool for sending and receiving NDP messages.
 .
 [libndp.so]
 provides a wrapper for IPv6 Neighbor Discovery Protocol.
EOF
}

build
