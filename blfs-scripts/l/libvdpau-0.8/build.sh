#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libvdpau-0.8.tar.gz
srcdir=libvdpau-0.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7)
Description: Video Decode and Presentation API for Unix
 The libvdpau package contains a library which implements the VDPAU library.
 .
 VDPAU (Video Decode and Presentation API for Unix) is an open source library
 (libvdpau) and API originally designed by Nvidia for its GeForce 8 series and
 later GPU hardware targeted at the X Window System This VDPAU API allows
 video programs to offload portions of the video decoding process and video
 post-processing to the GPU video-hardware.
 .
 Currently, the portions capable of being offloaded by VDPAU onto the GPU are
 motion compensation (mo comp), inverse discrete cosine transform (iDCT), VLD
 (variable-length decoding) and deblocking for MPEG-1, MPEG-2, MPEG-4 ASP
 (MPEG-4 Part 2), H.264/MPEG-4 AVC and VC-1, WMV3/WMV9 encoded videos. Which
 specific codecs of these that can be offloaded to the GPU depends on the
 version of the GPU hardware; specifically, to also decode MPEG-4 ASP (MPEG-4
 Part 2), Xvid/OpenDivX (DivX 4), and DivX 5 formats, a GeForce 200M (2xxM)
 Series (the eleventh generation of Nvidia's GeForce graphics processing
 units) or newer GPU hardware is required.
 .
 [libvdpau.so]
 contains functions to offload portions of the video decoding process and
 video post-processing to the GPU video-hardware.
EOF
}

build
