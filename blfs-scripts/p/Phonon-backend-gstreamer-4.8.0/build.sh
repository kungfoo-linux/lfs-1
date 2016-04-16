#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=phonon-backend-gstreamer-4.8.0.tar.xz
srcdir=phonon-backend-gstreamer-4.8.0
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
Depends: phonon (>= 4.8.0), GStreamer1 (>= 1.4.1)
Recommends: gst-plugins-base1 (>= -1.4.1), gst-plugins-good1 (>= 1.4.1), \
gst-plugins-bad1 (>= 1.4.1), gst-plugins-ugly1 (>= 1.4.1)
Description: Gstreamer phonon backend
EOF
}

build
