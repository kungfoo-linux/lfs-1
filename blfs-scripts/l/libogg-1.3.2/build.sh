#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libogg-1.3.2.tar.xz
srcdir=libogg-1.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--docdir=/usr/share/doc/libogg-1.3.2 \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The Ogg bitstream file format library
 The libogg package contains the Ogg file structure. This is useful for
 creating (encoding) or playing (decoding) a single physical bit stream.
EOF
}

build
