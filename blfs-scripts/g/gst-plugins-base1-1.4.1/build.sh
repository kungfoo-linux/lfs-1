#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gst-plugins-base-1.4.1.tar.xz
srcdir=gst-plugins-base-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer Base Plugins 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GStreamer1 (>= 1.4.1), alsa-lib (>= 1.0.28), \
gobject-introspection (>= 1.40.0), ISO-Codes (>= 3.56), libogg (>= 1.3.2), \
libtheora (>= 1.1.1), libvorbis (>= 1.3.4), Xorg-lib (>= 7.7), \
GTK+3 (>= 3.12.2)
Description: GStreamer Base Plug-ins
 The GStreamer Base Plug-ins is a well-groomed and well-maintained collection
 of GStreamer plug-ins and elements, spanning the range of possible types of
 elements one would want to write for GStreamer. You will need at least one of
 Good, Bad, Ugly or Libav plugins for GStreamer applications to function
 properly.
EOF
}

build
