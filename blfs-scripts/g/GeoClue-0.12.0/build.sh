#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=geoclue-0.12.0.tar.gz
srcdir=geoclue-0.12.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/geoclue-0.12.0-gpsd_fix-1.patch
sed -i "s@ -Werror@@" configure
sed -i "s@libnm_glib@libnm-glib@g" configure
sed -i "s@geoclue/libgeoclue.la@& -lgthread-2.0@g" \
	providers/skyhook/Makefile.in

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), GConf (>= 3.2.6), libxslt (>= 1.1.28)
Recommends: libsoup (>= 2.46.0), NetworkManager (>= 0.9.10.0)
Suggests: GTK+2 (>= 2.24.24)
Description: A modular geoinformation service
 GeoClue is a modular geoinformation service built on top of the D-Bus
 messaging system. The goal of the GeoClue project is to make creating
 location-aware applications as simple as possible.
EOF
}

build
