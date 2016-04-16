#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libexif-0.6.21.tar.bz2
srcdir=libexif-0.6.21
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-doc-dir=/usr/share/doc/libexif-0.6.21 \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library to parse EXIF files
 The libexif package contains a library for parsing, editing, and saving EXIF
 data. Most digital cameras produce EXIF files, which are JPEG files with
 extra tags that contain information about the image. All EXIF tags described
 in EXIF standard 2.1 are supported.
 .
 [libexif.so]
 contains functions used for parsing, editing, and saving EXIF data.
EOF
}

build
