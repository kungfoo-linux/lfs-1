#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libXp-1.0.2.tar.bz2
srcdir=libXp-1.0.2
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
Depends: printproto (>= 1.0.5)
Description: a library implementing the X Print Protocol
EOF
}

build
