#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xcursor-themes-1.0.4.tar.bz2
srcdir=xcursor-themes-1.0.4
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
Depends: Xorg-app (>= 7.7)
Description: Default set of cursor themes for X
EOF
}

build
