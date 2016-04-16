#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=phonon-backend-vlc-0.8.0.tar.xz
srcdir=phonon-backend-vlc-0.8.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_INSTALL_LIBDIR=lib \
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
Depends: phonon (>= 4.8.0), VLC (>= 2.1.5)
Description: VLC backend for Phonon
EOF
}

build
