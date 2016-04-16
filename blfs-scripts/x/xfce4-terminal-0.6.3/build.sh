#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-terminal-0.6.3.tar.bz2
srcdir=xfce4-terminal-0.6.3
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
Depends: libxfce4ui (>= 4.10.0), Vte2 (>= 0.28.2)
Description: a GTK+ 2 terminal emulator
 Xfce4 Terminal is a GTK+ 2 terminal emulator. This is useful for running
 commands or programs in the comfort of an Xorg window; you can drag and drop
 files into the Xfce4 Terminal or copy and paste text with your mouse.
 .
 [xfce4-terminal]
 is a GTK+ 2 terminal emulator.
EOF
}

build
