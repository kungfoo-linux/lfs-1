#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libarchive-3.1.2.tar.gz
srcdir=libarchive-3.1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--without-xml2 \
	--without-nettle
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: LZO (>= 2.08), OpenSSL (>= 1.0.1i)
Description: a library for handling streaming archive formats
 The libarchive library provides a single interface for reading/writing
 various compression formats.
 .
 [bsdcpio]
 is a tool similar to cpio.
 .
 [bsdtar]
 is a tool similar to GNU tar.
 .
 [libarchive.so]
 is a library that can create and read several streaming archive formats. 
EOF
}

build
