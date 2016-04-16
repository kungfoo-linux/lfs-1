#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libpng-1.6.13.tar.xz
srcdir=libpng-1.6.13
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you want to patch libpng to support apng files, apply the patch:
gzip -cd $BLFSSRC/$PKGLETTER/$CURDIR/libpng-1.6.13-apng.patch.gz | patch -p1

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/share/doc/libpng-1.6.13
cp -v README libpng-manual.txt $BUILDDIR/usr/share/doc/libpng-1.6.13

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a library of functions for manipulating PNG image format files
 The libpng package contains libraries used by other programs for reading and
 writing PNG files. The PNG format was designed as a replacement for GIF and,
 to a lesser extent, TIFF, with many improvements and extensions and lack of
 patent problems.
 .
 [pngfix]
 tests, optimizes and optionally fixes the zlib header in PNG files.
 Optionally, when fixing, strips ancillary chunks from the file.
 .
 [png-fix-itxt]
 fixes PNG files that have an incorrect length field in the iTXt chunks.
 .
 [libpng-config]
 is a shell script that provides configuration information for applications
 wanting to use libpng.
 .
 [libpng.so]
 contain routines used to create and manipulate PNG format graphics files.
EOF
}

build
