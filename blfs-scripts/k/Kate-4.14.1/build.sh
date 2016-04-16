#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kate-4.14.1.tar.xz
srcdir=kate-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-DINSTALL_PYTHON_FILES_IN_PYTHON_PREFIX=TRUE \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: kdelibs (>= 4.14.1)
Recommends: kactivities (>= 4.13.3)
Suggests: QJson (>= 0.8.1)
Description: Advanced Text Editor
 This package provides two texteditors: Kate and KWrite. Kate is a powerful
 programmer's text editor with syntax highlighting for many programming and
 scripting languages. KWrite is the lightweight cousin of Kate.
EOF
}

build
