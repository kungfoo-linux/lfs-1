#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=alsa-plugins-1.0.28.tar.bz2
srcdir=alsa-plugins-1.0.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), libsamplerate (>= 0.1.8), PulseAudio (>= 5.0), \
Speex (>= 1.2rc1)
Description: plugins for various audio libraries and sound servers
EOF
}

build
