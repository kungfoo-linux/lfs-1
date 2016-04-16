#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgtop-2.30.0.tar.xz
srcdir=libgtop-2.30.0
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
Depends: GLib (>= 2.40.0), Xorg-lib (>= 7.7), \
gobject-introspection (>= 1.40.0)
Description: the GNOME top libraries
EOF
}

build
