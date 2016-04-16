#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=a52dec-0.7.4.tar.gz
srcdir=a52dec-0.7.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--mandir=/usr/share/man \
	--enable-shared \
	--disable-static \
	CFLAGS="-g -O2 $([ $(uname -m) = x86_64 ] && echo -fPIC)"
make
make DESTDIR=$BUILDDIR install

cp liba52/a52_internal.h $BUILDDIR/usr/include/a52dec
install -v -m644 -D doc/liba52.txt \
	$BUILDDIR/usr/share/doc/liba52-0.7.4/liba52.txt

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for decoding ATSC A/52 streams
 liba52 is a free library for decoding ATSC A/52 (also known as AC-3) streams.
 The A/52 standard is used in a variety of applications, including digital
 television and DVD.
 .
 [a52dec]
 plays ATSC A/52 audio streams.
 .
 [extract_a52]
 extracts ATSC A/52 audio from an MPEG stream.
 .
 [liba52.so]
 provides functions for the programs dealing with ATSC A/52 streams.
EOF
}

build
