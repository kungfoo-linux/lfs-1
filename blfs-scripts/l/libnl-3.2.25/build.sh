#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libnl-3.2.25.tar.gz
srcdir=libnl-3.2.25
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for dealing with netlink sockets
 The libnl suite is a collection of libraries providing APIs to netlink
 protocol based Linux kernel interfaces.
 .
 [libnl*-3.so]
 These libraries contain API functions used to access Netlink interfaces in
 Linux kernel.
EOF
}

build
