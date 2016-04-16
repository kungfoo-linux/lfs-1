#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xterm-310.tgz
srcdir=xterm-310
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap
printf '\tkbs=\\177,\n' >> terminfo

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
	--with-app-defaults=/etc/X11/app-defaults
make
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR install-ti

cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc/X11/app-defaults
cat >> $BUILDDIR/etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-app (>= 7.7)
Description: a terminal emulator for the X Window System
 This package is not a part of the Xorg katamari and is provided only as a
 dependency to other packages or for testing the completed Xorg installation.
 .
 [koi8rxterm]
 is a wrapper script to set up xterm with a KOI8-R locale.
 .
 [resize]
 prints a shell command for setting the TERM and TERMCAP environment variables
 to indicate the current size of xterm window.
 .
 [uxterm]
 is a wrapper script that modifies the current locale to use UTF-8 and starts
 xterm with the proper settings.
 .
 [xterm]
 is a terminal emulator for the X Window System.
EOF
}

build
