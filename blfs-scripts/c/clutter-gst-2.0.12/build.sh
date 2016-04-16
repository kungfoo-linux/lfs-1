#!/bin/bash -e
. ../../blfs.comm

# NOTE: This package fails to build over an ssh session.

build_src() {
srcfil=clutter-gst-2.0.12.tar.xz
srcdir=clutter-gst-2.0.12
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
Depends: Clutter (>= 1.18.4), gst-plugins-base1 (>= 1.4.1)
Recommends: gobject-introspection (>= 1.40.0), gst-plugins-bad1 (>= 1.4.1)
Description: ClutterMedia interface to GStreamer
 The Clutter Gst is an integration library for using GStreamer with Clutter.
 Its purpose is to implement the ClutterMedia interface using GStreamer.
EOF
}

build
