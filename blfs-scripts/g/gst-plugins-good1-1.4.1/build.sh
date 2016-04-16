#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gst-plugins-good-1.4.1.tar.xz
srcdir=gst-plugins-good-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer Good Plugins 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" 
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gst-plugins-base1 (>= 1.4.1), Cairo (>= 1.12.16), FLAC (>= 1.3.0), \
gdk-pixbuf (>= 2.30.8), libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), \
libsoup (>= 2.46.0), libvpx (>= 1.3.0), Xorg-lib (>= 7.7), AAlib (>= 1.4rc5), \
GTK+3 (>= 3.12.2), PulseAudio (>= 5.0), Speex (>= 1.2rc1), taglib (>= 1.9.1), \
eudev (>= 1.10)
Description: GStreamer Good Plug-ins
 The GStreamer Good Plug-ins is a set of plug-ins considered by the GStreamer
 developers to have good quality code, correct functionality, and the
 preferred license (LGPL for the plug-in code, LGPL or LGPL-compatible for the
 supporting library). A wide range of video and audio decoders, encoders, and
 filters are included.
EOF
}

build
