#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=librsvg-2.40.3.tar.xz
srcdir=librsvg-2.40.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-vala \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gdk-pixbuf (>= 2.30.8), libcroco (>= 0.6.8), Pango (>= 1.36.7), \
GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0), Vala (>= 0.24.0)
Description: SAX-based renderer library for SVG files
 The librsvg package contains a library and tools used to manipulate, convert
 and view Scalable Vector Graphic (SVG) images.
 .
 [rsvg-convert]
 is used to convert images into PNG, PDF, PS, SVG and other formats.
 .
 [rsvg-view-3]
 is a simple GTK+ 3 application that can be used to view an SVG file.
 .
 [librsvg-2.so]
 provides the functions to render Scalable Vector Graphics.
 .
 [libpixbufloader-svg.so]
 is the Gdk Pixbuf plugin that allows GTK+ applications to render Scalable
 Vector Graphics images.
EOF
}

build
