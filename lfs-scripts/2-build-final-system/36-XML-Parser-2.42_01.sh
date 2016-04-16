#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=XML-Parser-2.42_01.tar.gz
    srcdir=XML-Parser-2.42_01

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    perl Makefile.PL
    make
    make test
    make install

    cd .. && rm -rf $srcdir
}

build
