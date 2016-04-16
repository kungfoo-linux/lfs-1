#!/bin/bash -e
. ../../blfs.comm

# This package need yasm-1.3.0 to compile.

build_src() {
srcfil=x264-snapshot-20140818-2245-stable.tar.bz2
srcdir=x264-snapshot-20140818-2245-stable
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-shared \
	--disable-cli
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a library for encoding video streams into the H.264/MPEG-4 AVC format
EOF
}

build
