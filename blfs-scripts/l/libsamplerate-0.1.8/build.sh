#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsamplerate-0.1.8.tar.gz
srcdir=libsamplerate-0.1.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR htmldocdir=/usr/share/doc/libsamplerate-0.1.8 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libsndfile (>= 1.0.25)
Description: a sample rate converter for audio
EOF
}

build
