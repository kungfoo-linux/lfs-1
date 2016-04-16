#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=hd2u-1.0.3.tgz
srcdir=hd2u-1.0.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make BUILD_ROOT=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: popt (>= 1.16)
Description: an any to any text format converter
 .
 [dos2unix]
 converts text between various OS formats (such as converting from DOS format
 to Unix).
EOF
}

build
