#!/bin/bash -e
. ../lfs.comm

# The Make package contains a program for compiling packages.

build_src() {
    srcfil=make-4.0.tar.bz2
    srcdir=make-4.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools \
        --without-guile
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
