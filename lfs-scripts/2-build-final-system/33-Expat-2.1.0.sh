#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=expat-2.1.0.tar.gz
    srcdir=expat-2.1.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    install -v -dm755 /usr/share/doc/expat-2.1.0
    install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0

    cd .. && rm -rf $srcdir
}

build
