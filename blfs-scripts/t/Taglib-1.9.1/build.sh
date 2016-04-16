#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=taglib-1.9.1.tar.gz
srcdir=taglib-1.9.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release ..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Audio Meta-Data Library
EOF
}

build
