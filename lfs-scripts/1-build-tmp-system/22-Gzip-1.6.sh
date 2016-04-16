#!/bin/bash -e
. ../lfs.comm

# The Gzip package contains programs for compressing and decompressing files.

build_src() {
    srcfil=gzip-1.6.tar.xz
    srcdir=gzip-1.6

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
