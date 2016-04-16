#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dbus-glib-0.102.tar.gz
srcdir=dbus-glib-0.102
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), GLib (>= 2.40.0)
Description: D-Bus GLib Binding
 The D-Bus Bindings are a group of packages that contain programming language
 and platform interfaces to the D-Bus API. This is useful for programmers to
 easily interface D-Bus with their supported platform or language of choice.
 Some non-D-Bus packages will require one or more of the Bindings packages in
 order to build successfully.
 .
 [dbus-binding-tool]
 is a tool used to interface with the D-Bus API.
 .
 [libdbus-glib-1.so]
 contains GLib interface functions to the D-Bus API.
EOF
}

build
