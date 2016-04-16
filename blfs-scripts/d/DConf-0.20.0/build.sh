#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dconf-0.20.0.tar.xz
srcdir=dconf-0.20.0
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
Depends: DBus (>= 1.8.8), GTK+3 (>= 3.12.2), libxml2 (>= 2.9.1), \
Vala (>= 0.24.0)
Description: a low-level configuration system
 The DConf package contains a low-level configuration system. Its main purpose
 is to provide a backend to GSettings on platforms that don't already have
 configuration storage systems.
 .
 [dconf]
 is a simple tool for manipulating the DConf database.
 .
 [dconf-editor]
 is a graphical program for editing settings that are stored in the DConf
 database.
 .
 [dconf-service]
 is the D-Bus service that writes to the DConf database.
EOF
}

build
