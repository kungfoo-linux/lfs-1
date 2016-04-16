#!/bin/bash -e
. ../lfs.comm

# The Iana-Etc package provides data for network services and protocols.

build_src() {
    srcfil=iana-etc-2.30.tar.bz2
    srcdir=iana-etc-2.30

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
