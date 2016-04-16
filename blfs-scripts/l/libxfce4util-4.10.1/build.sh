#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxfce4util-4.10.1.tar.bz2
srcdir=libxfce4util-4.10.1
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
Depends: GLib (>= 2.40.0)
Description: a basic utility library for the Xfce desktop environment
EOF
}

build
