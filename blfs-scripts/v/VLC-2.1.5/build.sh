#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=vlc-2.1.5.tar.xz
srcdir=vlc-2.1.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's:libsmbclient.h:samba-4.0/&:' modules/access/smb.c
./bootstrap

./configure --prefix=/usr \
	--enable-run-as-root
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), FFmpeg (>= 2.3.3), liba52 (>= 0.7.4), \
libgcrypt (>= 1.6.2), libmad (>= 0.15.1b), Lua (>= 5.2.3), \
Xorg-lib (>= 7.7), DBus (>= 1.8.8)
Suggests: libdv (>= 1.0.0), libdvdcss (>= 1.3.0), libdvdread (>= 5.0.0), \
libdvdnav (>= 5.0.1), libproxy (>= 0.4.11), Live555 (>= 2014.11.2), \
libogg (>= 1.3.2), libmodplug (>= 0.8.8.5), FAAD2 (>= 2.7), FLAC (>= 1.3.0), \
libass (>= 0.11.2), libmpeg2 (>= 0.5.1), libpng (>= 1.6.13), \
libtheora (>= 1.1.1), libva (>= 1.3.1), libvorbis (>= 1.3.4), Opus (>= 1.1), \
Speex (>= 1.2rc1), x264 (>= 20140818.2245), AAlib (>= 1.4rc5), \
Fontconfig (>= 2.11.1), FreeType (>= 2.5.3), FriBidi (>= 0.19.6), \
librsvg (>= 2.40.3), libvdpau (>= 0.8), SDL (>= 1.2.15), \
PulseAudio (>= 5.0), libsamplerate (>= 0.1.8), Qt4 (>= 4.8.6), \
Avahi (>= 0.6.31), GnuTLS (>= 3.3.7), libnotify (>= 0.7.6), \
libxml2 (>= 2.9.1), taglib (>= 1.9.1), xdg-utils (>= 1.1.0rc2)
Description: multimedia player and streamer
 VLC is a media player, streamer, and encoder. It can play from many inputs
 like files, network streams, capture device, desktops, or DVD, SVCD, VCD, and
 audio CD. It can play most audio and video codecs (MPEG 1/2/4, H264, VC-1,
 DivX, WMV, Vorbis, AC3, AAC, etc.), but can also convert to different formats
 and/or send streams through the network.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
        gtk-update-icon-cache
	update-desktop-database
	'
}

build
