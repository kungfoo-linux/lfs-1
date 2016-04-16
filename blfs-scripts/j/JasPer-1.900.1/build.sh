#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=jasper-1.900.1.zip
srcdir=jasper-1.900.1
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/jasper-1.900.1-security_fixes-1.patch

./configure --prefix=/usr \
	--enable-shared \
	--disable-static \
	--mandir=/usr/share/man
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/jasper-1.900.1
install -v -m644 doc/*.pdf $BUILDDIR/usr/share/doc/jasper-1.900.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libjpeg-turbo (>= 1.3.1)
Description: an Implementation of the JPEG-2000 Standard, Part 1
 The JasPer Project is an open-source initiative to provide a free
 software-based reference implementation of the JPEG-2000 codec.
 .
 [imgcmp]
 compares two images of the same geometry.
 .
 [imginfo]
 displays information about an image.
 .
 [jasper]
 converts images between formats (BMP, JPS, JPC, JPG, PGX, PNM, MIF, and RAS).
 .
 [jiv]
 displays images.
 .
 [tmrdemo]
 is a timer demonstration program.
 .
 [libjasper.so]
 a library used by programs for reading and writing JPEG2000 format files.
EOF
}

build
