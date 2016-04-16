#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pixman-0.32.6.tar.gz
srcdir=pixman-0.32.6
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
Description: Pixel manipulation library
 The Pixman package contains a library that provides low-level pixel
 manipulation features such as image compositing and trapezoid rasterization.
 .
 [libpixman-1.so]
 contains functions that provide low-level pixel manipulation features.
EOF
}

build
