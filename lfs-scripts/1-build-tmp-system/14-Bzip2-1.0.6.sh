#!/bin/bash -e
. ../lfs.comm

# The Bzip2 package contains programs for compressing and decompressing files.
# Compressing text files with bzip2 yields a much better compression
# percentage than the tarditional gzip.

build_src() {
    srcfil=bzip2-1.0.6.tar.gz
    srcdir=bzip2-1.0.6

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    make -j$JOBS
    make PREFIX=/tools install

    cd .. && rm -rf $srcdir
}

build
