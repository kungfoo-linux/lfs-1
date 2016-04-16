#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsigc++-2.3.2.tar.xz
srcdir=libsigc++-2.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/type_traits.h/i\#include <sigc++/visit_each.h>' \
	sigc++/macros/limit_reference.h.m4

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a typesafe callback system for standard C++
 .
 [libsigc-2.0.so] contains the libsigc++ API methods. 
EOF
}

build
