#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=diffutils-3.3.tar.xz
    srcdir=diffutils-3.3

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
