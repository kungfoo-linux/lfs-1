#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openobex-1.7.1-Source.tar.gz
srcdir=openobex-1.7.1-Source
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DCMAKE_BUILD_TYPE=Release \
	..
make
make DESTDIR=$BUILDDIR install
#make CMAKE_INSTALL_PREFIX=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libusb (>= 1.0.19), BlueZ (>= 5.23)
Description: Library for using OBEX
 The OpenOBEX package contains a library that implements Object Exchange
 Protocol used for binary file transfers between devices.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "plugdev" > /dev/null 2>&1 ; then
	    groupadd -g 90 plugdev
	fi'

POSTRM_CONF_DEF='
	if getent group "plugdev" > /dev/null 2>&1 ; then
	    groupdel plugdev
	fi'
}

build
