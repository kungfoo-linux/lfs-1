#!/bin/bash -e
. ../lfs.comm

# The DejaGNU package contains a framework for testing other programs.

build_src() {
    srcfil=dejagnu-1.5.1.tar.gz
    srcdir=dejagnu-1.5.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install
    make check

    cd ..
}

build
