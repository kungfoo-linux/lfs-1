#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xdg-utils-1.1.0-rc2.tar.gz
srcdir=xdg-utils-1.1.0-rc2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--mandir=/usr/share/man
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: xmlto (>= 0.0.26), Xorg-app (>= 7.7), DBus (>= 1.8.8)
Description: desktop integration utilities from freedesktop.org
 xdg-utils is a a set of command line tools that assist applications with a
 variety of desktop integration tasks. It is required for Linux Standards Base
 (LSB) conformance.
 .
 [xdg-desktop-menu]
 is a command line tool for (un)installing desktop menu items.
 .
 [xdg-desktop-icon]
 is a command line tool for (un)installing icons to the desktop.
 .
 [xdg-mime]
 is a command line tool for querying information about file type handling and
 adding descriptions for new file types.
 .
 [xdg-icon-resource]
 is a command line tool for (un)installing icon resources.
 .
 [xdg-open]
 opens a file or URL in the user's preferred application.
 .
 [xdg-email]
 opens the user's preferred e-mail composer in order to send a mail message.
 .
 [xdg-screensaver]
 is a command line tool for controlling the screensaver.
 .
 [xdg-settings]
 is a command line tool for managing various settings from the desktop
 environment.
EOF
}

build
