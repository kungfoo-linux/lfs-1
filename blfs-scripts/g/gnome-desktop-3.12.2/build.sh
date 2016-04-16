#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnome-desktop-3.12.2.tar.xz
srcdir=gnome-desktop-3.12.2
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
Depends: gsettings-desktop-schemas (>= 3.12.2), GTK+3 (>= 3.12.2), \
ISO-Codes (>= 3.56), xkeyboard-config (>= 2.12), yelp-xsl (>= 3.12.0), \
gobject-introspection (>= 1.40.0)
Description: library with common API for various GNOME modules
EOF
}

build
