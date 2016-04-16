#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=atk-2.12.0.tar.xz
srcdir=atk-2.12.0
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
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0)
Description: a library providing a set of interfaces for accessibility
 ATK provides the set of accessibility interfaces that are implemented by
 other toolkits and applications. Using the ATK interfaces, accessibility
 tools have full access to view and control running applications.
 .
 [libatk-1.0.so]
 contains functions that are used by assistive technologies to interact with
 the desktop applications.
EOF
}

build
