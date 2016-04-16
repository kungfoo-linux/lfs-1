#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=clutter-1.18.4.tar.xz
srcdir=clutter-1.18.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-egl-backend
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: ATK (>= 2.12.0), Cogl (>= 1.18.2), JSON-GLib (>= 1.0.2), \
gobject-introspection (>= 1.40.0), GTK+3 (>= 3.12.2)
Description: A library for creating rich graphical user interfaces
 The Clutter package contains an open source software library used for
 creating fast, visually rich and animated graphical user interfaces.
 .
 [libclutter-1.0.so]
 contains the Clutter API functions.
EOF
}

build
