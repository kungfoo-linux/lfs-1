#!/bin/bash -e
. ../lfs.comm

# The Less package contains a text file viewer.

build_src() {
    srcfil=less-458.tar.gz
    srcdir=less-458

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --sysconfdir=/etc
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
