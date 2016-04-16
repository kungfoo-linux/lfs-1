#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libtheora-1.1.1.tar.xz
srcdir=libtheora-1.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libogg (>= 1.3.2), libvorbis (>= 1.3.4)
Description: The Theora Video Compression Codec
EOF
}

build
