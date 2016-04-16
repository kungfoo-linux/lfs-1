#!/bin/bash -e
. ../lfs.comm

# The Zlib package contains compression and decompression routines used by
# some programs.

build_src() {
    srcfil=zlib-1.2.8.tar.xz
    srcdir=zlib-1.2.8

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    # The shared library needs to be moved to /lib, and as a result the .so
    # file in /usr/lib will need to be recreated:
    mv -v /usr/lib/libz.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

    cd .. && rm -rf $srcdir
}

build
