#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cmake-3.0.1.tar.gz
srcdir=cmake-3.0.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./bootstrap --prefix=/usr \
	--system-libs \
	--mandir=/share/man \
	--docdir=/share/doc/cmake-3.0.1 
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: cURL (>= 7.37.1), libarchive (>= 3.1.2)
Suggests: Qt4 (>= 4.8.6), Qt5 (>= 5.3.1)
Description: cross-platform make system
 The CMake package contains a modern toolset used for generating Makefiles. It
 is a successor of the auto-generated configure script and aims to be
 platform- and compiler-independent. A significant user of CMake is KDE since
 version 4.
 .
 [ccmake]
 is a curses based interactive frontend to cmake.
 .
 [cmake]
 is the makefile generator.
 .
 [cmake-gui]
 (optional) is the Qt-based frontent to cmake.
 .
 [cpack]
 is the CMake packaging program.
 .
 [ctest]
 is a testing utility for cmake-generated build trees. 
EOF
}

build
