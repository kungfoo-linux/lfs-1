#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=tar-1.28.tar.xz
    srcdir=tar-1.28

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    FORCE_UNSAFE_CONFIGURE=1  \
        ./configure --prefix=/usr \
        --bindir=/bin
    make -j$JOBS
    make install
    make -C doc install-html docdir=/usr/share/doc/tar-1.28

    cd .. && rm -rf $srcdir
}

build
