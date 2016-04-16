#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=GConf-3.2.6.tar.xz
srcdir=GConf-3.2.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-orbit \
	--disable-static
make
make DESTDIR=$BUILDDIR install
ln -s gconf.xml.defaults $BUILDDIR/etc/gconf/gconf.xml.system

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), libxml2 (>= 2.9.1), \
gobject-introspection (>= 1.40.0), GTK+3 (>= 3.12.2), Polkit (>= 0.112)
Description: a configuration database system used by many GNOME applications
EOF
}

build
