#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-appfinder-4.10.1.tar.bz2
srcdir=xfce4-appfinder-4.10.1
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
Depends: Garcon (>= 0.3.0), libxfce4ui (>= 4.10.0)
Description: Application finder for the Xfce4 Desktop Environment
EOF
}

build
