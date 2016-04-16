#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pulseaudio-5.0.tar.xz
srcdir=pulseaudio-5.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

find . -name "Makefile.in" | xargs sed -i "s|(libdir)/@PACKAGE@|(libdir)/pulse|" 
./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-bluez4 \
	--disable-rpath \
	--with-module-dir=/usr/lib/pulse/modules
make
make DESTDIR=$BUILDDIR install

rm -f $BUILDDIR/etc/dbus-1/system.d/pulseaudio-system.conf

cleanup_src .. $srcdir
}

configure() {
# The default configuration files allow to set up a working installation,
# except that you need to remove a reference to Console-Kit if it is not
# installed. For example, issue the following command as the root user: 
sed -i '/load-module module-console-kit/s/^/#/' $BUILDDIR/etc/pulse/default.pa
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: JSON-C (>= 0.12), libsndfile (>= 1.0.25), alsa-lib (>= 1.0.28), \
DBus (>= 1.8.8), GLib (>= 2.40.0), libcap (>= 2.24), OpenSSL (>= 1.0.1i), \
Speex (>= 1.2rc1), Xorg-lib (>= 7.7), Avahi (>= 0.6.31), Check (>= 0.9.14), \
GConf (>= 3.2.6), GTK+3 (>= 3.12.2), libsamplerate (>= 0.1.8)
Description: PulseAudio sound server
 PulseAudio, previously known as Polypaudio, is a sound server for POSIX and
 WIN32 systems. It is a drop in replacement for the ESD sound server with much
 better latency, mixing/re-sampling quality and overall architecture.
EOF
}

build
