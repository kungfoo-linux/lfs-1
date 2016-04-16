#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-power-manager-1.4.0.tar.bz2
srcdir=xfce4-power-manager-1.4.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR \
	docdir=/usr/share/doc/xfce4-power-manager-1.4.0 \
	imagesdir=/usr/share/doc/xfce4-power-manager-1.4.0/images \
	install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libnotify (>= 0.7.6), UPower (>= 0.9.23), xfce4-panel (>= 4.10.0), \
UDisks1 (>= 1.0.5)
Description: a power manager for the Xfce desktop
 The Xfce4 Power Manager is a power manager for the Xfce desktop, Xfce power
 manager manages the power sources on the computer and the devices that can be
 controlled to reduce their power consumption (such as LCD brightness level,
 monitor sleep, CPU frequency scaling). In addition, Xfce4 Power Manager
 provides a set of freedesktop-compliant DBus interfaces to inform other
 applications about current power level so that they can adjust their power
 consumption.
EOF
}

build
