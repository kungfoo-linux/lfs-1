#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=soundtouch-1.8.0.tar.gz
srcdir=soundtouch
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac
./bootstrap

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR pkgdocdir=/usr/share/doc/soundtouch-1.8.0 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: An open-source audio processing library
 The SoundTouch package contains an open-source audio processing library that
 allows changing the sound tempo, pitch and playback rate parameters
 independently from each other.
EOF
}

build
