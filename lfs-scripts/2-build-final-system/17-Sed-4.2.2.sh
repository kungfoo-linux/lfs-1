#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=sed-4.2.2.tar.bz2
    srcdir=sed-4.2.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --bindir=/bin \
        --htmldir=/usr/share/doc/sed-4.2.2
    make -j$JOBS
    make html
    make install
    make -C doc install-html

    cd .. && rm -rf $srcdir
}

build
