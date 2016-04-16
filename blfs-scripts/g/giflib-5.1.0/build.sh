#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=giflib-5.1.0.tar.bz2
srcdir=giflib-5.1.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for GIF images
 .
 [gif2rgb]
 converts images saved as GIF to 24-bit RGB images.
 .
 [gifbuild]
 dumps GIF data in a textual format, or undumps it to a GIF.
 .
 [gifclrmp]
 modifies GIF image colormaps.
 .
 [gifecho]
 generates a GIF from ASCII text.
 .
 [giffix]
 clumsily attempts to fix truncated GIF images.
 .
 [gifinto]
 is an end-of-pipe fitting for GIF-processing pipelines.
 .
 [giftext]
 prints (text only) general information about a GIF file.
 .
 [giftool]
 is a GIF transformation tool.
 .
 [libgif.so]
 contains API functions required by the giflib programs and any other programs
 needing library functionality to read, write and manipulate GIF images.
EOF
}

build
