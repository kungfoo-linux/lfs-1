#!/bin/bash -e
. ../lfs.comm

# The Autoconf package contains programs for producing shell scripts that can
# automatically configure source code.

build_src() {
    srcfil=autoconf-2.69.tar.xz
    srcdir=autoconf-2.69

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
