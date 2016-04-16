#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=baloo-4.14.1.tar.xz
srcdir=baloo-4.14.1
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
Depends: kdepimlibs (>= 4.14.1), kfilemetadata (>= 4.14.1), xapian (>= 1.2.17)
Suggests: OpenSSL (>= 1.0.1i)
Description: a framework for searching and managing metadata
EOF
}

build
