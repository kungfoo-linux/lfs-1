#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdvdread-5.0.0.tar.bz2
srcdir=libdvdread-5.0.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/libdvdread-5.0.0
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a library for reading DVDs
EOF
}

build
