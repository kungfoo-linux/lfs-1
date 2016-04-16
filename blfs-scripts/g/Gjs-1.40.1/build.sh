#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gjs-1.40.1.tar.xz
srcdir=gjs-1.40.1
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
Depends: Cairo (>= 1.12.16), gobject-introspection (>= 1.40.0), \
JS24 (>= 24.2.0)
Description: Javascript Bindings for GNOME
EOF
}

build
