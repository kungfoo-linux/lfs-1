#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libcroco-0.6.8.tar.xz
srcdir=libcroco-0.6.8
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
Depends: GLib (>= 2.40.0), libxml2 (>= 2.9.1)
Description: a CSS2 parsing library
 The libcroco package contains a standalone CSS2 parsing and manipulation
 library.
 .
 [csslint-0.6]
 is used to parse one or more CSS files specified on the command line.
 .
 [libcroco-0.6.so]
 contains the API functions for CSS2 parsing and manipulation.
EOF
}

build
