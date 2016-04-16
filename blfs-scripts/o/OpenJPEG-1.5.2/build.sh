#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openjpeg-1.5.2.tar.gz
srcdir=openjpeg-1.5.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

autoreconf -f -i
./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: lcms2 (>= 2.6), libpng (>= 1.6.13), LibTIFF (>= 4.0.3)
Description: an open-source implementation of the JPEG-2000 standard
 OpenJPEG is an open-source implementation of the JPEG-2000 standard. OpenJPEG
 fully respects the JPEG-2000 specifications and can compress/decompress
 lossless 16-bit images.
 .
 [image_to_j2k]
 converts various image formats to the jpeg2000 format.
 .
 [j2k_dump]
 reads in a jpeg2000 image and dumps the contents to stdout.
 .
 [j2k_to_image]
 converts jpeg2000 images to other image types.
EOF
}

build
