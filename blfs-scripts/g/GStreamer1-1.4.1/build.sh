#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gstreamer-1.4.1.tar.xz
srcdir=gstreamer-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" \
	--disable-valgrind
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0), Gsl (>= 1.16)
Description: Streaming-Media Framework Runtime
 GStreamer is a streaming media framework that enables applications to share a
 common set of plugins for things like video encoding and decoding, audio
 encoding and decoding, audio and video filters, audio visualisation, web
 streaming and anything else that streams in real-time or otherwise. This
 package only provides base functionality and libraries. You may need at least
 gst-plugins-base-1.4.1 and one of Good, Bad, Ugly or Libav plugins.
EOF
}

build
