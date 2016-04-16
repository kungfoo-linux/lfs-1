#!/bin/bash -e
. ../lfs.comm

# The M4 package contains a macro processor.

build_src() {
    srcfil=m4-1.4.17.tar.xz
    srcdir=m4-1.4.17

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
