#!/bin/bash -e
. ../lfs.comm

# The Linux API Headers expose the kernel's API for use by Glibc.

build_src() {
    srcfil=linux-3.16.2.tar.xz
    srcdir=linux-3.16.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    make mrproper
    make INSTALL_HDR_PATH=dest headers_install
    cp -rv dest/include/* /tools/include

    cd .. && rm -rf $srcdir
}

build
