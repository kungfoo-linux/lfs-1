#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdv-1.0.0.tar.gz
srcdir=libdv-1.0.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-xv \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: popt (>= 1.16)
Description: The Quasar DV Codec
 The Quasar DV Codec (libdv) is a software CODEC for DV video, the encoding
 format used by most digital camcorders. It can be used to copy videos from
 camcorders using a firewire (IEEE 1394) connection.
EOF
}

build
