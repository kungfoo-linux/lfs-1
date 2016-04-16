#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wine-1.6.2.tar.bz2
srcdir=wine-1.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

if [ "$ARCHITECTURE" = "amd64" ]; then
	ARCHARGS="--enable-win64"
fi

# enable('y') or disable('n') X Window System support:
ENABLE_X_WINDOW='y'
if [ "$ENABLE_X_WINDOW" = 'n' ]; then
	XARGS="--without-x --without-freetype"
fi

./configure --prefix=/usr CFLAGS=-O2 $ARCHARGS $XARGS
make $JOBS
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Recommends: Xorg-lib (>= 7.7)
Description: Microsoft Windows Compatibility Layer
 Wine is an Open Source implementation of the Windows API on top of X and
 Unix. Wine provides both a development toolkit for porting Windows sources
 to Unix and a program loader, allowing many unmodified Windows binaries to
 run on x86-based Unixes.
EOF
}

build
