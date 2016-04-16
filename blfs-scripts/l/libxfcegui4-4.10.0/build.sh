#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxfcegui4-4.10.0.tar.bz2
srcdir=libxfcegui4-4.10.0
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
Depends: libglade (>= 2.6.4), libxfce4util (>= 4.10.1)
Description: the basic GUI functions used by Xfce
EOF
}

build
