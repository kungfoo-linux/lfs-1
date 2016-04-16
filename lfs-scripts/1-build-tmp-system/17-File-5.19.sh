#!/bin/bash -e
. ../lfs.comm

# The File package contains a utility for determining the type of a given
# file or files.

build_src() {
    srcfil=file-5.19.tar.gz
    srcdir=file-5.19

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
