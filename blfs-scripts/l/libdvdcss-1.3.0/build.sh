#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdvdcss-1.3.0.tar.bz2
srcdir=libdvdcss-1.3.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/libdvdcss-1.3.0
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A portable abstraction library for DVD decryption
 This is a portable abstraction library for DVD decryption which is used by
 the VideoLAN project, a full MPEG2 client/server solution. You will need to
 install this package in order to have encrypted DVD playback with the
 VideoLAN client and the Xine navigation plugin.
EOF
}

build
