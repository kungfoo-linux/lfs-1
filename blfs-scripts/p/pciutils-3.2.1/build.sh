#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pciutils-3.2.1.tar.xz
srcdir=pciutils-3.2.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make PREFIX=/usr \
     SHAREDIR=/usr/share/misc \
     SHARED=yes
make DESTDIR=$BUILDDIR \
     PREFIX=/usr \
     SHAREDIR=/usr/share/misc \
     SHARED=yes \
     install install-lib
chmod -v 755 $BUILDDIR/usr/lib/libpci.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Linux PCI Utilities
 This package contains various utilities for inspecting and setting of devices
 connected to the PCI bus.
 .
 The pci.ids data file is constantly being updated. To get a current version
 of this file, run update-pciids as the root user. This program requires the
 Which-2.20 script or program to find "cURL", "Lynx" or "Wget" which are used
 to download the most current file, and then replace the existing file in
 /usr/share/misc.
 .
 [lspci]
 is an utility for displaying information about all PCI buses in the system
 and all devices connected to them.
 .
 [setpci]
 is an utility for querying and configuring PCI devices.
 .
 [update-pciids]
 fetches the current version of the PCI ID list. Requires "cURL", "Lynx" or
 "Wget".
 .
 [libpci.so]
 is library that allows applications to access the PCI subsystem.
EOF
}

build
