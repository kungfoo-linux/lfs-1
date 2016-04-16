#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-settings-4.11.0.tar.bz2
srcdir=xfce4-settings-4.11.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-sound-settings \
	--enable-pluggable-dialogs
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Exo (>= 0.10.2), libxfce4ui (>= 4.10.0), libcanberra (>= 0.30), \
libnotify (>= 0.7.6), libxklavier (>= 5.3)
Description: graphical application for managing Xfce settings
EOF
}

build
