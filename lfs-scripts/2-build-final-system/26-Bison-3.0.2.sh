#!/bin/bash -e
. ../lfs.comm

# The Bison package contains a parser generator.

build_src() {
    srcfil=bison-3.0.2.tar.xz
    srcdir=bison-3.0.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
