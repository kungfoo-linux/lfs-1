#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lame-3.99.5.tar.gz
srcdir=lame-3.99.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# with gcc-4.9.0, 32-bit i686 builds fail in xmm_quantize_sub.c with an error
# message error: inlining failed in call to always_inline '_mm_loadu_ps'.
# This sed makes it appear as if xmmintrin.h is not present. (Do not use this
# on other versions of gcc, or on x86_64):
case `uname -m` in
    i?86)
        gcc_ver=`gcc --version | head -n1 | cut -d" " -f3 | grep "4.9"`
	if [ ${#gcc_ver} != 0 ]; then
	    sed -i -e '/xmmintrin\.h/d' configure
	fi
	;;
esac

./configure --prefix=/usr \
	--disable-static \
	--enable-mp3rtp \
	--enable-nasm
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: MP3 encoding library
 .
 [lame]
 creates MP3 audio files from raw PCM or .wav data.
 .
 [mp3rtp]
 is used to encode MP3 with RTP streaming of the output.
 .
 [libmp3lame.so]
 libraries provide the functions necessary to convert raw PCM and WAV files to
 MP3 files.
EOF
}

build
