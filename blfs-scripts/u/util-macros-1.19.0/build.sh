#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=util-macros-1.19.0.tar.bz2
srcdir=util-macros-1.19.0
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
Depends: Xorg-buildenv (= 7.7)
Description: Xorg autotools macros
 The util-macros package contains the m4 macros used by all of the Xorg
 packages.
EOF
}

build
