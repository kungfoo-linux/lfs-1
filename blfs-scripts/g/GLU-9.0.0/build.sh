#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=glu-9.0.0.tar.bz2
srcdir=glu-9.0.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=$XORG_PREFIX \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: MesaLib (>= 10.2.7)
Description: the Mesa OpenGL Utility library
EOF
}

build
