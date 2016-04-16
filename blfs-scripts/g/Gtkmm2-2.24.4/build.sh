#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtkmm-2.24.4.tar.xz
srcdir=gtkmm-2.24.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

# The documents takes up many disk space (52M), if you not use it often,
# delete it:
rm -rf $BUILDDIR/usr/share/doc

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Atkmm (>= 2.22.7), GTK+2 (>= 2.24.0), Pangomm (>= 2.34.0)
Description: a C++ interface to GTK+ 2
EOF
}

build
