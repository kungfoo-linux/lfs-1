#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cairomm-1.10.0.tar.gz
srcdir=cairomm-1.10.0
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
Depends: Cairo (>= 1.12.16), libsigc++ (>= 2.3.2)
Description: C++ wrappers for Cairo
 cairomm provides C++ bindings for the Cairo graphics library, a
 multi-platform library providing anti-aliased vector-based rendering for
 multiple target backends.
 .
 [libcairomm-1.0.so]
 contains the Cairo API classes.
EOF
}

build
