#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=acpid-2.0.23.tar.xz
srcdir=acpid-2.0.23
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--docdir=/usr/share/doc/acpid-2.0.23
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/etc/acpi/events
cp -r samples $BUILDDIR/usr/share/doc/acpid-2.0.23

cleanup_src .. $srcdir
}

configure() {
# To automatically start acpid when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-acpid
popd

sed -i 's/\(\/run\/acpid.pid\)/\/var\1/' $BUILDDIR/etc/rc.d/init.d/acpid
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Advanced Configuration and Power Interface event daemon
 The acpid (Advanced Configuration and Power Interface event daemon) is a
 completely flexible, totally extensible daemon for delivering ACPI events. It
 listens on netlink interface and when an event occurs, executes programs to
 handle the event. The programs it executes are configured through a set of
 configuration files, which can be dropped into place by packages or by the
 user.
 .
 [acpid]
 is a program that listens for ACPI events and executes the rules that match
 the received event.
 .
 [acpi_listen]
 is a simple tool which connects to acpid and listens for events.
 .
 [kacpimon]
 is a monitor program that connects to three sources of ACPI events (events
 file, netlink and input layer) and then reports on what it sees while it is
 connected.
EOF
}

build
