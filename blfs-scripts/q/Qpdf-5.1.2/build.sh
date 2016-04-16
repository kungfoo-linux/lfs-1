#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=qpdf-5.1.2.tar.gz
srcdir=qpdf-5.1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/qpdf-5.1.2
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: PCRE (>= 8.35)
Description: tools for and transforming and inspecting PDF files
 The Qpdf package contains command-line programs and library that do
 structural, content-preserving transformations on PDF files.
 .
 [fix-qdf]
 is used to repair PDF files in QDF form after editing.
 .
 [qpdf]
 is used to convert one PDF file to another equivalent PDF file.
 .
 [libqpdf.so]
 contains the Qpdf API functions.
EOF
}

build
