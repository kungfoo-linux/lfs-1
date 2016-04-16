#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=SDL-1.2.15.tar.gz
srcdir=SDL-1.2.15
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/_XData32/s:register long:register _Xconst long:' \
	src/video/x11/SDL_x11sym.h

./configure --prefix=/usr \
	--disable-static \
	--enable-video-aalib
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-utils (>= 1.0.28), PulseAudio (>= 5.0), NASM (>= 2.11.05), \
Xorg-lib (>= 7.7), GLU (>= 9.0.0), AAlib (>= 1.4rc5)
Description: Simple DirectMedia Layer
 The Simple DirectMedia Layer (SDL for short) is a cross-platform library
 designed to make it easy to write multimedia software, such as games and
 emulators.
EOF
}

build
