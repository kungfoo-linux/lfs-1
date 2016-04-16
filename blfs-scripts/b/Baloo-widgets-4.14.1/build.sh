#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=baloo-widgets-4.14.1.tar.xz
srcdir=baloo-widgets-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: baloo (>= 4.14.1)
Description: widgets for the baloo search framework
EOF
}

build
