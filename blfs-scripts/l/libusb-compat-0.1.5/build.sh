#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libusb-compat-0.1.5.tar.bz2
srcdir=libusb-compat-0.1.5
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
Depends: libusb (>= 1.0.19)
Description: a compatibility layer of libusb-0.1 API
 The libusb-compat package aims to look, feel and behave exactly like
 libusb-0.1. It is a compatibility layer needed by packages that have not been
 upgraded to the libusb-1.0 API.
 .
 [libusb.so]
 is a library that is compatible with libusb-0.1, but uses libusb-1.0 to
 provide functionality.
EOF
}

build
