#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgusb-0.1.6.tar.xz
srcdir=libgusb-0.1.6
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
Depends: libusb (>= 1.0.19), Eudev (= 1.10), gobject-introspection (>= 1.40.0), \
Vala (>= 0.24.0)
Description: the GObject wrappers for libusb-1.0
 The libgusb package contains the GObject wrappers for libusb-1.0 that makes
 it easy to do asynchronous control, bulk and interrupt transfers with proper
 cancellation and integration into a mainloop.
 .
 [libgusb.so]
 contains the libgusb API functions.
EOF
}

build
