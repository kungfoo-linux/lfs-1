#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=thunar-volman-0.8.0.tar.bz2
srcdir=thunar-volman-0.8.0
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
Depends: Exo (>= 0.10.2), libxfce4ui (>= 4.10.0), eudev (>= 1.10), \
libnotify (>= 0.7.6), startup-notification (>= 0.12), Gvfs (>= 1.20.3), \
polkit-gnome (>= 0.105)
Description: an extension for the Thunar file manager
EOF
}

build
