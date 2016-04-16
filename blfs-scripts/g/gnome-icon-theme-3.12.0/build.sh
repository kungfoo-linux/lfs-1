#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnome-icon-theme-3.12.0.tar.xz
srcdir=gnome-icon-theme-3.12.0
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
Depends: GTK+3 (>= 3.12.2), hicolor-icon-theme (>= 0.13), \
icon-naming-utils (>= 0.8.90)
Description: GNOME Icon Theme
 The GNOME Icon Theme package contains an assortment of non-scalable icons of
 different sizes and themes.
EOF
}

build
