#!/bin/bash -e
. ../../../blfs.comm

build_src() {
python_module_setting
srcfil=pycairo-1.10.0.tar.bz2
srcdir=pycairo-1.10.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/pycairo-1.10.0-waf_unpack-1.patch
wafdir=$(./waf unpack)
pushd $wafdir
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/pycairo-1.10.0-waf_python_3_4-1.patch
popd
unset wafdir
PYTHON=/usr/bin/python3 ./waf configure --prefix=/usr
./waf build
./waf --destdir=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python3 (>= 3.4.1), Cairo (>= 1.12.16)
Description: Python 3 bindings to Cairo
EOF
}

build
