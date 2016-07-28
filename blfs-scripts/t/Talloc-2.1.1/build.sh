#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=talloc-2.1.1.tar.gz
srcdir=talloc-2.1.1
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
Depends: Python2 (>= 2.7.8)
Description: hierarchical pool based memory allocator
 Talloc provides a hierarchical, reference counted memory pool system with
 destructors. It is the core memory allocator used in Samba.
EOF
}

build
