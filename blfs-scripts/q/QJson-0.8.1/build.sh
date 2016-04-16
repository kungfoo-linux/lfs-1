#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=qjson-0.8.1.tar.bz2
srcdir=qjson-0.8.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Qt4 (>= 4.8.6)
Description: A qt-based library that maps JSON data to QVariant objects
EOF
}

build
