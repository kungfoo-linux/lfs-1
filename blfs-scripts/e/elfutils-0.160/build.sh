#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=elfutils-0.160.tar.bz2
srcdir=elfutils-0.160
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--program-prefix="eu-"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a collection of utilities and DSOs to handle compiled objects
 The elfutils package contains set of utilities and libraries for handling ELF
 (Executable and Linkable Format) files.
EOF
}

build
