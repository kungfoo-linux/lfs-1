#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libepoxy-1.2.tar.gz
srcdir=libepoxy-1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./autogen.sh --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: MesaLib (>= 10.2.7)
Description: a library for handling OpenGL function pointer management
 .
 [libepoxy.so]
 contains API functions for handling OpenGL function pointer management.
EOF
}

build
