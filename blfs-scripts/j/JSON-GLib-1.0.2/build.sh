#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=json-glib-1.0.2.tar.xz
srcdir=json-glib-1.0.2
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
Description: library for JavaScript Object Notation format
 The JSON GLib package is a library providing serialization and
 deserialization support for the JavaScript Object Notation (JSON) format
 described by RFC 4627.
 .
 [libjson-glib-1.0.so]
 contains the JSON GLib API functions. 
EOF
}

build
