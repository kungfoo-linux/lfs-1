#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=SDL2-2.0.3.tar.gz
srcdir=SDL2-2.0.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cp include/SDL_config_minimal.h $BUILDDIR/usr/include/SDL2/

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-utils (>= 1.0.28), PulseAudio (>= 5.0), NASM (>= 2.11.05), \
Xorg-lib (>= 7.7), GLU (>= 9.0.0)
Description: Simple DirectMedia Layer
 The Simple DirectMedia Layer (SDL for short) is a cross-platform library
 designed to make it easy to write multimedia software, such as games and
 emulators.
EOF
}

build
