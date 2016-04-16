#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=garcon-0.3.0.tar.bz2
srcdir=garcon-0.3.0
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
Depends: libxfce4util (>= 4.10.0), GTK+2 (>= 2.24.24)
Description: freedesktop.org compliant menu implementation for Xfce
EOF
}

build
