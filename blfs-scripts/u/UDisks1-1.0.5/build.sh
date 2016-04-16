#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=udisks-1.0.5.tar.gz
srcdir=udisks-1.0.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--enable-lvm2
make
make DESTDIR=$BUILDDIR profiledir=/etc/bash_completion.d install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), libatasmart (>= 0.19), LVM2 (>= 2.02.111), \
parted (>= 3.2), Polkit (>= 0.112), sg3-utils (>= 1.39), eudev (>= 1.10)
Description: D-BUS service to access and manipulate storage devices
 .
 [udisks]
 is a simple command line interface for the UDisks Daemon.
 .
 [udisks-tcp-bridge]
 is the UDisks TCP/IP bridge.
 .
 [udisks-daemon]
 is the UDisks Daemon.
EOF
}

build
