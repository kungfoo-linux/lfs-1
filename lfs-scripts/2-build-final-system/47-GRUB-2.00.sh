#!/bin/bash -e
. ../lfs.comm

# The GRUB package contains the GRand Unified Bootloader.

build_src() {
    srcfil=grub-2.00.tar.xz
    srcdir=grub-2.00

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Fix an incompatiblity between this package and Glibc-2.20:
    sed -i -e '/gets is a/d' grub-core/gnulib/stdio.in.h

    ./configure --prefix=/usr \
        --sbindir=/sbin \
        --sysconfdir=/etc \
        --disable-grub-emu-usb \
        --disable-efiemu \
        --disable-werror
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
