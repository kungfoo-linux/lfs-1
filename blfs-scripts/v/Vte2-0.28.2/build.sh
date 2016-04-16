#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=vte-0.28.2.tar.xz
srcdir=vte-0.28.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--libexecdir=/usr/lib/vte \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+2 (>= 2.24.24), gobject-introspection (>= 1.40.0)
Description: a library implementing a terminal emulator widget for GTK+
 .
 [vte]
 is a simple terminal emulator.
 .
 [libvte.so]
 contains the Vte API functions.
EOF
}

build
