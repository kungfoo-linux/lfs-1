#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=speex-1.2rc1.tar.gz
srcdir=speex-1.2rc1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/speex-1.2rc1
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libogg (>= 1.3.2)
Description: A Free Codec For Free Speech
 Speex is an Open Source/Free Software patent-free audio compression format
 designed for speech. The Speex Project aims to lower the barrier of entry for
 voice applications by providing a free alternative to expensive proprietary
 speech codecs. Moreover, Speex is well-adapted to Internet applications and
 provides useful features that are not present in most other codecs.
 .
 [speexdec]
 decodes a Speex file and produces a WAV or raw file.
 .
 [speexenc]
 encodes a WAV or raw files using Speex.
 .
 [libspeex.so]
 provides functions for the audio encoding/decoding programs.
 .
 [libspeexdsp.so]
 is a speech processing library that goes along with the Speex codec.
EOF
}

build
