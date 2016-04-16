#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=appstream-glib-0.3.0.tar.xz
srcdir=appstream-glib-0.3.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--disable-dep11
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gdk-pixbuf (>= 2.30.8), libarchive (>= 3.1.2), libsoup (>= 2.46.0), \
Pango (>= 1.36.7), gobject-introspection (>= 1.40.0)
Description: AppStream Abstraction Library
 The appstream-glib provides GObjects and helper methods to make it easy to
 read and write AppStream metadata. It also provides a simple DOM
 implementation that makes it easy to edit nodes and convert to and from the
 standardized XML representation.
EOF
}

build
