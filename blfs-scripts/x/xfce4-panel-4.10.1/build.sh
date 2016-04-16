#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-panel-4.10.1.tar.bz2
srcdir=xfce4-panel-4.10.1
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
Depends: Exo (>= 0.10.2), Garcon (>= 0.3.0), libwnck2 (>= 2.30.7), \
libxfce4ui (>= 4.10.0)
Description: the Xfce4 Panel
EOF
}

build
