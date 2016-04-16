#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=which-2.20.tar.gz
srcdir=which-2.20
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
Description: Displays where a particular program in your path is located
 The which command shows the full pathname of a specified program, if the
 specified program is in your PATH.
EOF
}

build
