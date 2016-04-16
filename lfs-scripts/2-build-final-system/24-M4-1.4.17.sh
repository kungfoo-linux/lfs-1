#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=m4-1.4.17.tar.xz
    srcdir=m4-1.4.17

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
