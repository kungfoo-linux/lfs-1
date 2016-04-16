#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=faac-1.28.tar.bz2
srcdir=faac-1.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/faac-1.28-glibc_fixes-1.patch
sed -i -e '/obj-type/d' -e '/Long Term/d' frontend/main.c

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Freeware Advanced Audio Coder
 FAAC is an encoder for a lossy sound compression scheme specified in MPEG-2
 Part 7 and MPEG-4 Part 3 standards and known as Advanced Audio Coding (AAC).
 This encoder is useful for producing files that can be played back on iPod.
 Moreover, iPod does not understand other sound compression schemes in video
 files.
 .
 [faac]
 is a command-line AAC encoder.
 .
 [libfaac.so]
 contains functions for encoding AAC streams.
 .
 [libmp4v2.so]
 contains functions for creating and manipulating MP4 files.
EOF
}

build
