#!/bin/bash -e
. ../lfs.comm

# The Libcap package implements the user-space interfaces to the POSIX 1003.1e
# capabilities available in Linux kernels. These capabilities are a
# partitioning of the all powerful root privilege into a set of distinct
# privileges.

build_src() {
    srcfil=libcap-2.24.tar.xz
    srcdir=libcap-2.24

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    make -j$JOBS
    make RAISE_SETFCAP=no prefix=/usr install
    chmod -v 755 /usr/lib/libcap.so

    mv -v /usr/lib/libcap.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

    cd .. && rm -rf $srcdir
}

build
