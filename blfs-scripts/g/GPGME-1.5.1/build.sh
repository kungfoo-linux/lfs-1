#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gpgme-1.5.1.tar.bz2
srcdir=gpgme-1.5.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-fd-passing \
	--disable-gpgsm-test
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Libassuan (>= 2.1.2)
Description: GPGME - GnuPG Made Easy
 The GPGME package is a C language library that allows to add support for
 cryptography to a program. It is designed to make access to public key crypto
 engines like GnuPG or GpgSM easier for applications. GPGME provides a
 high-level crypto API for encryption, decryption, signing, signature
 verification and key management.
 .
 [libgpgme-pthread.so] contains the GPGME API functions for applications 
 using pthread.
 .
 [libgpgme.so] contains the GPGME API functions. 
EOF
}

build
