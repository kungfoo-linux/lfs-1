#!/bin/bash -e
. ../../blfs.comm

build_src() {
# need NASM-2.11.05 or yasm-1.3.0 to build this package.

srcfil=libjpeg-turbo-1.3.1.tar.gz
srcdir=libjpeg-turbo-1.3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '/^docdir/     s:$:/libjpeg-turbo-1.3.1:' \
	-e '/^exampledir/ s:$:/libjpeg-turbo-1.3.1:' Makefile.in

./configure --prefix=/usr \
	--mandir=/usr/share/man \
	--with-jpeg8 \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a MMX/SSE2 accelerated library for manipulating JPEG image files
 libjpeg-turbo is a fork of the original IJG libjpeg which uses SIMD to
 accelerate baseline JPEG compression and decompression. libjpeg is a library
 that implements JPEG image encoding, decoding and transcoding.
 .
 [cjpeg]
 compresses image files to produce a JPEG/JFIF file on the standard output.
 Currently supported input file formats are: PPM (PBMPLUS color format), PGM
 (PBMPLUS gray-scale format), BMP, and Targa.
 .
 [djpeg]
 decompresses image files from JPEG/JFIF format to either PPM (PBMPLUS color
 format), PGM (PBMPLUS gray-scale format), BMP, or Targa format.
 .
 [jpegtran]
 is used for lossless transformation of JPEG files.
 .
 [rdjpgcom]
 displays text comments from within a JPEG file.
 .
 [tjbench]
 is used to benchmark the performance of libjpeg-turbo.
 .
 [wrjpgcom]
 inserts text comments into a JPEG file.
 .
 [libjpeg.so]
 contains functions used for reading and writing JPEG images.
EOF
}

build
