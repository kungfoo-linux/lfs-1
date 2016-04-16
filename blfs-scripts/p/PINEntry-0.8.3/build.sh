#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pinentry-0.8.3.tar.bz2
srcdir=pinentry-0.8.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Suggests: GTK+ (>= 2.24.24), Qt (>= 4.8.6)
Description: Collection of Simple PIN or Passphrase Entry Dialogs
 The PIN-Entry package contains a collection of simple PIN or pass-phrase
 entry dialogs which utilize the Assuan protocol as described by the Ägypten
 project. PIN-Entry programs are usually invoked by the gpg-agent daemon, but
 can be run from the command line as well. There are programs for various
 text-based and GUI environments, including interfaces designed for Ncurses
 (text-based), GTK+, GTK+2, Qt3, and Qt4.
 .
 [pinentry] is a symbolic link to the default PIN-Entry program.
 .
 [pinentry-curses] is an Ncurses text-based PIN-Entry program.
 .
 [pinentry-gtk] is a GTK+ GUI PIN-Entry program.
 .
 [pinentry-gtk-2] is a GTK+2 GUI PIN-Entry program.
 .
 [pinentry-qt] is a Qt3 GUI PIN-Entry program.
 .
 [pinentry-qt4] is a Qt4 GUI PIN-Entry program. 
EOF
}

build
