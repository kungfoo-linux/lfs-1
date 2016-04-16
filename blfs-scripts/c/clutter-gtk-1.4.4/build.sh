#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=clutter-gtk-1.4.4.tar.xz
srcdir=clutter-gtk-1.4.4
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
Depends: Clutter (>= 1.18.4), GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0)
Description: A basic GTK clutter widget
 The Clutter Gtk package is a library providing facilities to integrate
 Clutter into GTK+ applications.
EOF
}

build
