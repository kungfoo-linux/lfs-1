#!/bin/bash -e
. ../../blfs.comm

build_src() {
# For build this package, need the Boost's header files.

srcfil=exempi-2.2.2.tar.bz2
srcdir=exempi-2.2.2
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
Description: library for easy parsing of XMP metadata
 Exempi is an implementation of XMP (Adobe's Extensible Metadata Platform).
 .
 [libexempi.so]
 is a library used to parse XMP metadata. 
EOF
}

build
