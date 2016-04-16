#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=gperf-3.0.4.tar.gz
    srcdir=gperf-3.0.4

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/gperf-3.0.4
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
