#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=p11-kit-0.20.6.tar.gz
srcdir=p11-kit-0.20.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: CA (= 7.6), libtasn1 (>= 4.1), libffi (>= 3.1)
Description: Library for loading and sharing PKCS#11 modules
 The p11-kit package Provides a way to load and enumerate PKCS #11 (a
 Cryptographic Token Interface Standard) modules.
 .
 [p11-kit] is a command line tool that can be used to perform operations 
 on PKCS#11 modules configured on the system.
 .
 [libp11-kit.so] contains functions used to coordinate initialization and 
 finalization of any PKCS#11 module.
 .
 [p11-kit-proxy.so] is the PKCS#11 proxy module. 
EOF
}

build
