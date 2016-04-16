#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=alsa-utils-1.0.28.tar.bz2
srcdir=alsa-utils-1.0.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-alsaconf
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
touch $BUILDDIR/var/lib/alsa/asound.state

# To automatically store and restore volume settings (if udev rule doesn't
# work for you) when the system is rebooted, install the /etc/rc.d/init.d/alsa
# boot script from the blfs-bootscripts-20140919 package.
# To automatically start dbus-daemon when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-alsa
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), libsamplerate (>= 0.1.8)
Description: utilities for controlling sound card
 .
 [aconnect]
 is a utility for connecting and disconnecting two existing ports in the ALSA
 sequencer system.
 .
 [alsactl]
 is used to control advanced settings for the ALSA sound card drivers.
 .
 [alsaloop]
 allows creation of a PCM loopback between a PCM capture device and a PCM
 playback device.
 .
 [alsamixer]
 is an Ncurses based mixer program for use with the ALSA sound card drivers.
 .
 [alsaucm]
 allows applications to access the hardware in an abstracted manner
 .
 [amidi]
 is used to read from and write to ALSA RawMIDI ports.
 .
 [amixer]
 allows command-line control of the mixers for the ALSA sound card drivers.
 .
 [aplay]
 is a command-line soundfile player for the ALSA sound card drivers.
 .
 [aplaymidi]
 is a command-line utility that plays the specified MIDI file(s) to one or
 more ALSA sequencer ports.
 .
 [arecord]
 is a command-line soundfile recorder for the ALSA sound card drivers.
 .
 [arecordmidi]
 is a command-line utility that records a standard MIDI file from one or more
 ALSA sequencer ports.
 .
 [aseqdump]
 is a command-line utility that prints the sequencer events it receives as
 text.
 .
 [aseqnet]
 is an ALSA sequencer client which sends and receives event packets over a
 network.
 .
 [iecset]
 is a small utility to set or dump the IEC958 (or so-called “S/PDIF”) status
 bits of the specified sound card via the ALSA control API.
 .
 [speaker-test]
 is a command-line speaker test tone generator for ALSA.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='gpasswd -a root audio'
POSTRM_CONF_DEF='gpasswd -d root audio'
}

build
