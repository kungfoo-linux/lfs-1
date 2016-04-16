#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgpg-error-1.13.tar.bz2
srcdir=libgpg-error-1.13
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr --disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for common error values and messages in GnuPG components
 The libgpg-error package contains a library that defines common error 
 values for all GnuPG components. Among these are GPG, GPGSM, GPGME, 
 GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard Daemon and more.
 .
 [gpg-error] is used to determine libgpg-error error codes.
 .
 [gpg-error-config] is a utility used to configure and build applications 
 based on the libgpg-error library. It can be used to query the C compiler 
 and linker flags which are required to correctly compile and link the 
 application against the libgpg-error library.
 .
 [libgpg-error.so] contains the libgpg-error API functions. 
EOF
}

build
