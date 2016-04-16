#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=gdbm-1.11.tar.gz
    srcdir=gdbm-1.11

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --enable-libgdbm-compat
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
