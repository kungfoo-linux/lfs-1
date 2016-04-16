#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kde-base-artwork-4.14.1.tar.xz
srcdir=kde-base-artwork-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: kdelibs (>= 4.14.1)
Description: the default splash screen for KDE
EOF
}

build
