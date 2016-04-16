#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gcr-3.12.2.tar.xz
srcdir=gcr-3.12.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-valgrind=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), libgcrypt (>= 1.6.2), libtasn1 (>= 4.1), \
p11-kit (>= 0.20.6), GnuPG (>= 2.0.26), gobject-introspection (>= 1.40.0), \
GTK+3 (>= 3.12.2), libxslt (>= 1.1.28), Vala (>= 0.24.0)
Description: libraries used for displaying certificates and accessing key stores
 The Gcr package contains libraries used for displaying certificates and
 accessing key stores. It also provides the viewer for crypto files on the
 GNOME Desktop.
 .
 [gcr-prompter]
 provides the prompt dialog needed by libgcr.
 .
 [gcr-viewer]
 is used to view certificate and key files.
 .
 [libgck-1.so]
 contains GObject bindings for PKCS#11.
 .
 [libgcr-3.so]
 contains functions for high level crypto parsing.
EOF
}

build
