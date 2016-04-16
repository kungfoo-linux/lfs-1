#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ijs-0.35.tar.bz2
srcdir=ijs-0.35
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--mandir=/usr/share/man \
	--enable-shared \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: IJS raster image transport protocol
 The IJS package contains a library which implements a protocol for
 transmission of raster page images.
 .
 [ijs-config]
 is a program that is used to determine the compiler and linker flags that
 should be used to compile and link programs that use IJS.
 .
 [libijs.so]
 contains the IJS API functions.
EOF
}

build
