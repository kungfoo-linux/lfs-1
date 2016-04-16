#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=automoc4-0.9.88.tar.bz2
srcdir=automoc4-0.9.88
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
Depends: KDE-cfg (>= 7.6), Qt4 (>= 4.8.6)
Description: automatic moc for Qt 4 packages
 This package contains the automoc4 binary which is used to run moc on the
 right binaries in a Qt 4 or KDE 4 application.
 .
 Moc is the meta object compiler which is a much used tool when using the Qt
 toolkit.
EOF
}

build
