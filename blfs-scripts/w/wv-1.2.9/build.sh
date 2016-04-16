#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wv-1.2.9.tar.gz
srcdir=wv-1.2.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libgsf (>= 1.14.30), libpng (>= 1.6.13)
Description: MSWord 6/7/8/9 binary file format to HTML converter
EOF
}

build
