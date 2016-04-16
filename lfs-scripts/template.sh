#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=abc-x.y.z.tar.bz2
    srcdir=abc-x.y.z

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
