#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libmng-2.0.2.tar.xz
srcdir=libmng-2.0.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "s:#include <jpeg:#include <stdio.h>\n&:" libmng_types.h

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/libmng-2.0.2
install -v -m644 doc/*.txt $BUILDDIR/usr/share/doc/libmng-2.0.2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libjpeg-turbo (>= 1.3.1), lcms2 (>= 2.6)
Description: library for Multiple-image Network Graphics support
 The libmng libraries are used by programs wanting to read and write
 Multiple-image Network Graphics (MNG) files which are the animation
 equivalents to PNG files.
 .
 [libmng.so]
 provides functions for programs wishing to read and write MNG files which are
 animation files without the patent problems associated with certain other
 formats.
EOF
}

build
