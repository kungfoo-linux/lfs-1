#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=atkmm-2.22.7.tar.xz
srcdir=atkmm-2.22.7
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
Depends: ATK (>= 2.12.0), GLibmm (>= 2.40.0)
Description: the C++ interface for the ATK accessibility toolkit library
EOF
}

build
