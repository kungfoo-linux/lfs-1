#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gsl-1.16.tar.gz
srcdir=gsl-1.16
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make html
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/share/doc/gsl-1.16
cp doc/gsl-ref.html/* $BUILDDIR/usr/share/doc/gsl-1.16

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0)
Description: The GNU Scientific Library for numerical analysis
 The GNU Scientific Library (GSL) is a numerical library for C and C++
 programmers. It provides a wide range of mathematical routines such as random
 number generators, special functions and least-squares fitting.
 .
 [gsl-config]
 is a shell script to get the version number and compiler flags of the
 installed Gsl library.
 .
 [gsl-histogram]
 is a demonstration program for the GNU Scientific Library that computes a
 histogram from data taken from stdin.
 .
 [gsl-randist]
 is a demonstration program for the GNU Scientific Library that generates
 random samples from various distributions.
 .
 [libgslcblas.so]
 contains functions that implement a C interface to Basic Linear Algebra
 Subprograms.
 .
 [libgsl.so.so]
 contains functions that provide a collection of numerical routines for
 scientific computing.
EOF
}

build
