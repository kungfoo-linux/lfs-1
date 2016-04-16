#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=keyutils-1.5.9.tar.bz2
srcdir=keyutils-1.5.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: linux key management utilities
 Keyutils is a set of utilities for managing the key retention facility in the
 kernel, which can be used by filesystems, block devices and more to gain and
 retain the authorization and encryption keys required to perform secure
 operations.
 .
 [keyctl]
 is to control the key management facility in various ways using a variety of
 subcommands.
 .
 [libkeyutils.so]
 contains the keyuils library API instantiation. 
EOF
}

build
