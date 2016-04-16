#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=nss-3.17.tar.gz
srcdir=nss-3.17
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/nss-3.17-standalone-1.patch

# NOTE: This package does not support parallel build.
cd nss
make BUILD_OPT=1 \
	NSPR_INCLUDE_DIR=/usr/include/nspr \
	USE_SYSTEM_ZLIB=1 \
	ZLIB_LIBS=-lz \
	NSS_USE_SYSTEM_SQLITE=1 \
	$([ $(uname -m) = x86_64 ] && echo USE_64=1) \
	-j1

cd ../dist
mkdir -pv $BUILDDIR/usr/{include/nss,lib/pkgconfig,bin}
install -v -m755 Linux*/lib/*.so              $BUILDDIR/usr/lib
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} $BUILDDIR/usr/lib
cp -v -RL {public,private}/nss/*              $BUILDDIR/usr/include/nss
chmod -v 644                                  $BUILDDIR/usr/include/nss/*
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} $BUILDDIR/usr/bin
install -v -m644 Linux*/lib/pkgconfig/nss.pc  $BUILDDIR/usr/lib/pkgconfig

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: NSPR (>= 4.10.7), SQLite (>= 3.8.6)
Description: Network Security Services
 The Network Security Services (NSS) package is a set of libraries designed to
 support cross-platform development of security-enabled client and server
 applications. Applications built with NSS can support SSL v2 and v3, TLS,
 PKCS #5, PKCS #7, PKCS #11, PKCS #12, S/MIME, X.509 v3 certificates, and
 other security standards. This is useful for implementing SSL and S/MIME or
 other Internet security standards into an application.
 .
 [certutil] is the Mozilla Certificate Database Tool. It is a command-line 
 utility that can create and modify the Netscape Communicator cert8.db and 
 key3.db database files. It can also list, generate, modify, or delete 
 certificates within the cert8.db file and create or change the password, 
 generate new public and private key pairs, display the contents of the key 
 database, or delete key pairs within the key3.db file.
 .
 [nss-config] is used to determine the NSS library settings of the installed 
 NSS libraries.
 .
 [pk12util] is a tool for importing certificates and keys from pkcs #12 files
 into NSS or exporting them. It can also list certificates and keys in such 
 files. 
EOF
}

build
