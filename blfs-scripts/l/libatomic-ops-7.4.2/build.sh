#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libatomic_ops-7.4.2.tar.gz
srcdir=libatomic_ops-7.4.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's#pkgdata#doc#' doc/Makefile.am
autoreconf -fi

./configure --prefix=/usr \
	--enable-shared \
	--disable-static \
	--docdir=/usr/share/doc/libatomic_ops-7.4.2
make
make DESTDIR=$BUILDDIR install

mv -v $BUILDDIR/usr/share/libatomic_ops/* \
	$BUILDDIR/usr/share/doc/libatomic_ops-7.4.2
rm -rf $BUILDDIR/usr/share/libatomic_ops

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a library for atomic operations
 libatomic_ops provides implementations for atomic memory update operations on
 a number of architectures. This allows direct use of these in reasonably
 portable code. Unlike earlier similar packages, this one explicitly considers
 memory barrier semantics, and allows the construction of code that involves
 minimum overhead across a variety of architectures.
 .
 [libatomic_ops.so]
 contains functions for atomic memory operations.
EOF
}

build
