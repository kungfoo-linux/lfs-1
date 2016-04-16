#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gst-libav-1.4.1.tar.xz
srcdir=gst-libav-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer Libav Plugins 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gst-plugins-base1 (>= 1.4.1), yasm (>= 1.3.0)
Description: GStreamer plugins for Libav (a fork of FFmpeg)
EOF
}

build
