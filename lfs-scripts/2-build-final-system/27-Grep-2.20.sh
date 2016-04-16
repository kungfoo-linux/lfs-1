#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=grep-2.20.tar.xz
    srcdir=grep-2.20

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --bindir=/bin
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
