#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxfce4ui-4.10.0.tar.bz2
srcdir=libxfce4ui-4.10.0
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
Depends: GTK+2( >= 2.24.24), Xfconf (>= 4.10.0), startup-notification (>= 0.12)
Description: widget library for Xfce
EOF
}

build
