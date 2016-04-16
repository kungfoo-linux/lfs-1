#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=Thunar-1.6.3.tar.bz2
srcdir=Thunar-1.6.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--docdir=/usr/share/doc/Thunar-1.6.3
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Exo (>= 0.10.2), libxfce4ui (>= 4.10.0), libnotify (>= 0.7.6), \
startup-notification (>= 0.12), eudev (>= 1.10), xfce4-panel (>= 4.10.0), \
libexif (>= 0.6.21)
Description: File Manager for Xfce
EOF
}

build
