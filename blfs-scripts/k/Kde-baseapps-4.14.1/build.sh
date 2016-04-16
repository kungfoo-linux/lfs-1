#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kde-baseapps-4.14.1.tar.xz
srcdir=kde-baseapps-4.14.1
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
Recommends: kactivities (>= 4.13.3), kfilemetadata (>= 4.14.1), \
baloo (>= 4.14.1), baloo-widgets (>= 4.14.1)
Suggests: Tidy (>= 20101110cvs), GLib (>= 2.40.0)
Description: KDE Core Applications
EOF
}

build
