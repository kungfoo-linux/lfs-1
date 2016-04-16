#!/bin/bash -e
. ../lfs.comm

# The Patch package contains a program for modifying or creating files by
# applying a "patch" file typically created by the diff program.

build_src() {
    srcfil=patch-2.7.1.tar.xz
    srcdir=patch-2.7.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
