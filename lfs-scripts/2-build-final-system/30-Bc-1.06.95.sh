#!/bin/bash -e
. ../lfs.comm

# The Bc package contains an arbitrary precision numberic processing language.

build_src() {
    srcfil=bc-1.06.95.tar.bz2
    srcdir=bc-1.06.95

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    patch -Np1 -i $PATCHES/bc-1.06.95-memory_leak-1.patch

    ./configure --prefix=/usr \
        --with-readline \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
