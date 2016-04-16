#!/bin/bash -e
. ../../blfs.comm

# The ALSA Firmware package is only needed by those with advanced requirements
# for their sound card. See the README for configure options.

build_src() {
srcfil=alsa-firmware-1.0.28.tar.bz2
srcdir=alsa-firmware-1.0.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

rm -rf $BUILDDIR/lib/firmware/turtlebeach

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-tools (>= 1.0.28)
Description: firmware for certain sound cards
EOF
}

#build
rm -rf $BUILDDIR/lib/firmware/turtlebeach
