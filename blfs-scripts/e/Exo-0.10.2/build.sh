#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=exo-0.10.2.tar.bz2
srcdir=exo-0.10.2
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
Depends: libxfce4ui (>= 4.10.0), libxfce4util (>= 4.10.0), \
perl-module-uri (>= 1.65)
Description: Library with extensions for Xfce
EOF
}

build
