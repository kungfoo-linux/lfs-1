#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=upower-0.9.23.tar.xz
srcdir=upower-0.9.23
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--enable-deprecated \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), libusb (>= 1.0.19), Polkit (>= 0.112), \
eudev (>= 1.10), pm-utils (>= 1.4.1), gobject-introspection (>= 1.40.0)
Description: Power Management Service
 The UPower package provides an interface to enumerating power devices,
 listening to device events and querying history and statistics. Any
 application or service on the system can access the org.freedesktop.UPower
 service via the system message bus.
 .
 To use the command "upower -w" for information about processor wakeups (this
 command is used by gnome-power-manager) you need to enable
 CONFIG_TIMER_STATS in your kernel.
 .
 Kernel configuration:
 --------------------------------------------------
 . Kernel hacking  --->
 .   [*] Kernel debugging
 .       <*> Collect kernel timers statistics
 --------------------------------------------------
 .
 [upower]
 is the UPower command line tool.
 .
 [upowerd]
 is the UPower Daemon. It provides the org.freedesktop.UPower service on the
 system message bus.
 .
 [libupower-glib.so]
 contains the UPower API functions.
EOF
}

build
