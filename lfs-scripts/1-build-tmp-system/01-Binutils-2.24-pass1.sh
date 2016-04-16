#!/bin/bash -e
. ../lfs.comm

# The Binutils package contains a linker, an assembler, and other tools
# for handing object files.

build_src() {
    srcfil=binutils-2.24.tar.bz2
    srcdir=binutils-2.24

    tar -xf $LFSSRC/$srcfil
    mkdir -pv binutils-build && cd binutils-build

    ../$srcdir/configure \
        --prefix=/tools \
        --with-sysroot=$LFS \
        --with-lib-path=/tools/lib \
        --target=$LFS_TARGET \
        --disable-nls \
        --disable-werror
    make -j$JOBS
	
    case $(uname -m) in
        x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac

    make install

    cd .. && rm -rf $srcdir binutils-build
}

build
