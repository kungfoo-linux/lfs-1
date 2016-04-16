#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libva-1.3.1.tar.bz2
srcdir=libva-1.3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -p m4
autoreconf -f
./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: MesaLib (>= 10.2.7)
Description: Video Acceleration (VA) API for Linux
 The libva package contains a library which provides access to hardware
 accelerated video processing, using hardware to accelerate video processing
 in order to offload the central processing unit (CPU) to decode and encode
 compressed digital video. VA API video decode/encode interface is platform
 and window system independent targeted at Direct Rendering Infrastructure
 (DRI) in the X Window System however it can potentially also be used with
 direct framebuffer and graphics sub-systems for video output. Accelerated
 processing includes support for video decoding, video encoding, subpicture
 blending, and rendering.
 .
 [libva.so]
 contains API functions which provide access to hardware accelerated video
 processing.
EOF
}

build
