#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gst-plugins-bad-1.4.1.tar.xz
srcdir=gst-plugins-bad-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer Bad Plugins 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gst-plugins-base1 (>= 1.4.1), libdvdread (>= 5.0.0), \
libdvdnav (>= 5.0.1), SoundTouch (>= 1.8.0), cURL (>= 7.37.1), \
FAAC (>= 1.28), FAAD2 (>= 2.7), GnuTLS (>= 3.3.7), GTK+2 (>= 2.24.24), \
libass (>= 0.11.2), libexif (>= 0.6.21), libgcrypt (>= 1.6.2), \
libmpeg2 (>= 0.5.1), libvdpau (>= 0.8), MesaLib (>= 10.2.7), \
mpg123 (>= 1.20.1), neon (>= 0.30.0), OpenJPEG (>= 1.5.2), \
OpenSSL (>= 1.0.1i), SDL (>= 1.2.15), OpenAL (>= 1.16.0)
Description: Gstreamer Bad Plug-ins
 The GStreamer Bad Plug-ins package contains a set a set of plug-ins that
 aren't up to par compared to the rest. They might be close to being good
 quality, but they're missing something - be it a good code review, some
 documentation, a set of tests, a real live maintainer, or some actual wide
 use.
EOF
}

build
