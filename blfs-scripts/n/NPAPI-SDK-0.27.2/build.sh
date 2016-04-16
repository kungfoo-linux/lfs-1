#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=npapi-sdk-0.27.2.tar.bz2
srcdir=npapi-sdk-0.27.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Netscape Plugin API (NPAPI)
 NPAPI-SDK is a bundle of Netscape Plugin Application Programming Interface
 headers by Mozilla. This package provides a clear way to install those
 headers and depend on them.
EOF
}

build
