#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xf86-input-evdev-2.9.0.tar.bz2
srcdir=xf86-input-evdev-2.9.0
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
Depends: Libevdev (>= 1.2.2), Xorg-Server (>= 1.16.0), mtdev (>= 1.1.5)
Description: Generic Linux input driver for X
 The Xorg Evdev Driver package contains Generic Linux input driver for the
 Xorg X server. It handles keyboard, mouse, touchpads and wacom devices,
 though for touchpad and wacom advanced handling, additional drivers are
 required.
 .
 [evdev_drv.so]
 is an Xorg input driver for Linux generic event devices.
EOF
}

build
