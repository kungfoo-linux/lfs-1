#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdbusmenu-qt-0.9.2.tar.bz2
srcdir=libdbusmenu-qt-0.9.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release  \
	-DWITH_DOC=OFF \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Qt4 (>= 4.8.6)
Description: A Qt implementation of the DBusMenu protocol
EOF
}

build
