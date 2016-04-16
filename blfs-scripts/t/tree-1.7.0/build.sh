#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tree-1.7.0.tgz
srcdir=tree-1.7.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make prefix=$BUILDDIR/usr MANDIR=$BUILDDIR/usr/share/man/man1 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: file listing as a tree
 The tree application, as the name suggests, is useful to display, in a
 terminal, directory contents, including directories, files, links.
 .
 [tree]
 displays a directory tree in a terminal.
EOF
}

build
