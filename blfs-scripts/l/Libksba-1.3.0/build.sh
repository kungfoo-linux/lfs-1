#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libksba-1.3.0.tar.bz2
srcdir=libksba-1.3.0
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
Depends: libgpg-error (>= 1.13)
Description: CMS and X.509 library
 The Libksba package contains a library used to make X.509 certificates as
 well as making the CMS (Cryptographic Message Syntax) easily accessible by
 other applications. Both specifications are building blocks of S/MIME and
 TLS. The library does not rely on another cryptographic library but provides
 hooks for easy integration with Libgcrypt.
 .
 [ksba-config] is a utility used to configure and build applications based 
 on the libksba(3) library.
 .
 [libksba.{so,a}] contains the cryptographic API functions. 
EOF
}

build
