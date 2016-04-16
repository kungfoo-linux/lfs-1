#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=live.2014.11.28.tar.gz
srcdir=live
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./genMakefiles linux
make
make DESTDIR=$BUILDDIR PREFIX=/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A complete RTSP server application and a command-line RTSP client
EOF
}

build
