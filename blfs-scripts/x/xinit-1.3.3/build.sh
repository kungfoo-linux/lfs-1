#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xinit-1.3.3.tar.bz2
srcdir=xinit-1.3.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG \
	--with-xinitdir=/etc/X11/app-defaults
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: twm (>= 1.0.8), xclock (>= 1.0.7), xterm (>= 310)
Description: X Window System initializer
 The xinit package contains a usable script to start the xserver. This package
 is not a part of the Xorg katamari and is provided only as a dependency to
 other packages or for testing the completed Xorg installation.
 .
 [startx]
 initializes an X session.
 .
 [xinit]
 is the X Window System initializer.
EOF
}

build
