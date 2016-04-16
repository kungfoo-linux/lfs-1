#!/bin/bash -e
. ../lfs.comm

# The Bash package contains the Bourne-Again SHell.

build_src() {
    srcfil=bash-4.3.tar.gz
    srcdir=bash-4.3

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools \
        --without-bash-malloc
    make -j$JOBS
    make install

    ln -vs bash /tools/bin/sh

    cd .. && rm -rf $srcdir
}

build
