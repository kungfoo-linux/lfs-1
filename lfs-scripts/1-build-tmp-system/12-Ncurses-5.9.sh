#!/bin/bash -e
. ../lfs.comm

# The Ncurses package contains libraries for terminal-independent handling
# of character screens.

build_src() {
    srcfil=ncurses-5.9.tar.gz
    srcdir=ncurses-5.9

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools \
        --with-shared \
        --without-debug \
        --without-ada \
        --enable-widec \
        --enable-overwrite
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
