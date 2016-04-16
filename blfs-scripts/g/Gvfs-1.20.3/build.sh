#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gvfs-1.20.3.tar.xz
srcdir=gvfs-1.20.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-gphoto2
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), GLib (>= 2.40.0), GTK+3 (>= 3.12.2), \
libsecret (>= 0.18), libsoup (>= 2.46.0), eudev (>= 1.10), \
UDisks2 (>=2.1.3), Fuse (>= 2.9.3), libarchive (>= 3.1.2), \
Apache (>= 2.4.10), OpenSSH (>= 6.6p1)
Description: VFS functionality for GLib
 The Gvfs package is a userspace virtual filesystem designed to work with the
 I/O abstractions of GLib's GIO library.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='glib-compile-schemas /usr/share/glib-2.0/schemas'
}

build
