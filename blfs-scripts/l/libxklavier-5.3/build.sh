#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxklavier-5.3.tar.xz
srcdir=libxklavier-5.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), ISO-Codes (>= 3.56), libxml2 (>= 2.9.1), \
Xorg-lib (>= 7.7), gobject-introspection (>= 1.40.0)
Description: a utility library for X keyboard
EOF
}

build
