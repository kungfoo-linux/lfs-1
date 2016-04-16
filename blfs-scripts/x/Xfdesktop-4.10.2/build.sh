#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfdesktop-4.10.2.tar.bz2
srcdir=xfdesktop-4.10.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Exo (>= 0.10.2), libwnck2 (>= 2.30.7), libxfce4ui (>= 4.10.0), \
libnotify (>= 0.7.6), startup-notification (>= 0.12), Thunar (>= 1.6.3)
Description: a desktop manager for the Xfce Desktop Environment
 Xfdesktop is a desktop manager for the Xfce Desktop Environment. Xfdesktop
 sets the background image / color, creates the right click menu and window
 list and displays the file icons on the desktop using Thunar libraries.
EOF
}

build
