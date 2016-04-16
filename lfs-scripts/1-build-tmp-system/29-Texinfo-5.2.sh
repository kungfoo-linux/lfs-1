#!/bin/bash -e
. ../lfs.comm

# The Textinfo package contains programs for reading, writing, and converting
# info pages.

build_src() {
    srcfil=texinfo-5.2.tar.xz
    srcdir=texinfo-5.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
