#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lcms-1.19.tar.gz
srcdir=lcms-1.19
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--with-python
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/lcms-1.19
install -v -m644 README.1ST doc/* $BUILDDIR/usr/share/doc/lcms-1.19

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: LibTIFF (>= 4.0.3), libjpeg-turbo (>= 1.3.1), Python2 (>= 2.7.8), \
SWIG (>= 3.0.2)
Description: utilities for the Little CMS Engine
 The Little CMS library is used by other programs to provide color management
 facilities.
 .
 [icc2ps]
 generates PostScript CRD or CSA from ICC profiles.
 .
 [icclink]
 links two or more profiles into a single device link profile.
 .
 [icctrans]
 is a color space conversion calculator.
 .
 [jpegicc]
 is an ICC profile applier for JPEG files.
 .
 [tifficc]
 is an ICC profile applier for TIFF files.
 .
 [tiffdiff]
 A TIFF compare utility
 .
 [wtpt]
 shows media white of profiles, identifying black body locus.
 .
 [liblcms.so]
 is used by the lcms programs as well as other programs to provide color
 management facilities.
EOF
}

build
