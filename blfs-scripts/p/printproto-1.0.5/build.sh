#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=printproto-1.0.5.tar.bz2
srcdir=printproto-1.0.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: the protocol headers for the libXp
EOF
}

build
