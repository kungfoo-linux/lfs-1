#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=polkit-qt-1-0.112.0.tar.bz2
srcdir=polkit-qt-1-0.112.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DUSE_QT4=TRUE \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: automoc4 (>= 0.9.88), Polkit (>= 0.112)
Description: an API to polkit in the Qt environment
EOF
}

build
