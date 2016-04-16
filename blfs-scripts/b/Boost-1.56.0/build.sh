#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=boost_1_56_0.tar.bz2
srcdir=boost_1_56_0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./bootstrap.sh --prefix=$BUILDDIR/usr
./b2 stage threading=multi link=shared
./b2 install threading=multi link=shared

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: ICU (>= 53.1), Python2 (>= 2.7.8)
Description: Boost C++ libraries
 Boost provides a set of free peer-reviewed portable C++ source libraries. It
 includes libraries for linear algebra, pseudorandom number generation,
 multithreading, image processing, regular expressions and unit testing.
EOF
}

build
