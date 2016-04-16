#!/bin/bash -e
. ../lfs.comm

# The Sed package contains a stream editor.

build_src() {
    srcfil=sed-4.2.2.tar.bz2
    srcdir=sed-4.2.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
