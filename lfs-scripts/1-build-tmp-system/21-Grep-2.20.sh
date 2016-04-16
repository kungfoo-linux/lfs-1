#!/bin/bash -e
. ../lfs.comm

# The Grep package contains programs for searching through files.

build_src() {
    srcfil=grep-2.20.tar.xz
    srcdir=grep-2.20

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
