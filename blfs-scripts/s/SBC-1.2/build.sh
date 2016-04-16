#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sbc-1.2.tar.xz
srcdir=sbc-1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--disable-tester
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Suggests: libsndfile (>= 1.0.25)
Description: Bluetooth Low-Complexity, Sub-Band Codec Utilities
EOF
}

build
