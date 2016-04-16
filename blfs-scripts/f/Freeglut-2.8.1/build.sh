#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=freeglut-2.8.1.tar.gz
srcdir=freeglut-2.8.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLU (>= 9.0.0)
Description: Freely licensed alternative to the GLUT library
 Freeglut is intended to be a 100% compatible, completely opensourced clone of
 the GLUT library. GLUT is a window system independent toolkit for writing
 OpenGL programs, implementing a simple windowing API, which makes learning
 about and exploring OpenGL programming very easy.
 .
 [libglut.so]
 contains functions that implement the OpenGL Utility Toolkit.
EOF
}

build
