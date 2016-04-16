#!/bin/bash -e
. ../lfs.comm

# The Man-pages package contains over 1900 man pages.

build_src() {
    srcfil=man-pages-3.72.tar.xz
    srcdir=man-pages-3.72

    tar -xf $LFSSRC/$srcfil && cd $srcdir
    make install

    cd .. && rm -rf $srcdir
}

build
