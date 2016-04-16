#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=LibRaw-0.16.0.tar.gz
srcdir=LibRaw-0.16.0

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-jpeg    \
	--enable-jasper  \
	--enable-lcms    \
	--disable-static \
	--docdir=/usr/share/doc/libraw-0.16.0
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libjpeg-turbo (>= 1.3.1), JasPer (>= 1.900.1), lcms2 (>= 2.6)
Description: library for reading RAW files obtained from digital photo cameras
 Libraw is a library for reading RAW files obtained from digital photo cameras
 (CRW/CR2, NEF, RAF, DNG, and others).
EOF
}

build
