#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libevdev-1.2.2.tar.xz
srcdir=libevdev-1.2.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8)
Description: common functions for Xorg input drivers
 .
 Kernel configuration:
 --------------------------------------------------
 . Device Drivers  --->
 .     Input device support --->
 .       <*> Event interface: Y or M
 .       [*] Miscellaneous devices  --->
 .           <*> User level driver support: Y or M
 --------------------------------------------------
 .
 [libevdev.so]
 is a library of Xorg driver input functions.
EOF
}

build
