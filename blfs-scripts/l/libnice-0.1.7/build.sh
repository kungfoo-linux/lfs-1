#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libnice-0.1.7.tar.gz
srcdir=libnice-0.1.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--without-gstreamer-0.10
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), gst-plugins-base1 (>= 1.4.1)
Description: Interactive Connectivity Establishment implementation
 The libnice package is an implementation of the IETF's draft Interactive
 Connectivity Establishment standard (ICE). It provides GLib-based library,
 libnice and GStreamer, elements.
EOF
}

build
