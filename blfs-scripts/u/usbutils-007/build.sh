#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=usbutils-007.tar.xz
srcdir=usbutils-007
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-zlib \
	--datadir=/usr/share/misc
make
make DESTDIR=$BUILDDIR install
mv -v $BUILDDIR/usr/sbin/{update-usbids.sh,update-usbids}

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libusb (>= 1.0.19)
Description: Linux USB utilities
 The USB Utils package contains an utility used to display information about
 USB buses in the system and the devices connected to them.
 .
 The usb.ids data file is constantly being updated. To get a current version
 of this file, run update-usbids as the root user. This program requires the
 "Which" script or program to find "Lynx" or "Wget" which are used to download
 the most current file, and replace the existing file in /usr/share/misc.
 .
 [lsusb]
 is an utility for displaying information about all USB buses in the system
 and all devices connected to them.
 .
 [update-usbids]
 downloads the current version of the USB ID list. Requires "Lynx" or "Wget".
 .
 [usb-devices]
 is a shell script that displays details of USB buses and devices connected to
 them. It is designed to be used if /proc/bus/usb/devices is not available on
 your system.
 .
 [usbhid-dump]
 is used to dump report descriptors and streams from HID (human interface
 device) interfaces of USB devices.
EOF
}

build
