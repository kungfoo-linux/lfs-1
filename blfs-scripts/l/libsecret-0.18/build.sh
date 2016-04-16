#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsecret-0.18.tar.xz
srcdir=libsecret-0.18
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0), \
libgcrypt (>= 1.6.2), Vala (>= 0.24.0), gnome-keyring (>= 3.12.2)
Description: a GObject based library for accessing the Secret Service API
 .
 [secret-tool]
 is a command line tool that can be used to store and retrieve passwords.
 .
 [libsecret-1.so]
 contains the libsecret API functions.
EOF
}

build
