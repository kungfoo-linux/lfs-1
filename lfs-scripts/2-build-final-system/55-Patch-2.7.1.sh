#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=patch-2.7.1.tar.xz
    srcdir=patch-2.7.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
