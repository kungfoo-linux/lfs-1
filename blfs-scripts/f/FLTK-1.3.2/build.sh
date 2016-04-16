#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fltk-1.3.2-source.tar.gz
srcdir=fltk-1.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/fltk-1.3.2-tigervnc-1.patch
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/fltk-1.3.2-dynamic_libs-1.patch

sed -i -e '/FL_PATCH_VERSION=/ s/1/2/' configure
sed -i -e '/cat./d' documentation/Makefile

./configure --prefix=/usr \
	--enable-threads \
	--enable-xft \
	--enable-shared
make
make -C documentation html
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/fltk-1.3.2 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLU (>= 9.0.0), MesaLib (>= 10.2.7), Xorg-lib (>= 7.7), \
desktop-file-utils (>= 0.22), hicolor-icon-theme (>= 0.13), \
libjpeg-turbo (>= 1.3.1)
Description: a cross-platform C++ GUI toolkit
 FLTK (pronounced "fulltick") is a cross-platform C++ GUI toolkit. FLTK
 provides modern GUI functionality and supports 3D graphics via OpenGL and its
 built-in GLUT emulation libraries used for creating graphical user interfaces
 for applications.
 .
 [fltk-config]
 is a utility script that can be used to get information about the current
 version of FLTK that is installed on the system.
 .
 [fluid]
 is an interactive GUI designer for FLTK.
 .
 [libfltk.so]
 contains functions that provide an API to implement graphical user
 interfaces.
EOF
}

build
