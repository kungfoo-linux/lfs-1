#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=vte-0.36.3.tar.xz
srcdir=vte-0.36.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--enable-introspection
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0)
Description: a library implementing a terminal emulator widget for GTK+
EOF
}

build
