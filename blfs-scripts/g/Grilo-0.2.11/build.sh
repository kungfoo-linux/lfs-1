#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=grilo-0.2.11.tar.xz
srcdir=grilo-0.2.11
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
Depends: GTK+3 (>= 3.12.2), libsoup (>= 2.46.0), \
gobject-introspection (>= 1.40.0), Vala (>= 0.24.0), Avahi (>= 0.6.31)
Description: Framework for discovering and browsing media
 Grilo provides:
 [*] A single, high-level API that abstracts the differences among various media
 content providers, allowing application developers to integrate content from
 various services and sources easily.
 [*] A collection of plugins for accessing content from various media
 providers. Developers can share efforts and code by writing plugins for the
 framework that are application agnostic.
 [*] A flexible API that allows plugin developers to write plugins of various
 kinds.
EOF
}

build
