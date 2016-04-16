#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=check-0.9.14.tar.gz
srcdir=check-0.9.14
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/check-0.9.14 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a unit testing framework for C
 .
 [checkmk]
 is an Awk script used for generating C unit tests for use with the Check unit
 testing framework.
 .
 [libcheck.so]
 contains the Check API functions.
EOF
}

build
