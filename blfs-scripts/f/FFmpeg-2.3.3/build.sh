#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ffmpeg-2.3.3.tar.bz2
srcdir=ffmpeg-2.3.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/-lflite"/-lflite -lasound"/' configure

./configure --prefix=/usr   \
	--enable-gpl        \
	--enable-version3   \
	--enable-nonfree    \
	--disable-static    \
	--enable-shared     \
	--disable-debug     \
	--enable-libass     \
	--enable-libfdk-aac \
	--enable-libmp3lame \
	--enable-libtheora  \
	--enable-libvorbis  \
	--enable-libvpx     \
	--enable-libx264    \
	--enable-x11grab    \
	--enable-libfreetype
make
gcc tools/qt-faststart.c -o tools/qt-faststart

make DESTDIR=$BUILDDIR install
install -v -m755    tools/qt-faststart $BUILDDIR/usr/bin
install -v -m755 -d $BUILDDIR/usr/share/doc/ffmpeg
install -v -m644    doc/*.txt $BUILDDIR/usr/share/doc/ffmpeg

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: yasm (>= 1.3.0), libass (>= 0.11.2), fdk-aac (>= 0.1.3), \
LAME (>= 3.99.5), libtheora (>= 1.1.1), libvorbis (>= 1.3.4), \
libvpx (>= 1.3.0), x264 (>= 20140818), Xorg-lib (>= 7.7), \
alsa-lib (>= 1.0.28), SDL (>= 1.2.15), libva (>= 1.3.1), libvdpau (>= 0.8), \
FAAC (>= 1.28), FreeType (>= 2.5.3), libwebp (>= 0.4.1), \
OpenJPEG (>= 1.5.2), PulseAudio (>= 5.0), Speex (>= 1.2rc1), XviD (>= 1.3.3), \
OpenSSL (>= 1.0.1i), Fontconfig (>= 2.11.1), GnuTLS (>= 3.3.7), \
Opus (>= 1.1), libmodplug (>= 0.8.8.5), OpenAL (>= 1.16.0)
Description: Multimedia player, server, encoder and transcoder
 FFmpeg is a solution to record, convert and stream audio and video. It is a
 very fast video and audio converter and it can also acquire from a live
 audio/video source. Designed to be intuitive, the command-line interface
 (ffmpeg) tries to figure out all the parameters, when possible. FFmpeg can
 also convert from any sample rate to any other, and resize video on the fly
 with a high quality polyphase filter. FFmpeg can use a Video4Linux compatible
 video source and any Open Sound System audio source.
EOF
}

build
