#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lzo-2.08.tar.gz
srcdir=lzo-2.08
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-shared \
	--disable-static \
	--docdir=/usr/share/doc/lzo-2.08
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: data compression library with very fast (de)compression
 LZO is a data compression library which is suitable for data decompression
 and compression in real-time. This means it favors speed over compression
 ratio.
 .
 [liblzo2.so]
 is a data compression and decompression library. 
EOF
}

build
