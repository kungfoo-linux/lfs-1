#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kde-runtime-4.14.1.tar.xz
srcdir=kde-runtime-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DSYSCONF_INSTALL_DIR=/etc \
	-DCMAKE_BUILD_TYPE=Release \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install
ln -sfv ../lib/kde4/libexec/kdesu $BUILDDIR/$KDE_PREFIX/bin/kdesu

#build/usr/share/icons/hicolor/index.theme

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: kdelibs (>= 4.14.1)
Recommends: kactivities (>= 4.13.3), kdepimlibs (>= 4.14.1), \
alsa-lib (>= 1.0.28), libjpeg-turbo (>= 1.3.1), Exiv2 (>= 0.24)
Suggests: PulseAudio (>= 5.0), xine-lib (>= 1.2.6), libcanberra (>= 0.30), \
NetworkManager (>= 0.9.10.0)
Description: runtime applications and libraries essential for KDE
EOF
}

build
