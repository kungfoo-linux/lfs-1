#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libunistring-0.9.4.tar.gz
srcdir=libunistring-0.9.4
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
Description: GNU Unicode string library
 libunistring is a library that provides functions for manipulating Unicode
 strings and for manipulating C strings according to the Unicode standard.
 .
 [libunistring.{a,so}]
 provides the unicode string library API.
EOF
}

build
