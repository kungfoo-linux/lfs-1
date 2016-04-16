#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xine-lib-1.2.6.tar.xz
srcdir=xine-lib-1.2.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-vcd \
	--docdir=/usr/share/doc/xine-lib-1.2.6
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: FFmpeg (>= 2.3.3), alsa-utils (>= 1.0.28), PulseAudio (>= 5.0)
Suggests: AAlib (>= 1.4rc5), FAAD2 (>= 2.7), FLAC (>= 1.3.0), \
gdk-pixbuf (>= 2.30.8), GLU (>= 9.0.0), liba52 (>= 0.7.4), \
libdvdnav (>= 5.0.1), libmad (>= 0.15.1b), libmng (>= 2.0.2), \
libtheora (>= 1.1.1), libva (>= 1.3.1), libvdpau (>= 0.8), \
libvorbis (>= 1.3.4), libvpx (>= 1.3.0), MesaLib (>= 10.2.7), \
SDL (>= 1.2.15), Speex (>= 1.2rc1)
Description: Xine library
EOF
}

build
