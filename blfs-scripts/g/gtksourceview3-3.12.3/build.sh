#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtksourceview-3.12.3.tar.xz
srcdir=gtksourceview-3.12.3
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
Depends: GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0)
Description: Source code viewing library
 The GtkSourceView package contains libraries used for extending the GTK+ text
 functions to include syntax highlighting.
EOF
}

build
