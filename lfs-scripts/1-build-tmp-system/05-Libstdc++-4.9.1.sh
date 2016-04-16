#!/bin/bash -e
. ../lfs.comm

# Libstdc++ is the standard C++ library (part of the GCC sources).

build_src() {
    srcfil=gcc-4.9.1.tar.bz2
    srcdir=gcc-4.9.1

    tar -xf $LFSSRC/$srcfil
    mkdir -pv gcc-build && cd gcc-build

    ../$srcdir/libstdc++-v3/configure \
        --host=$LFS_TARGET \
        --prefix=/tools \
        --disable-multilib \
        --disable-shared \
        --disable-nls \
        --disable-libstdcxx-threads \
        --disable-libstdcxx-pch \
        --with-gxx-include-dir=/tools/$LFS_TARGET/include/c++/4.9.1
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir gcc-build
}

build
