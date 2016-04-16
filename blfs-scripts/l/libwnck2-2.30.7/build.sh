#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libwnck-2.30.7.tar.xz
srcdir=libwnck-2.30.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--program-suffix=-1
make GETTEXT_PACKAGE=libwnck-1
make
make DESTDIR=$BUILDDIR GETTEXT_PACKAGE=libwnck-1 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+2 (>= 2.24.24), startup-notification (>= 0.12), \
gobject-introspection (>= 1.40.0)
Description: a Window Navigator Construction Kit
EOF
}

build
