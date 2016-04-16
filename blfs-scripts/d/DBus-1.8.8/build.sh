#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dbus-1.8.8.tar.gz
srcdir=dbus-1.8.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr                    \
	--sysconfdir=/etc                    \
	--localstatedir=/var                 \
	--docdir=/usr/share/doc/dbus-1.8.8   \
	--with-console-auth-dir=/run/console \
	--without-systemdsystemunitdir       \
	--disable-systemd                    \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# To automatically start dbus-daemon when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-dbus
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7)
Description: D-Bus message bus
 D-Bus is a message bus system, a simple way for applications to talk to one
 another. D-Bus supplies both a system daemon (for events such as “new
 hardware device added” or “printer queue changed”) and a
 per-user-login-session daemon (for general IPC needs among user
 applications). Also, the message bus is built on top of a general one-to-one
 message passing framework, which can be used by any two applications to
 communicate directly (without going through the message bus daemon).
 .
 [dbus-cleanup-sockets]
 is used to clean up leftover sockets in a directory.
 .
 [dbus-daemon]
 is the D-Bus message bus daemon.
 .
 [dbus-launch]
 is used to start dbus-daemon from a shell script. It would normally be called
 from a user's login scripts.
 .
 [dbus-monitor]
 is used to monitor messages going through a D-Bus message bus.
 .
 [dbus-run-session]
 start a process as a new D-Bus session.
 .
 [dbus-send]
 is used to send a message to a D-Bus message bus.
 .
 [dbus-uuidgen]
 is used to generate a universally unique ID.
 .
 [libdbus-1.so]
 contains the API functions used by the D-Bus message daemon. D-Bus is first a
 library that provides one-to-one communication between any two applications;
 dbus-daemon is an application that uses this library to implement a message
 bus daemon.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "messagebus" > /dev/null 2>&1 ; then
	    groupadd -g 18 messagebus
	fi

	if ! getent passwd "messagebus" > /dev/null 2>&1 ; then
	    useradd -c "D-Bus Message Daemon User" -d /var/run/dbus \
	        -u 18 -g messagebus -s /bin/false messagebus
	fi'
}

build
