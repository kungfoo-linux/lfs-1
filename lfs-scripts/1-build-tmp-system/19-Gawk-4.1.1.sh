#!/bin/bash -e
. ../lfs.comm

# The Gawk package contains programs for manipulating test files.

build_src() {
    srcfil=gawk-4.1.1.tar.xz
    srcdir=gawk-4.1.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
