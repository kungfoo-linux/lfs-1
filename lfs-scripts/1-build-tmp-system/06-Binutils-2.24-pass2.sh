#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=binutils-2.24.tar.bz2
    srcdir=binutils-2.24

    tar -xf $LFSSRC/$srcfil
    mkdir -pv binutils-build && cd binutils-build

    CC=$LFS_TARGET-gcc \
        AR=$LFS_TARGET-ar \
        RANLIB=$LFS_TARGET-ranlib \
        ../$srcdir/configure \
        --prefix=/tools \
        --disable-nls \
        --disable-werror \
        --with-lib-path=/tools/lib \
        --with-sysroot
    make -j$JOBS
    make install

    make -C ld clean
    make -C ld LIB_PATH=/usr/lib:/lib
    cp -v ld/ld-new /tools/bin

    cd .. && rm -rf $srcdir binutils-build
}

build
