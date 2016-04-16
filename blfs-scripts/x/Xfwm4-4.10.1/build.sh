#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfwm4-4.10.1.tar.bz2
srcdir=xfwm4-4.10.1
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
Depends: libwnck2 (>= 2.30.7), libxfce4ui (>= 4.10.0), \
libxfce4util (>= 4.10.0), startup-notification (>= 0.12)
Description: the window manager for Xfce
 .
 [xfwm4]
 is the Xfce window manager.
EOF
}

build
