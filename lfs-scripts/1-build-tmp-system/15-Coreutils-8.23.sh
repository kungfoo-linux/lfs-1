#!/bin/bash -e
. ../lfs.comm

# The Coreutils package contains utilities for showing and setting the basic
# system characteristics.

build_src() {
    srcfil=coreutils-8.23.tar.xz
    srcdir=coreutils-8.23

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools \
        --enable-install-program=hostname
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
