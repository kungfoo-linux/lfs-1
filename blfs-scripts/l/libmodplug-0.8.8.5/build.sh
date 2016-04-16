#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libmodplug-0.8.8.5.tar.gz
srcdir=libmodplug-0.8.8.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Modplug mod music file format library
EOF
}

build
