#!/bin/bash -e
. ../lfs.comm

# The Tar package contains an archiving program.

build_src() {
    srcfil=tar-1.28.tar.xz
    srcdir=tar-1.28

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
