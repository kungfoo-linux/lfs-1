#!/bin/bash -e
. ../lfs.comm

# Check is a unit testing framework for C.

build_src() {
    srcfil=check-0.9.14.tar.gz
    srcdir=check-0.9.14

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    PKG_CONFIG= ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir tcl8.6.2 expect5.45 dejagnu-1.5.1
}

build
