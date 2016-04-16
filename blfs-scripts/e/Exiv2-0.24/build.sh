#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=exiv2-0.24.tar.gz
srcdir=exiv2-0.24
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install
chmod -v 755 $BUILDDIR/usr/lib/libexiv2.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: EXIF/IPTC metadata manipulation tool
 Exiv2 is a C++ library and a command line utility for managing image
 metadata.
 .
 [exiv2]
 is an utility used to dump Exif data.
EOF
}

build
