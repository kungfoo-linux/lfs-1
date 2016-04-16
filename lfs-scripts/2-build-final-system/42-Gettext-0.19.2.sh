#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=gettext-0.19.2.tar.xz
    srcdir=gettext-0.19.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/gettext-0.19.2
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
