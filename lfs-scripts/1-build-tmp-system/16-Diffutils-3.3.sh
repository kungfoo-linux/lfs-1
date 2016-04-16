#!/bin/bash -e
. ../lfs.comm

# The Diffutils package contains programs that show the differences between
# files or directories.

build_src() {
    srcfil=diffutils-3.3.tar.xz
    srcdir=diffutils-3.3

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
