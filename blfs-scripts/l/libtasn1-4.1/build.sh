#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libtasn1-4.1.tar.gz
srcdir=libtasn1-4.1
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
Description: a library encode and decode DER/BER data following an ASN.1 schema
 .
 [asn1Coding] is an ASN.1 DER encoder.
 .
 [asn1Decoding] is an ASN.1 DER decoder.
 .
 [asn1Parser] is an ASN.1 syntax tree generator for libtasn1.
 .
 [libtasn1.so] is a library for Abstract Syntax Notation One (ASN.1) and 
 Distinguish Encoding Rules (DER) manipulation. 
EOF
}

build
