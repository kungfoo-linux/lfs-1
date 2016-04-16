#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtkmm-3.12.0.tar.xz
srcdir=gtkmm-3.12.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

# The documents takes up many disk space (115M), if you not use it often,
# delete it:
rm -rf $BUILDDIR/usr/share/doc

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Atkmm (>= 2.22.7), GTK+3 (>= 3.12.0), Pangomm (>= 2.34.0)
Description: a C++ interface to GTK+ 3
EOF
}

build
