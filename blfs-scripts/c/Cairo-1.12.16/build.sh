#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cairo-1.12.16.tar.xz
srcdir=cairo-1.12.16
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

CFLAGS="$CFLAGS -ffat-lto-objects" \
	./configure --prefix=/usr \
	--disable-static \
	--enable-tee \
	--enable-xlib-xcb \
	--enable-gl
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libpng (>= 1.6.13), GLib (>= 2.40.0), Pixman (>= 0.32.6), \
Fontconfig (>= 2.11.1), Xorg-lib (>= 7.7), LZO (>= 2.08), MesaLib (>= 10.2.7)
Description: a 2D vector graphics library
 Cairo is a 2D graphics library with support for multiple output devices.
 Currently supported output targets include the X Window System, win32, image
 buffers, PostScript, PDF and SVG. Experimental backends include OpenGL,
 Quartz and XCB file output. Cairo is designed to produce consistent output on
 all output media while taking advantage of display hardware acceleration when
 available (e.g., through the X Render Extension). The Cairo API provides
 operations similar to the drawing operators of PostScript and PDF. Operations
 in Cairo include stroking and filling cubic Bézier splines, transforming and
 compositing translucent images, and antialiased text rendering. All drawing
 operations can be transformed by any affine transformation (scale, rotation,
 shear, etc.).
 .
 [cairo-trace]
 generates a log of all calls made by an application to Cairo.
 .
 [libcairo.so]
 contains the 2D graphics functions required for rendering to the various
 output targets.
 .
 [libcairo-gobject.so]
 contains functions that integrate Cairo with GLib-2.40.0's GObject type
 system.
 .
 [libcairo-script-interpreter.so]
 contains the script interpreter functions for executing and manipulating
 Cairo execution traces.
EOF
}

build
