#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=hicolor-icon-theme-0.13.tar.gz
srcdir=hicolor-icon-theme-0.13
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
Description: default fallback theme for FreeDesktop.org icon themes
EOF
}

build
