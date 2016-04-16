#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=oxygen-icons-4.14.1.tar.xz
srcdir=oxygen-icons-4.14.1
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
Description: The KDE 4 Oxygen Icon Set
EOF
}

build
