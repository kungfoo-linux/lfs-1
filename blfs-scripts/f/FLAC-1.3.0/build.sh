#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=flac-1.3.0.tar.xz
srcdir=flac-1.3.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# -enable-sse: This option is off by default and should be set on if your
# machine has SSE capability. One way to find out if you have SSE is to issue
# cat /proc/cpuinfo and see if sse is listed in the flags.

./configure --prefix=/usr \
	--disable-thorough-tests \
	--enable-sse
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libogg (>= 1.3.2), NASM (>= 2.11.05)
Description: Free Lossless Audio Codec
 FLAC is an audio CODEC similar to MP3, but lossless, meaning that audio is
 compressed without losing any information.
 .
 [flac]
 is a command-line utility for encoding, decoding and converting FLAC files.
 .
 [metaflac]
 is a program for listing, adding, removing, or editing metadata in one or
 more FLAC files.
 .
 [libFLAC{,++}.so]
 these libraries provide native FLAC and Ogg FLAC C/C++ APIs for programs
 utilizing FLAC.
EOF
}

build
