#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=udisks-2.1.3.tar.bz2
srcdir=udisks-2.1.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libatasmart (>= 0.19), libxslt (>= 1.1.28), Polkit (>= 0.112), \
eudev (>= 1.10), gobject-introspection (>= 1.40.0)
Description: D-BUS service to access and manipulate storage devices
EOF
}

build
