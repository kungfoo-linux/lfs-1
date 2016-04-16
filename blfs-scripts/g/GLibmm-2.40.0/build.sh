#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=glibmm-2.40.0.tar.xz
srcdir=glibmm-2.40.0
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
Depends: GLib (= 2.40.0), libsigc++ (>= 2.3.2)
Description: C++ interface for GLib
 The GLibmm package is a set of C++ bindings for GLib.
 .
 [libgiomm-2.4.so] contains the Gio API classes.
 .
 [libglibmm-2.4.so] contains the GLib API classes. 
EOF
}

build
