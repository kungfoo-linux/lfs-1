#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dosfstools-3.0.26.tar.xz
srcdir=dosfstools-3.0.26
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make DESTDIR=$BUILDDIR PREFIX=/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: utilities for making and checking MS-DOS FAT filesystems
EOF
}

build
