#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=faad2-2.7.tar.bz2
srcdir=faad2-2.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/faad2-2.7-mp4ff-1.patch
sed -i "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in
sed -i "s:man_MANS:man1_MANS:g" frontend/Makefile.am
autoreconf -fi

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: freeware Advanced Audio Decoder player
 .
 [faad]
 is a command-line utility for decoding AAC and MP4 files.
 .
 [libfaad.so]
 contains functions for decoding AAC streams.
EOF
}

build
