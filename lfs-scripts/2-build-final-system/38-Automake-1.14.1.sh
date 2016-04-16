#!/bin/bash -e
. ../lfs.comm

# The Automake package contains programs for generating Makefiles for use
# with Autoconf.

build_src() {
    srcfil=automake-1.14.1.tar.xz
    srcdir=automake-1.14.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/automake-1.14.1
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
