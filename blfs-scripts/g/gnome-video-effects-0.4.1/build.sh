#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnome-video-effects-0.4.1.tar.xz
srcdir=gnome-video-effects-0.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a collection of GStreamer effects
EOF
}

build
