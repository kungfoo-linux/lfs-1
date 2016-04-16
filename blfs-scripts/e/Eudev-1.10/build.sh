#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=eudev-1.10.tar.gz
srcdir=eudev-1.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# fix a test script:
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl

./configure --prefix=/usr       \
	--bindir=/sbin          \
	--sbindir=/sbin         \
	--libdir=/usr/lib       \
	--sysconfdir=/etc       \
	--libexecdir=/lib       \
	--with-rootprefix=      \
	--with-rootlibdir=/lib  \
	--enable-split-usr      \
	--enable-libkmod        \
	--enable-rule_generator \
	--enable-keymap         \
	--disable-introspection \
	--disable-gtk-doc-html  \
	--with-firmware-path=/lib/firmware
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0)
Description: utilities for dynamic creation of device nodes
 Eudev was indeed installed in LFS and there is no reason to reinstall it
 unless the user is going to install a package such as UPower that needs
 libgudev. These instructions enable building libgudev and also optionally
 create gir data for Eudev.
 .
 Eudev was indeed installed in LFS and there is no reason to reinstall it
 unless the user is going to install a package such as UPower that needs
 libgudev. These instructions enable building libgudev and also optionally
 create gir data for Eudev.
 .
 Runtime Dependencies:
 pciutils-3.2.1 and usbutils-007.
 .
 [libgudev-1.0.so]
 is a GObject-based wrapper library for libudev.
EOF
}

build
