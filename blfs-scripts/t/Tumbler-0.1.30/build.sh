#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tumbler-0.1.30.tar.bz2
srcdir=tumbler-0.1.30
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
Depends: dbus-glib (>= 0.102), cURL (>= 7.37.1), FreeType (>= 2.5.3), \
gdk-pixbuf (>= 2.30.8), libjpeg-turbo (>= 1.3.1), libgsf (>= 1.14.30), \
libpng (>= 1.6.13)
Description: D-Bus thumbnailing service
EOF
}

build
