#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=file-5.19.tar.gz
    srcdir=file-5.19

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
