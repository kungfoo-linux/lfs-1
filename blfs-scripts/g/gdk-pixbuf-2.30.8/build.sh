#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gdk-pixbuf-2.30.8.tar.xz
srcdir=gdk-pixbuf-2.30.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-x11 \
	--with-libjasper
make
make DESTDIR=$BUILDDIR install

make install
cp /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache \
	$BUILDDIR/usr/lib/gdk-pixbuf-2.0/2.10.0/

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), \
LibTIFF (>= 4.0.3), Xorg-lib (>= 7.7), gobject-introspection (>= 1.40.0), \
JasPer (>= 1.900.1)
Description: a toolkit for image loading and pixel buffer manipulation
 The Gdk Pixbuf is a toolkit for image loading and pixel buffer manipulation.
 It is used by GTK+ 2 and GTK+ 3 to load and manipulate images. In the past it
 was distributed as part of GTK+ 2 but it was split off into a separate
 package in preparation for the change to GTK+ 3.
 .
 [gdk-pixbuf-csource]
 is a small utility that generates C code containing images, used for
 compiling images directly into programs.
 .
 [gdk-pixbuf-query-loaders]
 collects information about loadable modules for Gdk Pixbuf and writes it to
 the default cache file location, or to stdout.
 .
 [libgdk_pixbuf-2.0.so]
 contains functions used to load and render images.
 .
 [libgdk_pixbuf_xlib-2.0.so]
 contains functions used to manipulate images and interfaces with Xlib.
EOF
}

build
