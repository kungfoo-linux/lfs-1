#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pa_stable_v19_20140130.tgz
srcdir=portaudio
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-cxx
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28)
Description: Portable Real-Time Audio Library
 PortAudio is a free, cross-platform, open-source, audio I/O library.  It lets
 you write simple audio programs in 'C' or C++ that will compile and run on
 many platforms including Windows, Macintosh OS X, and Unix (OSS/ALSA). It is
 intended to promote the exchange of audio software between developers on
 different platforms. Many applications use PortAudio for Audio I/O.
EOF
}

build
