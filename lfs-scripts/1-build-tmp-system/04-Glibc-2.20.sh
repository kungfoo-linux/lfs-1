#!/bin/bash -e
. ../lfs.comm

# The Glibc package contains the main C library. This library provides the
# basic routines for allocating memory, searching directories, opening and
# closing files, reading and writing files, string handling, pattern
# matching, arithmetic, and so on.

build_glibc() {
    srcfil=glibc-2.20.tar.xz
    srcdir=glibc-2.20

    tar -xf $LFSSRC/$srcfil
    mkdir -pv glibc-build && cd glibc-build

    ../$srcdir/configure \
        --prefix=/tools \
        --host=$LFS_TARGET \
        --build=$(../glibc-2.20/scripts/config.guess) \
        --disable-profile \
        --enable-kernel=2.6.32 \
        --with-headers=/tools/include \
        libc_cv_forced_unwind=yes \
        libc_cv_ctors_header=yes \
        libc_cv_c_cleanup=yes
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir glibc-build
}

check() {
    echo 'main(){}' > dummy.c	
    $LFS_TARGET-gcc dummy.c
    result=`echo \`readelf -l a.out | grep ': /tools'\``

    case $(uname -m) in
      x86_64)
        expect='[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]'
        ;;
      *)
        expect='[Requesting program interpreter: /tools/lib/ld-linux.so.2]'
        ;;
    esac

    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed'
        exit 1
    fi

    rm -fv dummy.c a.out
}

build_src() {
    build_glibc
    check
}

build
