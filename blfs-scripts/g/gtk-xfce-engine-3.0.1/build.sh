#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtk-xfce-engine-3.0.1.tar.bz2
srcdir=gtk-xfce-engine-3.0.1
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
Depends: GTK+2 (>= 2.24.24), GTK+3 (>= 3.12.2)
Description: several GTK+ 2 and GTK+ 3 themes and libraries for Xfce
EOF
}

build
