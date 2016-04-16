#!/bin/bash -e
. ../lfs.comm

# The Libtool package contains the GNU generic library support script. It
# wraps the complexity of using shared libraries in a consistent, portable
# interface.

build_src() {
    srcfil=libtool-2.4.2.tar.gz
    srcdir=libtool-2.4.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
