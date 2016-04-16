#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libnotify-0.7.6.tar.xz
srcdir=libnotify-0.7.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+3 (>= 3.12.2), gobject-introspection (>= 1.40.0)
Description: sends desktop notifications to a notification daemon
 The libnotify library is used to send desktop notifications to a notification
 daemon, as defined in the Desktop Notifications spec. These notifications can
 be used to inform the user about an event or display some form of information
 without getting in the user's way.
 .
 Runtime Required:
 xfce4-notifyd-0.2.4
 .
 [notify-send]
 is a command used to send notifications.
 .
 [libnotify.so]
 contains the libnotify API functions.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='echo "Runtime Required: xfce4-notifyd-0.2.4"'
}

build
