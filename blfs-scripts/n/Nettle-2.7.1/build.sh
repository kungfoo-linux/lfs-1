#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=nettle-2.7.1.tar.gz
srcdir=nettle-2.7.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

chmod -v 755 $BUILDDIR/usr/lib/libhogweed.so.2.5 \
	$BUILDDIR/usr/lib/libnettle.so.4.7 &&
install -v -m755 -d $BUILDDIR/usr/share/doc/nettle-2.7.1 &&
install -v -m644 nettle.html $BUILDDIR/usr/share/doc/nettle-2.7.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Suggests: OpenSSL (>= 1.0.1i)
Description: low-level cryptographic library
 The Nettle package contains the low-level cryptographic library that is
 designed to fit easily in many contexts.
 .
 [nettle-hash] calulates a hash value using a specified algorithm.
 .
 [nettle-lfib-stream] outputs a sequence of pseudorandom (non-cryptographic) 
 bytes, using Knuth's lagged fibonacci generator. The stream is useful for 
 testing, but should not be used to generate cryptographic keys or anything 
 else that needs real randomness.
 .
 [pkcs1-conv] converts private and public RSA keys from PKCS #1 format to 
 sexp format.
 .
 [sexp-conv] converts an s-expression to a different encoding. 
EOF
}

build
