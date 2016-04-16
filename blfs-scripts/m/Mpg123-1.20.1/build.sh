#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mpg123-1.20.1.tar.bz2
srcdir=mpg123-1.20.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-module-suffix=.so
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), OpenAL (>= 1.16.0), PulseAudio (>= 5.0), \
PortAudio (>= 19), SDL (>= 1.2.15)
Description: a console-based MP3 player
EOF
}

build
