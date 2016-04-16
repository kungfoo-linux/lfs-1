#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdaemon-0.14.tar.gz
srcdir=libdaemon-0.14
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/libdaemon-0.14 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: lightweight C library for daemons
 .
 [libdaemon.so]
 contains the libdaemon API functions.
EOF
}

build
