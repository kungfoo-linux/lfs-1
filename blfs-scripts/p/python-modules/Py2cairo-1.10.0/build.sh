#!/bin/bash -e
. ../../../blfs.comm

build_src() {
python_module_setting
srcfil=py2cairo-1.10.0.tar.bz2
srcdir=py2cairo-1.10.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./waf configure --prefix=/usr
./waf build
./waf --destdir=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8), Cairo (>= 1.12.16)
Description: Python 2 bindings to Cairo
EOF
}

build
