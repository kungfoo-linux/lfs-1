#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libwnck-3.4.9.tar.xz
srcdir=libwnck-3.4.9
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
Depends: GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0), \
startup-notification (>= 0.12)
Description: a Window Navigator Construction Kit
EOF
}

build
