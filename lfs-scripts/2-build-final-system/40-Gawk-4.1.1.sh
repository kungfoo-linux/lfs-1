#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=gawk-4.1.1.tar.xz
    srcdir=gawk-4.1.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    mkdir -v /usr/share/doc/gawk-4.1.1
    cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.1

    cd .. && rm -rf $srcdir
}

build
