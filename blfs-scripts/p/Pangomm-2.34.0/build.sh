#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pangomm-2.34.0.tar.xz
srcdir=pangomm-2.34.0
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
Depends: Cairomm (>= 1.10.0), GLibmm (>= 2.40.0), Pango (>= 1.36.7)
Description: a C++ interface to Pango
EOF
}

build
