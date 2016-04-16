#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lcms2-2.6.tar.gz
srcdir=lcms2-2.6
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
Depends: libjpeg-turbo (>= 1.3.1), LibTIFF (>= 4.0.3)
Description: utilities for the Little CMS Engine
 The Little Color Management System is a small-footprint color management
 engine, with special focus on accuracy and performance. It uses the
 International Color Consortium standard (ICC), which is the modern standard
 for color management.
 .
 [jpgicc]
 is the Little CMS ICC profile applier for JPEG.
 .
 [linkicc]
 is the Little CMS ICC device link generator
 .
 [psicc]
 is the Little CMS ICC PostScript generator.
 .
 [tificc]
 is the Little CMS ICC tiff generator.
 .
 [transicc]
 is the Little CMS ColorSpace conversion calculator.
 .
 [liblcms2.so]
 contains functions implement the lcms2 API.
EOF
}

build
