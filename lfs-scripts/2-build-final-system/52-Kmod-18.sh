#!/bin/bash -e
. ../lfs.comm

# The Kmod package contains libraries and utilities for loading kernel
# modules.

build_src() {
    srcfil=kmod-18.tar.xz
    srcdir=kmod-18

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --bindir=/bin \
        --sysconfdir=/etc \
        --with-rootlibdir=/lib \
        --with-xz \
        --with-zlib
    make -j$JOBS
    make check
    make install

    for target in depmod insmod modinfo modprobe rmmod; do
        ln -sv ../bin/kmod /sbin/$target
    done
    ln -sv kmod /bin/lsmod

    cd .. && rm -rf $srcdir
}

build
