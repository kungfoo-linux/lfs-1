#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=goffice-0.10.17.tar.xz
srcdir=goffice-0.10.17
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
Depends: GTK+3 (>= 3.12.2), libgsf (>= 1.14.30), librsvg (>= 2.40.3), \
Which (>= 2.20), ghostscript (>= 9.14), gobject-introspection (>= 1.40.0)
Description: a library of GLib/GTK document centric objects and utilities
 The GOffice package contains a library of GLib/GTK document centric objects
 and utilities. This is useful for performing common operations for document
 centric applications that are conceptually simple, but complex to implement
 fully. Some of the operations provided by the GOffice library include support
 for plugins, load/save routines for application documents and undo/redo
 functions.
 .
 [libgoffice-0.10.so]
 contains API functions to provide support for document centric objects and
 utilities.
EOF
}

build
