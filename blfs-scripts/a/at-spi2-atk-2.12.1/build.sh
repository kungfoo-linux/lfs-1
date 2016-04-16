#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=at-spi2-atk-2.12.1.tar.xz
srcdir=at-spi2-atk-2.12.1
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
Depends: at-spi2-core (>= 2.12.0), ATK (>= 2.12.0)
Description: a library that bridges ATK to At-Spi2 D-Bus service
 .
 [libatk-bridge.so]
 is the Accessibility Toolkit GTK+ module.
 .
 [libatk-bridge-2.0.so]
 Contains the common functions used by GTK+ Accessibility Toolkit Bridge.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
glib-compile-schemas /usr/share/glib-2.0/schemas'
}

build
