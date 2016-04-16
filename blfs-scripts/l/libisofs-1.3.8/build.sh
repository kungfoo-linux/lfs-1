#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libisofs-1.3.8.tar.gz
srcdir=libisofs-1.3.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr --disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library to create an ISO-9660 filesystem
EOF
}

build
