#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libva-intel-driver-1.3.2.tar.bz2
srcdir=libva-intel-driver-1.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -p m4
autoreconf -f
./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libva (>= 1.3.1)
Description: Video Acceleration for Intel Driver (i965 chipsets only)
 The libva-intel-driver is designed specifically for video cards based on an
 Intel GPU.
EOF
}

build
