#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=SDL_sound-1.0.3.tar.gz
srcdir=SDL_sound-1.0.3
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
Depends: SDL (>= 1.2.15), alsa-lib (>= 1.0.28), Mpg123 (>= 1.20.1), \
libvorbis (>= 1.3.4), Speex (>= 1.2rc1), FLAC (>= 1.3.0), \
libmodplug (>= 0.8.8.5)
Description: An abstract SDL sound-file decoder
EOF
}

build
