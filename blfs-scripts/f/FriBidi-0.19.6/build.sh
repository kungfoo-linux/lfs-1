#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fribidi-0.19.6.tar.bz2
srcdir=fribidi-0.19.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "s|glib/gstrfuncs\.h|glib.h|" charset/fribidi-char-sets.c
sed -i "s|glib/gmem\.h|glib.h|"      lib/mem.h

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0)
Description: Free Implementation of the Unicode BiDi algorithm
 This is useful for supporting Arabic and Hebrew alphabets in other packages.
 .
 [fribidi]
 is a command-line interface to the libfribidi library and can be used to
 convert a logical string to visual output.
 .
 [libfribidi.so]
 contains functions used to implement the Unicode Bidirectional Algorithm.
EOF
}

build
