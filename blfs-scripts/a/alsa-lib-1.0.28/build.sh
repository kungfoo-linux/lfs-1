#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=alsa-lib-1.0.28.tar.bz2
srcdir=alsa-lib-1.0.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The Advanced Linux Sound Architecture (ALSA) library
 .
 Kernel configuration:
 --------------------------------------------------
 . Device Drivers  --->
 .   <*> Sound card support  --->
 .       <*> Advanced Linux Sound Architecture --->
 .              Select settings and drivers appropriate for your hardware
 .       < > Open Sound System (unselected)
 --------------------------------------------------
 .
 [aserver]
 is the ALSA server.
 .
 [libasound.so]
 contains the ALSA API functions.
EOF
}

build
