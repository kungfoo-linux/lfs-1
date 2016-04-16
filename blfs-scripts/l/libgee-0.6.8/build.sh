#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgee-0.6.8.tar.xz
srcdir=libgee-0.6.8
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
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0), Vala (>= 0.24.0)
Description: GObject based collection library
 The libgee package is a collection library providing GObject based interfaces
 and classes for commonly used data structures.
 .
 [libgee.so]
 contains the libgee API functions.
EOF
}

build
