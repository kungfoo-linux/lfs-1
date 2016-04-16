#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gobject-introspection-1.40.0.tar.xz
srcdir=gobject-introspection-1.40.0
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
Depends: GLib (>= 2.40.0)
Description: Introspection system for GObject-based libraries
 The GObject Introspection is used to describe the program APIs and collect
 them in a uniform, machine readable format.
 .
 [g-ir-compiler] converts one or more GIR files into one or more typelib.
 .
 [g-ir-scanner] is a tool which generates GIR XML files by parsing headers
 and introspecting GObject based libraries.
 .
 [g-ir-generate] is a GIR generator using the repository API.
 .
 [libgirepository-1.0.so] provides an API to access to the typelib metadata.
EOF
}

build
