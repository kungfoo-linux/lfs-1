#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=qimageblitz-0.0.6.tar.bz2
srcdir=qimageblitz-0.0.6
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
Depends: Qt4 (>= 4.8.6)
Description: a graphical effect and filter library for KDE
EOF
}

build
