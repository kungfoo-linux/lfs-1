#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=konsole-4.14.1.tar.xz
srcdir=konsole-4.14.1
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
Depends: kdelibs (>= 4.14.1)
Recommends: kde-baseapps (>= 4.14.1)
Description: KDE Terminal emulator
EOF
}

build
