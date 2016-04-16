#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libpeas-1.10.1.tar.xz
srcdir=libpeas-1.10.1
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
Depends: gobject-introspection (>= 1.40.0), GTK+3 (>= 3.12.2), \
python-module-pygobject3 (>= 3.12.2)
Description: Application plugin library
 libpeas is a GObject based plugins engine, and is targeted at giving every
 application the chance to assume its own extensibility.
EOF
}

build
