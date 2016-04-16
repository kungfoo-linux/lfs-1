#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libwebp-0.4.1.tar.gz
srcdir=libwebp-0.4.1
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
Depends: libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), LibTIFF (>= 4.0.3), \
Freeglut (>= 2.8.1), giflib (>= 5.1.0)
Description: Library and tools for the WebP graphics format
 .
 [cwebp]
 compresses an image using the WebP format.
 .
 [dwebp]
 decompresses WebP files into PNG, PAM, PPM or PGM images.
 .
 [libwebp.so]
 contains the API functions for WebP encoding and decoding.
EOF
}

build
