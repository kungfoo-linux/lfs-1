#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libvorbis-1.3.4.tar.xz
srcdir=libvorbis-1.3.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

install -v -m644 doc/Vorbis* $BUILDDIR/usr/share/doc/libvorbis-1.3.4

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libogg (>= 1.3.2)
Description: The Vorbis General Audio Compression Codec
 Ogg Vorbis is a fully open, non-proprietary, patent-and-royalty-free,
 general-purpose compressed audio format for audio and music at fixed
 and variable bitrates from 16 to 128 kbps/channel.
 .
 [libvorbis.so]
 provides the functions used to read and write sound files.
EOF
}

build
