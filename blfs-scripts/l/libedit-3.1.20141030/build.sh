#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libedit-20141030-3.1.tar.gz
srcdir=libedit-20141029-3.1
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
Description: BSD editline and history libraries
 Command line editor library provides generic line editing, history, and
 tokenization functions.
EOF
}

build
