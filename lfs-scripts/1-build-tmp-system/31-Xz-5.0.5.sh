#!/bin/bash -e
. ../lfs.comm

# The Xz package contains programs for compressing and decompressing files. It
# provides capabilities for the lzma and newer xz compression formats.
# Compressing text files with xz yields a better compression percentage than
# with the traditional gzip or bzip2 commands.

build_src() {
    srcfil=xz-5.0.5.tar.xz
    srcdir=xz-5.0.5

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
