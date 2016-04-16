#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tiff-4.0.3.tar.gz
srcdir=tiff-4.0.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/glDrawPixels/a glFlush();' tools/tiffgt.c

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libjpeg-turbo (>= 1.3.1), jbigkit (>= 2.1)
Description: library of functions for manipulating TIFF format image files
 The LibTIFF package contains the TIFF libraries and associated utilities. The
 libraries are used by many programs for reading and writing TIFF files and
 the utilities are used for general work with TIFF files.
 .
 [bmp2tiff]
 converts a Microsoft Windows Device Independent Bitmap image file to a TIFF
 image.
 .
 [fax2ps]
 converts a TIFF facsimile to compressed PostScript file.
 .
 [fax2tiff]
 creates a TIFF Class F fax file from raw fax data.
 .
 [gif2tiff]
 creates a TIFF file from a GIF87 format image file.
 .
 [pal2rgb]
 converts a palette color TIFF image to a full color image.
 .
 [ppm2tiff]
 creates a TIFF file from a PPM image file.
 .
 [ras2tiff]
 creates a TIFF file from a Sun rasterfile.
 .
 [raw2tiff]
 converts a raw byte sequence into TIFF.
 .
 [rgb2ycbcr]
 converts non-YCbCr TIFF images to YCbCr TIFF images.
 .
 [thumbnail]
 creates a TIFF file with thumbnail images.
 .
 [tiff2bw]
 converts a color TIFF image to grayscale.
 .
 [tiff2pdf]
 converts a TIFF image to a PDF document.
 .
 [tiff2ps]
 converts a TIFF image to a PostScript file.
 .
 [tiff2rgba]
 converts a wide variety of TIFF images into an RGBA TIFF image.
 .
 [tiffcmp]
 compares two TIFF files.
 .
 [tiffcp]
 copies (and possibly converts) a TIFF file.
 .
 [tiffcrop]
 selects, copies, crops, converts, extracts and/or processes one or more TIFF
 files.
 .
 [tiffdither]
 converts a grayscale image to bilevel using dithering.
 .
 [tiffdump]
 prints verbatim information about TIFF files.
 .
 [tiffgt]
 displays an image stored in a TIFF file.
 .
 [tiffinfo]
 prints information about TIFF files.
 .
 [tiffmedian]
 applies the median cut algorithm to data in a TIFF file.
 .
 [tiffset]
 sets the value of a TIFF header to a specified value.
 .
 [tiffsplit]
 splits a multi-image TIFF into single-image TIFF files.
 .
 [libtiff.so]
 contains the API functions used by the libtiff programs as well as other
 programs to read and write TIFF files.
 .
 [libtiffxx.so]
 contains the C++ API functions used by programs to read and write TIFF files.
EOF
}

build
