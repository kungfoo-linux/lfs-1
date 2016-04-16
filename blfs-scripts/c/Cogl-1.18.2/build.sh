#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cogl-1.18.2.tar.xz
srcdir=cogl-1.18.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-gles1 \
	--enable-gles2
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gdk-pixbuf (>= 2.30.8), MesaLib (>= 10.2.7), Pango (>= 1.36.7), \
gobject-introspection (>= 1.40.0)
Description: A library for using 3D graphics hardware to draw pretty pictures
 Cogl is a modern 3D graphics API with associated utility APIs designed to
 expose the features of 3D graphics hardware using a direct state access API
 design, as opposed to the state-machine style of OpenGL.
 .
 [libcogl-gles2.so]
 is the OpenGL ES 2.0 integration library for Cogl.
 .
 [libcogl-pango.so]
 is the Pango integration library for Cogl.
 .
 [libcogl.so]
 is an object oriented GL/GLES Abstraction/Utility Layer library.
EOF
}

build
