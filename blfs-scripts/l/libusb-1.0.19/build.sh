#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libusb-1.0.19.tar.bz2
srcdir=libusb-1.0.19
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
Description: userspace USB programming library
 The libusb package contains a library used by some applications for USB
 device access.
 .
 [libusb-1.0.so]
 contains API functions used for accessing USB hardware.
 .
 Kernel configuration:
 -----------------------------------------------------------
 . Device Drivers --->
 .   [*] USB support --->
 .       <*> Support for Host-side USB
 .           <select any USB hardware device drivers you needed>
 -----------------------------------------------------------
EOF
}

build
