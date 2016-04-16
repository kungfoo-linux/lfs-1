#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libcanberra-0.30.tar.xz
srcdir=libcanberra-0.30
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-oss
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/libcanberra-0.30 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libvorbis (>= 1.3.4), alsa-lib (>= 1.0.28), GStreamer1 (>= 1.4.1), \
GTK+3 (>= 3.12.2), GTK+2 (>= 2.24.24), PulseAudio (>= 5.0)
Description: simple abstract interface for playing event sounds
EOF
}

build
