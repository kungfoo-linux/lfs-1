#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=audiofile-0.3.6.tar.xz
srcdir=audiofile-0.3.6
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
Depends: alsa-lib (>= 1.0.28), FLAC (>= 1.3.0)
Description: A library for accessing various audio file formats
 .
 [sfinfo]
 displays the sound file format, audio encoding, sampling rate and duration
 for audio formats supported by this library.
 .
 [sfconvert]
 converts sound file formats where the original format and destination
 format are supported by this library.
 .
 [libaudiofile.so]
 contains functions used by programs to support AIFF, AIFF-compressed,
 Sun/NeXT, WAV and BIC audio formats. 
EOF
}

build
