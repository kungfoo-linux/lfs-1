#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openssl-1.0.1i.tar.gz
srcdir=openssl-1.0.1i
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir
	
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/openssl-1.0.1i-fix_parallel_build-1.patch

./config --prefix=/usr \
	--openssldir=/etc/ssl \
	--libdir=lib \
	shared \
	zlib-dynamic
make

# If you want to disable installing the static libraries, use this sed:
sed -i 's# libcrypto.a##;s# libssl.a##' Makefile

make INSTALL_PREFIX=$BUILDDIR MANDIR=/usr/share/man MANSUFFIX=ssl install
install -dv -m755 $BUILDDIR/usr/share/doc/openssl-1.0.1i
cp -vfr doc/*     $BUILDDIR/usr/share/doc/openssl-1.0.1i

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Suggests: MIT_kerberos_V5-1.12.2
Description: Secure Sockets Layer toolkit
 The OpenSSL package contains management tools and libraries relating to 
 crptography. These are useful for providing cryptography functions to 
 other packages, notably OpenSSH, email applications and web browsers (for 
 accessing HTTPS sites).
 .
 [c_rehash] is a Perl script that scans all files in a directory and adds 
 symbolic links to their hash values.
 .
 [openssl] is a command-line tool for using the various cryptography 
 functions of OpenSSL's crypto library from the shell. It can be used for 
 various functions which are documented in man 1 openssl.
 .
 [libcrypto.{so,a}] implements a wide range of cryptographic algorithms used 
 in various Internet standards. The services provided by this library are 
 used by the OpenSSL implementations of SSL, TLS and S/MIME, and they have 
 also been used to implement OpenSSH, OpenPGP, and other cryptographic 
 standards.
 .
 [libssl.{so,a}] implements the Secure Sockets Layer (SSL v2/v3) and 
 Transport Layer Security (TLS v1) protocols. It provides a rich API, 
 documentation on which can be found by running man 3 ssl. 
EOF
}

build
