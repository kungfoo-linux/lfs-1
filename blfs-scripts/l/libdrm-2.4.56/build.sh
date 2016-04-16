#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdrm-2.4.56.tar.bz2
srcdir=libdrm-2.4.56
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -e "/pthread-stubs/d" -i configure.ac

autoreconf -fiv
./configure --prefix=/usr --enable-udev
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7)
Description: Direct Rendering Manager runtime library
 libdrm provides core library routines for the X Window System to directly
 interface with video hardware using the Linux kernel's Direct Rendering
 Manager (DRM).
 .
 [libdrm.so]
 contains the Direct Rendering Manager API functions.
 .
 [libdrm_intel.so]
 contains the Intel specific Direct Rendering Manager functions.
 .
 [libdrm_nouveau.so]
 contains the open source nVidia (Nouveau) specific Direct Rendering Manager
 functions.
 .
 [libdrm_radeon.so]
 contains the AMD Radeon specific Direct Rendering Manager functions.
 .
 [libkms.so]
 contains API functions for kernel mode setting abstraction.
EOF
}

build
