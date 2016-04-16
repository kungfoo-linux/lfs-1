#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=attica-0.4.2.tar.bz2
srcdir=attica-0.4.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-DQT4_BUILD=ON \
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
Description: Implementation of the Open Collaboration Services API
EOF
}

build
