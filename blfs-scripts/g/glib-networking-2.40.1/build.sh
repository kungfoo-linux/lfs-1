#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=glib-networking-2.40.1.tar.xz
srcdir=glib-networking-2.40.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-ca-certificates=/etc/ssl/ca-bundle.crt \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GnuTLS (>= 3.3.7), gsettings-desktop-schemas (>= 3.12.2), CA (= 7.6), \
p11-kit (>= 0.20.6), libproxy (>= 0.4.11)
Description: network-related giomodules for GLib
 This package contains various network related extensions for the GIO
 library.
EOF
}

build
