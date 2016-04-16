#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gsettings-desktop-schemas-3.12.2.tar.xz
srcdir=gsettings-desktop-schemas-3.12.2
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
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0)
Description: shared GSettings schemas for the desktop
 The GSettings Desktop Schemas package contains a collection of GSettings
 schemas for settings shared by various components of a GNOME Desktop.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='glib-compile-schemas /usr/share/glib-2.0/schemas'
}

build
