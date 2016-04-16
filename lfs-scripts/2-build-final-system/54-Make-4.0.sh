#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=make-4.0.tar.bz2
    srcdir=make-4.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
