#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=at-spi2-core-2.12.0.tar.xz
srcdir=at-spi2-core-2.12.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), GLib (>= 2.40.0), Xorg-lib (>= 7.7), \
gobject-introspection (>= 1.40.0)
Description: Assistive Technology Service Provider Interface
 The At-Spi2 Core package is a part of the GNOME Accessibility Project. It
 provides a Service Provider Interface for the Assistive Technologies
 available on the GNOME platform and a library against which applications can
 be linked.
EOF
}

build
