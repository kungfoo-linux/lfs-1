#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gst-plugins-ugly-1.4.1.tar.xz
srcdir=gst-plugins-ugly-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-package-name="GStreamer Ugly Plugins 1.4.1 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gst-plugins-base1 (>= 1.4.1), LAME (>= 3.99.5), \
libdvdread (>= 5.0.0), x264 (>= 20140818), liba52 (>= 0.7.4), \
libmad (>= 0.15.1b), libmpeg2 (>= 0.5.1)
Description: GStreamer Ugly Plug-ins
EOF
}

build
