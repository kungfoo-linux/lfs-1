#!/bin/bash -e
. ../lfs.comm

# The Libpipeline package contains a library for manipulating pipelines of
# subprocesses in a flexible and convenient way.

build_src() {
    srcfil=libpipeline-1.3.0.tar.gz
    srcdir=libpipeline-1.3.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
