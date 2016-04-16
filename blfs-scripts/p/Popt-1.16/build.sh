#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=popt-1.16.tar.gz
srcdir=popt-1.16
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: C library for parsing command line parameters
 The popt package contains the popt libraries which are used by some programs
 to parse command-line options.
 .
 [libpopt.so]
 is used to parse command-line options.
EOF
}

build
