#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kfilemetadata-4.14.1.tar.xz
srcdir=kfilemetadata-4.14.1
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
Suggests: taglib (>= 1.9.1), Poppler (>= 0.26.4), Exiv2 (>= 0.24), \
FFmpeg (>= 2.3.3)
Description: a framework for searching and managing metadata
EOF
}

build
