#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=phonon-4.8.0.tar.xz
srcdir=phonon-4.8.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build


cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=FALSE \
	-DDBUS_INTERFACES_INSTALL_DIR=/usr/share/dbus-1/interfaces \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: automoc4 (>= 0.9.88), GLib (>= 2.40.0)
Suggests: PulseAudio (>= 5.0)
Description: multimedia framework for Qt
 Phonon is the multimedia API for KDE4. It replaces the old aRts, that is no
 longer supported by KDE. Phonon needs either the GStreamer or VLC backend.
EOF
}

build
